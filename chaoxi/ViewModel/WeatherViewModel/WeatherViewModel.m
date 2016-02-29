//
//  WeatherViewModel.m
//  chaoxi
//
//  Created by fizz on 16/2/26.
//  Copyright © 2016年 chaox. All rights reserved.
//

#import "WeatherViewModel.h"

@implementation WeatherViewModel

- (instancetype)init
{
    if (self = [super init]) {
        
        [self initBind];
    }
    return self;
}

- (void)initBind
{
    self.requestCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        
        return [[CXAPIManage getWhetherData:@"beijing"]map:^id(RACTuple *x) {
            
            return x.first;
        }];
    }];
    
    [self.requestCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        
        self.dataDic = x;

    }];
}

@end
