//
//  CXProgress.m
//  chaoxi
//
//  Created by fizz on 15/12/2.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "CXProgress.h"

#define PERFECT 0.618
#define BASICTYPE 10

@interface CXProgress()

@end

@implementation CXProgress
@synthesize window, hud, cxType,pointMaskView,turnMaskView,catchMaskView;

+ (CXProgress *)shareInstance
{
    static dispatch_once_t once = 0;
    static CXProgress *cxProgress;
    
    dispatch_once(&once, ^{ cxProgress = [[CXProgress alloc]init];});
    
    return cxProgress;
}

- (id)init
{
    if (self = [super initWithFrame:[[UIScreen mainScreen] bounds]]) {
        
        id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
        
        if ([delegate respondsToSelector:@selector(window)])
            window = [delegate performSelector:@selector(window)];
        else {
            window = [[UIApplication sharedApplication] keyWindow];
        }
        
        self.alpha = 0;
    }
    return self;
}

#pragma mark- public method

+ (void)dismiss
{
    [[self shareInstance] hidden];
}

+ (void)showWithType:(CXProgressType )type
{
    [self shareInstance].cxType = type;
    
    [[self shareInstance] createHud];
}

- (CGRect )AnimationViewRect
{
    CGRect rect = CGRectZero;
    
    rect.size = hud.frame.size;
    
    return rect;
}

#pragma mark- animation method

- (void)beginPointAnimation: (BOOL)isFull
{
    pointMaskView = ({
        UIView *view = [[UIView alloc]initWithFrame:[self AnimationViewRect]];
        view.center = isFull ? CGPointMake(hud.center.x, hud.center.y) : CGPointMake(hud.frame.size.width/2 , hud.frame.size.height/2 );
        view;
    });
    
    [hud addSubview:pointMaskView];
    
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.bounds = CGRectMake(0, 0, pointMaskView.frame.size.width, pointMaskView.frame.size.height);
    replicatorLayer.position = CGPointMake(pointMaskView.frame.size.width/2, pointMaskView.frame.size.height/2);
    replicatorLayer.backgroundColor = [UIColor clearColor].CGColor;
    [pointMaskView.layer addSublayer:replicatorLayer];
    
    CALayer *circle = [CALayer layer];
    circle.bounds = CGRectMake(0, 0, 8, 8);
    circle.position = CGPointMake(pointMaskView.frame.size.width/2, pointMaskView.frame.size.height/2 - 25);
    circle.cornerRadius = 4;
    circle.backgroundColor = isFull ?   [UIColor blackColor].CGColor : [UIColor blackColor].CGColor;
    
    [replicatorLayer addSublayer:circle];
    
    replicatorLayer.instanceCount = 15;
    CGFloat angle = 2*M_PI / 15;
    replicatorLayer.instanceTransform = CATransform3DMakeRotation(angle, 0, 0, 1);
    
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale.fromValue = [NSNumber numberWithFloat:1];
    scale.toValue = [NSNumber numberWithFloat:0.1];
    scale.duration = 1;
    scale.repeatCount = HUGE;
    [circle addAnimation:scale forKey:nil];
    
    replicatorLayer.instanceDelay =0.06666667;
    circle.transform = CATransform3DMakeScale(0.01, 0.01, 0.01);
}


- (void)beiginSimpleAnimation:(BOOL)isFull
{
    turnMaskView = ({
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 120, 120)];
        view.backgroundColor = [UIColor clearColor];
        view.center = isFull ? CGPointMake(hud.center.x, hud.center.y) : CGPointMake(hud.frame.size.width/2 , hud.frame.size.height/2 );
        view;
    });
    
    [hud addSubview:turnMaskView];
    
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotate.duration = 1.2;
    rotate.fromValue = 0;
    rotate.toValue =[NSNumber numberWithFloat:2 * M_PI];
    rotate.repeatCount = HUGE;
    [turnMaskView.layer addAnimation:rotate forKey:nil];
    
    CAShapeLayer *ovalShapeLayer = [CAShapeLayer layer];
    ovalShapeLayer.strokeColor = isFull ? [UIColor darkGrayColor].CGColor:[UIColor blackColor].CGColor;
    ovalShapeLayer.fillColor = [UIColor clearColor].CGColor;
    ovalShapeLayer.lineWidth = 1.5;
    
    CGFloat ovalRadius = isFull ? turnMaskView.frame.size.height/2 * 0.55 : turnMaskView.frame.size.height/2 * (1-PERFECT);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(turnMaskView.frame.size.width/2-ovalRadius, turnMaskView.frame.size.width/2-ovalRadius, ovalRadius*2, ovalRadius*2)];
    
    ovalShapeLayer.path =path.CGPath;
    ovalShapeLayer.strokeEnd = 0.8;
    ovalShapeLayer.lineCap = kCALineCapRound; // 两头圆
    
    [turnMaskView.layer addSublayer:ovalShapeLayer];
}

- (void)beginCatchAnimation:(BOOL)isFull
{
    catchMaskView = ({
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 120, 120)];
        view.backgroundColor = [UIColor clearColor];
        view.center = isFull ? CGPointMake(hud.center.x, hud.center.y) : CGPointMake(hud.frame.size.width/2 , hud.frame.size.height/2 );
        view;
    });
    
    [hud addSubview:catchMaskView];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.lineWidth = 1.5;
    shapeLayer.strokeColor = isFull ? [UIColor darkGrayColor].CGColor:[UIColor darkGrayColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    
    CGFloat radius = isFull ? catchMaskView.frame.size.height/2 * 0.55 : catchMaskView.frame.size.height/2 * (1-PERFECT);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(catchMaskView.frame.size.width/2 - radius, catchMaskView.frame.size.width/2 - radius, radius*2, radius*2)];
    shapeLayer.path =path.CGPath;
    
    [catchMaskView.layer addSublayer:shapeLayer];
    
    CABasicAnimation *startAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    startAnimation.fromValue = [NSNumber numberWithFloat:-1.25];
    startAnimation.toValue = [NSNumber numberWithFloat:1.0];
    
    CABasicAnimation *endAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    endAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    endAnimation.toValue = [NSNumber numberWithFloat:1.0];
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.duration = 1.2;
    groupAnimation.repeatCount = HUGE;
    groupAnimation.animations = @[startAnimation, endAnimation];
    
    [shapeLayer addAnimation:groupAnimation forKey:nil];
}

#pragma mark- private method

- (void)createHud
{
    if (hud == nil) {
        hud = [[UIToolbar alloc] initWithFrame:CGRectZero];
        hud.translucent = YES;
        hud.layer.cornerRadius = 10;
        hud.layer.masksToBounds = YES;
    }
    
    if (cxType < BASICTYPE) {
        
        hud.frame = window.frame;
        hud.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
    }else{
        
        hud.frame = CGRectMake(0, 0, 150, 100);
    }
    
    hud.center = CGPointMake(window.frame.size.width/2, window.frame.size.height/2);
    hud.alpha = 0;
    hud.transform = CGAffineTransformScale(hud.transform, 1+PERFECT, 1+PERFECT);
    
    [UIView animateWithDuration:1-PERFECT delay:0 options:1 animations:^{
        hud.transform = CGAffineTransformScale(hud.transform, 1/1.618, 1/1.618);
        hud.alpha = 1;
    } completion:^(BOOL finished){
        hud.transform = CGAffineTransformScale(hud.transform, 1, 1);
    }];
    
    if (hud.superview == nil) {
        
        [window addSubview:hud];
    }
    
    [self judgeType];
}

- (void)judgeType
{
    if (pointMaskView) {
        [pointMaskView removeFromSuperview];
    }
    if (turnMaskView) {
        [turnMaskView removeFromSuperview];
    }
    if (catchMaskView) {
        [catchMaskView removeFromSuperview];
    }
    
    switch (cxType) {
        case CXProgressTypeFullPoint:
            [self beginPointAnimation:YES];
            break;
        case CXProgressTypeFullTurn:
            [self beiginSimpleAnimation:YES];
            break;
        case CXProgressTypeFullCatch:
            [self beginCatchAnimation:YES];
            break;
        case CXProgressTypeBasicCatch:
            [self beginCatchAnimation:NO];
            break;
        case CXProgressTypeBasicPoint:
            [self beginPointAnimation:NO];
            break;
        case CXProgressTypeBasicTurn:
            [self beiginSimpleAnimation:NO];
            break;
        default:
            break;
    }
}

- (void)hidden
{
    [UIView animateWithDuration:0.2 delay:0 options:1 animations:^{
        
        if (cxType == CXProgressTypeBasicCatch || cxType == CXProgressTypeBasicPoint || cxType == CXProgressTypeBasicTurn) {
            hud.transform = CGAffineTransformScale(hud.transform, 0.7, 0.7);
        }
        hud.alpha = 0;
    }completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        [hud removeFromSuperview];
        hud =nil;
        [pointMaskView removeFromSuperview];
        [turnMaskView removeFromSuperview];
        [catchMaskView removeFromSuperview];
    }];
}

@end
