//
//  ListenViewController.m
//  chaoxi
//
//  Created by fizz on 15/10/22.
//  Copyright (c) 2015年 chaox. All rights reserved.
//

#import "ListenViewController.h"
#import "LuoIMagaCell.h"
#import "ViedoModel.h"
#import "VideoDetailController.h"
#import "ListenListViewModel.h"

@interface ListenViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *imgArr;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) ListenListViewModel *listenViewModel;
@property (nonatomic, strong) ODRefreshControl *refreshControl;

@end

@implementation ListenViewController

#pragma mark- lifeCycle

/**
 *  数据的请求处理与刷新全部放在视图模型中, 由视图模型的信号自动检测数组的变化动态刷新视图
 *  视图控制器只保留一个刷新命令
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
        
    [RACObserve(self.listenViewModel, modelArr) subscribeNext:^(id x) {
       
        [self updateView];
    }];
    
//    self.refreshControl = [[ODRefreshControl alloc]initInScrollView:self.tableView];
//    
//    [self.refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing) forControlEvents:UIControlEventValueChanged];
    
    // FIXME:-
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       
        [self.listenViewModel first];
    }];
    
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self.listenViewModel next];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.navigationController.delegate = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark- method

- (void) updateView
{
//    [self.refreshControl endRefreshing];
    [self.tableView.footer endRefreshing];
    [self.tableView.header endRefreshing];
    [self.tableView reloadData];
}

- (void)dropViewDidBeginRefreshing
{
    [self.listenViewModel first];
}

#pragma mark- tableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listenViewModel.modelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indeinitfier = @"indeinitfier";
    
    LuoIMagaCell *cell = [tableView dequeueReusableCellWithIdentifier:indeinitfier];
    
    if (!cell) {
        
        cell = [[LuoIMagaCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indeinitfier];
    }
    cell.model = self.listenViewModel.modelArr[indexPath.row];
    cell.tag = indexPath.row;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.listenViewModel.didSelectCommand execute:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScreenHeight *250/ScreenHeight;
}

#pragma mark- getter

- (ListenListViewModel *)listenViewModel
{
    if (_listenViewModel == nil) {
        _listenViewModel = [[ListenListViewModel alloc]init];
        _listenViewModel.vc = self;
    }
    return _listenViewModel;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
