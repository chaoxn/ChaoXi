//
//  ShowDetailViewModel.h
//  chaoxi
//
//  Created by fizz on 15/11/30.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MuseumModel.h"

@interface ShowDetailViewModel : NSObject

@property (nonatomic, strong) RACCommand *requestCommand;

@property (nonatomic, strong) RACSignal *requestSignal;

@property (nonatomic, strong) MuseumModel *model;

@property (nonatomic, strong) NSString *detailID;

@property (nonatomic, strong) NSString *urlStr;

@end
