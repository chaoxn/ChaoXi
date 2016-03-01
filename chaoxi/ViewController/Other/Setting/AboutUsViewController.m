//
//  AboutUsViewController.m
//  chaoxi
//
//  Created by fizz on 15/11/5.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "AboutUsViewController.h"
#import <TOMSMorphingLabel/TOMSMorphingLabel.h>


@interface AboutUsViewController ()<UINavigationControllerDelegate>

@property (nonatomic, strong) UIButton *returnButton;
@property (nonatomic, strong) UIImageView *avatarImageView;

@property (nonatomic, strong) TOMSMorphingLabel *labelOne;
@property (nonatomic, strong) UILabel *labelTwo;
@property (nonatomic, assign) NSInteger idx;
@property (nonatomic, strong) NSArray *textValues;
@property (nonatomic, strong) NSMutableArray *labelArr;

@end

@implementation AboutUsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self layoutSubViews];
    
    [[self.returnButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)layoutSubViews
{
    self.view.backgroundColor = CXRGB16Color(0xf3f8db);
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.delegate = self;
    
    [self.view addSubview:self.avatarImageView];
    [self.view addSubview:self.returnButton];
    [self.view addSubview:self.labelOne];
    [self.view addSubview:self.labelTwo];
    
//    FBShimmeringView *shimmeringView = [[FBShimmeringView alloc] initWithFrame:self.labelTwo.frame];
//    [self.view addSubview:shimmeringView];
//    
//    shimmeringView.alpha = 0;
//    shimmeringView.contentView = self.labelTwo;
//    shimmeringView.shimmering = YES;
    
//    [self toggleText];
    [self createLabel];
    
    self.avatarImageView.transform = CGAffineTransformMakeScale(0.001, 0.001);
    
    POPSpringAnimation *buttonA = [POPSpringAnimation animation];
    buttonA.property = [POPAnimatableProperty propertyWithName:kPOPLayerPositionX];
    buttonA.beginTime = CACurrentMediaTime() + 0.5;
    buttonA.springBounciness = 6;
    buttonA.springSpeed = 10;
    buttonA.toValue = @(35 * WidthRate);
    [self.returnButton.layer pop_addAnimation:buttonA forKey:@"buttonA"];
    
    [buttonA setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
      
        POPSpringAnimation *ia = [POPSpringAnimation animation];
        ia.property = [POPAnimatableProperty propertyWithName:kPOPViewScaleXY];
        ia.beginTime = CACurrentMediaTime() + 0;
        ia.springBounciness = 6;
        ia.springSpeed = 10;
        ia.toValue=[NSValue valueWithCGSize:CGSizeMake(1, 1)];
        ia.name=@"i1";
        ia.delegate=self;
        [self.avatarImageView pop_addAnimation:ia forKey:@"avatar"];
        
        ia.completionBlock =^(POPAnimation *anim, BOOL finished){
            
            POPSpringAnimation *L1Y = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
            L1Y.beginTime = CACurrentMediaTime() + 0;
            L1Y.toValue = @(_labelOne.center.y + 40);
            L1Y.springBounciness = 8;
            L1Y.springSpeed = 8;
            [self.labelOne pop_addAnimation:L1Y forKey:@"l1y"];
            
            POPSpringAnimation *L2Y = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
            L2Y.beginTime = CACurrentMediaTime() + 0;
            L2Y.toValue = @(_labelTwo.center.y + 40);
            L2Y.springBounciness = 8;
            L2Y.springSpeed = 8;
            [self.labelTwo pop_addAnimation:L2Y forKey:@"L2Y"];
            
            POPBasicAnimation *M1A = [POPBasicAnimation animation];
            M1A.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
            M1A.beginTime = CACurrentMediaTime() + 0.05;
            M1A.fromValue= @(0);
            M1A.toValue= @(1);
            [self.labelOne pop_addAnimation:M1A forKey:@"M1A"];
            
            POPBasicAnimation *M2A = [POPBasicAnimation animation];
            M2A.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
            M2A.beginTime = CACurrentMediaTime() + 0.05;
            M2A.fromValue= @(0);
            M2A.toValue= @(1);
            [self.labelTwo pop_addAnimation:M2A forKey:@"M2A"];
            M2A.completionBlock = ^(POPAnimation *anim, BOOL finished){
                
                for (int i = 0; i < 5; i++) {
                    
                    UILabel *label = self.labelArr[i];
                    POPSpringAnimation *LY = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
                    LY.beginTime = CACurrentMediaTime() + 0.1 + 0.05*i;
                    LY.toValue = @(label.center.y - 100);
                    LY.springBounciness = 4;
                    LY.springSpeed = 8;
                    [label pop_addAnimation:LY forKey:@"ly"];
                    
                    POPBasicAnimation *MA = [POPBasicAnimation animation];
                    MA.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
                    MA.beginTime = CACurrentMediaTime() + 0.1 + 0.05*i;
                    MA.fromValue= @(0);
                    MA.toValue= @(1);
                    [label pop_addAnimation:MA forKey:@"MA"];
                }
            };
        };
    }];
}

- (void)viewDidDisappear:(BOOL)animated
{
    _vc.navigationController.navigationBarHidden = NO;
}

- (void)createLabel
{
    
    self.labelArr = [NSMutableArray array];
    
    NSArray *array = @[@"虽然不知道未来改向何方\n却知道了真正的爱", @"是当你孤单到极点时\n心里还会有个你", @"当你哀伤到刻骨时\n仍然对世界充满感激", @"当你一无所有时\n仍然对天地万物心存良心", @"当你睁开双眼的一瞬间\n信仰仍在"];
    
    for (int i = 0; i < 5; i++) {
        UILabel *label = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 360 + 63*i, ScreenWidth, 60)];
            
            label.text = array[i];
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = [UIColor colorWithRed:arc4random()%256/256.0 green:arc4random()%256/256.0 blue:arc4random()%256/256.0 alpha:0.3];
            label.textColor = [UIColor colorWithRed:0.416  green:0.439  blue:0.459 alpha:1];
            
            label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
            label.numberOfLines = 0;
            label.alpha = 0;
            label;
        });
        [self.view addSubview:label];
        [self.labelArr addObject:label];
    }
}

#pragma mark- setter

- (UIButton *)returnButton
{
    if (!_returnButton) {
        _returnButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"rocket"] forState:UIControlStateNormal];
            button.frame = CGRectMake(ScreenWidth, 25, 40, 40);
            button;
        });
    }
    return _returnButton;
}

- (UIImageView *)avatarImageView
{
    if (!_avatarImageView) {
        _avatarImageView = ({
            UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"chaoxi"]];
            imageView.size = CGSizeMake(100, 100);
            imageView.center = CGPointMake(ScreenWidth/2, 120);
            imageView;
        });
    }
    return _avatarImageView;
}

- (TOMSMorphingLabel *)labelOne
{
    if (!_labelOne) {
        _labelOne = ({
            TOMSMorphingLabel *label = [[TOMSMorphingLabel alloc]initWithFrame:({
                CGRect frame = CGRectMake(0, 0, ScreenWidth, 20);
                frame;
            })];
            label.center = CGPointMake(ScreenWidth/2, 160);
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"春风十里";
//            春水初生，春林初盛，春风十里，不如你。下联   ：秋池渐涨，秋叶渐黄，秋思一半，赋予卿
            label.textColor = [UIColor darkGrayColor];
            label.font = CXBoldFont(18);
            label.alpha = 0;
            label;
        });
    }
    return _labelOne;
}

- (void)setIdx:(NSInteger)idx
{
    _idx = MAX(0, MIN(idx, idx % [self.textValues count]));
}

- (NSArray *)textValues
{
    if (!_textValues) {
        _textValues = @[@"春水初生",
                        @"春林初盛",
                        @"春风十里"];
    }
    return _textValues;
}

- (void)toggleText
{
    self.labelOne.text = self.textValues[self.idx++];
    
    [self performSelector:@selector(toggleText)
               withObject:nil
               afterDelay:2];
}

- (UILabel *)labelTwo
{
    if (!_labelTwo) {
        _labelTwo = ({
            UILabel *label = [[UILabel alloc]initWithFrame:({
                CGRect frame = CGRectMake(0, 0, ScreenWidth, 20);
                frame;
            })];
            label.center = CGPointMake(ScreenWidth/2, 190);
            label.text = @"不如你";
            label.textColor = [UIColor darkGrayColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = CXFont(15);
            label.alpha = 0;
            label;
            
        });
    }
    return _labelTwo;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
