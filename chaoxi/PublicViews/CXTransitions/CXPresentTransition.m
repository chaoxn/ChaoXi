//
//  CXPresentTransition.m
//  chaoxi
//
//  Created by fizz on 15/12/17.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "CXPresentTransition.h"

@implementation CXPresentTransition

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.2;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    fromView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
    fromView.userInteractionEnabled = NO;
    
    UIView *dimmingView = [[UIView alloc] initWithFrame:fromView.bounds];
    dimmingView.backgroundColor = [UIColor darkGrayColor];
    dimmingView.layer.opacity = 0.0;
    
    UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    toView.frame = CGRectMake(0,
                              0,
                              CGRectGetWidth(transitionContext.containerView.bounds),
                              CGRectGetHeight(transitionContext.containerView.bounds)/3);
    toView.center = CGPointMake(transitionContext.containerView.center.x, -transitionContext.containerView.center.y);
    
//    [transitionContext.containerView addSubview:dimmingView];
    [transitionContext.containerView addSubview:toView];
    
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    
    positionAnimation.toValue = @(transitionContext.containerView.center.y-CGRectGetHeight(transitionContext.containerView.bounds)/3);
    positionAnimation.springBounciness = 10;
    positionAnimation.springSpeed = 17;
    //    positionAnimation.dynamicsFriction = 18;
    [positionAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        
        [transitionContext completeTransition:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"animationFinished" object:nil userInfo:@{@"Finished":@"Yes"}];
    }];
    
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.toValue = @(0.4);
    
    [toView.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    [dimmingView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
}



@end
