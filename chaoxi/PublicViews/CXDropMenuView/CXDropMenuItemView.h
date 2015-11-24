//
//  CXDropMenuItemView.h
//  CXDropMenuView
//
//  Created by fizz on 15/11/19.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define SepHeight 2 // 分割线高度

@interface CXDropMenuItemView : UIView

@property (nonatomic, strong) UILabel *titleLabel;

@end
