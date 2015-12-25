//
//  ListenListViewModel.m
//  chaoxi
//
//  Created by fizz on 15/11/11.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "ListenListViewModel.h"

#define LISTENURL @"http://api2.pianke.me/ting/radio_list"

@interface ListenListViewModel()

@property (nonatomic, strong) AFHTTPRequestOperationManager *httpClient;

@property (nonatomic, strong) NSNumber *page;
@property (nonatomic, copy) NSDictionary *parameter;

@end

@implementation ListenListViewModel

- (instancetype)init
{
    if (self = [super init]) {
        
        [self initBind];
    }
    return self;
}

- (void)initBind
{
//    self.httpClient = [AFHTTPRequestOperationManager manager];
//    self.httpClient.requestSerializer = [AFJSONRequestSerializer serializer];
//    self.httpClient.responseSerializer = [AFJSONResponseSerializer serializer];
    
    self.page = @9;
    
    @weakify(self);
    
// 绑定接口请求参数与页数, 通过页数的变化激活此信号
    [RACObserve(self, page) subscribeNext:^(NSNumber *page) {
        
         @strongify(self);
        NSDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           @"2", @"client",
                                          @"9", @"limit",
                                          [NSString stringWithFormat:@"%@", self.page], @"start",nil];
        
        self.parameter = parameter;
    }];
    
    // 绑定参数与网络请求 通过上面参数的激活继续激活网络请求,  RACAFNetworking的方式暂时没有掌握仍然使用封装好的AFN
    [RACObserve(self, parameter) subscribeNext:^( NSDictionary *parameter) {
        @strongify(self);
        
//        [[self.httpClient rac_GET:LISTENURL parameters:parameter] subscribeNext:^(RACTuple *JSONAndHeaders) {
//
//        }];
        
        NSMutableArray *listens = [NSMutableArray arrayWithCapacity:88];
        
        /**
         *  分两种情况: 如果是变为0,说明是重置数据;如果是大于0,说明是要加载更多数据;不处理向上翻页的情况.
         */
        
        if ([self.page isEqualToNumber:@9] != YES) {
            
            [listens addObjectsFromArray:self.modelArr];
        }
        
        [CXHttpManager NetRequestPOSTWithURL:LISTENURL Parameter:parameter ReturnValeuBlock:^(NSDictionary *returnValue) {
            
            NSArray *listenArr = [ViedoModel objectArrayWithKeyValuesArray:[[returnValue objectForKey:@"data"] objectForKey:@"list"]];
        
            [listens addObjectsFromArray:listenArr];
            
            self.modelArr = listens;
            
        } ErrorCodeBlock:^(id errorCode) {
           
        } FailureBlock:^{
            
        }];
    
    }];
}

- (void)first
{
    self.page = @9;
}

- (void)next
{
    self.page  = [NSNumber numberWithInteger: [self.page integerValue] + 9];
}

@end
