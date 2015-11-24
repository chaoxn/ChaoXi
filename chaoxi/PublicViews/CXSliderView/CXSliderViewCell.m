//
//  CXSliderViewCell.m
//  CXSilderViewDemo
//
//  Created by fizz on 15/11/16.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "CXSliderViewCell.h"

@implementation CXSliderViewCell

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.clipsToBounds = YES;

        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.desLabel];
        [self.contentView insertSubview:self.coverView belowSubview:self.title];
        [self.contentView insertSubview:self.cxImageView atIndex:0];
        
        [self addObserver];
    }
    return self;
}

- (void)addObserver
{
     @weakify(self);
    [RACObserve(self, dic) subscribeNext:^(id dic) {
        @strongify(self);
        
        self.title.text = dic[@"title"];
        [self.cxImageView  sd_setImageWithURL:[NSURL URLWithString:[dic[@"cover"] objectForKey:@"url"]]];
        self.desLabel.text = dic[@"description"];
    }];
    
    [RACObserve(self, tag) subscribeNext:^(NSNumber *index) {
        @strongify(self);
        
        if([index intValue] == 1){
            
            self.coverView.alpha = 0.3;
            self.desLabel.alpha = 0.85;
            self.desLabel.frame = CGRectMake(10, 85+60, self.desLabel.frame.size.width, self.desLabel.frame.size.height);
            self.title.layer.transform = CATransform3DMakeScale(1, 1, 1);
            self.title.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, self.contentView.center.y);
        }else{
            
            self.coverView.alpha = 0.6;
        }
    }];
    
     self.cxImageView.frame = CGRectMake(0, IMAGEVIEW_ORIGIN_Y-self.frame.origin.y/568*IMAGEVIEW_MOVE_DISTANCE, CELL_WIDTH, SC_IMAGEVIEW_HEIGHT);
}

- (UILabel *)title
{
    if (_title == nil) {
        _title = ({
            UILabel *label = [[UILabel alloc]initWithFrame:({
                CGRect frame = CGRectMake(0, (CELL_HEIGHT-TITLE_HEIGHT)/2, CELL_WIDTH, TITLE_HEIGHT);
                frame;
            })];
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:20];
            label.layer.transform =  CATransform3DMakeScale(0.5, 0.5, 1);
            label.center = self.contentView.center;
            label.textAlignment = NSTextAlignmentCenter;
            label;
        });
    }
    return _title;
}

- (UILabel *)desLabel
{
    if (_desLabel == nil) {
        _desLabel =({
            UILabel *label = [[UILabel alloc]initWithFrame:({
                CGRect frame = CGRectMake(0, (CELL_HEIGHT-TITLE_HEIGHT)/2, CELL_WIDTH, TITLE_HEIGHT);
                frame;
            })];
            label.alpha = 0;
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentCenter;
            label;
        });
    }
    return _desLabel;
}

- (UIImageView *)cxImageView
{
    if (_cxImageView == nil) {
        _cxImageView = ({
            UIImageView *ImageView = [[UIImageView alloc]init];
            ImageView.image =  [UIImage imageNamed:@"test"];
            ImageView;
        });
    }
    _cxImageView.frame = CGRectMake(0, IMAGEVIEW_ORIGIN_Y-self.frame.origin.y/568*IMAGEVIEW_MOVE_DISTANCE, CELL_WIDTH, SC_IMAGEVIEW_HEIGHT);
    return _cxImageView;
}

- (UIView *)coverView
{
    if (_coverView == nil) {
        _coverView = ({
            UIView *view = [[UIView alloc]initWithFrame:({
                CGRect frame = CGRectMake(0, 0, ScreenWidth, 250);
                frame;
            })];
            view.backgroundColor = [UIColor blackColor];
            view.alpha = 0.6;
            view;
        });
    }
    return _coverView;
}

@end
