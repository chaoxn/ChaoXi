//
//  PlayBaseViewController.m
//  chaoxi
//
//  Created by fizz on 15/12/22.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "PlayBaseViewController.h"
#import "PlayOnViewController.h"
#import "RadioListViewController.h"
#import "CXAudioPlayer.h"

@interface PlayBaseViewController ()<UIScrollViewDelegate, UIWebViewDelegate>

@property (nonatomic, strong) PlayOnViewController *playOnVC;
@property (nonatomic, strong) RadioListViewController *radioListVC;
@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIButton *playBt;
@property (nonatomic, strong) UIButton *nextBt;
@property (nonatomic, strong) UIButton *lastBt;
@property (nonatomic, strong) RACSignal *listPlaySignal;

@end

@implementation PlayBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.baseView];
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.pageControl];
    
    [self.view addSubview:self.nextBt];
    [self.view addSubview:self.lastBt];
    [self.view addSubview:self.playBt];
    
    [self layoutSubviews];
    [self addChildVC];
    [self dataBinging];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.navigationController.navigationBar lt_setBackgroundColor:CXRGBAColor(245, 245, 245, 1)];
}

- (void)layoutSubviews
{
    @weakify(self);
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        @strongify(self);
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        @strongify(self);
        make.edges.equalTo(self.scrollView).with.insets(UIEdgeInsetsMake(-64, 0, 0, 0));
        make.height.mas_equalTo(self.scrollView.frame.size.height - 100 * HeightRate);
        make.width.mas_equalTo(ScreenWidth * 3);
    }];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
       
        @strongify(self)
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.baseView.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(120, 20));
    }];
    
    [self.playBt mas_makeConstraints:^(MASConstraintMaker *make) {
       
        @strongify(self)
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];

    [self.nextBt mas_makeConstraints:^(MASConstraintMaker *make) {
        
        @strongify(self)
        make.centerY.equalTo(self.playBt);
        make.trailing.equalTo(self.view.mas_trailing).offset(-70);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [self.lastBt mas_makeConstraints:^(MASConstraintMaker *make) {
        
        @strongify(self)
        make.centerY.equalTo(self.playBt);
        make.leading.equalTo(self.view).offset(70);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
}

- (void)addChildVC
{
    [self addChildViewController:self.playOnVC];
    [self addChildViewController:self.radioListVC];
    [self.baseView addSubview:self.radioListVC.view];
    [self.baseView addSubview:self.playOnVC.view];
    [self.baseView addSubview:self.webView];
    
    @weakify(self);
    [self.playOnVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
       
         @strongify(self);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, ScreenHeight-100 * HeightRate));
        make.top.equalTo(self.baseView);
        make.leading.mas_equalTo(ScreenWidth);
    }];
    
    [self.radioListVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        @strongify(self);
        make.size.equalTo(self.playOnVC.view);
        make.top.and.leading.equalTo(self.baseView);
    }];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.size.equalTo(self.playOnVC.view);
        make.top.equalTo(self.baseView).offset(10);
        make.leading.mas_equalTo(ScreenWidth*2);
    }];
    
}

- (void)dataBinging
{
    // 阅读视图
    [[RACObserve([CXAudioPlayer shareInstance], index) map:^id(NSNumber *value) {
        
        return [CXAudioPlayer shareInstance].modelArr[[value integerValue]];
    }] subscribeNext:^(ViedoModel *model) {
        
        NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:model.webview_url]];
        [self.webView loadRequest:request];
    }];
    
    [[self.playBt rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *button) {
        
        button.selected = !button.selected;
        [[CXAudioPlayer shareInstance] begin];
    }];
    
    [[self.nextBt rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
       
        [[CXAudioPlayer shareInstance] next];
    }];
    
    [[self.lastBt rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        [[CXAudioPlayer shareInstance] last];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageFraction = self.scrollView.contentOffset.x / ScreenWidth;
    
    self.pageControl.currentPage = roundf(pageFraction);
}

#pragma mark - getter

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView =({
            UIScrollView *scrollView =[[UIScrollView alloc]initWithFrame:self.view.bounds];
            scrollView.pagingEnabled = YES;
            scrollView.bounces = NO;
            scrollView.showsHorizontalScrollIndicator = NO;
            scrollView.contentOffset = CGPointMake(ScreenWidth, 0);
            scrollView;
        });
    }
    return _scrollView;
}

- (UIView *)baseView
{
    if (!_baseView) {
        _baseView = ({
            UIView *view = [UIView new];
            view.backgroundColor = [UIColor redColor];
            view;
        });
    }
    return _baseView;
}

- (UIPageControl *)pageControl
{
    if (_pageControl == nil) {
        _pageControl = ({
            UIPageControl *pageControl = [[UIPageControl alloc] init];
            pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
            pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
            pageControl.numberOfPages = 3;
            pageControl.currentPage = 1;
            pageControl;
        });
    }
    return _pageControl;
}

- (UIWebView *)webView
{
    if (!_webView) {
        _webView = ({
            UIWebView *webView = [[UIWebView alloc]init];
            webView.backgroundColor = [UIColor whiteColor];
            webView.scalesPageToFit = YES;
            webView.delegate = self;
            webView;
        });
    }
    return _webView;
}

- (UIButton *)playBt
{
    if (!_playBt) {
        _playBt =({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"playBt"] forState:UIControlStateSelected];
            [button setImage:[UIImage imageNamed:@"stopBt"] forState:UIControlStateNormal];
            button;
        });
    }
    return _playBt;
}

- (UIButton *)nextBt
{
    if (!_nextBt) {
        _nextBt =({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
            button;
        });
    }
    return _nextBt;
}

- (UIButton *)lastBt
{
    if (!_lastBt) {
        _lastBt =({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"last"] forState:UIControlStateNormal];
            button;
        });
    }
    return _lastBt;
}

- (PlayOnViewController *)playOnVC
{
    if (!_playOnVC) {
        _playOnVC =  ({
            PlayOnViewController *playOnVC =  [[PlayOnViewController alloc]initWithNibName:@"PlayOnViewController" bundle:nil];
            playOnVC;
        });
    }
    return _playOnVC;
}

- (RadioListViewController *)radioListVC
{
    if (!_radioListVC) {
        _radioListVC =  ({
            RadioListViewController *radioListVC =  [[RadioListViewController alloc]initWithNibName:@"RadioListViewController" bundle:nil];
            radioListVC;
        });
    }
    return _radioListVC;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
