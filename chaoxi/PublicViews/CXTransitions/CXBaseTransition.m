//
//  CXBaseTransition.m
//  chaoxi
//
//  Created by fizz on 16/3/1.
//  Copyright © 2016年 chaox. All rights reserved.
//

#import "CXBaseTransition.h"

@implementation CXBaseTransition

#pragma mark - UIViewControllerAnimatedTransitioning


- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.30f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
}


#pragma mark - UIViewControllerTransitioningDelegate


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    _presenting = YES;
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    _presenting = NO;
    return self;
}

@end
