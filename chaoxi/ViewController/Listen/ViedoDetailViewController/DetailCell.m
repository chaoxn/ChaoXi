//
//  DetailCell.m
//  chaoxi
//
//  Created by fizz on 15/12/21.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "DetailCell.h"

@implementation DetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
        
        [RACObserve(self, model.playInfo) subscribeNext:^(NSDictionary *x) {
           
            self.tLabel.text = x[@"title"];
        }];
        
        RAC(self.countLabel, text) = RACObserve(self, model.musicVisit);
        
        [RACObserve(self, model.coverimg) subscribeNext:^(NSString *x) {
        
            [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:x]];
        }];
        
    }
    return self;
}

- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
