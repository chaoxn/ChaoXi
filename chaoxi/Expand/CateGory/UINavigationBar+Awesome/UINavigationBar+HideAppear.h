//
//  UINavigationBar+HideAppear.h
//  chaoxi
//
//  Created by fizz on 15/11/30.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (HideAppear)

@property (nonatomic, strong) UIView *overlayView;

- (void)cx_setBackgroundColor:(UIColor *)backgroundColor;

@end
