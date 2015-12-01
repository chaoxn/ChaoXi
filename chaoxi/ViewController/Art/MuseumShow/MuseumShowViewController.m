//
//  MuseumShowViewController.m
//  chaoxi
//
//  Created by fizz on 15/11/26.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "MuseumShowViewController.h"
#import "MuseumShowCell.h"
#import "MuseumShowViewModel.h"
#import "ShowDetailViewController.h"

@interface MuseumShowViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, strong) UIButton *returnButton;

@property (nonatomic, strong) MuseumShowViewModel *showViewModel;

@property (nonatomic, strong) NSMutableArray *modelArray;

@end

@implementation MuseumShowViewController

#pragma mark- life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view addSubview:self.tableView];
//    [self.view addSubview:self.coverView];
//    [self.coverView addSubview:self.returnButton];
    
//    [self showProgress:CX];
    [self layoutSubViews];
    [self bindViewModel];
}

- (void)viewWillAppear:(BOOL)animated
{
//    [self showProgress:CX];
}

- (void)layoutSubViews
{
    @weakify(self)
//    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        @strongify(self)
//        make.left.top.and.right.equalTo(self.view);
//        make.height.mas_equalTo(40);
//    }];
    
//    [self.returnButton mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        @strongify(self)
//        make.top.equalTo(self.coverView).offset(10);
//        make.left.equalTo(self.coverView).offset(20);
//        make.width.and.height.mas_equalTo(24);
//    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        @strongify(self)
        make.edges.equalTo(self.view);
    }];
    
}

- (void)bindViewModel
{
    @weakify(self)
    [[self.returnButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        @strongify(self)
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    self.showViewModel.delegateSignal = [RACSubject subject];
    
    [self.showViewModel.requestCommand execute:nil];
    
    [self.showViewModel.delegateSignal subscribeNext:^(id array) {
       
        self.modelArray = array;
        [self.tableView reloadData];
//        [KVNProgress dismiss];
    }];
    
}

#pragma mark- tableView delegate

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indeinitfier = @"indeinitfier";
    
    MuseumShowCell *cell = [tableView dequeueReusableCellWithIdentifier:indeinitfier];
    
    if (!cell) {
        cell = [[MuseumShowCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indeinitfier];
    }
    
    cell.model = self.modelArray[indexPath.row];
    return cell;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScreenHeight/3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MuseumModel *model = self.modelArray[indexPath.row];
    ShowDetailViewController *sdVC = [[ShowDetailViewController alloc]init];
    sdVC.detailID = model.objectId;
    [self.navigationController pushViewController:sdVC animated:YES];
}

#pragma mark- setter & getter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = ({
            UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
            tableView.delegate = self;
            tableView.dataSource  = self;
            tableView.backgroundColor = [UIColor blackColor];
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableView;
        });
    }
    return _tableView;
}

- (UIView *)coverView
{
    if (!_coverView) {
        _coverView = ({
            UIView *view = [[UIView alloc]init];
            view.backgroundColor = [UIColor blackColor];
            view.alpha = 0.618;
            view;
        });
    }
    return _coverView;
}

- (UIButton *)returnButton
{
    if (!_returnButton) {
        _returnButton = ({
            UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
            button;
        });
    }
    return _returnButton;
}

- (MuseumShowViewModel *)showViewModel
{
    if (!_showViewModel) {
        _showViewModel = [[MuseumShowViewModel alloc]init];
        _showViewModel.museumId = self.musuemId;
    }
    return _showViewModel;
}

- (NSMutableArray *)modelArray
{
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

#pragma mark - 

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
