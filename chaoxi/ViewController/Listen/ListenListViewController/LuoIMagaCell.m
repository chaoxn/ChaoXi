//
//  LuoIMagaCell.m
//  chaoxi
//
//  Created by fizz on 15/10/27.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "LuoIMagaCell.h"

@implementation LuoIMagaCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
        
        self.bGView.layer.masksToBounds = YES;
        self.bGView.layer.cornerRadius = 10.0;
        self.bGView.layer.borderWidth = 0.8;
        self.bGView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        
        NSString *path = [[NSBundle mainBundle]pathForResource:@"imagePlist" ofType:@"plist" ];
        self.imgArr = [NSArray arrayWithContentsOfFile:path];
        
        @weakify(self);
        [RACObserve(self, model) subscribeNext:^(ViedoModel *model) {
            @strongify(self);
            
            self.titleLable.text = model.title;
            self.saveCountLabel.text = [NSString stringWithFormat:@"%u", arc4random()%100 + 20];
        }];
    }
    return self;
}

- (void)setTag:(NSInteger)tag
{
    [self.beuImageView sd_setImageWithURL: [NSURL URLWithString:self.imgArr[tag]]];
     self.volLable.text = [NSString stringWithFormat:@"vol.%zd",tag+1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
