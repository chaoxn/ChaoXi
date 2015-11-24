/********************************************************************
 文件名称 : NavigationViewController.h 文件
 作   者 : ChaoX
 创建时间 : 15/10/26
 文件描述 : 类
 *********************************************************************/

#import <UIKit/UIKit.h>
#import "REMenu.h"

@interface NavigationViewController : UINavigationController

@property (nonatomic, strong) REMenu *menu;

- (void)toggleMenu;

@end
