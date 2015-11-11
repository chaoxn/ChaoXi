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
//@property (nonatomic, strong) NSArray *videoModelArr;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) ListenListViewModel *listenViewModel;

@end

@implementation ListenViewController

- (ListenListViewModel *)listenViewModel
{
    if (_listenViewModel == nil) {
        
        _listenViewModel = [[ListenListViewModel alloc]init];
    }
    
    return _listenViewModel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [RACObserve(self.listenViewModel, modelArr) subscribeNext:^(id x) {
       
        [self updateView];
    }];
    
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.listenViewModel first];
    }];
    
    _tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self.listenViewModel next];
    }];
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
    cell.volLable.text = [NSString stringWithFormat:@"vol.%ld",(long)indexPath.row+1];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoDetailController *videoDetailVC = [[VideoDetailController alloc]init];
    [self.navigationController pushViewController:videoDetailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScreenHeight *230/ScreenHeight;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
