//
//  VideoEncoder.m
//  HelloLivePushOC
//
//  Created by Chen,Meisong on 2019/9/3.
//  Copyright © 2019 xyz.chenms. All rights reserved.
//

#import "VideoEncoder.h"
#import <AVFoundation/AVFoundation.h>
#import <VideoToolbox/VideoToolbox.h>

@interface VideoEncoder () {
    VTCompressionSessionRef _encodingSession;
    NSInteger frameID;
}
@property (nonatomic) dispatch_queue_t encodeQueue;
@end

@implementation VideoEncoder
- (instancetype)init {
    self = [super init];
    if (self) {
        self.encodeQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    
    return self;
}

#pragma mark - Public
- (void)prepare {
    dispatch_sync(self.encodeQueue, ^{
        self->frameID = 0;
        
        NSInteger width = 480;
        NSInteger height = 640;
        
        OSStatus status
        = VTCompressionSessionCreate(NULL, width, height, kCMVideoCodecType_H264, NULL, NULL, NULL, didCompressH264, (__bridge void *)(self), &self->_encodingSession);
        NSLog(@"【m2】status:%d  %s", status, __func__);
        if (status != 0) {
            NSLog(@"【m2】创建Encoder失败:%d  %s", status, __func__);
        }
        
        VTSessionSetProperty(self->_encodingSession, kVTCompressionPropertyKey_RealTime, kCFBooleanTrue);
        VTSessionSetProperty(self->_encodingSession, kVTCompressionPropertyKey_ProfileLevel, kVTProfileLevel_H264_Baseline_AutoLevel);
        
        NSInteger frameInterval = 10;
        CFNumberRef  frameIntervalRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberIntType, &frameInterval);
        VTSessionSetProperty(self->_encodingSession, kVTCompressionPropertyKey_MaxKeyFrameInterval, frameIntervalRef);
        
        NSInteger fps = 10;
        CFNumberRef fpsRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberIntType, &fps);
        VTSessionSetProperty(self->_encodingSession, kVTCompressionPropertyKey_ExpectedFrameRate, fpsRef);
        
        NSInteger bitRate = width * height * 3 * 4 * 8;
        CFNumberRef bitRateRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &bitRate);
        VTSessionSetProperty(self->_encodingSession, kVTCompressionPropertyKey_AverageBitRate, bitRateRef);
        
        NSInteger bitRateLimit = width * height * 3 * 4;
        CFNumberRef bitRateLimitRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &bitRateLimit);
        VTSessionSetProperty(self->_encodingSession, kVTCompressionPropertyKey_DataRateLimits, bitRateLimitRef);
        
        VTCompressionSessionPrepareToEncodeFrames(self->_encodingSession);
    });
}

- (void)encode:(CMSampleBufferRef)sampleBuffer {
    dispatch_sync(self.encodeQueue, ^{
        CVImageBufferRef imageBuffer = (CVImageBufferRef)CMSampleBufferGetImageBuffer(sampleBuffer);
        CMTime presentationTimeStamp = CMTimeMake(self->frameID++, 1000);
        VTEncodeInfoFlags flags;
        OSStatus statusCode = VTCompressionSessionEncodeFrame(self->_encodingSession, imageBuffer, presentationTimeStamp, kCMTimeInvalid, NULL, NULL, &flags);
        if (statusCode != noErr) {
            NSLog(@"【m2】encode失败，statusCode:%d  %s", (int)statusCode,  __func__);
            VTCompressionSessionInvalidate(self->_encodingSession);
            CFRelease(self->_encodingSession);
            self->_encodingSession = nil;
            return;
        }
        NSLog(@"【m2】 encode成功 %s", __func__);
    });
}

#pragma mark -
void didCompressH264(void *outputCallbackRefCon, void *sourceFrameRefCon, OSStatus status, VTEncodeInfoFlags infoFlags, CMSampleBufferRef sampleBuffer) {
    NSLog(@"【m2】status:%d  %s", (int)status, __func__);
    
    if (status != 0) {
        NSLog(@"【m2】status: %d %s", status, __func__);
        return;
    }
    
    if (!CMSampleBufferDataIsReady(sampleBuffer)) {
        NSLog(@"【m2】sampleBuffer尚未准备好  %s", __func__);
        return;
    }
    
    BOOL isKeyFrame = CFDictionaryContainsKey(CFArrayGetValueAtIndex(CMSampleBufferGetSampleAttachmentsArray(sampleBuffer, true), 0), kCMSampleAttachmentKey_NotSync);
    
    if (isKeyFrame) {
        CMFormatDescriptionRef format = CMSampleBufferGetFormatDescription(sampleBuffer);
        size_t sparameterSetSize, sparameterSetCount;
        const uint8_t *sparameterSet;
        OSStatus statusCode = CMVideoFormatDescriptionGetH264ParameterSetAtIndex(format, 0, &sparameterSet, &sparameterSetSize, &sparameterSetCount, 0);
        if (statusCode == noErr) {
            size_t pparameterSetSize, pparameterSetCount;
            const uint8_t *pparameterSet;
            OSStatus statusCode = CMVideoFormatDescriptionGetH264ParameterSetAtIndex(format, 1, &pparameterSet, &pparameterSetSize, &pparameterSetCount, 0);
            if (statusCode == noErr) {
                NSData *sps = [NSData dataWithBytes:sparameterSet length:sparameterSetSize];
                NSData *pps = [NSData dataWithBytes:pparameterSet length:pparameterSetSize];
                VideoEncoder* encoder = (__bridge VideoEncoder*)outputCallbackRefCon;
                [encoder writeSPS:sps pps:pps];
            }
        }
    }
}

- (void)writeSPS:(NSData *)sps pps:(NSData *)pps {
    
}

- (void)writeData:(NSData *)data isKeyFrame:(BOOL)isKeyFrame {
    
}

#pragma mark - Public
- (void)shutdowm {
    VTCompressionSessionCompleteFrames(_encodingSession, kCMTimeInvalid);
    VTCompressionSessionInvalidate(_encodingSession);
    CFRelease(_encodingSession);
    _encodingSession = nil;
}

@end
