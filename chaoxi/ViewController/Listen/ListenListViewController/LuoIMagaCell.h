//
//  LuoIMagaCell.h
//  chaoxi
//
//  Created by fizz on 15/10/27.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViedoModel.h"

@interface LuoIMagaCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bGView;

@property (weak, nonatomic) IBOutlet UIImageView *beuImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet UIImageView *saveImageView;

@property (weak, nonatomic) IBOutlet UILabel *saveCountLabel;

@property (nonatomic, strong) NSMutableArray *imgArr;

@property (weak, nonatomic) IBOutlet UILabel *volLable;
@property (nonatomic, strong) ViedoModel *model;

@end
