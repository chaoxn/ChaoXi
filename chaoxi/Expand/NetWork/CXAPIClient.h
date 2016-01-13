//
//  CXAPIClient.h
//  chaoxi
//
//  Created by fizz on 15/12/21.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    Get = 0,
    Post,
    Put,
    Delete
} NetworkMethod;

@interface CXAPIClient : AFHTTPRequestOperationManager

+ (CXAPIClient *)sharedJsonClient;

- (RACSignal *)requestJsonDataWithPath:(NSString *)aPath
                            withParams:(NSDictionary*)params
                        withMethodType:(NetworkMethod)method;

- (RACSignal *)uploadImageWithPath:(NSString *)aPath
                          withFile:(NSURL*)filePath;

@end
