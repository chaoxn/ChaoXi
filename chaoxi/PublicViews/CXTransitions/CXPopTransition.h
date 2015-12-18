//
//  CXPopTransition.h
//  chaoxi
//
//  Created by fizz on 15/12/10.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CXPopTransition : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, strong) UIViewController *pushVC;

@property (nonatomic, strong) UIViewController *popVC;

@property (nonatomic, assign) NSInteger index;

@end
