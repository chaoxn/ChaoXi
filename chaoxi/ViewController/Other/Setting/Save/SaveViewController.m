//
//  SaveViewController.m
//  chaoxi
//
//  Created by fizz on 15/11/5.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "SaveViewController.h"
#import "CXPopTransition.h"

@interface SaveViewController ()<UINavigationControllerDelegate>

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *percentTransition;

@end

@implementation SaveViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationController.delegate = self;
    [self.view addSubview:self.returnButton];
    [self layoutSubViews];
    
    [[self.returnButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)layoutSubViews
{
    self.view.backgroundColor = [UIColor yellowColor];
    
    [self.returnButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.and.top.equalTo(self.view).with.offset(25);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPop) {
        CXPopTransition *pop = [CXPopTransition new];
        pop.popVC = self;
        return pop;
    }else{
        return nil;
    }
}

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    return _percentTransition;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
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
