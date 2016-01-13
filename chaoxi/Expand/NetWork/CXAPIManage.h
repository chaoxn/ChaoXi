//
//  CXAPIManage.h
//  chaoxi
//
//  Created by fizz on 15/12/28.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXAPIManage : NSObject

+ (instancetype)sharedManager;

#pragma mark  PoeApi
+ (RACSignal *)getPoeData:(NSString *)index;

#pragma mark ListenApi
+ (RACSignal *)getListenData:(NSDictionary *)para;




@end
