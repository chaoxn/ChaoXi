//
//  CXAudioPlayer.m
//  chaoxi
//
//  Created by fizz on 15/12/23.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "CXAudioPlayer.h"
#import "ViedoModel.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation CXAudioPlayer

+ (CXAudioPlayer *)shareInstance
{
    static dispatch_once_t once = 0;
    static CXAudioPlayer *cxAudioPlayer;
    
    dispatch_once(&once, ^{
        
        cxAudioPlayer = [[CXAudioPlayer alloc] initWithOptions:(STKAudioPlayerOptions){ .flushQueueOnSeek = YES, .enableVolumeMixer = NO, .equalizerBandFrequencies = {50, 100, 200, 400, 800, 1600, 2600, 16000} }];
        cxAudioPlayer.meteringEnabled = YES;
        cxAudioPlayer.volume = 1;
    });
    
    return cxAudioPlayer;
}

- (void)next
{
    if (self.index < self.modelArr.count-1) {
        
        self.index++;
    }else{
        
        [CXNotification show: ISLASTRADIO];
        return;
    }
}

- (void)last
{
    if (self.index > 0) {
        
        self.index--;
    }else{
        
        [CXNotification show: ISFIRSTRADIO];
        return;
    }
}

- (void)begin
{
    if (!self){
        
        return;
    }
    
    if (self.state == STKAudioPlayerStatePaused) {
        
        [self resume];
    } else{
        
        [self pause];
    }
}

- (void)configNowPlayingInfoCenter
{
    if (self.modelArr.count == 0) {
        
        return;
    }
    
     @autoreleasepool {
    
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];

        UIImageView *imageView = [[UIImageView alloc]init];
    
        ViedoModel *model = self.modelArr[self.index];
     
        [dict setValue:model.title forKey:MPMediaItemPropertyTitle];
        
        [dict setObject:[NSNumber numberWithDouble:self.duration] forKey:MPMediaItemPropertyPlaybackDuration];
        
        [dict setObject:model.userinfo[@"uname"] forKey:MPMediaItemPropertyArtist];
    
        [dict setObject:[NSNumber numberWithDouble:self.progress] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl]];
        
         if (imageView.image) {
             
             MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:imageView.image];
             [dict setObject:artwork forKey:MPMediaItemPropertyArtwork];
         }
         
         DLog(@"%@", dict);
     
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
     }
}

- (void)startBackground
{
    
}

@end
