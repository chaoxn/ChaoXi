//
//  PoeViewModel.h
//  chaoxi
//
//  Created by fizz on 15/11/9.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "CXViewModelClass.h"

@interface PoeViewModel : CXViewModelClass

@property (nonatomic, strong, readonly) RACCommand *requestCommand;

@property (nonatomic, strong) NSString *receiveIndex;

@property (nonatomic, strong) RACSubject *delegateSignal;

@end
