//
//  CXNotification.m
//  chaoxi
//
//  Created by fizz on 15/12/24.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "CXNotification.h"

@implementation CXNotification

+ (void)show:(NSString *)str
{
    NSDictionary *options = @{
                              kCRToastTextKey : str,
                              kCRToastFontKey : CXFont(15),
                              kCRToastTextColorKey : [UIColor whiteColor],
                              kCRToastTextAlignmentKey : @(NSTextAlignmentLeft),
                              kCRToastBackgroundColorKey : [UIColor orangeColor],
                              kCRToastNotificationTypeKey : @(1),
                              kCRToastTimeIntervalKey : @(1.5),
                              kCRToastImageKey: [UIImage imageNamed:@"warn"],
                              kCRToastAnimationInTypeKey : @(CRToastAnimationTypeSpring),
                              kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeSpring),
                              kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
                              kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight)
                              };
    
    [CRToastManager showNotificationWithOptions:options completionBlock:nil];
}

+ (void)disMiss
{
    [CRToastManager dismissNotification:YES];
}

@end
