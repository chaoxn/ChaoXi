//
//  MuseumDetailViewController.m
//  chaoxi
//
//  Created by fizz on 15/12/18.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "MuseumDetailViewController.h"

@interface MuseumDetailViewController ()

@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic, strong) UIVisualEffectView *visualEffectView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *dissmissButton;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *infoLabel;

@end

@implementation MuseumDetailViewController

#pragma mark- life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.backgroundImage addSubview:self.visualEffectView];
    [self.scrollView addSubview:self.containerView];
    [self.containerView addSubview:self.titleLabel];
    [self.containerView addSubview:self.dissmissButton];
    [self.containerView addSubview:self.infoLabel];
    [self.view addSubview:self.backgroundImage];
    [self.view addSubview:self.scrollView];
    
    [self layoutSubviews];
    [self dataBinding];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

- (void)layoutSubviews
{
//    [view.superview layoutIfNeeded];
    
    [self.backgroundImage mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self.view);
    }];
    
    [self.visualEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.backgroundImage);
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.backgroundImage);
    }];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(80);
        make.centerX.equalTo(self.containerView);
        make.size.mas_equalTo(CGSizeMake(200, 30));
    }];
    
    [self.dissmissButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.containerView).offset(20);
        make.right.equalTo(self.containerView).offset(-20);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.titleLabel).offset(60);
        make.centerX.equalTo(self.titleLabel);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth-10, 200));
    }];
    
    UIImageView *lastImageView;
    
    for (NSInteger i = 0 ; i < self.model.contentPicArr.count; i++) {
        
        UIImageView *imageView = [[UIImageView alloc]init];
        
        [imageView sd_setImageWithURL:self.model.contentPicArr[i][@"url"]];
        [self.containerView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(self.infoLabel.mas_bottom).offset(20 + 275*i);
            make.centerX.equalTo(self.containerView);
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, 250));
        }];
        
        if (i == self.model.contentPicArr.count - 1) {
            lastImageView = imageView;
        }
    }
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom. equalTo(lastImageView.mas_bottom);
    }];
}

- (void)dataBinding
{
    self.titleLabel.text = self.model.nameBase;
    self.infoLabel.text = self.model.information;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.infoLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:10];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.infoLabel.text length])];
    
    NSDictionary *dic = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
    CGRect rect = [self.infoLabel.text boundingRectWithSize:CGSizeMake(ScreenWidth, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    
    [self.infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.titleLabel).offset(60);
        make.centerX.equalTo(self.titleLabel);
        make.width.mas_equalTo(ScreenWidth-10);
        make.height.mas_equalTo(rect.size.height * 1.4);
    }];
    
    [[self.dissmissButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
       
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark getter
- (UIImageView *)backgroundImage
{
    if (!_backgroundImage) {
        _backgroundImage = ({
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.image = [UIImage imageNamed:@"night"];
            imageView;
        });
    }
    return _backgroundImage;
}

- (UIVisualEffectView *)visualEffectView
{
    if (!_visualEffectView) {
        _visualEffectView = ({
            UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
            visualEffectView.frame = self.view.bounds;
            visualEffectView;
        });
    }
    return _visualEffectView;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = ({
            UIScrollView *scrollView = [UIScrollView new];
            scrollView.backgroundColor = [UIColor clearColor];
            scrollView.alwaysBounceHorizontal = NO;
            scrollView;
        });
    }
    return _scrollView;
}

- (UIView *)containerView
{
    if (!_containerView) {
        _containerView = ({
            UIView *view = [UIView new];
            view;
        });
    }
    return _containerView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = ({
            UILabel *label = [[UILabel alloc]init];
            label.font = CXFont(22);
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor whiteColor];
            label;
        });
    }
    return _titleLabel;
}

- (UIButton *)dissmissButton
{
    if (!_dissmissButton) {
        _dissmissButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundImage:[UIImage imageNamed:@"dis"] forState:UIControlStateNormal];
            button;
        });
    }
    return _dissmissButton;
}

- (UILabel *)infoLabel
{
    if (!_infoLabel) {
        _infoLabel = ({
            UILabel *label = [UILabel new];
            label.textColor = [UIColor whiteColor];
            label.numberOfLines = 0;
            label.font = CXFont(14);
            label;
        });
    }
    return _infoLabel;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
