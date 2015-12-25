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

@end

@implementation ListenViewController

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

- (void) updateView
{
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
    [self.tableView reloadData];
}

#pragma mark- tableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

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
    VideoDetailController *videoDetailVC = [[VideoDetailController alloc]init];
    ViedoModel *model = self.listenViewModel.modelArr[indexPath.row];
    videoDetailVC.radioid = model.radioid;
    [self.navigationController pushViewController:videoDetailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScreenHeight *250/ScreenHeight;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (ListenListViewModel *)listenViewModel
{
    if (_listenViewModel == nil) {
        
        _listenViewModel = [[ListenListViewModel alloc]init];
    }
    
    return _listenViewModel;
}

@end
