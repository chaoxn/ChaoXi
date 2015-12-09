//
//  ShowDetailViewModel.m
//  chaoxi
//
//  Created by fizz on 15/11/30.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "ShowDetailViewModel.h"

#define URL @"http://dev.knowhere.avosapps.com/Api/exhibition/5653f73700b0c0606f6cb839?sessionToken=(null)"

@implementation ShowDetailViewModel

- (instancetype)init
{
    if (self = [super init]) {
     
        [self bindModel];
    }
    return self;
}

- (void)bindModel
{
    [[RACObserve(self, detailID) map:^id(NSString *value) {
        
        return [NSString stringWithFormat:@"http://dev.knowhere.avosapps.com/Api/exhibition/%@?sessionToken=(null)", value];
        
    }] subscribeNext:^(NSString  *x) {
        
        self.urlStr = x;
    }];
    
    _requestCommand  = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id value) {
       
        RACSignal *signal = [self requestSignal];
        
        return [signal map:^id(id value) {
            
            self.model = [MuseumModel objectWithKeyValues:[value objectForKey:@"results"]];
        
            return self.model;
        }];
        
    }];
}

- (RACSignal *)requestSignal
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [CXHttpManager NetRequestGETWithURL:self.urlStr Parameter:nil ReturnValeuBlock:^(id returnValue) {
            
            [subscriber sendNext:returnValue];
            [subscriber sendCompleted];
            
        } ErrorCodeBlock:^(id errorCode) {
            
            [subscriber sendError:errorCode];
        } FailureBlock:^{
            
        }];
        
        RACDisposable *dispose = [RACDisposable disposableWithBlock:^{
            NSLog(@"clean up");
        }];
        return dispose;
        
    }];
}


@end
