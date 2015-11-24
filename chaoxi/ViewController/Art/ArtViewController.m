//
//  ArtViewController.m
//  chaoxi
//
//  Created by fizz on 15/10/26.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "ArtViewController.h"
#import "ArtCell.h"

@interface ArtViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UIImageView *backGroundImageView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIVisualEffectView *visualEffectView;

@end

@implementation ArtViewController

#pragma mark- life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.backGroundImageView addSubview:self.visualEffectView];
    [self.view addSubview:self.backGroundImageView];
    [self.view addSubview:self.collectionView];
    
    [self layoutPageSubviews];
    
    // TODO:
    [RACObserve(self.collectionView, contentOffset) subscribeNext:^(id x) {
       
        
    }];
}

- (void)layoutPageSubviews
{
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
    }];
    
    [self.backGroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
    }];
}

#pragma mark- collectionView delegate

- (NSInteger )numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ArtCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ARTCELL" forIndexPath:indexPath];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(ScreenWidth, ScreenHeight);
}

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
            collectionView.backgroundColor = [UIColor clearColor];
            collectionView.delegate = self;
            collectionView.dataSource = self;
            collectionView.bounces = NO;
            collectionView;
        });
    }
    return _collectionView;
}

#pragma mark-

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
