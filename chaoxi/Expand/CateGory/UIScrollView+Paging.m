//
//  UIScrollView+Paging.m
//  chaoxi
//
//  Created by fizz on 16/1/13.
//  Copyright © 2016年 chaox. All rights reserved.
//

#import "UIScrollView+Paging.h"

static const float kAnimationDuration = 0.25f;

static const char cx_originContentHeight;
static const char cx_secondScrollView;

@interface UIScrollView()

@property (nonatomic, assign) float originContentHeight;

@end

@implementation UIScrollView (Paging)

- (void)setOriginContentHeight:(float)originContentHeight
{
    objc_setAssociatedObject(self, &cx_originContentHeight, @(originContentHeight), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (float)originContentHeight
{
    return [objc_getAssociatedObject(self, &cx_originContentHeight) floatValue];
}


- (void)setFirstScrollView:(UIScrollView *)firstScrollView
{
    [self addFirstScrollViewFooter];
}

- (UIScrollView *)secondScrollView
{
    return objc_getAssociatedObject(self, &cx_secondScrollView);
}

- (void)setSecondScrollView:(UIScrollView *)secondScrollView
{
    objc_setAssociatedObject(self, &cx_secondScrollView, secondScrollView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self addFirstScrollViewFooter];
    
    CGRect frame = self.bounds;
    frame.origin.y = self.contentSize.height + self.footer.frame.size.height;
    secondScrollView.frame = frame;
    
    [self addSubview:secondScrollView];
    
    [self addSecondScrollViewHeader];
}

- (void)addFirstScrollViewFooter
{
    __weak __typeof(self) weakSelf = self;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf endFooterRefreshing];
    }];
//    footer.appearencePercentTriggerAutoRefresh = 2;
    [footer setTitle:@"滑动查看更多" forState:MJRefreshStateIdle];
    
    self.footer = footer;
}

- (void)addSecondScrollViewHeader
{
    __weak __typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf endHeaderRefreshing];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"下拉,返回宝贝详情" forState:MJRefreshStateIdle];
    [header setTitle:@"释放,返回宝贝详情" forState:MJRefreshStatePulling];
    
    self.secondScrollView.header = header;
}

- (void)endFooterRefreshing
{
    [self.footer endRefreshing];
    self.footer.hidden = YES;
    self.scrollEnabled = NO;
    
    self.secondScrollView.header.hidden = NO;
    self.secondScrollView.scrollEnabled = YES;
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.contentInset = UIEdgeInsetsMake(-self.contentSize.height - self.footer.frame.size.height, 0, 0, 0);
    }];
    
    self.originContentHeight = self.contentSize.height;
    self.contentSize = self.secondScrollView.contentSize;
}

- (void)endHeaderRefreshing
{
    [self.secondScrollView.header endRefreshing];
    self.secondScrollView.header.hidden = YES;
    self.secondScrollView.scrollEnabled = NO;
    
    self.scrollEnabled = YES;
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.contentInset = UIEdgeInsetsMake(0, 0, self.footer.frame.size.height, 0);
    }];
    self.contentSize = CGSizeMake(0, self.originContentHeight);
    
    [self setContentOffset:CGPointZero animated:YES];
    
    [self addFirstScrollViewFooter];
}

@end
