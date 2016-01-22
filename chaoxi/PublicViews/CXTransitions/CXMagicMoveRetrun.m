//
//  CXMagicMoveRetrun.m
//  chaoxi
//
//  Created by fizz on 16/1/22.
//  Copyright © 2016年 chaox. All rights reserved.
//

#import "CXMagicMoveRetrun.h"
#import "VideoDetailController.h"
#import "PlayBaseViewController.h"
#import "DetailCell.h"

@implementation CXMagicMoveRetrun 
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.6f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    //获取动画前后两个VC 和 发生的容器containerView
    VideoDetailController *toVC = (VideoDetailController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    PlayBaseViewController *fromVC = (PlayBaseViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    //在前一个VC上创建一个截图
    UIView  *snapShotView = [fromVC.currentView snapshotViewAfterScreenUpdates:NO];
    snapShotView.backgroundColor = [UIColor clearColor];
    snapShotView.frame = [containerView convertRect:fromVC.currentView.frame fromView:fromVC.view];
    fromVC.playOnVC.bgImageView.hidden = YES;
    
    //初始化后一个VC的位置
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    
    //获取toVC中图片的位置
    DetailCell *cell = (DetailCell *)[toVC.tableView cellForRowAtIndexPath:toVC.indexPath];
    cell.iconImageView.hidden = YES;
//    CGRect finalRect =  [containerView convertRect:cell.imageView.frame fromView:cell.imageView.superview];
    
    //顺序很重要，
    [containerView insertSubview:toVC.view belowSubview:fromVC.view];
    [containerView addSubview:snapShotView];
    
    //发生动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0f usingSpringWithDamping:0.6f initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        fromVC.view.alpha = 0.0f;
        snapShotView.frame = toVC.finalCellRect;
    } completion:^(BOOL finished) {
        [snapShotView removeFromSuperview];
        fromVC.playOnVC.bgImageView.hidden = NO;
        cell.iconImageView.hidden = NO;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
    
}

@end
