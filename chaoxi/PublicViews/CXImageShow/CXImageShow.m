//
//  CXImageShow.m
//  chaoxi
//
//  Created by fizz on 15/12/9.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "CXImageShow.h"
#define DHEIGHT 250

@interface CXImageShow ()

{
    UIWindow *window;
}

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation CXImageShow

- (id)init
{
    if (self = [super init]) {
        
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        
        window = [UIApplication sharedApplication].keyWindow;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

+ (CXImageShow *)share
{
    static dispatch_once_t once = 0;
    static CXImageShow *cxImageShow;
    
    dispatch_once(&once, ^{cxImageShow = [[CXImageShow alloc]init];});
    
    return cxImageShow;
}

+(void)showImage :(NSArray *)imageArr index:(NSInteger )index
{
    [[self share] createScrollView:imageArr:index];
    [[self share] show];
}

- (void)createScrollView:(NSArray *)array :(NSInteger )index
{
    if (!self.scrollView) {
        self.scrollView = ({
            UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, DHEIGHT)];
            scrollView.center = self.center;
            scrollView.contentSize = CGSizeMake(ScreenWidth * array.count, 0);
            scrollView.pagingEnabled = YES;
            scrollView;
        });
        [self addSubview:self.scrollView];
    }
    
    self.scrollView.contentOffset = CGPointMake(ScreenWidth * index, 0);
    
    for (NSInteger i = 0; i < array.count; i++) {
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0 + ScreenWidth*i, 0, ScreenWidth, DHEIGHT)];
        
        UIImageView *old = array[i];
        UIImageView *im = [[UIImageView alloc]initWithImage:old.image];
        im.frame = view.bounds;
        
        [view addSubview:im];
        [self.scrollView addSubview:view];
    }
}

- (void)show
{
    [UIView animateWithDuration:0.618 animations:^{
        
        self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.8];
        
    } completion:^(BOOL finished) {
        
        [window addSubview:self];
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.618 animations:^{
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}

@end
