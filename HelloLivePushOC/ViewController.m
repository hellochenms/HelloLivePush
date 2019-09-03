//
//  ViewController.m
//  HelloLivePushOC
//
//  Created by Chen,Meisong on 2019/8/29.
//  Copyright © 2019 xyz.chenms. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "Captor.h"
//#import <PLMediaStreamingKit/PLMediaStreamingKit.h>
#import "Previewer.h"

@interface ViewController ()
//@property (nonatomic, strong) PLMediaStreamingSession *session;
@property (nonatomic) Captor *captor;
@property (nonatomic) Previewer *previewer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 七牛云
//    PLVideoCaptureConfiguration *videoCaptureConfiguration = [PLVideoCaptureConfiguration defaultConfiguration];
//    PLAudioCaptureConfiguration *audioCaptureConfiguration = [PLAudioCaptureConfiguration defaultConfiguration];
//    PLVideoStreamingConfiguration *videoStreamingConfiguration = [PLVideoStreamingConfiguration defaultConfiguration];
//    PLAudioStreamingConfiguration *audioStreamingConfiguration = [PLAudioStreamingConfiguration defaultConfiguration];
//
//    self.session = [[PLMediaStreamingSession alloc] initWithVideoCaptureConfiguration:videoCaptureConfiguration audioCaptureConfiguration:audioCaptureConfiguration videoStreamingConfiguration:videoStreamingConfiguration audioStreamingConfiguration:audioStreamingConfiguration stream:nil];
//
//    [self.view addSubview:self.session.previewView];
    
    
    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [startButton setTitle:@"start" forState:UIControlStateNormal];
    startButton.frame = CGRectMake(0, 64, 100, 44);
    [startButton addTarget:self action:@selector(onTapStart) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startButton];
    
    UIButton *stopButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [stopButton setTitle:@"stop" forState:UIControlStateNormal];
    stopButton.frame = CGRectMake(120, 64, 100, 44);
    [stopButton addTarget:self action:@selector(onTapStop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopButton];
    
    
    // 手工打造
    self.captor = [Captor new];
    [self.captor prepare];
    
    self.previewer = [Previewer new];
    [self.previewer prepareWithSession:self.captor.captureSession];
    self.previewer.frame = [UIScreen mainScreen].bounds;
    [self.view addSubview:self.previewer];
    [self.view sendSubviewToBack:self.previewer];
}

#pragma mark - Event
- (void)onTapStart {
    NSURL *pushURL = [NSURL URLWithString:@"rtmp://172.24.32.128/rtmplive/qweasd"];
    [self.captor start];
    
    // 七牛云
//    [self.session startStreamingWithPushURL:pushURL feedback:^(PLStreamStartStateFeedback feedback) {
//        if (feedback == PLStreamStartStateSuccess) {
//            NSLog(@"Streaming started.");
//        }
//        else {
//            NSLog(@"Oops.");
//        }
//    }];
}

- (void)onTapStop {
    [self.captor stop];
}

@end
