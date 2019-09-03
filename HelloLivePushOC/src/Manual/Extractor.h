//
//  Encoder.h
//  HelloLivePushOC
//
//  Created by Chen,Meisong on 2019/9/3.
//  Copyright © 2019 xyz.chenms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Extractor : NSObject
- (NSData *)dataWithSampleBuffer:(CMSampleBufferRef)sampleBuffer;
@end

NS_ASSUME_NONNULL_END
