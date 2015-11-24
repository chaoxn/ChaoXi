//
//  ArtCell.m
//  chaoxi
//
//  Created by fizz on 15/11/24.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "ArtCell.h"

@interface ArtCell ()

@property (nonatomic, strong) UIVisualEffectView *visualEffectView;

@end

@implementation ArtCell

- (id)initWithFrame:(CGRect)frame
{
    if (self  = [super initWithFrame:frame]) {
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.decLabel];
        [self.contentView addSubview:self.mainImageView];
        
        [self.mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(self.contentView).offset(120);
            make.centerX.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(220, 320));
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(self.mainImageView.mas_bottom).offset(50);
            make.centerX.equalTo(self.mainImageView);
            make.size.mas_equalTo(CGSizeMake(200, 20));
        }];
        
        [self.decLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
            make.centerX.equalTo(self.titleLabel);
            make.width.and.height.equalTo(self.titleLabel);
        }];
        
        
    }
    return self;
}

- (UIImageView *)mainImageView
{
    if (!_mainImageView) {
        
        _mainImageView = ({
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.backgroundColor = [UIColor whiteColor];
            imageView;
        });
    }
    return _mainImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = ({
            UILabel *label = [[UILabel alloc]init];
            label.text = @"中华艺术宫";
            label.font = CXFont(20);
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
