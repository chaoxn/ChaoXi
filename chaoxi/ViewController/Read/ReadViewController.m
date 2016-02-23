//
//  ReadViewController.m
//  chaoxi
//
//  Created by fizz on 15/10/26.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "ReadViewController.h"

@interface ReadViewController ()

@property (nonatomic, strong) UITextField *inPutTF;
@property (nonatomic, strong) UIButton *searchButton;

@end

@implementation ReadViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.hidesBarsOnSwipe = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
