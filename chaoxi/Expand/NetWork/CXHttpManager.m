//
//  CXHttpManager.m
//  chaoxi
//
//  Created by fizz on 15/10/29.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "CXHttpManager.h"

@implementation CXHttpManager

+ (instancetype)JspManager
{
    CXHttpManager *mgr = [super manager];

    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/x-javascript"];
    
    return mgr;
}

+ (instancetype)TextManager
{
    CXHttpManager *mgr = [super manager];
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    return mgr;
}

@end
