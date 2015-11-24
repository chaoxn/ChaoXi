//
//  CXDropMenuView.m
//  CXDropMenuView
//
//  Created by fizz on 15/11/19.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "CXDropMenuView.h"
#import "CXDropMenuItemView.h"

#define BehindBarHeight 100
#define Perfect 0.618

@interface CXDropMenuView()

@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, strong) NSArray *views;

@property (nonatomic, strong) UIView *headerView;

@end

@implementation CXDropMenuView

- (instancetype)initWithItems:(NSArray *)items
{
    if (self = [super init]) {
        
        self.views = items;        
        self.itemHeight = 50;
        
        self.frame = CGRectMake(0, -450, ScreenWidth, ScreenHeight);
        self.backgroundColor = [UIColor clearColor];
        [self initItemViews];
    }
    return self;
}

- (void)initItemViews
{
    for (int i = 0; i < self.views.count; i++) {
        
        CXDropMenuItemView *view = [[CXDropMenuItemView alloc]initWithFrame:CGRectMake(0, BehindBarHeight+ 64 +(self.itemHeight)*i, ScreenWidth, self.itemHeight)];
        view.titleLabel.text = self.views[i];
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemClicked:)];
        view.tag = i;
        [view addGestureRecognizer:tapGes];
        
        [self addSubview:view];
    }
    
    [self addSubview:self.headerView];
}

- (void)itemClicked:(UITapGestureRecognizer *)tap
{
    NSUInteger i = tap.view.tag;
    
    for (CXDropMenuItemView *view in self.subviews) {
        
        if (view.tag == i && [self.delegate respondsToSelector:@selector(itemViewClicked:)]) {
            
            [self.delegate itemViewClicked:i];
            
            [self closedMenuView];
        }
    }
}

#pragma mark - viewEvent

- (void)showMenuInView:(UIView *)view
{
    if (self.isOPen) {
        
        [self closedMenuView];
    }else{
        
        [self openedMenuView];
    }
    
    [view addSubview:self.coverView];
    [view addSubview:self];
}

- (void)openedMenuView
{
    self.isOPen = YES;
    [UIView animateWithDuration:Perfect delay:0.01 usingSpringWithDamping:1-Perfect initialSpringVelocity:6.18 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        
        self.frame = CGRectMake(0, -BehindBarHeight, ScreenWidth, ScreenHeight);
        self.coverView.alpha = 1 - Perfect;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)closedMenuView
{
    self.isOPen = NO;
    [UIView animateWithDuration: 1 - Perfect animations:^{
        
        self.frame = CGRectMake(0, -450, ScreenWidth, ScreenHeight);
        self.coverView.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}

#pragma mark- setter && getter

- (UIView *)coverView
{
    if (_coverView == nil) {
        
        _coverView = ({
            UIView *view = [[UIView alloc]initWithFrame:({
                CGRect frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
                frame;
            })];
            view.alpha = 0;
            view.backgroundColor = [UIColor blackColor];
            view;
        });
    }
    return _coverView;
}

- (UIView *)headerView
{
    if (_headerView == nil) {
        
        _headerView = ({
            UIView *view = [[UIView alloc]initWithFrame:({
                CGRect frame = CGRectMake(0, 64, ScreenWidth, 100);
                frame;
            })];
            view.backgroundColor = [UIColor colorWithRed:0.208  green:0.208  blue:0.204 alpha:1];
            view;
        });
    }
    return _headerView;
}

@end
