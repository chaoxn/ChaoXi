//
//  RadioListViewController.m
//  chaoxi
//
//  Created by fizz on 15/12/23.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "RadioListViewController.h"
#import "RadioListCell.h"

@interface RadioListViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation RadioListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [RACObserve([CXAudioPlayer shareInstance], index)subscribeNext:^(id x) {
       
        [self.tableView reloadData];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indeinitfier = @"indeinitfier";
    
    RadioListCell *cell = [tableView dequeueReusableCellWithIdentifier:indeinitfier];
    
    if (!cell) {
        cell = [[RadioListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indeinitfier];
    }
    
    cell.model =  [CXAudioPlayer shareInstance].modelArr[indexPath.row];
    
    cell.playing =  [CXAudioPlayer shareInstance].index == indexPath.row ? YES : NO;
    
    return cell;
}


- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [CXAudioPlayer shareInstance].modelArr.count;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60 * HeightRate;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [CXAudioPlayer shareInstance].index = indexPath.row;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
