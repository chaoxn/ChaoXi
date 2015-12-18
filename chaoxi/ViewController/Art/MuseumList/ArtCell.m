//
//  ArtCell.m
//  chaoxi
//
//  Created by fizz on 15/11/24.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "ArtCell.h"

@interface ArtCell ()

@property (nonatomic, strong) UIBezierPath *path;

@end

@implementation ArtCell

- (id)initWithFrame:(CGRect)frame
{
    if (self  = [super initWithFrame:frame]) {
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.decLabel];
        [self.contentView addSubview:self.mainImageView];
        [self.mainImageView addSubview:self.detailButton];
        
        @weakify(self);
        [self.mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            @strongify(self);
            make.top.equalTo(self.contentView).offset(5);
            make.centerX.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(250*WidthRate, 370*HeightRate));
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            @strongify(self);
            make.top.equalTo(self.mainImageView.mas_bottom).offset(20);
            make.centerX.equalTo(self.mainImageView);
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, 20));
        }];
        
        [self.decLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            @strongify(self);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
            make.centerX.equalTo(self.titleLabel);
            make.width.and.height.equalTo(self.titleLabel);
        }];
        
        [self.detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
           
            @strongify(self);
            make.top.equalTo(self.mainImageView).with.offset(10);
            make.right.equalTo(self.mainImageView).with.offset(-10);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        
        [RACObserve(self, model) subscribeNext:^(MuseumModel *model) {
            
            @strongify(self);
            [self.mainImageView sd_setImageWithURL:model.coverUrl[@"url"]];
            self.titleLabel.text = model.nameBase;
            self.decLabel.text = [NSString stringWithFormat:@"共有%@个展览", model.exCount];
        }];
        
    }
    return self;
}

#pragma mark - getter

- (UIImageView *)mainImageView
{
    if (!_mainImageView) {
        
        _mainImageView = ({
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.backgroundColor = [UIColor whiteColor];
            imageView.image = [UIImage imageNamed:@"welcome0"];
            imageView.layer.shadowColor = [UIColor blackColor].CGColor;
            imageView.layer.shadowOffset = CGSizeMake(4, -4);
            imageView.layer.shadowOpacity = 0.7;
            imageView.userInteractionEnabled = YES;
       //     imageView.layer.shadowPath = self.path.CGPath;
            imageView;
        });
    }
    return _mainImageView;
}

- (UIBezierPath *)path
{
    if (!_path) {
        _path = ({
            UIBezierPath *path = [UIBezierPath bezierPath];
            CGFloat width = self.mainImageView.bounds.size.width;
            CGFloat height = self.mainImageView.bounds.size.height;
            float x = self.mainImageView.bounds.origin.x;
            float y = self.mainImageView.bounds.origin.y;
            
            CGPoint topLeft = self.mainImageView.bounds.origin;
            CGPoint topRight = CGPointMake(x + width, y);
            CGPoint bottemRight = CGPointMake(x + width, y + height);
            CGPoint bottemLeft = CGPointMake(x, y +height);
            
            [path moveToPoint:topLeft];
            [path addLineToPoint:topRight];
            [path addLineToPoint:bottemRight];
            [path addLineToPoint:bottemLeft];
            [path addLineToPoint:topLeft];
            path;
        });
    }
    return _path;
}

- (UIButton *)detailButton
{
    if (!_detailButton) {
        _detailButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundImage:[UIImage imageNamed:@"detail"] forState:UIControlStateNormal];
//            [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _detailButton;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = ({
            UILabel *label = [[UILabel alloc]init];
            label.text = @"中华艺术宫";
            label.font = CXFont(23);
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            label;
        });
    }
    return _titleLabel;
}

- (UILabel *)decLabel
{
    if (!_decLabel) {
        _decLabel = ({
            UILabel *label = [[UILabel alloc]init];
            label.text = @"共6个展览";
            label.font = CXFont(12);
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            label;
        });
    }
    return _decLabel;
}

@end
