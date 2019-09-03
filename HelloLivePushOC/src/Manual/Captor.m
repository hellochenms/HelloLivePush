//
//  Captor.m
//  HelloLivePushOC
//
//  Created by Chen,Meisong on 2019/8/30.
//  Copyright © 2019 xyz.chenms. All rights reserved.
//

#import "Captor.h"
#import "Extractor.h"

@interface Captor ()<AVCaptureVideoDataOutputSampleBufferDelegate>
@property (nonatomic) AVCaptureSession *captureSession;
@property (nonatomic) AVCaptureDeviceInput *backCameraInput;
@property (nonatomic) AVCaptureVideoDataOutput *videoDataOutput;
@property (nonatomic) Extractor *extractor;
@end

@implementation Captor

- (void)prepare {
    self.captureSession = [AVCaptureSession new];
    
    [self.captureSession beginConfiguration];
    [self prepareBackCameraInput];
    if ([self.captureSession canAddInput:self.backCameraInput]) {
        [self.captureSession addInput:self.backCameraInput];
    }
    [self prepareVideoDataOutput];
    if ([self.captureSession canAddOutput:self.videoDataOutput]) {
        [self.captureSession addOutput:self.videoDataOutput];
    }
    
    [self.captureSession commitConfiguration];
    
}

- (void)prepareBackCameraInput {
    AVCaptureDevice *camera = nil;
    AVCaptureDevicePosition position = AVCaptureDevicePositionBack;
    AVCaptureDeviceDiscoverySession *videoSession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:position];
    NSArray<AVCaptureDevice *> *devices = videoSession.devices;
    for (AVCaptureDevice *tempCamera in devices) {
        if (tempCamera.position == position) {
            camera = tempCamera;
            break;
        }
    }
    self.backCameraInput = [AVCaptureDeviceInput deviceInputWithDevice:camera error:nil];
}

- (void)prepareVideoDataOutput {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    AVCaptureVideoDataOutput *videoDataOutput = [AVCaptureVideoDataOutput new];
    videoDataOutput.alwaysDiscardsLateVideoFrames = YES;
    [videoDataOutput setVideoSettings:@{(__bridge NSString *)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange)}]; // yuv420(NV12)
    [videoDataOutput setSampleBufferDelegate:self queue:queue];
    
    self.videoDataOutput = videoDataOutput;
}

#pragma mark - Public
- (void)start {
    [self.captureSession startRunning];
}

- (void)stop {
    [self.captureSession stopRunning];
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    NSData *data = [self.extractor dataWithSampleBuffer:sampleBuffer];
    NSLog(@"【m2】data:%ld  %s", [data length], __func__);
}

#pragma mark - Getter
- (Extractor *)extractor {
    if (!_extractor) {
        _extractor = [Extractor new];
    }
    
    return _extractor;
}
@end
