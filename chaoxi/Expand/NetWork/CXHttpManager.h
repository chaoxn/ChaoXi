//
//  CXHttpManager.h
//  chaoxi
//
//  Created by fizz on 15/10/29.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ReturnValueBlock) (id returnValue);
typedef void (^ErrorCodeBlock) (id errorCode);
typedef void (^FailureBlock)();
typedef void (^NetWorkBlock)(BOOL netConnetState);

@interface CXHttpManager : NSObject

/**
 *  监测网络的可链接性
 *
 *  @param strUrl 
 *
 *  @return Bool值
 */
+ (BOOL) netWorkReachabilityWithURLString:(NSString *) strUrl;

/**
 *  POST请求
 *
 *  @param requestURLString 请求url
 *  @param parameter        请求参数
 *  @param block            成功block
 *  @param errorBlock       错误block
 *  @param failureBlock     失败block
 */
+ (void) NetRequestPOSTWithURL: (NSString *) requestURLString
                        Parameter: (NSDictionary *) parameter
                 ReturnValeuBlock: (ReturnValueBlock) block
                   ErrorCodeBlock: (ErrorCodeBlock) errorBlock
                     FailureBlock: (FailureBlock) failureBlock;

/**
 *  Get请求
 *
 *  @param requestURLString 请求url
 *  @param parameter        请求参数
 *  @param block            成功block
 *  @param errorBlock       错误block
 *  @param failureBlock     失败block
 */
+ (void) NetRequestGETWithURL: (NSString *) requestURLString
                       Parameter: (NSDictionary *) parameter
                ReturnValeuBlock: (ReturnValueBlock) block
                  ErrorCodeBlock: (ErrorCodeBlock) errorBlock
                    FailureBlock: (FailureBlock) failureBlock;

@end
