//
//  UINavigationBar+HideAppear.m
//  chaoxi
//
//  Created by fizz on 15/11/30.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "UINavigationBar+HideAppear.h"

@interface UINavigationBar()

@property (nonatomic, strong) UIColor *bgColor;

@end

@implementation UINavigationBar (HideAppear)

@dynamic overlayView;

- (void)cx_setBackgroundColor:(UIColor *)backgroundColor
{
    self.bgColor = backgroundColor;
    
    [self createOverlayView];
    
     [RACObserve(self, bgColor) subscribeNext:^(UIColor *currentColor) {
        
         self.overlayView.backgroundColor = currentColor;
     }];
}

- (void)createOverlayView
{
    if (!self.overlayView) {

        self.overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, CGRectGetHeight(self.bounds) + 20)];
        self.overlayView.userInteractionEnabled = NO;
        self.overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self insertSubview:self.overlayView atIndex:0];
    }

}

- (void)setOverlayView:(UIView *)overlayView
{
    
}

@end
