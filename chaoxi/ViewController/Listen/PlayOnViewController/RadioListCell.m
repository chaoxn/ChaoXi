//
//  RadioListCell.m
//  chaoxi
//
//  Created by fizz on 15/12/23.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "RadioListCell.h"

@implementation RadioListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
        
        [RACObserve(self, model) subscribeNext:^(ViedoModel *model) {
            
            self.titleLabel.text = self.model.title;
            self.authorLabel.text = self.model.userinfo[@"uname"];
        }];
        
        
        [RACObserve(self, playing) subscribeNext:^(NSNumber *x) {
                        
            self.preView.hidden = ![x boolValue];
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
