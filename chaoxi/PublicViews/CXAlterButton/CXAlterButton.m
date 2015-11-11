//
//  CXAlterButton.m
//  AlterButtonDemo
//
//  Created by fizz on 15/11/2.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "CXAlterButton.h"

@interface CXAlterButton()<CXAlterItemButtonDelegate>

@property (strong, nonatomic) UIImage *centerImage;
@property (nonatomic, strong) UIButton *centerButton;

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSMutableArray *keyArr;

@property (nonatomic, strong) UIView *buttonBGView;
@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, assign) CGSize openSize;
@property (nonatomic, assign) CGSize closeSize;

@end

@implementation CXAlterButton

#pragma mark- publicMethod
- (instancetype)initWithImage :(UIImage *)centerImage{
    
    // TODO:- 加旋转
    if (self = [super init]) {
        
        self.centerImage = centerImage;
        
        self.items = [NSMutableArray array];
        self.keyArr = [NSMutableArray array];

        self.closeSize = CGRectZero.size;
        self.openSize = [UIScreen mainScreen].bounds.size;
        
//        self.frame = CGRectMake(0, 0,self.closeSize.width, self.closeSize.height);
        self.frame = CGRectMake(0, 0,ScreenWidth,60);
    
        [self initViews];
    }
    return self;
}

- (void)addButton:(CXAlterItemButton *)button {
    
    assert(button != nil);
    if (self.items == nil) {
        self.items = [[NSMutableArray alloc] init];
    }
    
    if (![self.items containsObject:button]) {
        [self.items addObject:button];
        button.alpha = 0;
        [self addSubview:button];
    }
}

- (void)addButtonItems:(NSArray *)itemButton
{
    assert(itemButton != nil);
    for (CXAlterItemButton *item in itemButton) {
        [self addButton:item];
    }
}

#pragma mark setter&&getter

- (void)setButtonCenter:(CGPoint)buttonCenter
{
    _buttonCenter = buttonCenter;
    self.buttonBGView.frame = CGRectMake(_buttonCenter.x, self.buttonCenter.y, self.buttonSize.width, self.buttonSize.height);
}

- (void)setButtonSize:(CGSize)buttonSize
{
    _buttonSize = buttonSize;
    self.centerButton.frame = CGRectMake(0, 0, buttonSize.width, buttonSize.height);
    self.buttonBGView.frame = CGRectMake(self.buttonCenter.x, self.buttonCenter.y, buttonSize.width, buttonSize.height);
}

- (void)setAnimationDuration:(float)animationDuration
{
    _animationDuration = animationDuration;
}

- (void)initViews
{
    self.buttonBGView = ({
        UIView *view = [[UIView alloc]initWithFrame:({
            CGRect frame = CGRectMake(0, 0, 40, 40);
            frame;
        })];
        view.backgroundColor = [UIColor clearColor];
        view;
    });
    
    self.centerButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:self.centerImage forState:UIControlStateNormal];
        [button addTarget:self action:@selector(rollAction:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, 0, 40, 40);
        button;
    });
    [self.buttonBGView addSubview:self.centerButton];
    [self addSubview:self.buttonBGView];
    
    self.coverView = ({
        UIView *view = [[UIView alloc]initWithFrame:({
            CGRect frame = CGRectMake(0, 0, self.openSize.width*2, self.openSize.height*2);
            frame;
        })];
        view.alpha = 0;
        view.backgroundColor = [UIColor blackColor];
        view;
    });

}

- (void)rollAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        
        [self centerButtonOpen];
    }else{
        
        [self centerButtonClosed];
    }
}

#pragma mark- buttonClicked

// FIXMI:- 展开needFix 
- (void)centerButtonOpen
{    
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.5];
    [self showAnimatonWithSeleted:M_PI_4];
    
    for (int i = 0;  i < self.items.count; i++) {
        
        CXAlterItemButton *itemButton = self.items[i];
        itemButton.index = i;
        
        [CATransaction setCompletionBlock:^{
            
            for (CXAlterItemButton *itemButton in self.items) {
                itemButton.transform = CGAffineTransformIdentity;
                itemButton.alpha = 1;
            }
        }];
        
        CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        
        CGPoint originPosition = self.buttonBGView.center;
        CGPoint finalPosition = CGPointMake(self.buttonBGView.center.x - (i+1)*70, self.buttonBGView.center.y);
        
        positionAnimation.duration = self.animationDuration;
        positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        positionAnimation.fromValue = [NSValue valueWithCGPoint:originPosition];
        positionAnimation.toValue = [NSValue valueWithCGPoint:finalPosition];
        positionAnimation.beginTime = CACurrentMediaTime() + (0.5/(float)self.items.count * (float)i);
        
        positionAnimation.fillMode = kCAFillModeForwards;
        positionAnimation.removedOnCompletion = NO;
        
        [itemButton.layer addAnimation:positionAnimation forKey:@"positionAnimation"];
        
        itemButton.layer.position = finalPosition;
        
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        
        scaleAnimation.duration = _animationDuration;
        scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        scaleAnimation.fromValue = [NSNumber numberWithFloat:0.01f];
        scaleAnimation.toValue = [NSNumber numberWithFloat:1.f];
        scaleAnimation.beginTime = CACurrentMediaTime() + (_animationDuration/(float)_items.count * (float)i) + 0.03f;
        scaleAnimation.fillMode = kCAFillModeForwards;
        scaleAnimation.removedOnCompletion = NO;
        
        [itemButton.layer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
        
        itemButton.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
        
    }
    [CATransaction commit];
}

- (void)closeAnimation
{
     [self showAnimatonWithSeleted:0];
        for (int i = (int)self.items.count - 1; i>=0; i--) {
            
            CXAlterItemButton *button = self.items[i];
            [UIView animateWithDuration:0.2
                             animations:^{
                                 
                                 button.center = self.buttonBGView.center;
                                 button.alpha = 0;
                             }];
                }
}

#pragma mark- buttonUnclicked
- (void)centerButtonClosed
{
    [CATransaction begin];
    [self showAnimatonWithSeleted:0];
    [CATransaction setAnimationDuration:_animationDuration];
    
    [UIView animateWithDuration:0.1f
                          delay:_animationDuration + 0.05f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         _coverView.alpha = 0;
                     }
                     completion:nil];
    
    [CATransaction setCompletionBlock:^{
        
        for (CXAlterItemButton *button in self.items) {
            button.transform = CGAffineTransformIdentity;
            button.alpha = 0;
        }
    }];
    
    for (int i = (int)self.items.count - 1; i>=0; i--) {
        
        CXAlterItemButton *button = self.items[i];
        
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        
        scaleAnimation.duration = _animationDuration;
        scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        scaleAnimation.fromValue = [NSNumber numberWithFloat:1.f];
        scaleAnimation.toValue = [NSNumber numberWithFloat:0.01f];
        scaleAnimation.beginTime = CACurrentMediaTime() + (_animationDuration/(float)_items.count * (float)i) + 0.03;
        scaleAnimation.fillMode = kCAFillModeForwards;
        scaleAnimation.removedOnCompletion = NO;
        
        [button.layer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
        
        button.transform = CGAffineTransformMakeScale(1.f, 1.f);
        
        
        CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        
        CGPoint originPosition = button.layer.position;
        CGPoint finalPosition = self.buttonBGView.center;
        
        positionAnimation.duration = _animationDuration;
        positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        positionAnimation.fromValue = [NSValue valueWithCGPoint:originPosition];
        positionAnimation.toValue = [NSValue valueWithCGPoint:finalPosition];
        positionAnimation.beginTime = CACurrentMediaTime() + (_animationDuration/(float)_items.count * (float)i);
        positionAnimation.fillMode = kCAFillModeForwards;
        positionAnimation.removedOnCompletion = NO;
        
        [button.layer addAnimation:positionAnimation forKey:@"positionAnimation"];
        
        button.layer.position = originPosition;
    }
    
    [CATransaction commit];
}

- (void)showAnimatonWithSeleted:(CGFloat)Rotataion
{
    [UIView animateWithDuration:1 delay:0.05 usingSpringWithDamping:0.1 initialSpringVelocity:5 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        
        _buttonBGView.transform = CGAffineTransformMakeRotation(Rotataion);
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)showAnimationType:(NSString *)type
              withSubType:(NSString *)subType
                 duration:(CFTimeInterval)duration
           timingFunction:(NSString *)timingFunction
                     view:(UIView *)theView
{
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.5;
    animation.type = type;
    animation.subtype = subType;
    
    [self.layer addAnimation:animation forKey:nil];
}

#pragma mark - itemClicked

- (void)itemButtonClicked:(CXAlterItemButton *)itemButton
{
    
    if ([self.delegate respondsToSelector:@selector(AlterButton:clickItemButtonAtIndex:)]) {
        
        CXAlterItemButton *selectedButton = self.items[itemButton.index];
        
        [UIView animateWithDuration:0.0618f * 3
                         animations:^{
                             selectedButton.transform = CGAffineTransformMakeScale(3, 3);
                             selectedButton.alpha = 0.0f;
                         }];

//        for (int i = 0; i < self.items.count; i++) {
//            if (i == selectedButton.index) {
//                continue;
//            }
//            CXAlterItemButton *unselectedButton = self.items[i];
//            [UIView animateWithDuration:0.0618f * 2
//                             animations:^{
//                                 unselectedButton.transform = CGAffineTransformMakeScale(0, 0);
//                             }];
//        }
        
        [self.delegate AlterButton:self clickItemButtonAtIndex:itemButton.index];
        
        self.centerButton.selected = NO;
        
        [self centerButtonClosed];
    }
}

@end
