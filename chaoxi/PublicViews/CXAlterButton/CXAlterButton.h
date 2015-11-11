//
//  CXAlterButton.h
//  AlterButtonDemo
//
//  Created by fizz on 15/11/2.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXAlterItemButton.h"

@class CXAlterButton;

@protocol CXAlterButtonDelegate <NSObject>

- (void)AlterButton:(CXAlterButton *)button clickItemButtonAtIndex:(NSUInteger)index;

@end

@interface CXAlterButton : UIView

@property (nonatomic, weak) id <CXAlterButtonDelegate> delegate;

@property (nonatomic, assign) CGPoint  buttonCenter;

@property (nonatomic, assign) CGSize buttonSize;

@property (nonatomic) float animationDuration;

- (instancetype)initWithImage :(UIImage *)centerImage;

- (void)addButtonItems:(NSArray *)itemButton;

@end
