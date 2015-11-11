//
//  ClearCacheViewController.m
//  chaoxi
//
//  Created by fizz on 15/11/5.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "ClearCacheViewController.h"

@interface ClearCacheViewController ()

@end

@implementation ClearCacheViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.hidesBarsOnSwipe = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.hidesBarsOnSwipe = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
