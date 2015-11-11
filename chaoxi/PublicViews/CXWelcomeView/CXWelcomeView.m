//
//  CXWelcomeView.m
//  chaoxi
//
//  Created by fizz on 15/10/29.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "CXWelcomeView.h"

@interface CXWelcomeView () <UIScrollViewDelegate>

@property (strong, nonatomic)  UIScrollView *scrollView;
@property (strong, nonatomic)  UIPageControl *pageControl;
@property UIView *holeView;
@property UIView *circleView;
@property UIButton *doneButton;

@end

@implementation CXWelcomeView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.bounces = NO;
        [self addSubview:self.scrollView];
        
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height*0.9, self.frame.size.width, 10)];
        self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        [self addSubview:self.pageControl];
        
        [self setView];
        
        self.pageControl.numberOfPages = 5;
        self.scrollView.contentSize = CGSizeMake(self.frame.size.width*5, self.scrollView.frame.size.height);
        
        CGPoint scrollPoint = CGPointMake(0, 0);
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }
    return self;
}

- (void)onFinishedIntroButtonPressed:(id)sender {
    
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"YES"];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = CGRectGetWidth(self.bounds);
    CGFloat pageFraction = self.scrollView.contentOffset.x / pageWidth;
    self.pageControl.currentPage = roundf(pageFraction);
    
}

- (void)setView
{
    for (NSUInteger i = 0 ; i < 5; i++) {
        CGFloat originWidth = self.frame.size.width;
        CGFloat originHeight = self.frame.size.height;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(originWidth * i, 0, originWidth, originHeight)];
        
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:self.frame];
        imageview.backgroundColor = [UIColor greenColor];
//           imageview.contentMode = UIViewContentModeScaleAspectFit;
        imageview.image = [UIImage imageNamed:[NSString stringWithFormat:@"welcome%zd",i]];
        [view addSubview:imageview];
        
        view.tag = i;
        
        self.scrollView.delegate = self;
        [self.scrollView addSubview:view];
    }
    
    UIView *view = [self viewWithTag:4];
    
    self.doneButton = [[UIButton alloc] initWithFrame:CGRectMake(90 * ScreenWidth / 375, 530 * ScreenHeight / 667 , 210 * zoomRate, 65 * zoomRate)];
    self.doneButton.backgroundColor = [UIColor clearColor];
    [self.doneButton addTarget:self action:@selector(onFinishedIntroButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:self.doneButton];
    
}


@end