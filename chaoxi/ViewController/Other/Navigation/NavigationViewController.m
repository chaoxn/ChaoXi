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
#import "CXDropMenuView.h"

@interface NavigationViewController ()

@end

@implementation NavigationViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (REUIKitIsFlatMode()) {
        [self.navigationBar performSelector:@selector(setBarTintColor:) withObject:CXRGBAColor(245, 245, 245, 1)];
        self.navigationBar.tintColor = [UIColor colorWithRed:0.196  green:0.278  blue:0.376 alpha:1];
    } else {
        self.navigationBar.tintColor = CXRGBAColor(0, 179, 134, 1);
    }
    
    __typeof (self) __weak weakSelf = self;
    
    REMenuItem *listen = [[REMenuItem alloc] initWithTitle:@"Listen"
                                                     image:nil
                                          highlightedImage:nil
                                                    action:^(REMenuItem *item) {
                                                        ListenViewController *controller = [[ListenViewController alloc] init];
                                                        [weakSelf setViewControllers:@[controller] animated:NO];
                                                    }];
    
    REMenuItem *poem = [[REMenuItem alloc] initWithTitle:@"Poem"
                                                   image:nil
                                        highlightedImage:nil
                                                  action:^(REMenuItem *item) {
                                                      PoeViewController *controller = [[PoeViewController alloc] init];
                                                      [weakSelf setViewControllers:@[controller] animated:NO];
                                                  }];
    
    REMenuItem *read = [[REMenuItem alloc] initWithTitle:@"Movie"
                                                    image:nil
                                         highlightedImage:nil
                                                   action:^(REMenuItem *item) {
                                                       ReadViewController *controller = [[ReadViewController alloc] init];
                                                       [weakSelf setViewControllers:@[controller] animated:NO];
                                                   }];
    // 高亮小标
    //    movie.badge = @"12";
    REMenuItem *art = [[REMenuItem alloc] initWithTitle:@"Art"
                                                   image:nil
                                        highlightedImage:nil
                                                  action:^(REMenuItem *item) {
                                                      ArtViewController *controller = [[ArtViewController alloc] init];
                                                      [weakSelf setViewControllers:@[controller] animated:NO];
                                                  }];
    
    REMenuItem *funny = [[REMenuItem alloc] initWithTitle:@"Picture"
//                                               subtitle:@"cici wish"
                                                  image:nil
                                       highlightedImage:nil
                                                 action:^(REMenuItem *item) {
                                                     FunnyViewController *controller = [[FunnyViewController alloc] init];
                                                     [weakSelf setViewControllers:@[controller] animated:NO];
                                                 }];
    
    
    self.menu = [[REMenu alloc] initWithItems:@[listen, poem, read, art, funny]];
    self.menu.separatorOffset = CGSizeMake(15.0, 0.0);

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

- (void)toggleMenu
{
    if (self.menu.isOpen)
        return [self.menu close];
    
    [self.menu showFromNavigationController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
