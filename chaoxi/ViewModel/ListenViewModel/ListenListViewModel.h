//
//  ListenListViewModel.h
//  chaoxi
//
//  Created by fizz on 15/11/11.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViedoModel.h"

@class ViedoModel;

@interface ListenListViewModel : NSObject

@property (nonatomic, copy) NSArray *modelArr;

@property (nonatomic, strong, readonly) RACCommand *requestCommand;

- (void)first;

- (void)next;

@end
