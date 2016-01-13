//
//  FMDatabaseQueue+Extension.m
//  chaoxi
//
//  Created by fizz on 15/12/29.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "FMDatabaseQueue+Extension.h"

#define DB_PATH [NSString stringWithFormat:@"%@/%@.db", CX_DOCUMENT_DIRECTORY, CX_APP_NAME]

@implementation FMDatabaseQueue (Extension)

+ (instancetype)shareInstense {
    
    static FMDatabaseQueue *queue = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 根据路径，创建数据库
    
        queue = [FMDatabaseQueue databaseQueueWithPath:DB_PATH];
        DLog(@"%@", DB_PATH);
        
        
    });
    
    return queue;
}

@end