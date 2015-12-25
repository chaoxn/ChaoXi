//
//  ViedoDetailViewModel.h
//  chaoxi
//
//  Created by fizz on 15/12/21.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViedoModel.h"

@interface ViedoDetailViewModel : NSObject

@property (nonatomic, strong) NSString *radioid;

@property (nonatomic, strong) NSArray *modelArr;

@property (nonatomic, strong) ViedoModel *detailModel;

- (void)first;

- (void)next;

@end
