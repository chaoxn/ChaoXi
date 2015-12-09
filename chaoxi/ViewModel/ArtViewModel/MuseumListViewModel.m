//
//  MuseumListViewModel.m
//  chaoxi
//
//  Created by fizz on 15/11/25.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "MuseumListViewModel.h"

#define URL @"http://knowhere.avosapps.com/Api/gallery/recommend"

@implementation MuseumListViewModel

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
       
        RACSignal *signal = [self requestSignal];
    
        return [signal map:^id(NSDictionary *value) {
            
            NSArray *reultArr = [MuseumModel objectArrayWithKeyValuesArray:[value objectForKey:@"results"]];
            
            self.modelArr = reultArr;
            
            return reultArr;
        }];
        
    }];
    
    // 取出command信号中的数据
    @weakify(self)
    [_requestCommand.executionSignals.switchToLatest subscribeNext:^(id model) {
        
        @strongify(self)
        if (self.delegateSignal) {
            
            [self.delegateSignal sendNext:model];
        }
    }];
    
}

- (RACSignal *)requestSignal
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [CXHttpManager NetRequestGETWithURL:URL Parameter:nil ReturnValeuBlock:^(id returnValue) {
            
            [subscriber sendNext : returnValue];
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
