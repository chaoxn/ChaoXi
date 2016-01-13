//
//  ArtViewController.m
//  chaoxi
//
//  Created by fizz on 15/10/26.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "ArtViewController.h"
#import "ArtCell.h"
#import "ArtHeaderView.h"
#import "MuseumListViewModel.h"
#import "MuseumShowViewController.h"
#import "MuseumDetailViewController.h"
#import "CXPushTransition.h"
#import "CXPopTransition.h"

#define ItemPadding 10
#define HeaderHeight 190

@interface ArtViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImageView *backGroundImageView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIVisualEffectView *visualEffectView;

@property (nonatomic, strong) MuseumListViewModel *viewModel;

@property (nonatomic, strong) NSMutableArray *modelArr;

@property (nonatomic, strong) NSMutableArray *cellArr;

@property (nonatomic, assign) BOOL stop;

@property (nonatomic, assign) int page;

@end

@implementation ArtViewController
@dynamic button;

#pragma mark- life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [CXProgress showWithType:CXProgressTypeBasicCatch];
    
    [self.backGroundImageView addSubview:self.visualEffectView];
    [self.view addSubview:self.backGroundImageView];
    [self.view addSubview:self.collectionView];
    
    [self layoutSubviews];
    [self bindModel];
}

// TODO:- navi 优化

#pragma mark- event response

- (void)layoutSubviews
{
    @weakify(self);
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        @strongify(self);
        make.edges.equalTo(self.view);
    }];
    
    [self.backGroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        @strongify(self);
        make.edges.equalTo(self.view);
    }];
}

- (void)bindModel
{
    [self.viewModel.requestCommand execute:nil];
    
    @weakify(self);
    [[[RACObserve(self.viewModel, modelArr) deliverOn:[RACScheduler mainThreadScheduler]] filter:^BOOL(NSArray *modelArr) {
        
        return modelArr.count>0;
    }] subscribeNext:^(id x) {
        
        @strongify(self);
        [self.collectionView reloadData];
        [CXProgress dismiss];
    }];
    
    [[RACObserve(self, page) filter:^BOOL(id value) {
        
       @strongify(self);
        return self.viewModel.modelArr.count > 0 && self.stop;
    }]subscribeNext:^(NSNumber *x) {
        
        @strongify(self);
        MuseumModel *model = [self.viewModel.modelArr objectAtIndex:[x integerValue]];
        [self.backGroundImageView sd_setImageWithURL:model.coverUrl[@"url"]];
    }];
}

#pragma mark- collectionView delegate

- (NSInteger )numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewModel.modelArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ArtCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ARTCELL" forIndexPath:indexPath];
    cell.model = self.viewModel.modelArr[indexPath.item];
    cell.detailButton.tag = indexPath.row;
    [cell.detailButton addTarget:self action:@selector(detailAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)detailAction:(UIButton *)sender
{
    MuseumDetailViewController *mdVC = [[MuseumDetailViewController alloc]init];
    mdVC.model = self.viewModel.modelArr[sender.tag];
    [self.navigationController pushViewController:mdVC animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == self.viewModel.modelArr.count-1) {
        
        return CGSizeMake(ScreenWidth, ScreenHeight);
    }else{
        
        return CGSizeMake(ScreenWidth, ScreenHeight - HeaderHeight * HeightRate);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MuseumShowViewController *msVC = [[MuseumShowViewController alloc]init];
    UINavigationController *msNaVC = [[UINavigationController alloc]initWithRootViewController:msVC];
    MuseumModel *model = self.viewModel.modelArr[indexPath.row];
    msVC.musuemId = model.objectId;
    [self presentViewController:msNaVC animated:YES completion:nil];
}

/*
 *一个柔顺的滚动
 *
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGPoint targetOffset = [self nearestTargetOffsetForOffset:*targetContentOffset];
    targetContentOffset->x = targetOffset.x;
    targetContentOffset->y = targetOffset.y;
}

- (CGPoint)nearestTargetOffsetForOffset:(CGPoint)offset
{
    // 减去item之间的padding或者直接设置为0
    CGFloat pageSize = ScreenHeight- (HeaderHeight - ItemPadding) * HeightRate;
    self.page = roundf(offset.y / pageSize);
    CGFloat targetY = pageSize * self.page;
    return CGPointMake(offset.x, targetY);
}
*/

/**
 *  一个不太柔顺的滚动
 */
- (void)snapToNearestItem
{
    CGPoint targetOffset = [self nearestTargetOffsetForOffset:self.collectionView.contentOffset];
    [self.collectionView setContentOffset:targetOffset animated:YES];
}

- (CGPoint)nearestTargetOffsetForOffset:(CGPoint)offset
{
    CGFloat pageSize = ScreenHeight- (HeaderHeight - ItemPadding) * HeightRate;
    self.page = roundf(offset.y / pageSize);
    CGFloat targetY = pageSize * self.page;
    return CGPointMake(offset.x, targetY);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self snapToNearestItem];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.stop = YES;
    [self snapToNearestItem];
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{    
    CGSize size={ScreenWidth,110 * HeightRate};
    return size;
}

#pragma mark- private method


#pragma mark- setter && getter

- (UIImageView *)backGroundImageView
{
    if (!_backGroundImageView) {
        _backGroundImageView = ({
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.frame];
            imageView.image = [UIImage imageNamed:@"test"];
            imageView;
        });
    }
    return _backGroundImageView;
}

- (UIVisualEffectView *)visualEffectView
{
    if (!_visualEffectView) {
        _visualEffectView = ({
            UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
            visualEffectView.frame = self.view.bounds;
            visualEffectView;
        });
    }
    return _visualEffectView;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumInteritemSpacing = 30;
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        _collectionView = ({
            UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
            [collectionView registerClass:[ArtCell class] forCellWithReuseIdentifier:@"ARTCELL"];
            [collectionView registerClass:[ArtHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ARTHEADER"];
            collectionView.backgroundColor = [UIColor clearColor];
            collectionView.delegate = self;
            collectionView.dataSource = self;
            collectionView.bounces = NO;
            collectionView;
        });
    }
    return _collectionView;
}

- (MuseumListViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [[MuseumListViewModel alloc]init];
        _viewModel.delegateSignal = [RACSubject subject];
    }
    return _viewModel;
}

- (NSMutableArray *)modelArr
{
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}

#pragma mark-

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
