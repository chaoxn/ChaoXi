//
//  ClearCacheViewController.m
//  chaoxi
//
//  Created by fizz on 15/11/5.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "ClearCacheViewController.h"

@interface ClearCacheViewController ()

@property (nonatomic, strong) UIButton *returnButton;

@end

@implementation ClearCacheViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.returnButton];
    [self layoutSubViews];
    
    [[self.returnButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
       
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)layoutSubViews
{
    self.view.backgroundColor = CXRGB16Color(0xf8dbe4);
    
    [self.returnButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.and.top.equalTo(self.view).with.offset(25);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [_vc.navigationController setNavigationBarHidden:NO animated:YES];
}

- (UIButton *)returnButton
{
    if (!_returnButton) {
        _returnButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
             [button setImage:[UIImage imageNamed:@"iconfont-return"] forState:UIControlStateNormal];
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
