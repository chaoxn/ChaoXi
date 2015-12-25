//
//  ViedoDetailViewModel.m
//  chaoxi
//
//  Created by fizz on 15/12/21.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "ViedoDetailViewModel.h"

#define DETAILURL @"http://api2.pianke.me/ting/radio_detail"
#define DETAILURLLIST @"http://api2.pianke.me/ting/radio_detail_list"

@interface ViedoDetailViewModel ()

@property (nonatomic, strong) NSNumber *page;
@property (nonatomic, copy) NSDictionary *parameter;
@property (nonatomic, strong) NSString *url;

@end

@implementation ViedoDetailViewModel

- (instancetype)init
{
    if (self = [super init]) {
        
        [self dataBinding];
        [self headerRequest];
    }
    return self;
}

- (void)dataBinding
{
    self.page = @0;
    self.url = DETAILURL;
    
    @weakify(self);
    [[RACObserve(self, radioid) filter:^BOOL(NSString *value) {
        
        return value.length>0;
    }] subscribeNext:^(NSString *value) {
        
        [[RACObserve(self, page) filter:^BOOL(NSNumber *value) {
            
            return value>0;
        }] subscribeNext:^(NSNumber *page)  {
            
            @strongify(self);
            NSDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       value, @"radioid",
                                       [NSString stringWithFormat:@"%@", self.page], @"start",
                                       @"2", @"client",
                                       @"10", @"limit",nil];
            
            self.parameter = parameter;
        }];
    }];
    
    [RACObserve(self, parameter) subscribeNext:^( NSDictionary *parameter) {
        
        @strongify(self);
        
        NSMutableArray *details = [NSMutableArray array];
        
        if ([self.page isEqualToNumber:@0] != YES) {
            
            [details addObjectsFromArray:self.modelArr];
        }
        
        [CXHttpManager NetRequestPOSTWithURL:DETAILURLLIST Parameter:parameter ReturnValeuBlock:^(NSDictionary *returnValue) {
            
            NSArray *listenArr = [ViedoModel objectArrayWithKeyValuesArray:[[returnValue objectForKey:@"data"] objectForKey:@"list"]];
            
            [details addObjectsFromArray:listenArr];
            
            self.modelArr = details;
            
        } ErrorCodeBlock:^(id errorCode) {
            
        } FailureBlock:^{
            
        }];
        
    }];
    
}

- (void)headerRequest
{
    @weakify(self);
    [RACObserve(self, parameter) subscribeNext:^( NSDictionary *parameter) {
    
        [CXHttpManager NetRequestPOSTWithURL:DETAILURL Parameter:parameter ReturnValeuBlock:^(NSDictionary *returnValue) {
            
            @strongify(self);
            self.detailModel = [ViedoModel objectWithKeyValues:returnValue[@"data"][@"radioInfo"]];
            
        } ErrorCodeBlock:^(id errorCode) {
            
        } FailureBlock:^{
            
        }];
    }];
}

- (void)first
{
    self.page = @0;
    self.url = DETAILURL;
}

- (void)next
{
    self.page  = [NSNumber numberWithInteger: [self.page integerValue] + 10];
    self.url = DETAILURLLIST;
}

@end
