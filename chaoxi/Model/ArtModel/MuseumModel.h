//
//  MuseumModel.h
//  chaoxi
//
//  Created by fizz on 15/11/25.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MuseumModel : NSObject

@property (nonatomic, strong) NSDictionary *coverUrl;

@property (nonatomic, strong) NSString *nameBase;

@property (nonatomic, strong) NSNumber *exCount;

@property (nonatomic, strong) NSArray *contentPicArr;

@property (nonatomic, strong) NSDictionary *gallery;

@property (nonatomic, strong) NSString *videoUrl;

@property (nonatomic, strong) NSString *objectId;

@property (nonatomic, strong) NSString *subName;

@property (nonatomic, strong) NSArray *tag;

@property (nonatomic, strong) NSString *views;

@property (nonatomic, strong) NSString *commentCount;

@property (nonatomic, strong) NSString *favoriteCount;

@property (nonatomic, strong) NSDictionary *beginTime;

@property (nonatomic, strong) NSDictionary *endTime;

@property (nonatomic, strong) NSString *timeAddInfo;

@property (nonatomic, strong) NSString *entrancePrice;

@property (nonatomic, strong) NSString *priceAddInfo;

@property (nonatomic, strong) NSString *information;

@end
