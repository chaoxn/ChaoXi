//
//  VideoDetailController.m
//  chaoxi
//
//  Created by fizz on 15/10/30.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "VideoDetailController.h"
#import "ViedoDetailViewModel.h"
#import "ViedoModel.h"
#import "DetailCell.h"
#import "CXLineView.h"
#import "CXAudioPlayer.h"
#import "PlayOnViewController.h"
#import "PlayBaseViewController.h"
#import "PlayBaseViewController.h"
#import "CXMagicMoveTransition.h"

#define APPEARHEIGHE 50
#define NAIHEIGHT 64

@interface VideoDetailController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIView *header;
@property (nonatomic, strong) UIImageView *headerImage;
@property (nonatomic, strong) UILabel *desLabel;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) ViedoDetailViewModel *viewModel;
@property (nonatomic, strong) CXLineView *lineView;
@property (nonatomic, strong) ODRefreshControl *refreshControl;

@end

@implementation VideoDetailController

#pragma mark- lify-cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(![SCCatWaitingHUD sharedInstance].isAnimating)
    {
        [[SCCatWaitingHUD sharedInstance] animateWithInteractionEnabled:YES];
    }
    
    [self.header addSubview:self.authorLabel];
    [self.header addSubview:self.desLabel];
    [self.header addSubview:self.headerImage];
    [self.header addSubview:self.iconImageView];
    [self.header addSubview:self.lineView];
    [self.view addSubview:self.tableView];
        
    [self layoutSubviews];
    [self dataBinding];
    
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self.viewModel next];
    }];
    
    self.refreshControl = [[ODRefreshControl alloc]initInScrollView:self.tableView];
    
    [self.refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing) forControlEvents:UIControlEventValueChanged];
}

- (void)dropViewDidBeginRefreshing
{
    [self.viewModel first];
}

-(void)viewDidAppear:(BOOL)animated
{    
    self.navigationController.delegate = self;
}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"iconfont-return"] style:UIBarButtonItemStyleDone target:self action:@selector(returnAciton:)];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar lt_setBackgroundColor:CXRGBColor(245, 245, 245)];
}

-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                 animationControllerForOperation:(UINavigationControllerOperation)operation
                                              fromViewController:(UIViewController *)fromVC
                                                toViewController:(UIViewController *)toVC
{
    if ([toVC isKindOfClass:[PlayBaseViewController class]]) {
        CXMagicMoveTransition *transition = [[CXMagicMoveTransition alloc]init];
        return transition;
    }else{
        return nil;
    }
}

#pragma mark- private method

- (void)layoutSubviews
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(-64, 0, 0, 0));
    }];
    
    [self.headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.height.mas_equalTo(CGRectGetHeight(self.header.bounds) - 75 * HeightRate);
        make.width.equalTo(self.header);
        make.top.equalTo(self.header.mas_top);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.equalTo(self.header).offset(20);
        make.top.equalTo(self.headerImage.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    self.iconImageView.layer.cornerRadius = 10;
    
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.equalTo(self.iconImageView.mas_trailing).with.offset(10);
        make.centerY.equalTo(self.iconImageView);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.iconImageView.mas_bottom).with.offset(8);
        make.leading.equalTo(self.iconImageView);
        make.size.mas_equalTo(CGSizeMake(300, 20));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.equalTo(self.header.mas_bottom).offset(0);
        make.centerX.equalTo(self.header);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 0.5));
    }];
}

- (void)dataBinding
{
    [RACObserve(self.viewModel, modelArr) subscribeNext:^(id x) {
        
        [self updateView];
    }];
    
    RAC(self.desLabel, text) = RACObserve(self.viewModel, detailModel.desc);
    RAC(self.authorLabel,text) = RACObserve(self.viewModel, detailModel.title);
    
    [RACObserve(self.viewModel, detailModel.coverimg) subscribeNext:^(NSString *imageUrl) {
        
        [self.headerImage sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    }];
    
    [RACObserve(self.viewModel, detailModel.userinfo) subscribeNext:^(NSDictionary *info) {
        
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:info[@"icon"]]];
        [[SCCatWaitingHUD sharedInstance] stop];
    }];
    
}

- (void) updateView
{
    [self.tableView.footer endRefreshing];
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}

#pragma mark - delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indeinitfier = @"indeinitfier";
    
    DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:indeinitfier];
    
    if (!cell) {
        cell = [[DetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indeinitfier];
    }
    
    cell.model = self.viewModel.modelArr[indexPath.row];
    
    return cell;
}

- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.modelArr.count;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlayBaseViewController *playOnVC = [PlayBaseViewController new];
    
    NSMutableArray *modelArray = [NSMutableArray array];
    for (ViedoModel *model in self.viewModel.modelArr) {
        
        ViedoModel *newModel = [ViedoModel objectWithKeyValues:model.playInfo];
        [modelArray addObject:newModel];
    }
    
    [CXAudioPlayer shareInstance].index = indexPath.row;
    [CXAudioPlayer shareInstance].modelArr = modelArray;
    
    [self.navigationController pushViewController:playOnVC animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    UIColor *color = [UIColor colorWithRed:0.478  green:0.502  blue:1 alpha:1];
    UIColor *color = CXRGBColor(245, 245, 245);
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY > APPEARHEIGHE) {
        
        CGFloat alpha = MIN(1, 1 - ((APPEARHEIGHE + NAIHEIGHT - offsetY) / NAIHEIGHT));
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
    }
}

- (void)returnAciton:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- setter

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = ({
            UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.tableHeaderView  = self.header;
            tableView;
        });
    }
    return _tableView;
}

- (UIImageView *)headerImage
{
    if (!_headerImage) {
        _headerImage = ({
            UIImageView *view = [[UIImageView alloc]init];
            view;
        });
    }
    return _headerImage;
}

- (UIView *)header
{
    if (!_header) {
        _header = ({
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 320*HeightRate)];
            view;
        });
    }
    return _header;
}

- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = ({
            UIImageView *view = [[UIImageView alloc]init];
            view.backgroundColor = [UIColor clearColor];
            view;
        });
    }
    return _iconImageView;
}

- (UILabel *)authorLabel
{
    if (!_authorLabel) {
        _authorLabel = ({
            UILabel *label = [[UILabel alloc]init];
            label.font = CXFont(13);
            label.textColor = [UIColor grayColor];
            label;
        });
    }
    return _authorLabel;
}

- (UILabel *)desLabel
{
    if (!_desLabel) {
        _desLabel = ({
            UILabel *label = [[UILabel alloc]init];
            label.font = CXFont(12);
            label.textColor = [UIColor darkGrayColor];
            label;
        });
    }
    return _desLabel;
}

- (ViedoDetailViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [[ViedoDetailViewModel alloc]init];
        _viewModel.radioid = self.radioid;
    }
    return _viewModel;
}

- (CXLineView *)lineView
{
    if (!_lineView) {
        _lineView = [[CXLineView alloc]init];
        _lineView.backgroundColor = [UIColor lightGrayColor];
        _lineView.tag = 1;
    }
    return _lineView;
}

#pragma mark-

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
