//
//  MuseumShowViewModel.m
//  chaoxi
//
//  Created by fizz on 15/11/26.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "MuseumShowViewModel.h"

#define URL @"http://dev.knowhere.avosapps.com/Api/gallery/5549e3dce4b03fd8345e1fe6/exhibition"

@interface MuseumShowViewModel()


@end

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
    __block NSString *urlStr = nil;
    
    @weakify(self)
    [[RACObserve(self, museumId) map:^id(NSString *value) {
        
        return [NSString stringWithFormat:@"http://dev.knowhere.avosapps.com/Api/gallery/%@/exhibition", value];
    }] subscribeNext:^(NSString  *x) {
       
        urlStr = x;
    }];
    
    _requestCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
       
        RACSignal *requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
           
            [CXHttpManager NetRequestGETWithURL:urlStr Parameter:nil ReturnValeuBlock:^(id returnValue) {
                
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
    
    [_requestCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        
        @strongify(self)
        if (self.delegateSignal) {
            
            [self.delegateSignal sendNext:x];
        }
        
    }];
    
}

@end
