//
//  FunnyViewController.m
//  chaoxi
//
//  Created by fizz on 15/10/26.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "FunnyViewController.h"
#import "FunnyViewModel.h"
#import "WebViewController.h"

@interface FunnyViewController ()

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) FunnyViewModel *viewModel;

@end

@implementation FunnyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self showProgress:@"春风十里不如你"];
    [self.view addSubview:self.collectionView];
    
    self.viewModel.delegateSignal = [RACSubject subject];
    [self.viewModel.delegateSignal subscribeNext:^(id dicArr) {
        
        self.dataArray = dicArr;
        [self.collectionView reloadData];
        [KVNProgress dismiss];
    }];
    
    [self.viewModel.requestCommand execute:nil];
}

#pragma -mark UICollectionView 代理方法

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count+1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        return CGSizeMake(CELL_WIDTH, HEADER_HEIGHT);
    }else if(indexPath.row == 1){
        return CGSizeMake(CELL_WIDTH, CELL_CURRHEIGHT);
    }else{
        return CGSizeMake(CELL_WIDTH, CELL_HEIGHT);
    }
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CXSliderViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    cell.tag = indexPath.row;
    cell.dic = self.dataArray[indexPath.row];    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WebViewController *web = [[WebViewController alloc]init];
    NSDictionary *dic = _dataArray[indexPath.row];
    web.urlStr =dic[@"access_url"];
    [self presentViewController:web animated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UICollectionView *)collectionView
{
    CXSliderViewLayout *layout = [[CXSliderViewLayout alloc] init];
    layout.count = 590;
    if (_collectionView == nil) {
        
        _collectionView = ({
            UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CELL_WIDTH, CGRectGetHeight([UIScreen mainScreen].bounds)) collectionViewLayout:layout];
            [collectionView registerClass:[CXSliderViewCell class] forCellWithReuseIdentifier:@"CELL"];
            collectionView.backgroundColor = [UIColor clearColor];
            collectionView.delegate = self;
            collectionView.dataSource = self;
            collectionView.bounces = NO;
            collectionView;
        });
    }
    return _collectionView;
}

- (FunnyViewModel *)viewModel
{
    if (_viewModel == nil) {
        _viewModel = [[FunnyViewModel alloc]init];
    }
    return _viewModel;
}

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
