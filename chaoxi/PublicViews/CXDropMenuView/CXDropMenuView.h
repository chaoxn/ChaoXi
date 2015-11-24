//
//  CXDropMenuView.h
//  CXDropMenuView
//
//  Created by fizz on 15/11/19.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CXDropMenuViewDelegate <NSObject>

- (void)itemViewClicked :(NSUInteger )index;

@end

@interface CXDropMenuView : UIView

@property (nonatomic, weak) id <CXDropMenuViewDelegate> delegate;

@property (nonatomic, assign) Boolean isOPen;

@property (nonatomic, assign) NSUInteger itemHeight;

@property (nonatomic, strong) UIViewController *viewController;

- (void)showMenuInView:(UIView *)view;

- (instancetype)initWithItems:(NSArray *)items;

@end
