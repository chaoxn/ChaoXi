//
//  ViedoModel.h
//  chaoxi
//
//  Created by fizz on 15/10/29.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViedoModel : NSObject

@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *radioid;
@property (nonatomic,strong)NSString *guide;
@property (nonatomic,strong)NSNumber *musicvisitnum;
@property (nonatomic,strong)NSMutableDictionary *userinfo;
@property (nonatomic,strong)NSString *baseimg;
@property (nonatomic,strong)NSString *coverimg;

@property (nonatomic,strong)NSString *pic;
@property (nonatomic,strong)NSString *ringid;
@property (nonatomic,strong)NSString *musicVisit;
@property (nonatomic,strong)NSString *musicUrl;
@property (nonatomic,strong)NSString *tingid;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *userimg;
@property (nonatomic,strong)NSMutableDictionary *playInfo;

@end
