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

@interface ListenListViewModel : CXViewModelClass

@property (nonatomic, copy) NSArray *modelArr;
@property (nonatomic, strong) UIViewController *vc;

@property (nonatomic, assign) NSNumber *page;
@property (nonatomic, assign) NSUInteger perPage;

@property (nonatomic, strong) RACCommand *didSelectCommand;
@property (nonatomic, strong, readonly) RACCommand *requestRemoteDataCommand;

- (void)first;

- (void)next;

- (BOOL (^)(NSError *error))requestRemoteDataErrorsFilter;

- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page;

@end
