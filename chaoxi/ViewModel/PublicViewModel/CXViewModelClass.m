//
//  CXViewModelClass.m
//  chaoxi
//
//  Created by fizz on 15/11/5.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "CXViewModelClass.h"

@interface CXViewModelClass()

@property (nonatomic, copy, readwrite) NSDictionary *params;

@property (nonatomic, strong, readwrite) RACSubject *errors;
@property (nonatomic, strong, readwrite) RACSubject *willDisappearSignal;

@end

@implementation CXViewModelClass

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    CXViewModelClass *viewModel = [super allocWithZone:zone];
    
    @weakify(viewModel)
    [[viewModel
      rac_signalForSelector:@selector(initWithParams:)]
    	subscribeNext:^(id x) {
            @strongify(viewModel)
            [viewModel initialize];
        }];
    
    return viewModel;
}

- (instancetype)initWithParams:(NSDictionary *)params
{
    if (self = [super init]) {
        self.params = params;
    }
    return self;
}

- (RACSubject *)errors
{
    if (!_errors){
        _errors = [RACSubject subject];
    }
    return _errors;
}

- (RACSubject *)willDisappearSignal
{
    if (!_willDisappearSignal){
        _willDisappearSignal = [RACSubject subject];
    }
    return _willDisappearSignal;
}

- (void)initialize
{
    
}

#pragma 获取网络状态
-(void) netWorkStateWithNetConnectBlock: (NetWorkBlock) netConnectBlock WithURlStr: (NSString *) strURl;
{
    BOOL netState = [CXHttpManager netWorkReachabilityWithURLString:strURl];
    netConnectBlock(netState);
}

#pragma 接收传过来的block
-(void) setBlockWithReturnBlock: (ReturnValueBlock) returnBlock
                 WithErrorBlock: (ErrorCodeBlock) errorBlock
               WithFailureBlock: (FailureBlock) failureBlock
{
    _returnBlock = returnBlock;
    _errorBlock = errorBlock;
    _failureBlock = failureBlock;
}

@end
