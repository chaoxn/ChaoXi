//
//  PlayOnViewController.m
//  chaoxi
//
//  Created by fizz on 15/12/22.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "PlayOnViewController.h"
#import "CXAudioPlayer.h"

@interface PlayOnViewController ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation PlayOnViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    CXAudioShare.delegate = self;
    
    [self dataBinding];
    [self basicSetting];
}

- (void)viewDidAppear:(BOOL)animated
{
//    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
//    self.view.backgroundColor = CXRGBAColor(245, 245, 245, 1);
}

- (void)dataBinding
{ 
    [[RACObserve([CXAudioPlayer shareInstance], index) delay:0.01 ] subscribeNext:^(NSNumber *index) {
        
        [CXAudioShare pause];
        
        self.model = CXAudioShare.modelArr[[index integerValue]];
    }];
    
    // 全局监听 index 播放页面主要还是靠监听model的变化
    [RACObserve(self, model) subscribeNext:^(ViedoModel *model) {
    
        [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl]];
    }];
    
    RAC(self.titleLabel, text) = RACObserve(self, model.title);
    
    [[RACObserve(self, model.musicUrl) filter:^BOOL(NSString *value) {
        
        return value.length > 0;
    }] subscribeNext:^(NSString *url) {
        
        [CXAudioShare play:url];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(tracking) userInfo:nil repeats:YES];
    }];
    
    [[self.slider rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UISlider *x) {
       
        if (CXAudioShare) {
            [CXAudioShare seekToTime:x.value];
        }
    }];
}

- (void)basicSetting
{
    [self.slider setThumbImage:[UIImage imageNamed:@"shu"] forState:UIControlStateNormal];
}

- (void)tracking
{
    self.slider.maximumValue = CXAudioShare.duration;
    self.slider.value = CXAudioShare.progress;
    
    self.beginTimeLabel.text = [NSString stringWithFormat:@"%.2ld:%.2ld", (NSInteger) CXAudioShare.progress / 60, (NSInteger)CXAudioShare.progress % 60];
    self.endTimeLabel.text = [NSString stringWithFormat:@"%.2ld:%.2ld", (NSInteger) CXAudioShare.duration / 60, (NSInteger)CXAudioShare.duration % 60];
}

-(void)audioPlayer:(STKAudioPlayer *)audioPlayer didFinishBufferingSourceWithQueueItemId:(NSObject *)queueItemId
{
    NSLog(@"完成缓冲");
}
-(void)audioPlayer:(STKAudioPlayer *)audioPlayer didFinishPlayingQueueItemId:(NSObject *)queueItemId withReason:(STKAudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration
{
    NSLog(@"完成播放");
    //FIXME:
//    [[CXAudioPlayer shareInstance] next];

    DLog(@"StopReason:  %ld", stopReason);
}

-(void)audioPlayer:(STKAudioPlayer *)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState
{
    if (state == STKAudioPlayerStateStopped) {
        
    }
    
    if (state == STKAudioPlayerStatePlaying) {
        
    }
}
-(void)audioPlayer:(STKAudioPlayer *)audioPlayer didStartPlayingQueueItemId:(NSObject *)queueItemId
{
    NSLog(@"开始播放");
}
-(void)audioPlayer:(STKAudioPlayer *)audioPlayer unexpectedError:(STKAudioPlayerErrorCode)errorCode
{
    NSLog(@"离开code (%ld)", errorCode);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
