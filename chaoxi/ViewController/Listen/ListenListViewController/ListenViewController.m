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

@interface ListenViewController ()<UITableViewDataSource, UITableViewDelegate, UIViewControllerPreviewingDelegate>

@property (nonatomic, strong) NSMutableArray *imgArr;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) ListenListViewModel *listenViewModel;
@property (nonatomic, strong) ODRefreshControl *refreshControl;

@property (nonatomic, strong) NSMutableArray *cellArr;

@property (nonatomic, readonly) UIForceTouchCapability forceTouchCapability;

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
    
//    self.tableView.alpha = 0;
//    [self.tableView reloadData];
//    double diff = 0.05;
//    CGFloat tableHeight = self.tableView.bounds.size.height;
//    NSArray *cells = self.tableView.visibleCells;
    
    [self check3DTouchAvailable];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.navigationController.delegate = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)check3DTouchAvailable {

    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        // source 要pop的view
        [self registerForPreviewingWithDelegate:(id)self sourceView:self.tableView];
    }
}

- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)context viewControllerForLocation:(CGPoint)point {
    //防止重复加入
    if ([self.presentedViewController isKindOfClass:[ListenViewController class]]){
        return nil;
    }
    else {
        ListenViewController *peekViewController = [[ListenViewController alloc] init];
        return peekViewController;
    }
}

- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    
    // 生成UIPreviewAction
    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"Action 1" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"Action 1 selected");
    }];
    
    UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:@"Action 2" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"Action 2 selected");
    }];
    
    UIPreviewAction *action3 = [UIPreviewAction actionWithTitle:@"Action 3" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"Action 3 selected");
    }];
    
    //添加到到UIPreviewActionGroup中
    NSArray *actions = @[action1, action2, action3];
  
    return actions;
}


/**
 *  获取用户手势点所在cell的下标，同时判断手势点是否超出tableview的范围
 */
- (BOOL)getShouldShowRectAndIndexPathWithLocation:(CGPoint)location {
    CGPoint tableLocation = [self.view convertPoint:location toView:self.tableView];
    NSIndexPath *selectedPath = [self.tableView indexPathForRowAtPoint:tableLocation];
//    CGRect sourceRect = CGRectMake(0, selectedPath.row * ScreenHeight *250/ScreenHeight, ScreenHeight, ScreenHeight *250/ScreenHeight);
    
    NSLog(@"%zd",selectedPath.row);
    return (selectedPath.row >= (self.listenViewModel.modelArr.count+10)) ? NO : YES;
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
