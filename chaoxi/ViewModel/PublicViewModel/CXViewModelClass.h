//
//  CXViewModelClass.h
//  chaoxi
//
//  Created by fizz on 15/11/5.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CXHttpManager.h"

@interface CXViewModelClass : NSObject

@property (nonatomic, strong, readonly) RACSubject *errors;
@property (nonatomic, strong, readonly) RACSubject *willDisappearSignal;

@property (nonatomic, copy, readonly) NSDictionary *params;

@property (strong, nonatomic) ReturnValueBlock returnBlock;
@property (strong, nonatomic) ErrorCodeBlock errorBlock;
@property (strong, nonatomic) FailureBlock failureBlock;

-(void) netWorkStateWithNetConnectBlock: (NetWorkBlock) netConnectBlock WithURlStr: (NSString *) strURl;

-(void) setBlockWithReturnBlock: (ReturnValueBlock) returnBlock
                 WithErrorBlock: (ErrorCodeBlock) errorBlock
               WithFailureBlock: (FailureBlock) failureBlock;

@end
