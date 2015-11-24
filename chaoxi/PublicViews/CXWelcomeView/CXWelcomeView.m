//
//  CXWelcomeView.m
//  chaoxi
//
//  Created by fizz on 15/10/29.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "CXWelcomeView.h"

@interface CXWelcomeView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIButton *doneButton;

@end

@implementation CXWelcomeView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
    }
    return self;
}

- (void)doneButtonClicked:(id)sender
{
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"YES"];
        [self removeFromSuperview];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = CGRectGetWidth(self.bounds);
    CGFloat pageFraction = self.scrollView.contentOffset.x / pageWidth;
    self.pageControl.currentPage = roundf(pageFraction);
}

- (void)setView
{
    for (NSUInteger i = 0 ; i < _pageCount; i++) {
        
        CGFloat originWidth = self.frame.size.width;
        CGFloat originHeight = self.frame.size.height;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(originWidth * i, 0, originWidth, originHeight)];
        
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:self.frame];
        imageview.backgroundColor = [UIColor greenColor];
        imageview.contentMode = UIViewContentModeScaleAspectFit;
        imageview.image = [UIImage imageNamed:[NSString stringWithFormat:@"welcome%zd",i]];
        [view addSubview:imageview];
        
        view.tag = i;
        
        self.scrollView.delegate = self;
        [self.scrollView addSubview:view];
    }
    
    UIView *view = [self viewWithTag:_pageCount - 1];
    [view addSubview:self.doneButton];
}

#pragma mark- setter and getter
- (void)setPageCount:(NSInteger)pageCount
{
    _pageCount = pageCount;
    self.pageControl.numberOfPages = pageCount;
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width*pageCount, self.scrollView.frame.size.height);
    [self setView];
}

- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        
        CGPoint scrollPoint = CGPointMake(0, 0);
        _scrollView = ({
           UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
            [scrollView setContentOffset:scrollPoint animated:YES];
            scrollView.pagingEnabled = YES;
            scrollView.showsVerticalScrollIndicator = NO;
            scrollView.showsHorizontalScrollIndicator = NO;
            scrollView.bounces = NO;
            scrollView;
        });
    }
    return _scrollView;
}

- (UIPageControl *)pageControl
{
    if (_pageControl == nil) {
        
        _pageControl = ({
            UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:({
                CGRect frame = CGRectMake(0, self.frame.size.height*0.9, self.frame.size.width, 10);
                frame;
            })];
            pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
            pageControl;
        });
    }
    return _pageControl;
}

- (UIButton *)doneButton
{
    if (_doneButton == nil) {
        
        _doneButton = ({
            UIButton *button = [[UIButton alloc] initWithFrame:({
                CGRect frame = CGRectMake(90 * ScreenWidth / 375, 530 * ScreenHeight / 667 , 210 * zoomRate, 65 * zoomRate);
                frame;
            })];
            [button addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            button.backgroundColor = [UIColor redColor];
            button;
        });
    }
    return _doneButton;
}

@end