//
//  CXScaleTransition.m
//  chaoxi
//
//  Created by fizz on 16/3/1.
//  Copyright © 2016年 chaox. All rights reserved.
//

#import "CXScaleTransition.h"

@implementation CXScaleTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.30f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
//    [containerView addSubview:toVC.view];
//    [toVC.view setAlpha:0];
//    
//    [UIView animateWithDuration:[self transitionDuration:transitionContext]
//                     animations:^{
//                         [toVC.view setAlpha:1];
//                     }
//                     completion:^(BOOL finished) {
//                         [transitionContext completeTransition:YES];
//                     }];
    
    [containerView addSubview:toVC.view];
    CGRect fromFrame = fromVC.view.frame;
    CGRect toFrame = toVC.view.frame;
    
    fromFrame.origin.y = -fromFrame.size.height/2;
    toFrame.origin.y = containerView.frame.size.height;
    [toVC.view setFrame:toFrame];
    toFrame.origin.y = 0;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
         usingSpringWithDamping:0.92f
          initialSpringVelocity:17
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [fromVC.view setFrame:fromFrame];
                         [toVC.view setFrame:toFrame];
                     } completion:^(BOOL finished) {
                         [transitionContext completeTransition:YES];
                     }];
    
}

@end
