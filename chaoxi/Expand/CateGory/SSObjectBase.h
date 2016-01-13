//
//  SSObjectBase.h
//  WiFi104
//
//  Created by Steven on 13-12-6.
//  Copyright (c) 2013年 Neva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSObjectBase : NSObject <NSCoding,NSCopying>

@property (nonatomic, assign) NSInteger tag;

- (BOOL)saveToFile:(NSString *)path;
+ (id)loadFromFile:(NSString *)path;

-(id)initWithCoder:(NSCoder *)aDecoder;

@end
