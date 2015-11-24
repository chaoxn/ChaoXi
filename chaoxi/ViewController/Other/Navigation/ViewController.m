//
//  ViewController.m
//  chaoxi
//
//  Created by fizz on 15/11/24.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "ViewController.h"
#import "ListenViewController.h"
#import "PoeViewController.h"
#import "ReadViewController.h"
#import "ArtViewController.h"
#import "FunnyViewController.h"
#import "CXDropMenuView.h"

@interface ViewController ()<CXDropMenuViewDelegate>

@property (nonatomic, strong) CXDropMenuView *dropView;
@property (nonatomic, strong) ListenViewController *listenVC;
@property (nonatomic, strong) PoeViewController *poeVC;
@property (nonatomic, strong) ReadViewController *readVC;
@property (nonatomic, strong) ArtViewController *artVC;
@property (nonatomic, strong) FunnyViewController *funnyVC;
@property (nonatomic, strong) UIViewController *currentVC;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    self.listenVC = [[ListenViewController alloc]init];
    self.listenVC.view.frame = self.view.frame;
    
    self.poeVC = [[PoeViewController alloc]init];
    self.poeVC.view.frame = self.view.bounds;
    
    self.readVC = [[ReadViewController alloc]init];
    self.readVC.view.frame = self.view.bounds;
    
    self.artVC = [[ArtViewController alloc]init];
    self.artVC.view.frame = self.view.bounds;
    
    self.funnyVC = [[FunnyViewController alloc] init];
    self.funnyVC.view.frame = self.view.bounds;
    
    [self addChildViewController:self.poeVC];
    [self.view addSubview:self.poeVC.view];
    self.currentVC = self.poeVC;
    
    self.dropView = [[CXDropMenuView alloc]initWithItems:@[@"First", @"Second",@"Third", @"Forth", @"five"]];
    self.dropView.delegate = self;
    self.dropView.viewController = self;

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"潮汐" style:UIBarButtonItemStylePlain target:self action:@selector(toggleMenu)];
    
}

- (void)itemViewClicked:(NSUInteger)index
{
    
    if ((self.currentVC == self.listenVC && index == 0) || (self.currentVC ==self.poeVC && index == 1) || (self.currentVC == self.readVC && index == 2) || (self.currentVC == self.artVC && index == 3) || (self.currentVC == self.funnyVC && index == 4)){
        
        return;
    }else{
        
        switch (index) {
            case 0:
                [self replaceController:self.currentVC newController:self.listenVC];
                break;
            case 1:
                [self replaceController:self.currentVC newController:self.poeVC];
                break;
            case 2:
                [self replaceController:self.currentVC newController:self.readVC];
                break;
            case 3:
                [self replaceController:self.currentVC newController:self.artVC];
                break;
            case 4:
                [self replaceController:self.currentVC newController:self.funnyVC];
                break;
            default:
                break;
        }
    }
}

- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController
{
    [self addChildViewController:newController];
    [self transitionFromViewController:oldController toViewController:newController duration:1.0 options:UIViewAnimationOptionOverrideInheritedCurve animations:nil completion:^(BOOL finished) {
        
        if (finished) {
            
            [newController didMoveToParentViewController:self];
            [oldController willMoveToParentViewController:nil];
            [oldController removeFromParentViewController];
            self.currentVC = newController;
            
        }else{
            
            self.currentVC = oldController;
        }
    }];
}

- (void)toggleMenu
{
    [self.dropView showMenuInView:self.view];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
