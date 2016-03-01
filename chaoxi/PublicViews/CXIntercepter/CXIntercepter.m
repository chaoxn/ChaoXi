//
//  CXIntercepter.m
//  chaoxi
//
//  Created by fizz on 15/12/11.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "CXIntercepter.h"
#import "AboutUsViewController.h"
#import "ClearCacheViewController.h"
#import "SaveViewController.h"
#import "NavigationViewController.h"
#import "CXPushTransition.h"
#import "CXPopTransition.h"
#import "CXScaleTransition.h"
#import "CXScaleReturn.h"

#define NeedInterceptArr @[@"ArtViewController",@"FunnyViewController",@"ListenViewController",@"PoeViewController",@"ReadViewController"]

#define NeedReturnArr @[@"PlayBaseViewController", @"ShowDetailViewController",@"VideoDetailController"]

//typedef void (^AspectHandlerBlock)(id<AspectInfo> aspectInfo);

@interface CXIntercepter()

@property (nonatomic, strong) UIViewController *baseViewController;
@property (nonatomic, strong) UIViewController *returnViewController;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) SaveViewController *saveVC;
@property (nonatomic, strong) AboutUsViewController *aboutVC;
@property (nonatomic, strong) ClearCacheViewController *clearVC;

@end

@implementation CXIntercepter 

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static CXIntercepter *sharedInstance;
    
    dispatch_once(&onceToken, ^{ sharedInstance = [[CXIntercepter alloc] init];});
    
    return sharedInstance;
}

/**
 *  自动被runtime调用
 */
+ (void)load
{
    [super load];
    [CXIntercepter sharedInstance];
}

- (instancetype)init
{
    if (self = [super init]) {
        
        // 拦截 🤒
        [UIViewController aspect_hookSelector:@selector(loadView)
                                  withOptions:AspectPositionAfter
                                   usingBlock:^(id<AspectInfo>aspectInfo){
                                       
            NSString *className = NSStringFromClass([[aspectInfo instance] class]);
                                       
                                       if ([NeedInterceptArr containsObject:className]) {
               
                                           self.baseViewController = [aspectInfo instance];
                                           [self loadView:[aspectInfo instance]];
                                       }
        } error:NULL];
        
        [UIViewController aspect_hookSelector:@selector(viewWillAppear:)
                                  withOptions:AspectPositionAfter
                                   usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated){
                               
           NSString *className = NSStringFromClass([[aspectInfo instance] class]);
           
                                       if ([NeedInterceptArr containsObject:className]) {
                                           
                                           [self viewWillAppear:animated viewController:[aspectInfo instance]];
                                       }
                                    
                                       if ([NeedReturnArr containsObject:className]) {
                                           
                                           [self addReturnPic:[aspectInfo instance]];
                                       }
                                       
        } error:NULL];
    }
    return self;
}

#pragma mark - fake methods
- (void)loadView:(UIViewController *)viewController
{
    NSLog(@"[%@ loadView]", [viewController class]);
    
    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"潮汐" style:UIBarButtonItemStylePlain target:viewController.navigationController action:@selector(presenting)];
    
    viewController.navigationController.delegate = self;
    viewController.navigationController.navigationBar.tintColor = CXRGBColor(32, 47, 60);
    viewController.navigationController.navigationBar.barTintColor = CXRGBColor(245, 245, 245);
    
    [self addWindow];
}

- (void)viewWillAppear:(BOOL)animated viewController:(UIViewController *)viewController
{
    viewController.navigationController.navigationBar.tintColor = CXRGBColor(32, 47, 60);
    viewController.navigationController.navigationBar.barTintColor = CXRGBColor(245, 245, 245);
    NSLog(@"[%@ viewWillAppear]", [viewController class]);
}

- (void)addReturnPic:(UIViewController *)viewController
{
    self.returnViewController = viewController;
    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"iconfont-return"] style:UIBarButtonItemStyleDone target:self action:@selector(returnAciton:)];
}

- (void)returnAciton:(UIBarButtonItem *)sender
{
    [self.returnViewController.navigationController popViewControllerAnimated:YES];
}

-(void)addWindow
{
    CXAlterButton *button = [[CXAlterButton alloc]initWithImage:[UIImage imageNamed:@"jian"]];
    
    CXAlterItemButton *item1 = [[CXAlterItemButton alloc]initWithImage:[UIImage imageNamed:@"item1"]];
    
    CXAlterItemButton *item2 = [[CXAlterItemButton alloc]initWithImage:[UIImage imageNamed:@"item2"]];
    
    CXAlterItemButton *item3 = [[CXAlterItemButton alloc]initWithImage:[UIImage imageNamed:@"item3"]];
    
    button.buttonCenter = CGPointMake(225,8);
    button.buttonSize = CGSizeMake(30, 30);
    
    [button addButtonItems:@[item1, item2, item3]];
    
    button.animationDuration = 0.5;
    button.delegate = self;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 250, 44)];
    view.backgroundColor = [UIColor clearColor];
    
    [view addSubview:button ];
    
    self.baseViewController.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc]initWithCustomView:view];
}

- (void)AlterButton:(CXAlterButton *)button clickItemButtonAtIndex:(NSUInteger)index
{
    self.index = index;
    
    switch (index) {
        case 0:
        {
            SaveViewController *saveVC = [[SaveViewController alloc]init];
            saveVC.vc = self.baseViewController;
            [self.baseViewController.navigationController pushViewController:saveVC animated:YES];
        }
            break;
        case 1:
        {
            AboutUsViewController *abVC = [[AboutUsViewController alloc]init];
            abVC.vc = self.baseViewController;
            [self.baseViewController.navigationController pushViewController:abVC animated:YES];
        }
            break;
        case 2:
        {
            ClearCacheViewController *clearVC = [[ClearCacheViewController alloc]init];
            clearVC.vc = self.baseViewController;
            [self.baseViewController.navigationController pushViewController:clearVC animated:YES];
        }
            break;
        default:
            break;
    }
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPush) {
        
        CXScaleTransition *push = [[CXScaleTransition alloc]init];
        
        return push;
    }
    else if (operation == UINavigationControllerOperationPop){
        
        CXScaleReturn *pop  = [[CXScaleReturn alloc]init];
        
        return pop;
    }
    else{
        return nil;
    }
}

@end
