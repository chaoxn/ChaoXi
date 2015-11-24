//
//  FunnyViewModel.h
//  chaoxi
//
//  Created by fizz on 15/11/17.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "CXViewModelClass.h"

@interface FunnyViewModel : CXViewModelClass

@property (nonatomic, strong, readonly) RACCommand *requestCommand;

@property (nonatomic, strong) RACSubject *delegateSignal;

@end
