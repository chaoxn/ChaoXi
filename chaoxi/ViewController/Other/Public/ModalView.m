//
//  ModalView.m
//  chaoxi
//
//  Created by fizz on 15/12/17.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "ModalView.h"

@implementation ModalView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0;
        
        [self addSubview:self.imageView];
        [self addSubview:self.label];
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerY.equalTo(self);
            make.leading.equalTo(self).with.offset(20);
            make.size.mas_equalTo(CGSizeMake(18,18));
        }];
        
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerY.equalTo(self.imageView);
            make.leading.equalTo(self.imageView).with.offset(30);
            make.size.mas_equalTo(CGSizeMake(200, 40));
        }];
        
    }
    return self;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = ({
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView;
        });
    }
    return _imageView;
}

- (UILabel *)label
{
    if (!_label) {
        _label = ({
            UILabel *label = [[UILabel alloc]init];
            label.font = [UIFont fontWithName:@"Avenir" size:15];
            label.textColor = [UIColor whiteColor];
            label.text = @"Test";
            label;
        });
    }
    return _label;
}

@end
