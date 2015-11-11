//
//  CXHttpManager.m
//  chaoxi
//
//  Created by fizz on 15/10/29.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "CXHttpManager.h"

@implementation CXHttpManager

#pragma 监测网络的可链接性
+ (BOOL) netWorkReachabilityWithURLString:(NSString *) strUrl
{
    __block BOOL netState = NO;
    
    NSURL *baseURL = [NSURL URLWithString:strUrl];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    
    NSOperationQueue *operationQueue = manager.operationQueue;
    
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [operationQueue setSuspended:NO];
                netState = YES;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                netState = NO;
            default:
                [operationQueue setSuspended:YES];
                break;
        }
    }];
    
    [manager.reachabilityManager startMonitoring];
    
    return netState;
}


/***************************************
 在这做判断如果有dic里有errorCode
 调用errorBlock(dic)
 没有errorCode则调用block(dic
 ******************************/

#pragma --mark GET请求方式
+ (void) NetRequestGETWithURL: (NSString *) requestURLString
                    Parameter: (NSDictionary *) parameter
             ReturnValeuBlock: (ReturnValueBlock) block
               ErrorCodeBlock: (ErrorCodeBlock) errorBlock
                 FailureBlock: (FailureBlock) failureBlock
{
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    
    AFHTTPRequestOperation *op = [manager GET:requestURLString parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        DLog(@"%@", dic);
        
        block(dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureBlock();
        DLog(@"%@", error);
    }];
    
    op.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [op start];
}

#pragma --mark POST请求方式

+ (void) NetRequestPOSTWithURL: (NSString *) requestURLString
                     Parameter: (NSDictionary *) parameter
              ReturnValeuBlock: (ReturnValueBlock) block
                ErrorCodeBlock: (ErrorCodeBlock) errorBlock
                  FailureBlock: (FailureBlock) failureBlock
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    
    AFHTTPRequestOperation *op = [manager POST:requestURLString parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
//        DLog(@"%@", dic);
        
        block(dic);
        /***************************************
         在这做判断如果有dic里有errorCode
         调用errorBlock(dic)
         没有errorCode则调用block(dic
         ******************************/
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureBlock();
    }];
    
    op.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [op start];
    
}

@end
