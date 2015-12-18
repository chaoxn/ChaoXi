//
//  BaseViewController.h
//  chaoxi
//
//  Created by fizz on 15/10/27.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationViewController.h"
#import "CXAlterButton.h"

@interface BaseViewController : UIViewController

@property (nonatomic) KVNProgressConfiguration *basicConfiguration;
@property (nonatomic) KVNProgressConfiguration *customConfiguration;

@property (nonatomic,strong) UIButton *button;

- (void)showProgress:(NSString *)str;

- (KVNProgressConfiguration *)customKVNProgressUIConfiguration;

@end
