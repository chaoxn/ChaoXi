//
//  MuseumShowViewModel.h
//  chaoxi
//
//  Created by fizz on 15/11/26.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MuseumModel.h"

@interface MuseumShowViewModel : NSObject

@property (nonatomic, strong) RACCommand *requestCommand;

@property (nonatomic, strong) RACSubject *delegateSignal;

@property (nonatomic, strong) NSMutableArray *modelArr;

@property (nonatomic, strong) NSString *museumId;

@end
