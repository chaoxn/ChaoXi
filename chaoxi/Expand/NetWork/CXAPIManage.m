//
//  CXAPIManage.m
//  chaoxi
//
//  Created by fizz on 15/12/28.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "CXAPIManage.h"
#import "Poem.h"
#import "ViedoModel.h"

@implementation CXAPIManage

+ (instancetype)sharedManager
{
    static CXAPIManage *apiManager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        apiManager = [[CXAPIManage alloc]init];
    });
    return apiManager;
}

+ (RACSignal *)getPoeData:(NSString *)index
{
    NSString *path = [NSString stringWithFormat:@"http://bubo.in/poe/poem?s=%@", index];
    
    return [[[CXAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Get] map:^id(RACTuple *JSONAndHeaders) {
        
        id resultData = JSONAndHeaders[0];
        NSError *error = JSONAndHeaders[1];
        if (resultData) {
    
            Poem *poeModel = [Poem objectWithKeyValues:[resultData firstObject]];
            return RACTuplePack(poeModel, nil);
        } else {
            return RACTuplePack(nil, error);
        }
    }];
}

+ (RACSignal *)getListenData:(NSDictionary *)para
{
    NSString *path = @"http://api2.pianke.me/ting/radio_list";
    
    return [[[CXAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:para withMethodType:Post]map:^id(RACTuple *JSONAndHeaders) {
      
        id resultData = JSONAndHeaders[0];
        NSError *error = JSONAndHeaders[1];
        if (resultData) {
            
         NSArray *listenArr = [ViedoModel objectArrayWithKeyValuesArray:[[resultData objectForKey:@"data"] objectForKey:@"list"]];
            
            return RACTuplePack(listenArr, nil);
        }else {
            
            return RACTuplePack(nil, error);
        }
        
    }];
    
    return nil;
}

+ (RACSignal *)getWhetherData:(NSString *)cityName
{
    NSString *path = [NSString stringWithFormat:@"https://api.heweather.com/x3/weather?city=%@&key=02a5e1fb5dd64f36ab1791188201c90f", cityName];
    
    return [[[CXAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Get] map:^id(RACTuple *JSONAndHeaders) {
        
        id resultData = JSONAndHeaders[0];
        NSError *error = JSONAndHeaders[1];
        if (resultData) {
            
            return RACTuplePack(resultData, nil);
        } else {
            
            return RACTuplePack(nil, error);
        }
    }];
    
    return nil;
}

@end
