//
//  PoeViewController.h
//  chaoxi
//
//  Created by fizz on 15/11/5.
//  Copyright (c) 2015年 chaox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface PoeViewController : BaseViewController

@property (nonatomic, strong) NSString *receiveIndex;

@property (weak, nonatomic) IBOutlet UIButton *refreshButton;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *autherLabel;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
