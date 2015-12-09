//
//  ShowDetailViewController.h
//  chaoxi
//
//  Created by fizz on 15/11/30.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowDetailViewController : UIViewController

@property (nonatomic, strong) NSString *detailID;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *baseView;

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (weak, nonatomic) IBOutlet UILabel *tagFirstLabel;

@property (weak, nonatomic) IBOutlet UILabel *tagSecLabel;

@property (weak, nonatomic) IBOutlet UILabel *viewsCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailAddressLabel;

@property (weak, nonatomic) IBOutlet UILabel *entrancePriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *informationLabel;

@property (weak, nonatomic) IBOutlet UIView *imageContentView;

@property (weak, nonatomic) IBOutlet UIView *videoContentView;

@property (weak, nonatomic) IBOutlet UIView *videoView;

@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;

@property (weak, nonatomic) IBOutlet UIImageView *secendImageView;

@property (weak, nonatomic) IBOutlet UIImageView *thirdImageView;

@property (weak, nonatomic) IBOutlet UIImageView *forthImageView;

@end
