//
//  CXScaleReturn.m
//  chaoxi
//
//  Created by fizz on 16/3/1.
//  Copyright © 2016年 chaox. All rights reserved.
//

#import "CXScaleReturn.h"

@implementation CXScaleReturn


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
//    [containerView addSubview:fromVC.view];
//    
//    [UIView animateWithDuration:[self transitionDuration:transitionContext]
//                     animations:^{
//                         [fromVC.view setAlpha:0];
//                     }
//                     completion:^(BOOL finished) {
//                         [transitionContext completeTransition:YES];
//                     }];
    
    [containerView addSubview:toVC.view];
    [containerView addSubview:fromVC.view];
    
    CGRect fromFrame = fromVC.view.frame;
    CGRect toFrame = toVC.view.frame;
    
    fromFrame.origin.y = containerView.frame.size.height;
    
    toFrame.origin.y = -containerView.frame.size.height;
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
