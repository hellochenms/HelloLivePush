//
//  Previewer.m
//  HelloLivePushOC
//
//  Created by Chen,Meisong on 2019/8/30.
//  Copyright © 2019 xyz.chenms. All rights reserved.
//

#import "Previewer.h"

@interface Previewer ()
@property (nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
@end

@implementation Previewer

- (void)prepareWithSession:(AVCaptureSession *)session {
    [self.previewLayer removeFromSuperlayer];
    
    if (!session) { return; }
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    [self.layer addSublayer:self.previewLayer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.previewLayer.frame = self.bounds;
}

@end
