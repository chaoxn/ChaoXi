//
//  DetailCell.h
//  chaoxi
//
//  Created by fizz on 15/12/21.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViedoModel.h"

@interface DetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *tLabel;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (nonatomic, strong) ViedoModel *model;

@end
