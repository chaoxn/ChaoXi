//
//  CXDropMenuItemView.m
//  CXDropMenuView
//
//  Created by fizz on 15/11/19.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "CXDropMenuItemView.h"


@interface CXDropMenuItemView ()

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) UIView *separatorView;

@end

@implementation CXDropMenuItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithRed:0.208  green:0.208  blue:0.204 alpha:1];
        
        [self addSubview:self.separatorView];
        [self addSubview:self.titleLabel];
        [self insertSubview:self.backgroundView atIndex:0];
    }
    return self;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        
        _titleLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:({
                CGRect frame = CGRectMake(0, 0, ScreenWidth, self.frame.size.height - SepHeight);
                frame;
            })];
            label.contentMode = UIViewContentModeCenter;
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor lightGrayColor];
            label.font = [UIFont boldSystemFontOfSize:18];
            label.shadowColor = [UIColor blackColor];
            label.shadowOffset = CGSizeMake(0, -1.0);
            label;
        });
    }
    return _titleLabel;
}

- (UIView *)backgroundView
{
    if (_backgroundView == nil) {
        
        _backgroundView = ({
            UIView *view = [[UIView alloc] initWithFrame:({
                CGRect frame = CGRectMake(0, 0, ScreenWidth, self.frame.size.height-SepHeight);
                frame;
            })];
            view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            view.backgroundColor =  [UIColor colorWithRed:0.208  green:0.208  blue:0.204 alpha:1];
            view;
        });
    }
    return _backgroundView;
}

- (UIView *)separatorView
{
    if (_separatorView == nil) {
        
        _separatorView = ({
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-1, ScreenWidth, 1)];
            view.backgroundColor = [UIColor darkGrayColor];
            view.layer.shadowColor = [UIColor blackColor].CGColor;
            view.layer.shadowOffset = CGSizeMake(3, 0);
            view.layer.shadowOpacity = 0.7;
            view;
        });
    }
    return _separatorView;
}

@end
