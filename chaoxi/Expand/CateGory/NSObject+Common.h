//
//  NSObject+Common.h
//  RacNetWork
//
//  Created by  plusub on 9/26/15.
//  Copyright (c) 2015 plusub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Common)

#pragma mark Tip M

- (NSString *)tipFromError:(NSError *)error;

- (void)showHudTipStr:(NSString *)tipStr;

- (void)showCustomHud;

@end
