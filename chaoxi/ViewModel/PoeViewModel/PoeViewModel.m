//
//  PoeViewModel.m
//  chaoxi
//
//  Created by fizz on 15/11/9.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "PoeViewModel.h"
#import "Poem.h"

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
    _requestCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
       
        RACSignal *requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
           
            NSString *urlStr = [NSString stringWithFormat:@"http://bubo.in/poe/poem?s=%@",self.receiveIndex];
            
            [CXHttpManager NetRequestGETWithURL:urlStr Parameter:nil ReturnValeuBlock:^(id returnValue) {
                
                [subscriber sendNext:returnValue];
                [subscriber sendCompleted];
                
            } ErrorCodeBlock:^(id errorCode) {
                
            } FailureBlock:^{
                
            }];

            return nil;
        }];
        
        return [requestSignal map:^id(NSArray *value) {
            
            return [Poem objectWithKeyValues:[value firstObject]];
        }];
    }];
    
    [_requestCommand.executionSignals.switchToLatest subscribeNext:^(id model) {
       
        if (self.delegateSignal) {
            
            [self.delegateSignal sendNext:model];
        }
    }];
}

-(void) errorCodeWithDic: (NSDictionary *) errorDic
{
    self.errorBlock(errorDic);
}

-(void) netFailure
{
    self.failureBlock();
}

@end
