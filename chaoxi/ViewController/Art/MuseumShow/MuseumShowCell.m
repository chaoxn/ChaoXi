//
//  MuseumShowCell.m
//  chaoxi
//
//  Created by fizz on 15/11/26.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "MuseumShowCell.h"

@implementation MuseumShowCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.basicImageView addSubview:self.visualEffectView];
        [self.visualEffectView addSubview:self.titleLabel];
        [self.visualEffectView addSubview:self.nameLabel];
        [self.contentView addSubview:self.basicImageView];
        
        
        @weakify(self)
        [self.basicImageView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            @strongify(self)
            make.edges.equalTo(self.contentView);
        }];
        
        [self.visualEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            @strongify(self)
            make.leading.equalTo(self.basicImageView);
            make.centerY.equalTo(self.basicImageView);
            make.size.mas_equalTo(CGSizeMake(200, 100));
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            @strongify(self)
            make.leading.equalTo(self.visualEffectView).offset(10);
            make.centerY.equalTo(self.visualEffectView).offset(15);
            make.size.mas_equalTo(CGSizeMake(200, 20));
        }];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            @strongify(self)
            make.leading.equalTo(self.titleLabel);
            make.top.equalTo(self.visualEffectView).offset(30);
            make.size.equalTo(self.titleLabel);
        }];
        
        [RACObserve(self, model) subscribeNext:^(MuseumModel *model) {
           
            @strongify(self)
            [self.basicImageView sd_setImageWithURL:model.coverUrl[@"url"]];
            self.nameLabel.text = model.nameBase;
            self.titleLabel.text = model.gallery[@"nameBase"];
            
//            // 滤镜
//            GPUImageGaussianBlurFilter *blurFilter = [[GPUImageGaussianBlurFilter alloc]init];
//            blurFilter.blurRadiusInPixels = 2.0;
//            
//            [blurFilter forceProcessingAtSize:self.maskImageView.frame.size];
//            
//            // 输入源
//            GPUImagePicture *picture = [[GPUImagePicture alloc]initWithImage:self.basicImageView.image];
//            
//            
//            [picture addTarget:blurFilter];
//            [picture processImage];
//            
//            UIImage *new = [blurFilter imageFromCurrentFramebuffer];
//            
//            self.maskImageView.image = new;
            
        }];
        
    }
    return self;
}

#pragma mark - getter

- (UIImageView *)basicImageView
{
    if (!_basicImageView) {
        _basicImageView = ({
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.image = [UIImage imageNamed:@"test"];
            imageView;
        });
    }
    return _basicImageView;
}

- (UIVisualEffectView *)visualEffectView
{
    if (!_visualEffectView) {
        _visualEffectView = ({
            UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
            visualEffectView;
        });
    }
    return _visualEffectView;
}

- (UIImageView *)maskImageView
{
    if (!_maskImageView) {
        _maskImageView = ({
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView;
        });
    }
    return _maskImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = ({
            UILabel *label = [[UILabel alloc]init];
            label.font = CXFont(13);
            label.textColor = [UIColor whiteColor];
            label;
        });
    }
    return _titleLabel;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = ({
            UILabel *label = [[UILabel alloc]init];
            label.font = CXFont(18);
            label.textColor = [UIColor whiteColor];
            label;
        });
    }
    return _nameLabel;
}

#pragma mark -

- (void)awakeFromNib
{

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
