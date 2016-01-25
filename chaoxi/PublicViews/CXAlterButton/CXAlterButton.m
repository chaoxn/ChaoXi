//
//  CXAlterButton.m
//  AlterButtonDemo
//
//  Created by fizz on 15/11/2.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "CXAlterButton.h"

#define NormalHeight 60

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
    
    if (self = [super init]) {
        
        self.centerImage = centerImage;
        
        self.items = [NSMutableArray array];
        self.keyArr = [NSMutableArray array];

        self.closeSize = CGRectZero.size;
        self.openSize = [UIScreen mainScreen].bounds.size;
        
        self.frame = CGRectMake(0, 0, ScreenWidth,60);
        
        [self.buttonBGView addSubview:self.centerButton];
        [self addSubview:self.buttonBGView];
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
        button.center = self.buttonBGView.center;
        button.alpha = 0;
        button.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
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

    self.buttonBGView.size = CGSizeMake(self.buttonSize.width, self.buttonSize.height);
    self.buttonBGView.center = buttonCenter;
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
- (void)centerButtonOpen
{
    [self showAnimatonWithSeleted:M_PI_4*3];
    
    for (int i = 0;  i < self.items.count; i++) {
        
        CXAlterItemButton *itemButton = self.items[i];
        itemButton.index = i;
        
        POPSpringAnimation *pa = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
        pa.toValue = @(self.buttonBGView.center.x - (i+1)*70);
        pa.beginTime = CACurrentMediaTime() + 0.3;
        pa.springBounciness = 4;
        pa.springSpeed = 8;
        [itemButton pop_addAnimation:pa forKey:@"positionAnimation"];
        
        POPBasicAnimation *aa = [POPBasicAnimation animation];
        aa.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
        aa.beginTime = CACurrentMediaTime() + 0.3;
        aa.fromValue= @(0);
        aa.toValue= @(1);
        [itemButton pop_addAnimation:aa forKey:@"aa"];
        
        POPSpringAnimation *rotationAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
        rotationAnimation.beginTime = CACurrentMediaTime() + 0.3;
        rotationAnimation.toValue = @(M_PI*2);
        rotationAnimation.springBounciness = 4;
        rotationAnimation.springSpeed = 10;
        [itemButton.layer pop_addAnimation:rotationAnimation forKey:@"rotationAnimation"];
        
        POPSpringAnimation *av = [POPSpringAnimation animation];
        av.property = [POPAnimatableProperty propertyWithName:kPOPViewScaleXY];
        av.beginTime = CACurrentMediaTime() + 0.3;
        av.springBounciness = 6;
        av.springSpeed = 10;
        av.toValue=[NSValue valueWithCGSize:CGSizeMake(1, 1)];
        av.name=@"i1";
        av.delegate=self;
        [itemButton pop_addAnimation:av forKey:@"avatar"];
    }
}

#pragma mark- buttonUnclicked
- (void)centerButtonClosed
{
    [self showAnimatonWithSeleted:0];
    
    [UIView animateWithDuration:0.1f
                          delay:_animationDuration + 0.05f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         _coverView.alpha = 0;
                     }
                     completion:nil];
    
    
    for (int i = (int)self.items.count - 1; i>=0; i--) {
        
        CXAlterItemButton *button = self.items[i];
        
        POPSpringAnimation *pa = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
        pa.toValue = @(self.buttonBGView.center.x);
        pa.beginTime = CACurrentMediaTime() + 0.2;
        pa.springBounciness = 4;
        pa.springSpeed = 8;
        [button pop_addAnimation:pa forKey:@"positionAnimation"];
        
        POPSpringAnimation *av = [POPSpringAnimation animation];
        av.property = [POPAnimatableProperty propertyWithName:kPOPViewScaleXY];
        av.beginTime = CACurrentMediaTime() + 0.2;
        av.springBounciness = 6;
        av.springSpeed = 10;
        av.toValue=[NSValue valueWithCGSize:CGSizeMake(0.01, 0.01)];
        av.delegate=self;
        [button pop_addAnimation:av forKey:@"avatar"];
        
        POPBasicAnimation *aa = [POPBasicAnimation animation];
        aa.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
        aa.beginTime = CACurrentMediaTime() + 0.2;
        aa.fromValue= @(1);
        aa.toValue= @(0);
        [button pop_addAnimation:aa forKey:@"aa"];
        
        POPSpringAnimation *rotationAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
        rotationAnimation.beginTime = CACurrentMediaTime() + 0.2;
        rotationAnimation.toValue = @(0);
        rotationAnimation.springBounciness = 4;
        rotationAnimation.springSpeed = 10;
        [button.layer pop_addAnimation:rotationAnimation forKey:@"ra"];
    }
}

- (void)showAnimatonWithSeleted:(CGFloat)Rotataion
{
    POPSpringAnimation *rotationAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
    rotationAnimation.beginTime = CACurrentMediaTime() + 0.1;
    rotationAnimation.toValue = @(Rotataion);
    rotationAnimation.springBounciness = 4;
    rotationAnimation.springSpeed = 10;
    rotationAnimation.dynamicsFriction = 12;
    [_buttonBGView.layer pop_addAnimation:rotationAnimation forKey:@"rotationAnimation"];
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
        
        [self.delegate AlterButton:self clickItemButtonAtIndex:itemButton.index];
        
        self.centerButton.selected = NO;
        
        [self centerButtonClosed];
    }
}

- (UIButton *)centerButton
{
    if (!_centerButton) {
        self.centerButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundImage:self.centerImage forState:UIControlStateNormal];
            [button addTarget:self action:@selector(rollAction:) forControlEvents:UIControlEventTouchUpInside];
            button.size = CGSizeMake(40, 40);
            button.center = CGPointMake(30, 30);
            button;
        });
    }
    return _centerButton;
}

- (UIView *)buttonBGView
{
    if (!_buttonBGView) {
        self.buttonBGView = ({
            UIView *view = [[UIView alloc]initWithFrame:({
                CGRect frame = CGRectMake(200 , 0, NormalHeight, NormalHeight);
                frame;
            })];
            view;
        });
    }
    return _buttonBGView;
}

@end
