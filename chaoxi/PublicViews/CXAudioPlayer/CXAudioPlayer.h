//
//  CXAudioPlayer.h
//  chaoxi
//
//  Created by fizz on 15/12/23.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    CXAudioPlayTypeCircle,  //循环播放
    CXAudioPlayTypeRandom,  //随机播放
    CXAudioPlayTypeOneMusic,//单曲循环
    CXAudioPlayTypeNoNext,  //播完就不播了
} CXAudioPlayType;

@interface CXAudioPlayer : STKAudioPlayer

@property (nonatomic, assign) CXAudioPlayType playType;

@property (nonatomic, strong) NSMutableArray *modelArr;

@property (nonatomic, assign) NSInteger index;

+ (CXAudioPlayer *)shareInstance;

- (void)begin;

- (void)next;

- (void)last;

- (void)configNowPlayingInfoCenter;

- (void)startBackground;

@end
