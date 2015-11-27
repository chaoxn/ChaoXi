//
//  MuseumShowViewModel.m
//  chaoxi
//
//  Created by fizz on 15/11/26.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "MuseumShowViewModel.h"

#define URL @"http://dev.knowhere.avosapps.com/Api/gallery/5549e3dce4b03fd8345e1fe6/exhibition"

@implementation MuseumShowViewModel

- (instancetype)init
{
    if (self = [super init]) {
        
        [self bindModel];
    }
    return self;
}

- (void)bindModel
{
    _requestCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
       
        RACSignal *requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
           
            [CXHttpManager NetRequestGETWithURL:URL Parameter:nil ReturnValeuBlock:^(id returnValue) {
                
                [subscriber sendNext:returnValue];
                [subscriber sendCompleted];
                
            } ErrorCodeBlock:^(id errorCode) {
                
                [subscriber sendError:errorCode];
            } FailureBlock:^{
                
            }];
            
             return nil;
        }];
        
       
        return [requestSignal map:^id(NSDictionary *value) {
           
            NSArray *array = [MuseumModel objectArrayWithKeyValuesArray:value[@"results"]];
            return array;
        }];
        
    }];
    
    @weakify(self)
    [_requestCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        
        @strongify(self)
        if (self.delegateSignal) {
            
            [self.delegateSignal sendNext:x];
        }
        
    }];
    
}

@end
