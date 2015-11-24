//
//  FunnyViewModel.m
//  chaoxi
//
//  Created by fizz on 15/11/17.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "FunnyViewModel.h"
#define URL @"http://iliangcang.com:8200/topic/list?app_key=iphone&build=136&osVersion=82&v=2.1.3"

@interface FunnyViewModel()

@end

@implementation FunnyViewModel

- (instancetype)init
{
    if (self = [super init]) {
        
        [self dataBind];
    }
    
    return self;
}

- (void)dataBind
{
    _requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
       
        RACSignal *requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
           
            [CXHttpManager NetRequestGETWithURL:URL Parameter:nil ReturnValeuBlock:^(id returnValue) {
                
                [subscriber sendNext:returnValue];
                [subscriber sendCompleted];
                
            } ErrorCodeBlock:^(id errorCode) {
                
            } FailureBlock:^{
                
            }];
            
            return nil;
        }];
        
        return [requestSignal map:^id(NSDictionary *value) {
            
            return [[value objectForKey:@"data"]objectForKey:@"items"];;
        }];
    }];
    
    @weakify(self);
    [_requestCommand.executionSignals.switchToLatest subscribeNext:^(id dicArr) {
        @strongify(self);
        
        if (self.delegateSignal) {
            
            [self.delegateSignal sendNext:dicArr];
        }
    }];
}
@end
