//
//  MuseumListViewModel.h
//  chaoxi
//
//  Created by fizz on 15/11/25.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "CXViewModelClass.h"
#import "MuseumModel.h"

@interface MuseumListViewModel : CXViewModelClass

@property (nonatomic, strong) RACCommand *requestCommand;

@property (nonatomic, strong) RACSubject *delegateSignal;

@property (nonatomic, strong) NSMutableArray *modelArr;

@end
