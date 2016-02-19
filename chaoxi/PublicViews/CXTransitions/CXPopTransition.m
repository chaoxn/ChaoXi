//
//  CXPopTransition.m
//  chaoxi
//
//  Created by fizz on 15/12/10.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "CXPopTransition.h"
#import "SaveViewController.h"

@interface CXPopTransition()

@property (nonatomic, strong) id<UIViewControllerContextTransitioning>transitionContext;

@end

@implementation CXPopTransition

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.618f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    self.transitionContext = transitionContext;
    
    self.popVC =[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    SaveViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];

    [containerView addSubview:toVC.view];
    [containerView addSubview:self.popVC.view];
    
    __block CGRect rect;
    
    // pop回 push来的button位置
//    [RACObserve(self, index) subscribeNext:^(NSNumber *x) {
//        
//        rect = CGRectMake(ScreenWidth-100 - 70*[x intValue], 35, 30, 30);
//    }];
    
    rect.origin = toVC.rectOrigin;
    
    UIBezierPath *finalPath = [UIBezierPath bezierPathWithOvalInRect:rect];
    
    CGPoint finalPoint;
    
    if(rect.origin.x > (toVC.view.bounds.size.width / 2)){
        if (rect.origin.y < (toVC.view.bounds.size.height / 2)) {
            //第一象限
            finalPoint = CGPointMake(rect.origin.x - 0, rect.origin.y - CGRectGetMaxY(toVC.view.bounds)+30);
        }else{
            //第四象限
            finalPoint = CGPointMake(rect.origin.x - 0, rect.origin.y - 0);
        }
    }else{
        if (rect.origin.y < (toVC.view.bounds.size.height / 2)) {
            //第二象限
            finalPoint = CGPointMake(rect.origin.x - CGRectGetMaxX(toVC.view.bounds), rect.origin.y - CGRectGetMaxY(self.popVC.view.bounds)+30);
        }else{
            //第三象限
            finalPoint = CGPointMake(rect.origin.x - CGRectGetMaxX(toVC.view.bounds), rect.origin.y - 0);
        }
    }

    CGFloat radius = sqrt(finalPoint.x * finalPoint.x + finalPoint.y * finalPoint.y);
    UIBezierPath *startPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(rect, -radius, -radius)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = finalPath.CGPath;
    self.popVC.view.layer.mask = maskLayer;
    
    CABasicAnimation *pingAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pingAnimation.fromValue = (__bridge id)(startPath.CGPath);
    pingAnimation.toValue   = (__bridge id)(finalPath.CGPath);
    pingAnimation.duration = [self transitionDuration:transitionContext];
    pingAnimation.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    pingAnimation.delegate = self;
    
    [maskLayer addAnimation:pingAnimation forKey:@"pingInvert"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{    
    [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
    [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;
}

@end
