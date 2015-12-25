//
//  PlayOnViewController.h
//  chaoxi
//
//  Created by fizz on 15/12/22.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViedoModel.h"

@interface PlayOnViewController : UIViewController <STKAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *beginTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

@property (weak, nonatomic) IBOutlet UISlider *slider;

@property (nonatomic, strong) ViedoModel *model;

@end
