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
@property (nonatomic, copy) NSString *urlPath;

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
    
    self.httpClient = [AFHTTPRequestOperationManager manager];
    self.httpClient.requestSerializer = [AFJSONRequestSerializer serializer];
    self.httpClient.responseSerializer = [AFJSONResponseSerializer serializer];
    
    self.page = @9;
    
    @weakify(self);
    
    [RACObserve(self, page) subscribeNext:^(NSNumber *page) {
        
         @strongify(self);
        NSDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                            @"", @"auth",
                                           @"1", @"client",
                                           @"7F390F40-86ED-43BB-AB07-FC786C148941", @"deviceid",
                                          @"9", @"limit",
                                          [NSString stringWithFormat:@"%@", self.page], @"start",
                                        @"3.0.6", @"version", nil];
        
        self.parameter = parameter;
    }];
    
    [RACObserve(self, parameter) subscribeNext:^( NSDictionary *parameter) {
        @strongify(self);
        
//        [[self.httpClient rac_GET:LISTENURL parameters:parameter] subscribeNext:^(RACTuple *JSONAndHeaders) {
//
//        }];
        
        NSMutableArray *listens = [NSMutableArray arrayWithCapacity:88];
        
        if ([self.page isEqualToNumber:@9] != YES) {
            
            [listens addObjectsFromArray:self.modelArr];
        }
        
        [CXHttpManager NetRequestGETWithURL:LISTENURL Parameter:parameter ReturnValeuBlock:^(NSDictionary *returnValue) {
            
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
