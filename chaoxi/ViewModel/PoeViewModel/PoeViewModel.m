//
//  PoeViewModel.m
//  chaoxi
//
//  Created by fizz on 15/11/9.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "PoeViewModel.h"
#import "Poem.h"
#import "CXAPIManage.h"

@interface PoeViewModel ()

@end

@implementation PoeViewModel

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
       
        return [[CXAPIManage getPoeData:self.receiveIndex]map:^id(RACTuple *x) {
            
            return x.first;
        }];
    }];
    
    [self.requestCommand.executionSignals.switchToLatest subscribeNext:^(Poem *model) {
       
        if (self.delegateSignal) {
            
            [self.delegateSignal sendNext:model];
        }
    }];
}

@end
