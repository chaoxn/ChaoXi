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
       
        RACSignal *requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
           
            [CXHttpManager NetRequestGETWithURL:URL Parameter:nil ReturnValeuBlock:^(id returnValue) {
                
                [subscriber sendNext : returnValue];
                [subscriber sendCompleted];
            } ErrorCodeBlock:^(id errorCode) {
                
                [subscriber sendError:errorCode];
            } FailureBlock:^{
                
            }];
            
            return nil;
        }];
        
        return [requestSignal map:^id(NSDictionary *value) {
            
            NSArray *reultArr = [MuseumModel objectArrayWithKeyValuesArray:[value objectForKey:@"results"]];
            
            return reultArr;
        }];
        
    }];
    
    @weakify(self)
    [_requestCommand.executionSignals.switchToLatest subscribeNext:^(id model) {
        
        @strongify(self)
        if (self.delegateSignal) {
            
            [self.delegateSignal sendNext:model];
        }
    }];
    
}

@end
