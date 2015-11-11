//
//  CXAlterItemButton.h
//  AlterButtonDemo
//
//  Created by fizz on 15/11/2.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CXAlterItemButton;

@protocol CXAlterItemButtonDelegate <NSObject>

- (void)itemButtonClicked:(CXAlterItemButton *)itemButton;

@end

@interface CXAlterItemButton : UIButton

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, weak) id <CXAlterItemButtonDelegate> delegate;

- (instancetype)initWithImage :(UIImage *)image;

@end
