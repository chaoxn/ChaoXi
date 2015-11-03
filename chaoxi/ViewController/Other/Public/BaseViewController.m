//
//  BaseViewController.m
//  chaoxi
//
//  Created by fizz on 15/10/27.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "BaseViewController.h"
#import "NavigationViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"潮汐" style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(toggleMenu)];
    
    //TODO:- 按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Temp" style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(toggleMenu)];
    
    
    self.navigationController.hidesBarsOnSwipe = YES;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    NavigationViewController *navigationController = (NavigationViewController *)self.navigationController;
    [navigationController.menu setNeedsLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
