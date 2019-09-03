//
//  Encoder.m
//  HelloLivePushOC
//
//  Created by Chen,Meisong on 2019/9/3.
//  Copyright © 2019 xyz.chenms. All rights reserved.
//

#import "Extractor.h"

@implementation Extractor

- (NSData *)dataWithSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    size_t y_size = width * height;
    size_t uv_size = y_size / 2;
    
    uint8_t *yuv_frame = malloc(y_size + uv_size);
    uint8_t *y_frame = CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0);
    memcpy(yuv_frame, y_frame, y_size);
    uint8_t *uv_frame = CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 1);
    memcpy(yuv_frame + y_size, uv_frame, uv_size);
    
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    
    NSData *data = [NSData dataWithBytes:yuv_frame length:y_size + uv_size];
    
    return data;
}

@end
