//
//  RadioListCell.h
//  chaoxi
//
//  Created by fizz on 15/12/23.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViedoModel.h"

@interface RadioListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *authorLabel;

@property (weak, nonatomic) IBOutlet UIView *preView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) ViedoModel *model;

@property (nonatomic, assign) BOOL playing;

@end
