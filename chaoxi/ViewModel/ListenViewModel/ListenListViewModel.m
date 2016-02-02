//
//  ListenListViewModel.m
//  chaoxi
//
//  Created by fizz on 15/11/11.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "ListenListViewModel.h"
#import "ViedoModel.h"
#import "VideoDetailController.h"

#define LISTENURL @"http://api2.pianke.me/ting/radio_list"

@interface ListenListViewModel()

@property (nonatomic, copy) NSDictionary *parameter;
@property (nonatomic, strong, readwrite) RACCommand *requestRemoteDataCommand;

@end

@implementation ListenListViewModel

- (instancetype)init
{
    if (self = [super init]) {
        
        @weakify(self)
        
        self.didSelectCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSIndexPath *indexPath) {
           
            VideoDetailController *videoDetailVC = [[VideoDetailController alloc]init];
            ViedoModel *model = self.modelArr[indexPath.row];
            videoDetailVC.radioid = model.radioid;
            [self.vc.navigationController pushViewController:videoDetailVC animated:YES];
            
            return [RACSignal empty];
        }];
        
        self.requestRemoteDataCommand = [[RACCommand alloc] initWithSignalBlock:^(NSNumber *page) {
            @strongify(self)
            return [[self requestRemoteDataSignalWithPage:page.unsignedIntegerValue] takeUntil:self.rac_willDeallocSignal];
        }];
        
        [[self.requestRemoteDataCommand.errors
          filter:[self requestRemoteDataErrorsFilter]]
         subscribe:self.errors];
        
        [self initBind];
    }
    return self;
}

- (void)initBind
{
    self.page = @9;
    
    @weakify(self);
    
    [RACObserve(self, page) subscribeNext:^(NSNumber *page) {
        
         @strongify(self);
        self.parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           @"2", @"client",
                                          @"9", @"limit",
                                          [NSString stringWithFormat:@"%@", self.page], @"start",nil];
        
    }];
    
    
    [RACObserve(self, parameter) subscribeNext:^( NSDictionary *parameter) {
        @strongify(self);

        NSMutableArray *listens = [NSMutableArray arrayWithCapacity:88];
        
        // 分两种情况: 如果是变为0,说明是重置数据;如果是大于0,说明是要加载更多数据;不处理向上翻页的情况.
        if ([self.page isEqualToNumber:@9] != YES) {
            
            [listens addObjectsFromArray:self.modelArr];
        }
        
        [[CXAPIManage getListenData:parameter]subscribeNext:^(RACTuple *value) {
         
            [listens addObjectsFromArray:value.first];
            
            self.modelArr = listens;
        }];
        
        
//        [CXHttpManager NetRequestPOSTWithURL:LISTENURL Parameter:parameter ReturnValeuBlock:^(NSDictionary *returnValue) {
//            
//            NSArray *listenArr = [ViedoModel objectArrayWithKeyValuesArray:[[returnValue objectForKey:@"data"] objectForKey:@"list"]];
//        
//            [listens addObjectsFromArray:listenArr];
//            
//            self.modelArr = listens;
//            
//        } ErrorCodeBlock:^(id errorCode) {
//           
//        } FailureBlock:^{
//            
//        }];
        
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

- (BOOL (^)(NSError *error))requestRemoteDataErrorsFilter
{
    return ^(NSError *error) {
        return YES;
    };
}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page
{
    return [RACSignal empty];
}

@end
