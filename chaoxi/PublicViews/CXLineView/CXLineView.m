//
//  CXLineView.m
//  chaoxi
//
//  Created by fizz on 15/12/24.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "CXLineView.h"

@implementation CXLineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UIView *view = self;
    
    //判断是否开启了AutoLayout
    if (self.translatesAutoresizingMaskIntoConstraints == NO) {
        
        view.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSDictionary *selfDic = NSDictionaryOfVariableBindings(view);
        
        for (NSLayoutConstraint *constraint in self.constraints) {
            
            if (constraint.firstAttribute == NSLayoutAttributeHeight && self.tag == LineType_Top) {
                
                [self removeConstraint:constraint];
                
                [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(0.5)]" options:1 metrics:0 views:selfDic]];
            }
            
            if (self.tag == LineType_Bottom) {
                
                if (constraint.firstAttribute == NSLayoutAttributeHeight) {
                    
                    [self removeConstraint:constraint];
                    
                    [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(0.5)]" options:1 metrics:0 views:selfDic]];
                }
                
                if (constraint.firstAttribute == NSLayoutAttributeTop) {
                    
                    [self removeConstraint:constraint];
                    
                    [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-1-[view]" options:1 metrics:0 views:selfDic]];
                }
                
                if (constraint.firstAttribute == NSLayoutAttributeBottom) {
                    
                    [self removeConstraint:constraint];
                    
                    [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view]|" options:1 metrics:0 views:selfDic]];
                }
            }
            
            if (self.tag == LineType_Left) {
                
                if (constraint.firstAttribute == NSLayoutAttributeWidth) {
                    
                    [self removeConstraint:constraint];
                    
                    [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[view(0.5)]" options:1 metrics:0 views:selfDic]];
                }
                
                if (constraint.firstAttribute == NSLayoutAttributeLeft) {
                    
                    [self removeConstraint:constraint];
                    
                    [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-1-[view]" options:1 metrics:0 views:selfDic]];
                }
            }
            
            if (self.tag == LineType_Right) {
                
                if (constraint.firstAttribute == NSLayoutAttributeWidth) {
                    
                    [self removeConstraint:constraint];
                    
                    [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[view(0.5)]" options:1 metrics:0 views:selfDic]];
                }
                
                if (constraint.firstAttribute == NSLayoutAttributeRight) {
                    
                    [self removeConstraint:constraint];
                    
                    [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[view]-1-|" options:1 metrics:0 views:selfDic]];
                }
            }
        }
    }else{

        CGRect frame = view.frame;
        
        switch (view.tag) {
                
            case LineType_Top:
            {
                frame.size.height = 0.5f;
            }
                break;
            case LineType_Bottom:
            {
                frame.size.height = 0.5f;
                frame.origin.y = frame.origin.y + 0.5f;
            }
                break;
            case LineType_Left:
            {
                frame.size.width = 0.5f;
            }
                break;
            case LineType_Right:
            {
                frame.origin.x = frame.origin.x + 0.5f;
                frame.size.width = 0.5f;
            }
                break;
            default:
                break;
        }
        view.frame = frame;
    }
}


@end
