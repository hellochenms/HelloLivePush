//
//  Previewer.h
//  HelloLivePushOC
//
//  Created by Chen,Meisong on 2019/8/30.
//  Copyright © 2019 xyz.chenms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Previewer : UIView
- (void)prepareWithSession:(AVCaptureSession *)session;
@end

NS_ASSUME_NONNULL_END
