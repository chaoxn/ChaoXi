//
//  CXRequestManager.m
//  chaoxi
//
//  Created by fizz on 15/11/6.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "CXRequestManager.h"
#import <objc/runtime.h>

@implementation CXRequestManager

- (NSArray*)fatherPropertyKeys:(Class )mClass
{
    unsigned int outCount, i;
    
    objc_property_t *properties;
    
    properties = class_copyPropertyList([mClass class], &outCount);

    NSMutableArray *keys = [[NSMutableArray alloc] initWithCapacity:outCount];
    
    for (i = 0; i < outCount; i++) {
        
        objc_property_t property = properties[i];
        
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property)
                                                          encoding:NSUTF8StringEncoding];
        
        if(propertyName){
            
            [keys addObject:propertyName];
            
        }else
        {

        }
        
    }
    
    free(properties);
    
    return keys;
    
}

- (NSDictionary *)transformModelToDictionary:(id )mClass
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    for (NSString *key in [self fatherPropertyKeys:[mClass class]]) {
        
        id propertyValue = [mClass valueForKey:key];
        
        if (propertyValue) {
            
            [dic setObject:propertyValue forKey:key];
            
        }else{
            
            DLog(@"父类属性%@的值为空",key);
        }
    }
    
    return dic;
}


+(NSString *)picParameterFormModel:(id)model
{
    NSDictionary *dict = [NSMutableDictionary dictionary];;
    
    if (model) {
        
        dict = [[self class] transformModelToDictionary:model];

    }else
    {
        DLog(@"model = %@",model);
    }
    
    NSData *json = [NSJSONSerialization dataWithJSONObject:dict
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    
    NSString *string = [[NSString alloc] initWithData:json
                                             encoding:NSUTF8StringEncoding];
    
    return string;
}


@end
