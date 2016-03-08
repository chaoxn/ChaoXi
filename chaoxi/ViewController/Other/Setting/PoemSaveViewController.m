//
//  PoemSaveViewController.m
//  chaoxi
//
//  Created by fizz on 16/2/1.
//  Copyright © 2016年 chaox. All rights reserved.
//

#import "PoemSaveViewController.h"
#import "PoeViewController.h"
#import "FMDatabaseQueue+Extension.h"

@interface PoemSaveViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *arr;
@property (nonatomic, strong) NSMutableArray *titleArr;
@property (nonatomic, retain) FMDatabase *db;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation PoemSaveViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self.view addSubview:self.tableView];
    [self selected];
    
    if (self.arr.count == 0) {
        [self.tableView removeFromSuperview];
        [self createNothing];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

- (void)createNothing
{
    UIImageView *big = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jusang.jpg"]];
    big.frame = CGRectMake(self.view.frame.size.width / 4, self.view.frame.size.height / 3, self.view.frame.size.width / 2, self.view.frame.size.width / 2);
    [self.view addSubview:big];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"您还没有收藏poem呢，再去看看吧";
    label.frame = CGRectMake(0, 0, 260, 40);
    label.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height * 2 /3);    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:label];
}

- (void)selected
{
    [[FMDatabaseQueue shareInstense] inDatabase:^(FMDatabase *db) {
        
        FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM poem"];
        
        self.arr = [NSMutableArray array];
        self.titleArr = [NSMutableArray array];
        
        while ([resultSet next]) {
            NSString *tingID = [resultSet stringForColumn:@"poemIndex"];
            NSString *title = [resultSet stringForColumn:@"title"];
            
            [self.arr addObject:tingID];
            [self.titleArr addObject:title];
        }
        NSLog(@" ..%@", self.arr);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"chaox";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
    }
    cell.textLabel.text = [self.titleArr objectAtIndex:indexPath.row];
    cell.textLabel.font = CXFont(13);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PoeViewController *poem = [[PoeViewController alloc]init];
    poem.receiveIndex = [self.arr objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:poem animated:NO];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = ({
            UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
            tableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView;
        });
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
