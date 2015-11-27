//
//  ArtCell.h
//  chaoxi
//
//  Created by fizz on 15/11/24.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MuseumModel.h"

@interface ArtCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *mainImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *decLabel;

@property (nonatomic, strong) MuseumModel *model;

@end
