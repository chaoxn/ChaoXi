//
//  AppDelegate.m
//  chaoxi
//
//  Created by fizz on 15/10/22.
//  Copyright (c) 2015年 chaox. All rights reserved.
//

#import "AppDelegate.h"
#import "ReadViewController.h"
#import "NavigationViewController.h"
#import "ListenViewController.h"
#import "PoeViewController.h"
#import "SaveViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[NavigationViewController alloc]initWithRootViewController:[[ReadViewController alloc]init]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    NSError* error;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    if ([CXAudioPlayer shareInstance].state == STKAudioPlayerStatePlaying||
        [CXAudioPlayer shareInstance].state == STKAudioPlayerStateBuffering||
        [CXAudioPlayer shareInstance].state == STKAudioPlayerStatePaused ||
        [CXAudioPlayer shareInstance].state == STKAudioPlayerStateStopped){
    
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        [self becomeFirstResponder];
        [[CXAudioPlayer shareInstance] configNowPlayingInfoCenter];
        
    }else{
        
        [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
        [self resignFirstResponder];
    }
}

// 锁屏控制
- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent {
    
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        
        switch (receivedEvent.subtype) {
                
            case UIEventSubtypeRemoteControlPause:

                [[CXAudioPlayer shareInstance] pause];
                break;
            case UIEventSubtypeRemoteControlNextTrack:

                [[CXAudioPlayer shareInstance] next];
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                
                [[CXAudioPlayer shareInstance] last];
                break;
            case UIEventSubtypeRemoteControlPlay:

                [[CXAudioPlayer shareInstance] begin];
                break;
            default:
                break;
        }
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
}

@end
