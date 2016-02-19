//
//  SaveViewController.m
//  chaoxi
//
//  Created by fizz on 15/11/5.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "SaveViewController.h"
#import "CXPopTransition.h"
#import "CXPushTransition.h"
#import <ImageIO/ImageIO.h>
#import "YLGIFImage.h"
#import "YLImageView.h"
#import "PoemSaveViewController.h"
#import "ListenSaveViewController.h"

#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI)) //弧度转角度
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI) // 角度转弧度

@interface SaveViewController ()<UINavigationControllerDelegate>
{
    CALayer *_layer;
    NSMutableArray *buttonArr;
}
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *percentTransition;
@property (nonatomic, strong) UIView *circleView;
@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) YLImageView *imageView;
@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, weak) CALayer *movingLayer;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) NSMutableArray *layerArr;

@property (nonatomic, strong) PoemSaveViewController *psVC;
@property (nonatomic, strong) ListenSaveViewController *lsVC;
@property (nonatomic, assign) NSInteger index;

@end

@implementation SaveViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createButton];

//    [self.view addSubview:self.imageView];
//    [self.view sendSubviewToBack:self.imageView];
    
    self.psVC = [[PoemSaveViewController alloc]init];
    self.lsVC = [[ListenSaveViewController alloc]init];
    
    [self addAnimations];
    
     self.layerArr = [NSMutableArray array];
    [self.view addSubview:self.returnButton];
    [self layoutSubViews];
    
    [[self.returnButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)layoutSubViews
{
    self.view.backgroundColor = [UIColor blackColor];
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
    [self.view addGestureRecognizer:self.tapGesture];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.delegate = self;
}

- (void)viewDidDisappear:(BOOL)animated
{
    _vc.navigationController.navigationBarHidden = NO;
}

- (void)addAnimations
{
    [self.view addSubview:self.containerView];
    [self.view addSubview:self.circleView];
    [self.circleView addSubview:self.imageView];
    
    self.circleView.transform = CGAffineTransformMakeScale(0.001, 0.001);
    
    POPSpringAnimation *ca = [POPSpringAnimation animation];
    ca.property = [POPAnimatableProperty propertyWithName:kPOPViewScaleXY];
    ca.beginTime = CACurrentMediaTime() + 0.5;
    ca.springBounciness = 6;
    ca.springSpeed = 6;
    ca.toValue=[NSValue valueWithCGSize:CGSizeMake(1, 1)];
    ca.delegate=self;
    [self.circleView pop_addAnimation:ca forKey:@"avatar"];
    
    ca.completionBlock =^(POPAnimation *anim, BOOL finished){
        
        [self setEmmiter];
        
        POPBasicAnimation *CA = [POPBasicAnimation animation];
        CA.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
        CA.beginTime = CACurrentMediaTime() + 0.1;
        CA.fromValue= @(0);
        CA.toValue= @(1);
        [self.containerView pop_addAnimation:CA forKey:@"CA"];
        
        for (int i = 0 ; i < 5; i++) {
            
            UIButton *button = buttonArr[i];
            [UIView animateWithDuration:1.3 animations:^{
                button.alpha = 1;
                
                CAKeyframeAnimation *keyframeAnimation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
                
                CGMutablePathRef path = CGPathCreateMutable();
                
                CGFloat endPoint = (M_PI_2) * (1-0.5*i);
                //            (M_PI_2-0.2) * (1-0.55*i);
                if (i == 0) {
                    
                    CGPathMoveToPoint(path, NULL, -80, self.circleView.center.y + 200);
                    CGPathAddLineToPoint(path, NULL, 80, self.circleView.center.y + 200);
                }else{
                    // 中心点坐标 半径 开始角度，结束角度，角度的单位是“弧度”, 顺时针
                    CGPathAddArc(path, NULL, 80, 330, 200, M_PI_2, endPoint, true);
                }
                
                keyframeAnimation.path = path;
                keyframeAnimation.duration = 0.618;
                keyframeAnimation.removedOnCompletion = NO;
                // 动画结束保持不动 和removedOnCompletion 成对出现
                keyframeAnimation.fillMode = kCAFillModeForwards;
                keyframeAnimation.beginTime = CACurrentMediaTime()+0.1+0.05*i;
                
                CGSize layerSize = CGSizeMake(50, 50);
                CALayer *movingLayer = [CALayer layer];
                movingLayer.bounds = CGRectMake(0, 0, layerSize.width, layerSize.height);
                movingLayer.anchorPoint = CGPointMake(0, 0);
                [movingLayer setBackgroundColor:[UIColor orangeColor].CGColor];
                
                [button.layer addAnimation:keyframeAnimation forKey:@"position"];
                
                [self.layerArr addObject:button.layer];
            }];
        }
    };
}

- (void)createButton
{
    buttonArr = [NSMutableArray array];
    for (int i = 0 ; i < 5; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button setImage:[UIImage imageNamed:@"Avatar"] forState:UIControlStateNormal];
        button.alpha = 0;
        button.frame = CGRectMake(300, self.circleView.center.y, 50, 50);
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 25;
        button.tag = i;
        [self.containerView addSubview:button];
        [buttonArr addObject:button];
    }
}

-(void)click:(UITapGestureRecognizer *)tapGesture {
    
    CGPoint touchPoint = [tapGesture locationInView:self.containerView];
    
    for (int i = 0; i < 5; i++) {
        
        CALayer *layer = self.layerArr[i];
        
        if ([layer.presentationLayer hitTest:touchPoint]) {
            
            if (i == 4) {
                self.circleView.hidden = YES;
                self.navigationController.delegate = nil;
                [self.navigationController popViewControllerAnimated:YES];
            }
            
            if (i == 3) {
                
                self.index = i;
                self.rectOrigin = touchPoint;
                [self.navigationController pushViewController:self.psVC animated:YES];
            }
            
            if (i == 2) {
                
                self.index = i;
                self.rectOrigin = touchPoint;
                [self.navigationController pushViewController:self.lsVC animated:YES];
            }
            
            if (i == 1) {
                
                self.index = i;
                self.rectOrigin = touchPoint;
            }
            
            NSLog(@"presentationLayer");
        }
    }
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPush) {
        
        CXPushTransition *push = [[CXPushTransition alloc]init];
        
        [RACObserve(self, index) subscribeNext:^(NSNumber *x) {
            
            push.index = [x intValue];
            
            if ([x intValue]== 3) {
                push.popVC = self.psVC;
            }else if ([x intValue]== 2){
                push.popVC = self.lsVC;
            }
//            else{
//                push.popVC = self.clearVC;
//            }
        }];
    
        return push;
    }
    else if (operation == UINavigationControllerOperationPop){
        
        CXPopTransition *pop  = [[CXPopTransition alloc]init];
//        pop.pushVC = self;
        
        [RACObserve(self, index) subscribeNext:^(NSNumber *x) {
            
            pop.index = [x intValue];
            
            if ([x intValue]== 3) {
                pop.popVC = self.psVC;
            }else if ([x intValue] == 2){
                pop.popVC = self.lsVC;
            }
//            else{
//                pop.popVC = self.clearVC;
//            }
        }];
        return pop;
    }
    else{
        return nil;
    }
}

- (void)setEmmiter
{
    // 创建粒子Layer
    CAEmitterLayer *snowEmitter = [CAEmitterLayer layer];
    // 粒子发射位置
    snowEmitter.emitterPosition = CGPointMake(120,-20);
    // 发射源的尺寸大小
    snowEmitter.emitterSize  = self.containerView.frame.size;
    // 发射模式
    snowEmitter.emitterMode  = kCAEmitterLayerSurface;
    // 发射源的形状
    snowEmitter.emitterShape = kCAEmitterLayerLine;
    // 创建雪花类型的粒子
    CAEmitterCell *snowflake = [CAEmitterCell emitterCell];
    // 粒子的名字
    snowflake.name = @"snow";
    // 粒子参数的速度乘数因子
    snowflake.birthRate = 20.0;
    snowflake.lifetime  = 120.0;
    // 粒子速度
    snowflake.velocity = 10.0;
    // 粒子的速度范围
    snowflake.velocityRange = 10;
    // 粒子y方向的加速度分量
    snowflake.yAcceleration = 2;
    // 周围发射角度
    snowflake.emissionRange = 0.5 * M_PI;
    // 子旋转角度范围
    snowflake.spinRange = 0.25 * M_PI;
    snowflake.contents  = (id)[[UIImage imageNamed:@"snow"] CGImage];
    // 设置雪花形状的粒子的颜色
    snowflake.color      = [[UIColor whiteColor] CGColor];
    //    snowflake.redRange   = 2.f;
    //    snowflake.greenRange = 2.f;
    //    snowflake.blueRange  = 2.f;
    snowflake.scaleRange = 0.2f;
    snowflake.scale      = 0.3f;
    
    snowEmitter.shadowOpacity = 1.0;
    snowEmitter.shadowRadius  = 0.0;
    snowEmitter.shadowOffset  = CGSizeMake(0.0, 0.0);
    // 粒子边缘的颜色
    snowEmitter.shadowColor  = [[UIColor whiteColor] CGColor];
    // 添加粒子
    snowEmitter.emitterCells = @[snowflake];
    // 将粒子Layer添加进图层中
    [self.containerView.layer addSublayer:snowEmitter];
}


- (YLImageView *)imageView
{
    if (!_imageView) {
        _imageView = ({
            YLImageView* imageView = [[YLImageView alloc] initWithFrame:CGRectMake(-50, 0, 350, 300)];
            imageView.image = [YLGIFImage imageNamed:@"rol.gif"];
            imageView.layer.masksToBounds = YES;
            imageView.layer.cornerRadius = 150;
            imageView;
        });
    }
    return _imageView;
}

- (UIView *)circleView
{
    if (!_circleView) {
        _circleView = ({
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
            view.backgroundColor = CXRGB16Color(0xaaf165);
            view.center = CGPointMake(80, ScreenHeight/2);
            view.layer.masksToBounds = YES;
            view.layer.cornerRadius = 150;
            view;
        });
    }
    return _circleView;
}

- (UIView *)view1
{
    if (!_view1) {
        _view1 = ({
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
            view.backgroundColor = [UIColor orangeColor];
            view.layer.masksToBounds = YES;
            view.layer.cornerRadius = 25;
            view;
        });
    }
    return _view1;
}

- (UIButton *)returnButton
{
    if (!_returnButton) {
        _returnButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"iconfont-return"] forState:UIControlStateNormal];
            button;
        });
    }
    return _returnButton;
}

- (UIView *)containerView
{
    if (!_containerView) {
        _containerView = ({
            UIView *view = [[UIView alloc]initWithFrame:self.view.frame];
            view.backgroundColor = [UIColor blackColor];
            view.alpha = 0;
            view.userInteractionEnabled = YES;
            view;
        });
    }
    return _containerView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
