//
//  ModalViewController.m
//  chaoxi
//
//  Created by fizz on 15/12/17.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "ModalViewController.h"
#import "ModalView.h"

#define TITLEARR @[@"Listen", @"Poem", @"Weather", @"Art", @"Funny"]

@interface ModalViewController()

@property (nonatomic, strong) UIButton *dismissButton;
@property (nonatomic, strong) NSString *animationFinished;
@property (nonatomic, strong) NSMutableArray *viewArr;

- (void)dismiss:(id)sender;

@end

@implementation ModalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.view.alpha = 0.8;
    [self.view addSubview:self.dismissButton];
    
    [self.dismissButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(self.view);
        make.trailing.equalTo(self.view).with.offset(-20);
        make.size.mas_equalTo(CGSizeMake(1, 1));
    }];
    
    [self addTitleView];
}

- (void)addTitleView
{
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"animationFinished" object:nil] subscribeNext:^(NSNotification* x) {

        self.animationFinished = x.userInfo[@"Finished"];
    }];
    
    self.viewArr = [NSMutableArray array];
    
    [RACObserve(self, animationFinished) subscribeNext:^(NSString *x) {
        
        if ([x isEqualToString:@"Yes"]) {
            
            for (int i = 0; i < 5; i++) {
                
                ModalView *view = [[ModalView alloc]initWithFrame:CGRectMake(ScreenWidth + 20 * i, 10+40*HeightRate*i, ScreenWidth-100, 40)];
                UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewClicked:)];
                view.tag = i+10;
                view.label.text = TITLEARR[i];
                view.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon%d", i]];
                [view addGestureRecognizer:tapGes];
                [self.view addSubview:view];
                
                POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
                positionAnimation.toValue = @(view.center.x-ScreenWidth - 20 * i);
                positionAnimation.springBounciness = 8;
                positionAnimation.springSpeed = 20;
                positionAnimation.beginTime = CACurrentMediaTime() + 0.1+0.05*i;
                
                POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
                opacityAnimation.fromValue = @(0);
                opacityAnimation.toValue = @(1);
                opacityAnimation.beginTime = CACurrentMediaTime() + 0.1+0.05*i;
                
                [view.layer pop_addAnimation:positionAnimation forKey:@"position"];
                [view.layer pop_addAnimation:opacityAnimation forKey:@"opacity"];
            }
            
            self.dismissButton.transform = CGAffineTransformMakeScale(0.001, 0.001);
            
            POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
            scaleAnimation.beginTime = CACurrentMediaTime() + 0.1;
            scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.3f, 1.3f)];
            scaleAnimation.springBounciness = 6.f;
            scaleAnimation.springSpeed = 10;
            scaleAnimation.dynamicsFriction = 10;
            
            POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
            opacityAnimation.fromValue = @(0);
            opacityAnimation.toValue = @(1);
            opacityAnimation.beginTime = CACurrentMediaTime() + 0.1; 
            
            POPSpringAnimation *rotationAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
            rotationAnimation.beginTime = CACurrentMediaTime() + 0.1;
            rotationAnimation.toValue = @(M_PI*2);
            rotationAnimation.springBounciness = 1.f;
            rotationAnimation.springSpeed = 4;
    
            [self.dismissButton.layer pop_addAnimation:rotationAnimation forKey:@"rotationAnim"];
            [self.dismissButton.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnim"];
            [self.dismissButton.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
            
            [self.dismissButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.centerY.equalTo(self.view);
                make.right.equalTo(self.view).with.offset(-20);
                make.size.mas_equalTo(CGSizeMake(26, 26));
            }];
            
            self.dismissButton.layer.cornerRadius = 13;
        }
    }];
}

- (void)dismissAnimation
{

}

#pragma mark - Private Instance methods
- (void)viewClicked:(UITapGestureRecognizer *)tap
{
    self.index = tap.view.tag;
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)dismiss:(id)sender
{
    [self dismissAnimation];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (UIButton *)dismissButton
{
    if (!_dismissButton) {
        _dismissButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.alpha = 0;
            button.tintColor = [UIColor colorWithRed:0.922  green:0.310  blue:0.220 alpha:1];
            button.translatesAutoresizingMaskIntoConstraints = NO;
            [button setImage:[UIImage imageNamed:@"dismiss"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _dismissButton;
}

@end
