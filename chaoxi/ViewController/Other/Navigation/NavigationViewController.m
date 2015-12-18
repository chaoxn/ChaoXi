/********************************************************************
 文件名称 : NavigationViewController.m 文件
 作   者 : ChaoX
 创建时间 : 15/10/26
 文件描述 : 类
 *********************************************************************/

#import "NavigationViewController.h"
#import "ListenViewController.h"
#import "PoeViewController.h"
#import "ReadViewController.h"
#import "ArtViewController.h"
#import "FunnyViewController.h"
#import "CXWelcomeView.h"
#import "CXAlterButton.h"
#import "ModalViewController.h"
#import "CXPresentTransition.h"
#import "CXDismissTransition.h"

@interface NavigationViewController ()

@property (nonatomic, assign) NSInteger index;

@end

@implementation NavigationViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
//     MARK:- 欢迎页
//    [self addWelcomeView];
}

- (void)addWelcomeView
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"YES"]) {
        
        CXWelcomeView *cxWV = [[CXWelcomeView alloc] initWithFrame:self.view.frame];
        cxWV.pageCount = 5;
        [self.view addSubview:cxWV];
    }
}

- (void)presenting
{
    ModalViewController *modalViewController = [ModalViewController new];
    modalViewController.transitioningDelegate = self;
    modalViewController.modalPresentationStyle = UIModalPresentationCustom;
    
    [[RACObserve(modalViewController, index) filter:^BOOL(NSNumber *value) {
        
        return [value integerValue] > 9;
        
    }] subscribeNext:^(NSNumber *index) {
                
        switch ([index integerValue]) {
            case 11:
            {
                PoeViewController *poe = [[PoeViewController alloc]init];
                [self setViewControllers:@[poe] animated:NO];
            }
                break;
            case 10:
            {
                ListenViewController *listen =[[ListenViewController alloc]init];
                [self setViewControllers:@[listen] animated:NO];
            }
                break;
            case 12:
            {
                ReadViewController *controller = [[ReadViewController alloc] init];
                [self setViewControllers:@[controller] animated:NO];
            }
                break;
            case 13:
            {
                ArtViewController *controller = [[ArtViewController alloc] init];
                [self setViewControllers:@[controller] animated:NO];
            }
                break;
            case 14:
            {
                FunnyViewController *controller = [[FunnyViewController alloc] init];
                [self setViewControllers:@[controller] animated:NO];
            }
                break;
            default:
                break;
        }
    }];
    
    [self presentViewController:modalViewController
                                            animated:YES
                                          completion:NULL];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    return [CXPresentTransition new];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [CXDismissTransition new];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
