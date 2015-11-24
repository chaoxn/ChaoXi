//
//  BaseViewController.m
//  chaoxi
//
//  Created by fizz on 15/10/27.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "BaseViewController.h"
#import "NavigationViewController.h"
#import "AboutUsViewController.h"
#import "ClearCacheViewController.h"
#import "SaveViewController.h"
#import "CXAlterButton.h"

@interface BaseViewController ()<CXAlterButtonDelegate>

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"潮汐" style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(toggleMenu)];
    
     [self performSelector:@selector(addWindow) withObject:nil afterDelay:0.01];
}

- (void)viewWillAppear:(BOOL)animated
{
     self.navigationController.hidesBarsOnSwipe = YES;
}

-(void)addWindow{
    
    CXAlterButton *button = [[CXAlterButton alloc]initWithImage:[UIImage imageNamed:@"jian"]];
    
    CXAlterItemButton *item1 = [[CXAlterItemButton alloc]initWithImage:[UIImage imageNamed:@"item1"]];
    
    CXAlterItemButton *item2 = [[CXAlterItemButton alloc]initWithImage:[UIImage imageNamed:@"item2"]];
    
    CXAlterItemButton *item3 = [[CXAlterItemButton alloc]initWithImage:[UIImage imageNamed:@"item3"]];
    
    [button addButtonItems:@[item1, item2, item3]];
        
    button.buttonCenter = CGPointMake(225,8);
    button.buttonSize = CGSizeMake(30, 30);
    
    button.animationDuration = 0.5;
    button.delegate = self;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 250, 44)];
    view.backgroundColor = [UIColor clearColor];
    
    
    [view addSubview:button];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:view];
}

- (void)AlterButton:(CXAlterButton *)button clickItemButtonAtIndex:(NSUInteger)index
{
    switch (index) {
        case 0:
        {
            SaveViewController *saveVC = [[SaveViewController alloc]init];
            [self.navigationController pushViewController:saveVC animated:YES];
        }
            break;
        case 1:
        {
            AboutUsViewController *abVC = [[AboutUsViewController alloc]init];
            [self.navigationController pushViewController:abVC animated:YES];
        }
            break;
        case 2:
        {
            ClearCacheViewController *clearVC = [[ClearCacheViewController alloc]init];
            [self.navigationController pushViewController:clearVC animated:YES];
        }
            break;
        default:
            break;
    }
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

- (void)showProgress:(NSString *)str
{
    self.basicConfiguration = [KVNProgressConfiguration defaultConfiguration];
    self.customConfiguration = [self customKVNProgressUIConfiguration];
    [KVNProgress showWithStatus:str];
}

- (KVNProgressConfiguration *)customKVNProgressUIConfiguration
{
    KVNProgressConfiguration *configuration = [[KVNProgressConfiguration alloc] init];
    
    configuration.statusColor = [UIColor whiteColor];
    configuration.statusFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:15.0f];
    configuration.circleStrokeForegroundColor = [UIColor whiteColor];
    configuration.circleStrokeBackgroundColor = [UIColor colorWithWhite:1.0f alpha:0.3f];
    configuration.circleFillBackgroundColor = [UIColor colorWithWhite:1.0f alpha:0.1f];
    configuration.backgroundFillColor = [UIColor colorWithRed:0.173f green:0.263f blue:0.856f alpha:0.9f];
    configuration.backgroundTintColor = [UIColor colorWithRed:0.173f green:0.263f blue:0.856f alpha:0.4f];
    configuration.successColor = [UIColor whiteColor];
    configuration.errorColor = [UIColor whiteColor];
    configuration.circleSize = 110.0f;
    configuration.lineWidth = 1.0f;
    
    return configuration;
}



@end
