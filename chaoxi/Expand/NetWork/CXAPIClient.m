//
//  CXAPIClient.h
//  chaoxi
//
//  Created by fizz on 15/12/21.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "CXAPIClient.h"
#import "NSObject+Common.h"
#define kNetworkMethodName @[@"Get", @"Post", @"Put", @"Delete"]

static CXAPIClient *_sharedClient = nil;
static dispatch_once_t onceToken;

@implementation CXAPIClient

+ (CXAPIClient *)sharedJsonClient {
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:@""]];
    });
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.requestSerializer.timeoutInterval = 1;
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", @"application/x-javascript", nil];
    
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [self.requestSerializer setValue:url.absoluteString forHTTPHeaderField:@"Referer"];
    
    self.securityPolicy.allowInvalidCertificates = YES;
    
    return self;
}

- (RACSignal *)requestJsonDataWithPath:(NSString *)aPath
                            withParams:(NSDictionary*)params
                        withMethodType:(NetworkMethod)method
{
    return [self requestJsonDataWithPath:aPath withParams:params withMethodType:method autoShowError:YES];
}

- (RACSignal *)requestJsonDataWithPath:(NSString *)aPath
                            withParams:(NSDictionary*)params
                        withMethodType:(NetworkMethod)method
                         autoShowError:(BOOL)autoShowError
{
    switch (method) {
        case Get:
            return [[[[self rac_GET:aPath parameters:params] map:^id(RACTuple *JSONAndHeaders) {
                id responseObject = JSONAndHeaders[0];
//                DLog(@"\n===========response===========\n%@:\n%@", aPath, JSONAndHeaders);
                id error = [self handleResponse:responseObject autoShowError:autoShowError rerequestJsonDataWithPath:aPath withParams:params];
                if (error) {
                    return RACTuplePack(nil, error);
                }else{
                    return RACTuplePack(responseObject, nil);
                }
            }]
                     catch:^RACSignal *(NSError *error) {
                         DLog(@"\n===========response===========\n%@:\n%@", aPath, error);
                         return [self showError:error];
                     }] replayLazily];
            break;
        case Post:
            return [[[[self rac_POST:aPath parameters:params] map:^id(RACTuple *JSONAndHeaders) {
                NSDictionary *responseObject = JSONAndHeaders[0];
//                DLog(@"\n===========response===========\n%@:\n%@", aPath, responseObject);
                id error = [self handleResponse:responseObject autoShowError:autoShowError rerequestJsonDataWithPath:aPath withParams:params];
                if (error) {
                    return RACTuplePack(nil, error);
                }else{
                    return RACTuplePack(responseObject, nil);
                }
            }]
                     catch:^RACSignal *(NSError *error) {
                         //                  [CustomHud hideHUDForView:view animated:YES];
                         DLog(@"\n===========response===========\n%@:\n%@", aPath, error);
                         return [self showError:error];
                     }] replayLazily];
            break;
        default:
            break;
    }
    
    return 0;
}

// 判断返回的json的对错 到时候根据实际接口的状态值来判断
-(id)handleResponse:(id)responseJSON autoShowError:(BOOL)autoShowError
rerequestJsonDataWithPath:(NSString *)aPath
         withParams:(NSDictionary*)params {
    
    NSError *error = nil;
    //    NSNumber *resultCode = [responseJSON valueForKeyPath:@"code"];
    //
    //    if (resultCode.integerValue != 0) {
    //
    //            error = [NSError errorWithDomain:@"2" code:resultCode.intValue userInfo:responseJSON];
    //            if (autoShowError) {
    //                [self showError:error];
    //            }
    //
    //    }
    return error;
}

- (RACSignal *)showError:(NSError *)error
{
    if (error.code == NSURLErrorTimedOut) {
        [self showHudTipStr:@"服务器开了个小差~"];
        
    } else {
        NSString *tipStr = [self tipFromError:error];
        [self showHudTipStr:tipStr];
    }
    [[SCCatWaitingHUD sharedInstance] stop];
    return [RACSignal error:error];
}

- (RACSignal *)uploadImageWithPath:(NSString *)aPath
                          withFile:(NSURL*)filePath
{
    return [RACSignal createSignal:^ RACDisposable * (id<RACSubscriber> subscriber) {
        [self POST:aPath parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileURL:filePath name:@"upload_avatar" error:nil];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            DLog(@"\n===========response===========\n%@:\n%@", aPath, responseObject);
            id error = [self handleResponse:responseObject autoShowError:YES rerequestJsonDataWithPath:aPath withParams:nil];
            if (error) {
                [subscriber sendNext:RACTuplePack(nil, error)];
            }else{
                [subscriber sendNext:RACTuplePack(responseObject, nil)];
            }
            [subscriber sendCompleted];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [subscriber sendCompleted];
        }];
        
        return nil;
    }];
}

@end
