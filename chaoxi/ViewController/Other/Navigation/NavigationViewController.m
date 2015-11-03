/********************************************************************
 文件名称 : NavigationViewController.m 文件
 作   者 : ChaoX
 创建时间 : 15/10/26
 文件描述 : 类
 *********************************************************************/

#import "NavigationViewController.h"
#import "ListenViewController.h"
#import "PoemViewController.h"
#import "ReadViewController.h"
#import "ArtViewController.h"
#import "FunnyViewController.h"
#import "CXWelcomeView.h"

@interface NavigationViewController ()

@property (strong, readwrite, nonatomic) REMenu *menu;
@property CXWelcomeView *introView;

@end

@implementation NavigationViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    if (REUIKitIsFlatMode()) {
        [self.navigationBar performSelector:@selector(setBarTintColor:) withObject:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1]];
        self.navigationBar.tintColor = [UIColor blackColor];
    } else {
        self.navigationBar.tintColor = [UIColor colorWithRed:0 green:179/255.0 blue:134/255.0 alpha:1];
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
                                                      PoemViewController *controller = [[PoemViewController alloc] init];
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
    
    REMenuItem *art = [[REMenuItem alloc] initWithTitle:@"Read"
                                                   image:nil
                                        highlightedImage:nil
                                                  action:^(REMenuItem *item) {
                                                      ArtViewController *controller = [[ArtViewController alloc] init];
                                                      [weakSelf setViewControllers:@[controller] animated:NO];
                                                  }];
    
    REMenuItem *funny = [[REMenuItem alloc] initWithTitle:@"Picture"
                                               subtitle:@"cici wish"
                                                  image:nil
                                       highlightedImage:nil
                                                 action:^(REMenuItem *item) {
                                                     FunnyViewController *controller = [[FunnyViewController alloc] init];
                                                     [weakSelf setViewControllers:@[controller] animated:NO];
                                                 }];
    
    listen.tag = 0;
    poem.tag = 1;
    art.tag = 2;
    read.tag = 3;
    funny.tag = 4;
    
    self.menu = [[REMenu alloc] initWithItems:@[listen, poem, read, art, funny]];
    
    if (!REUIKitIsFlatMode()) {
        self.menu.cornerRadius = 4;
        self.menu.shadowRadius = 4;
        self.menu.shadowColor = [UIColor blackColor];
        self.menu.shadowOffset = CGSizeMake(0, 1);
        self.menu.shadowOpacity = 1;
    }
    
    self.menu.separatorOffset = CGSizeMake(15.0, 0.0);
    self.menu.imageOffset = CGSizeMake(5, -1);
    self.menu.waitUntilAnimationIsComplete = NO;
    self.menu.badgeLabelConfigurationBlock = ^(UILabel *badgeLabel, REMenuItem *item) {
        badgeLabel.backgroundColor = [UIColor colorWithRed:0 green:179/255.0 blue:134/255.0 alpha:1];
        badgeLabel.layer.borderColor = [UIColor colorWithRed:0.000 green:0.648 blue:0.507 alpha:1.000].CGColor;
    };
    
    // MARK:- 欢迎页
//    [self addWelcomeView];
}

- (void)addWelcomeView {
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"YES"]) {
        self.introView = [[CXWelcomeView alloc] initWithFrame:self.view.frame];
        [self.view addSubview:self.introView];
    }
}

- (void)toggleMenu
{
    if (self.menu.isOpen)
        return [self.menu close];
    
    [self.menu showFromNavigationController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
