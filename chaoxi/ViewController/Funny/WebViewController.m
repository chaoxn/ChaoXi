//
//  WebViewController.m
//  chaoxi
//
//  Created by fizz on 15/11/17.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "WebViewController.h"

static void dispatch_main_after(NSTimeInterval delay, void (^block)(void))
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        block();
    });
}

@interface WebViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIButton *returnButton;

@end

@implementation WebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.webView];
    [self.view insertSubview:self.returnButton aboveSubview:self.webView];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    [self.webView loadRequest:request];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self.basicConfiguration = [KVNProgressConfiguration defaultConfiguration];
    self.customConfiguration = [self customKVNProgressUIConfiguration];
    self.basicConfiguration.fullScreen = YES;
    self.customConfiguration.fullScreen = YES;
    
    [KVNProgress showProgress:0.0f status:@"Loading..."];
    
    [self updateProgress];
    
    dispatch_main_after(2.7f, ^{
        [KVNProgress updateStatus:@"请稍等..."];
    });
    
}
- (void)updateProgress
{
    dispatch_main_after(2.0f, ^{
        [KVNProgress updateProgress:0.3f
                           animated:YES];
    });
    dispatch_main_after(2.5f, ^{
        [KVNProgress updateProgress:0.5f
                           animated:YES];
    });
    dispatch_main_after(2.8f, ^{
        [KVNProgress updateProgress:0.6f
                           animated:YES];
    });
    dispatch_main_after(3.7f, ^{
        [KVNProgress updateProgress:0.93f
                           animated:YES];
    });
    dispatch_main_after(5.0f, ^{
        [KVNProgress updateProgress:1.0f
                           animated:YES];
    });
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [KVNProgress showSuccessWithStatus:@"Success"];
}

- (void)returnAction
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)dealloc
{
    self.webView.delegate = nil;
}

- (UIWebView *)webView
{
    if (_webView == nil) {

        _webView = ({
            UIWebView *webView = [[UIWebView alloc]initWithFrame:({
                CGRect frame = CGRectMake(0, 30, ScreenWidth, ScreenHeight-20);
                frame;
            })];
            webView.scalesPageToFit = YES;
            webView.delegate = self;
            webView.scrollView.bounces = NO;
            webView;
        });
    }
    return _webView;
}

- (UIButton *)returnButton
{
    if (_returnButton == nil) {
        
        _returnButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(20, ScreenHeight-70, 40, 40);
            [button setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
            button.imageEdgeInsets = UIEdgeInsetsMake(7, 6, 7, 6);
            button.backgroundColor = [UIColor blackColor];
            button.alpha = 0.618;
            button.layer.cornerRadius = 20;
            [button addTarget:self action:@selector(returnAction) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _returnButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
