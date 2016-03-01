//
//  WeatherViewModel.h
//  chaoxi
//
//  Created by fizz on 16/2/26.
//  Copyright © 2016年 chaox. All rights reserved.
//

#import "CXViewModelClass.h"

@interface WeatherViewModel : CXViewModelClass

@property (nonatomic, strong) RACCommand *requestCommand;

@property (nonatomic, strong) RACSubject *delegateSignal;

@property (nonatomic, strong) NSDictionary *dataDic;

@property (nonatomic, strong) RACSignal *locSignal;

@property (nonatomic, strong) NSString *cityStr;

@end
