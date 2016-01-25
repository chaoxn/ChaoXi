//
//  AboutUsViewController.m
//  chaoxi
//
//  Created by fizz on 15/11/5.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@property (nonatomic, strong) UIButton *returnButton;
@property (nonatomic, strong) UIImageView *avatarImageView;

@end

@implementation AboutUsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.returnButton];
    [self layoutSubViews];
    
    [[self.returnButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)layoutSubViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.returnButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view).with.offset(25);
        make.leading.equalTo(self.view).offset(10);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    
    [self.view addSubview:self.avatarImageView];
    self.avatarImageView.transform = CGAffineTransformMakeScale(0.001, 0.001);
    
    POPSpringAnimation *av = [POPSpringAnimation animation];
    av.property = [POPAnimatableProperty propertyWithName:kPOPViewScaleXY];
    av.beginTime = CACurrentMediaTime() + 0.5 +0.1;
    av.springBounciness = 6;
    av.springSpeed = 10;
    av.toValue=[NSValue valueWithCGSize:CGSizeMake(1, 1)];
    av.name=@"i1";
    av.delegate=self;
    [self.avatarImageView pop_addAnimation:av forKey:@"avatar"];
    
     av.completionBlock =^(POPAnimation *anim, BOOL finished){
         
         
     };
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
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

- (UIImageView *)avatarImageView
{
    if (!_avatarImageView) {
        _avatarImageView = ({
            UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Avatar"]];
            imageView.size = CGSizeMake(100, 100);
            imageView.center = CGPointMake(ScreenWidth/2, 100);
            imageView;
        });
    }
    return _avatarImageView;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
