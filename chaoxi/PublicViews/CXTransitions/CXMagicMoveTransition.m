//
//  CXMagicMoveTransition.m
//  chaoxi
//
//  Created by fizz on 16/1/22.
//  Copyright © 2016年 chaox. All rights reserved.
//

#import "CXMagicMoveTransition.h"
#import "VideoDetailController.h"
#import "PlayBaseViewController.h"
#import "DetailCell.h"

@implementation CXMagicMoveTransition

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.6f;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    PlayBaseViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    VideoDetailController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    DetailCell *cell = (DetailCell *)[fromVC.tableView cellForRowAtIndexPath:[[fromVC.tableView indexPathsForSelectedRows] firstObject]];
    fromVC.indexPath = [[fromVC.tableView indexPathsForSelectedRows]firstObject];
    
    UIView *snapShotView = [cell.iconImageView snapshotViewAfterScreenUpdates:NO];
    snapShotView.frame = fromVC.finalCellRect = [containerView convertRect:cell.iconImageView.frame fromView:cell.iconImageView.superview];
    cell.iconImageView.hidden = YES;
    
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    toVC.view.alpha = 0;
    toVC.playOnVC.bgImageView.hidden = YES;
    
    [containerView addSubview:toVC.view];
    [containerView addSubview:snapShotView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0f usingSpringWithDamping:0.6f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveLinear animations:^{
        
        [containerView layoutIfNeeded];
        toVC.view.alpha = 1.0;
        snapShotView.frame = [containerView convertRect:toVC.currentView.frame fromView:toVC.view];
    } completion:^(BOOL finished) {

        toVC.playOnVC.bgImageView.hidden = NO;
        cell.iconImageView.hidden = NO;
        [snapShotView removeFromSuperview];

        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
    
}

@end
