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
        self.imgArr = [NSMutableArray arrayWithContentsOfFile:path];
    }
    return self;
}

- (void)setTag:(NSInteger)tag
{
    [self.beuImageView sd_setImageWithURL: [NSURL URLWithString:self.imgArr[tag]]];
}

- (void)setModel:(ViedoModel *)model
{
    _model = model;
    
    self.titleLable.text = model.guide;
    self.saveCountLabel.text = [NSString stringWithFormat:@"%u", arc4random()%100 + 20];
}

- (void)awakeFromNib
{

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
