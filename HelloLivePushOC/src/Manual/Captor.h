//
//  Captor.h
//  HelloLivePushOC
//
//  Created by Chen,Meisong on 2019/8/30.
//  Copyright © 2019 xyz.chenms. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Captor : NSObject
@property (nonatomic, readonly) AVCaptureSession *captureSession;
- (void)prepare;
- (void)start;
- (void)stop;
@end

NS_ASSUME_NONNULL_END
