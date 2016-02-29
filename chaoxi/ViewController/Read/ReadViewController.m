//
//  ReadViewController.m
//  chaoxi
//
//  Created by fizz on 15/10/26.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "ReadViewController.h"
#import "WeatherViewModel.h"

@interface ReadViewController ()

@property (nonatomic, strong) WeatherViewModel *viewModel;
@property (nonatomic, strong) NSDictionary *bigDic;

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *weatherIcon;
@property (nonatomic, strong) UIImageView *locImageView;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *condtxtLabel;
@property (nonatomic, strong) UILabel *tmpLabel; //温度
@property (nonatomic, strong) UILabel *locLabel; //地点
@property (nonatomic, strong) UIImageView *beiView;

@end

@implementation ReadViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.viewModel = [[WeatherViewModel alloc]init];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.viewModel.requestCommand execute:nil];
    
    [RACObserve(self.viewModel, dataDic) subscribeNext:^(NSDictionary *dataDic) {
       
        NSArray *arr = dataDic[@"HeWeather data service 3.0"];
        self.bigDic = [arr firstObject];
        
        if (dataDic) {
            [self basicAnim];
        }
        
        
        
        self.tmpLabel.text = [NSString stringWithFormat:@"%@°", self.bigDic[@"now"][@"tmp"]];
        self.dateLabel.text = [NSString stringWithFormat:@"TODAY:%@", [self.bigDic[@"daily_forecast"]firstObject][@"date"]];
        self.condtxtLabel.text = self.bigDic[@"now"][@"cond"][@"txt"];
        
    }];
    
    [self.view addSubview:self.bgImageView];
    [self.view insertSubview:self.bgImageView atIndex:0];
    
    [self.view addSubview:self.weatherIcon];
    [self.view addSubview:self.tmpLabel];
    [self.view addSubview:self.dateLabel];
    [self.view addSubview:self.condtxtLabel];
    [self.view addSubview:self.locLabel];
    [self.view addSubview:self.locImageView];
    [self.view addSubview:self.beiView];
    
//    [self basicAnim];
}

- (void)basicAnim
{
    POPSpringAnimation *iconY = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    iconY.beginTime = CACurrentMediaTime() + 0.05;
    iconY.toValue = @(_weatherIcon.center.y - 70);
    iconY.springBounciness = 4;
    iconY.springSpeed = 1;
    [self.weatherIcon pop_addAnimation:iconY forKey:@"iconY"];
    
    POPBasicAnimation *iconA = [POPBasicAnimation animation];
    iconA.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
    iconA.beginTime = CACurrentMediaTime() + 0.1;
    iconA.fromValue= @(0);
    iconA.toValue= @(1);
    [self.weatherIcon pop_addAnimation:iconA forKey:@"iconA"];
    
    [iconA setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
       
        POPSpringAnimation *dateX = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
        dateX.beginTime = CACurrentMediaTime() + 0.05;
        dateX.toValue = @(_dateLabel.center.x + 180);
        dateX.springBounciness = 1;
        dateX.springSpeed = 1;
        [self.dateLabel pop_addAnimation:dateX forKey:@"dateX"];
        
        POPBasicAnimation *dateA = [POPBasicAnimation animation];
        dateA.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
        dateA.beginTime = CACurrentMediaTime() + 0.1;
        dateA.fromValue= @(0);
        dateA.toValue= @(1);
        [self.dateLabel pop_addAnimation:dateA forKey:@"dateA"];
        
        POPSpringAnimation *conX = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
        conX.beginTime = CACurrentMediaTime() + 0.05;
        conX.toValue = @(_dateLabel.center.x + 180);
        conX.springBounciness = 1;
        conX.springSpeed = 1;
        [self.condtxtLabel pop_addAnimation:dateX forKey:@"conX"];
        
        POPBasicAnimation *conA = [POPBasicAnimation animation];
        conA.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
        conA.beginTime = CACurrentMediaTime() + 0.1;
        conA.fromValue= @(0);
        conA.toValue= @(1);
        [self.condtxtLabel pop_addAnimation:dateA forKey:@"conA"];
        
        
        [dateX setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
            
            POPSpringAnimation *locX = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
            locX.beginTime = CACurrentMediaTime() + 0.05;
            locX.toValue = @(_locLabel.center.x + 180);
            locX.springBounciness = 1;
            locX.springSpeed = 1;
            [self.locLabel pop_addAnimation:locX forKey:@"locX"];
            
            POPBasicAnimation *locA = [POPBasicAnimation animation];
            locA.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
            locA.beginTime = CACurrentMediaTime() + 0.05;
            locA.fromValue= @(0);
            locA.toValue= @(1);
            [self.locLabel pop_addAnimation:locA forKey:@"locA"];
            
            POPSpringAnimation *locIX = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
            locIX.beginTime = CACurrentMediaTime() + 0.05;
            locIX.toValue = @(_locImageView.center.x + 180);
            locIX.springBounciness = 1;
            locIX.springSpeed = 1;
            [self.locImageView pop_addAnimation:locIX forKey:@"locIX"];
            
            POPBasicAnimation *locIA = [POPBasicAnimation animation];
            locIA.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
            locIA.beginTime = CACurrentMediaTime() + 0.05;
            locIA.fromValue= @(0);
            locIA.toValue= @(1);
            [self.locImageView pop_addAnimation:locIA forKey:@"locIA"];
            
            POPSpringAnimation *tmpX = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
            tmpX.beginTime = CACurrentMediaTime() + 0.2;
            tmpX.toValue = @(_tmpLabel.center.x + 170);
            tmpX.springBounciness = 1;
            tmpX.springSpeed = 1;
            [self.tmpLabel pop_addAnimation:tmpX forKey:@"tmpX"];
            
            POPBasicAnimation *tmpA = [POPBasicAnimation animation];
            tmpA.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
            tmpA.beginTime = CACurrentMediaTime() + 0.2;
            tmpA.fromValue= @(0);
            tmpA.toValue= @(1);
            [self.tmpLabel pop_addAnimation:tmpA forKey:@"tmpA"];
            
            [tmpA setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
               
                [UIView animateWithDuration:0.618 animations:^{
                    
                    self.beiView.alpha = 1;
                }];
                
                UIBezierPath* path = UIBezierPath.bezierPath;

                NSArray *senvenDayArr = self.bigDic[@"daily_forecast"];
                
                for (int i = 0; i < 7; i++) {
                    
                    NSDictionary *dic = senvenDayArr[i];
                    NSInteger maxStr = [dic[@"tmp"][@"max"] integerValue];
                    
                    UILabel *label = ({
                        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((ScreenWidth/8) * (i+1)+17, 110-maxStr*3 - 20, 30, 15)];
                        label.font = CXFont(11);
                        label.textColor = [UIColor whiteColor];
                        label.text = [NSString stringWithFormat:@"%ld°",maxStr];
                        label;
                    });
                
                    [self.beiView addSubview:label];
                    
                    NSLog(@"%ld", maxStr);
                    
                    if (i==0) {
                        [path moveToPoint: CGPointMake(ScreenWidth/8+17, 110-maxStr*3)];
                    }else{
                        [path addLineToPoint: CGPointMake((ScreenWidth/8) * (i+1)+17, 110-maxStr*3)];
                    }
                    
                }

                path.lineWidth = 3;
                path.lineCapStyle = kCGLineCapRound; //线条拐角
                path.lineJoinStyle = kCGLineCapRound;
                [path stroke];
                
                CAShapeLayer *line=[CAShapeLayer layer];
                line.path=path.CGPath;
                line.fillColor=[UIColor clearColor].CGColor;
                line.strokeColor=[[UIColor whiteColor]CGColor];
                [self.beiView.layer addSublayer:line];
                
                CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
                animation.beginTime =CACurrentMediaTime() + 0.2;
                animation.duration=1;
                animation.removedOnCompletion=NO;
                animation.autoreverses = NO;
                animation.fillMode=kCAFillModeBoth;
                animation.fromValue=@(0);
                animation.toValue=@(1);
                animation.timingFunction=[CAMediaTimingFunction  functionWithControlPoints:0.5 : 0.29 :0.2 :0.83];
                [line addAnimation:animation forKey:@"line1"];
                
                
                UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
                
                for (int i = 0; i < 7; i++) {
                    
                    NSDictionary *dic = senvenDayArr[i];
                    
                    NSInteger min = [dic[@"tmp"][@"min"] integerValue];
                    
                    UILabel *label = ({
                        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((ScreenWidth/8) * (i+1)+17, 114-min*3, 30, 15)];
                        label.font = CXFont(11);
                        label.textColor = [UIColor whiteColor];
                        label.text = [NSString stringWithFormat:@"%ld°",min];
                        label;
                    });
                    
                    [self.beiView addSubview:label];
                    
                    if (i==0) {
                        [bezier2Path moveToPoint: CGPointMake(ScreenWidth/8+17, 110-min*3)];
                    }else{
                        [bezier2Path addLineToPoint: CGPointMake((ScreenWidth/8) * (i+1)+17, 110-min*3)];
                    }
                    
                }
            
                bezier2Path.lineWidth = 3;
                [bezier2Path stroke];
                
                CAShapeLayer *line2=[CAShapeLayer layer];
                line2.path=bezier2Path.CGPath;
                line2.fillColor=[UIColor clearColor].CGColor;
                line2.strokeColor=[[UIColor cyanColor]CGColor];
                [self.beiView.layer addSublayer:line2];
                
                CABasicAnimation *animation2=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
                animation2.beginTime =CACurrentMediaTime() + 0.2;
                animation2.duration=0.8;
                animation2.removedOnCompletion=NO;
                animation2.autoreverses = NO;
                animation2.fillMode=kCAFillModeBoth;
                animation2.fromValue=@(0);
                animation2.toValue=@(1);
                animation2.timingFunction=[CAMediaTimingFunction  functionWithControlPoints:0.5 : 0.29 :0.2 :0.83];
                [line2 addAnimation:animation2 forKey:@"line2"];
            }];
        }];
    }];
}

- (UIImageView *)weatherIcon
{
    if (!_weatherIcon) {
        _weatherIcon = ({
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
            imageView.image = [UIImage imageNamed:@"101"];
            imageView.center = CGPointMake(ScreenWidth/2, 230);
            imageView.alpha = 0;
            imageView;
        });
    }
    return _weatherIcon;
}

- (UILabel *)tmpLabel
{
    if (!_tmpLabel) {
        _tmpLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(-150, ScreenHeight/2-70, 150, 110)];
            label.text = @"8°";
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont fontWithName:@"CourierNewPSMT" size:100];
            label.alpha = 0;
            label;
        });
    }
    return _tmpLabel;
}

- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(-150, self.tmpLabel.origin.y+110, 200, 20)];
            label.text = @"TODAY:2016.2.26";
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont fontWithName:@"CourierNewPSMT" size:16];
            label.alpha = 0;
            label;
        });
    }
    return _dateLabel;
}

- (UILabel *)condtxtLabel
{
    if (!_condtxtLabel) {
        _condtxtLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(-150, self.dateLabel.origin.y+20, 200, 20)];
            label.text = @"多云";
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont fontWithName:@"CourierNewPSMT" size:16];
            label.alpha = 0;
            label;
        });
    }
    return _condtxtLabel;
}

- (UILabel *)locLabel
{
    if (!_locLabel) {
        _locLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(-133, self.condtxtLabel.origin.y+30, 200, 20)];
            label.text = @"SHANG HAI";
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont fontWithName:@"CourierNewPSMT" size:16];
            label.alpha = 0;
            label;
        });
    }
    return _locLabel;
}

- (UIImageView *)bgImageView
{
    if (!_bgImageView) {
        _bgImageView = ({
            UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg"]];
            imageView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
            imageView;
        });
    }
    return _bgImageView;
}

- (UIImageView *)locImageView
{
    if (!_locImageView) {
        _locImageView = ({
            UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dingwei"]];
            imageView.frame = CGRectMake(-150, self.locLabel.origin.y+3, 15, 15);
            imageView;
        });
    }
    return _locImageView;
}

- (UIImageView *)beiView
{
    if (!_beiView) {
        _beiView = ({
            UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(0, ScreenHeight-200, ScreenWidth, 200)];
            view.image = [UIImage imageNamed:@"tmpbg"];
            view.alpha = 0;
            view.backgroundColor = [UIColor clearColor];
            view;
        });
    }
    return _beiView;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.hidesBarsOnSwipe = NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
