//
//  CXPushTransition.m
//  chaoxi
//
//  Created by fizz on 15/12/10.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "CXPushTransition.h"
#import "BaseViewController.h"
#import "SaveViewController.h"

#import "ArtViewController.h"

@interface CXPushTransition()

@property (nonatomic,strong)id<UIViewControllerContextTransitioning> transitionContext;

@end

@implementation CXPushTransition

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.618;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.transitionContext = transitionContext;
    
    ArtViewController *pushVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    self.popVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *contView = [transitionContext containerView];
    
    [contView addSubview:self.popVC.view];
    
   __block CGRect rect;
    
    [RACObserve(self, index) subscribeNext:^(NSNumber *x) {
       
        if (x == 0) {
            
            rect = pushVC.button.frame;
        } else{
            
            rect = CGRectMake(ScreenWidth-100 - 70*[x intValue], 35, 30, 30);
        }
    }];
    
    UIBezierPath *maskStartBP = [UIBezierPath bezierPathWithOvalInRect:rect];
    
    CGPoint finalPoint = CGPointMake(rect.origin.x - 0, rect.origin.y - CGRectGetMaxY(self.popVC.view.bounds));
    
    // FIXME:
    CGFloat radius = sqrt((finalPoint.x * finalPoint.x) + (finalPoint.y * finalPoint.y));
    UIBezierPath *maskFinalBP = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(rect, -radius, -radius)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = maskFinalBP.CGPath;
    self.popVC.view.layer.mask = maskLayer;
        
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.fromValue = (__bridge id)(maskStartBP.CGPath);
    maskLayerAnimation.toValue = (__bridge id)((maskFinalBP.CGPath));
    maskLayerAnimation.duration = [self transitionDuration:transitionContext];
    maskLayerAnimation.delegate = self;
    
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self.transitionContext completeTransition:![self. transitionContext transitionWasCancelled]];
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
    [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;
}

@end
