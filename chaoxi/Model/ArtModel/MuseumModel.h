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

@end
