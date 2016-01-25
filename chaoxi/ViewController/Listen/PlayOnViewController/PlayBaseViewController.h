//
//  PlayBaseViewController.h
//  chaoxi
//
//  Created by fizz on 15/12/22.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViedoModel.h"
#import "PlayOnViewController.h"

@interface PlayBaseViewController : UIViewController

@property (nonatomic, strong) UIImageView *currentView;
@property (nonatomic, strong) PlayOnViewController *playOnVC;

@property (nonatomic, strong) UIButton *playBt;
@property (nonatomic, strong) UIButton *nextBt;
@property (nonatomic, strong) UIButton *lastBt;

@end
