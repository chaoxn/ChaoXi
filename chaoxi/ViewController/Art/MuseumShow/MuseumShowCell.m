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
        
        [self.contentView addSubview:self.basicImageView];
        [self.basicImageView addSubview:self.maskImageView];
        
        @weakify(self)
        [self.basicImageView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            @strongify(self)
            make.edges.equalTo(self.contentView);
        }];
        
        [self.maskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            @strongify(self)
            make.leading.equalTo(self.basicImageView);
            make.centerY.equalTo(self.basicImageView);
            make.size.mas_equalTo(CGSizeMake(150, 100));
        }];
        
     
        [RACObserve(self, model) subscribeNext:^(MuseumModel *model) {
           
            @strongify(self)
            UIImageView *temp= [[UIImageView alloc]initWithFrame:self.maskImageView.bounds];
            [self.basicImageView sd_setImageWithURL:model.coverUrl[@"url"]];
            
//            GPUImageGaussianSelectiveBlurFilter *blurFilter = [[GPUImageGaussianSelectiveBlurFilter alloc]init];
            
            GPUImageGaussianBlurFilter *blurFilter = [[GPUImageGaussianBlurFilter alloc]init];
            blurFilter.blurRadiusInPixels = 2.0;
            blurFilter.blurRadiusAsFractionOfImageWidth = 150;
            blurFilter.blurRadiusAsFractionOfImageHeight = 90;
            UIImage *blurredImage = [blurFilter imageByFilteringImage:temp.image];
            self.maskImageView.image = blurredImage;
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

#pragma mark -

- (void)awakeFromNib
{

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
