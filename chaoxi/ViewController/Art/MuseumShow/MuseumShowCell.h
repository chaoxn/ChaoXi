//
//  MuseumShowCell.h
//  chaoxi
//
//  Created by fizz on 15/11/26.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MuseumModel.h"

@interface MuseumShowCell : UITableViewCell

@property (nonatomic, strong) UIImageView *basicImageView;

@property (nonatomic, strong) UIVisualEffectView *visualEffectView;

@property (nonatomic, strong) UIImageView *maskImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) MuseumModel *model;

@end
