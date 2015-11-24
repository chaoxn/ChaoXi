//
//  PoeViewController.m
//  chaoxi
//
//  Created by fizz on 15/9/28.
//  Copyright (c) 2015年 chaox. All rights reserved.
//

#import "PoeViewController.h"
#import "FMDatabase.h"
#import "Poem.h"
#import "PoeViewModel.h"

@interface PoeViewController ()<UIAlertViewDelegate>

@property (nonatomic, retain) FMDatabase *db;
@property (nonatomic, retain) NSString *index;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) Poem *model;
@property (nonatomic, strong) PoeViewModel *viewModel ;

@end

@implementation PoeViewController

- (UILabel *)contentLabel
{
    if (_contentLabel == nil) {
        
        _contentLabel = ({
            UILabel *label = [[UILabel alloc]init];
            label.numberOfLines = 0;
            label.textColor = CXRGBColor(101, 98, 98);
            label.textAlignment = NSTextAlignmentCenter;
            label.font = CXFont(13);
            label;
        });
    }
    return _contentLabel;
}

- (PoeViewModel *)viewModel
{
    if (_viewModel == nil) {
        _viewModel = [[PoeViewModel alloc]init];
    }
    return _viewModel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initModel];
    [self initViewModel];
    [self.scrollView addSubview:self.contentLabel];
    [self.saveButton setBackgroundImage:[UIImage imageNamed:@"bushoucang"] forState:UIControlStateNormal];
    [self.saveButton setBackgroundImage:[UIImage imageNamed:@"shouchang"] forState:UIControlStateSelected];
}

- (void)initModel
{
    [self createDB];

    FMResultSet *resultSet = [self.db executeQuery:@"SELECT * FROM poem"];

    NSMutableArray *tingIdarr = [NSMutableArray array];
    while ([resultSet next]) {
        NSString *name = [resultSet stringForColumn:@"poemIndex"];
        [tingIdarr addObject:name];
    }
    
    if ([tingIdarr containsObject:self.index] || [tingIdarr containsObject:self.receiveIndex]) {
        
        self.saveButton.selected = YES;
    }else{
        
        self.saveButton.selected = NO;
    }
}

- (IBAction)refreshAction:(UIButton *)sender
{
    [self showProgress:@"春风十里不如你"];
    
    _contentLabel.text = nil;
    [self transitionWithType:@"fade" WithSubtype:kCATransitionFromLeft ForView:self.view];
    
    [self initViewModel];
    [self initModel];
}

- (void)initViewModel
{
    self.index = [NSString stringWithFormat:@"%u",arc4random()%88+1];
    
    self.viewModel.receiveIndex = self.receiveIndex.length == 0 ? self.index : self.receiveIndex;
    
    self.viewModel.delegateSignal = [RACSubject subject];
    
    [self.viewModel.delegateSignal subscribeNext:^(id model) {
        
        self.model = model;
        [KVNProgress dismiss];
    }];
    
    [self.viewModel.requestCommand execute:nil];
    
    @weakify(self);
    [RACObserve(self, model) subscribeNext:^(Poem *model) {
        
        @strongify(self);
        
        self.titleLabel.text = model.title;
        self.autherLabel.text = model.artist;
        
        NSString *str = [model.content stringByReplacingOccurrencesOfString:@"|^n|" withString:@"\n\n"];
        
        CGSize size = CGSizeMake(ScreenWidth - 40, MAXFLOAT);

        NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:CXFont(13),NSFontAttributeName, nil];

        CGSize actualSize = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic1 context:nil].size;
        
        _scrollView.contentSize = CGSizeMake(0, actualSize.height + 100);
        _contentLabel.frame = CGRectMake(0, 10, ScreenWidth ,actualSize.height);
        _contentLabel.text = str;
      
    }];
}

- (IBAction)saveAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        
        [self delete];
    } else {
        
        [self createDB];
        [self insert];
    }
}

- (void)createDB
{
    // 1.获得数据库文件路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *fileName = [doc stringByAppendingPathComponent:@"niu.db"];
    // 2.获得数据库
    FMDatabase *db = [FMDatabase databaseWithPath:fileName];
    if ([db open]) {
        BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS poem (poemIndex text PRIMARY KEY , title text NOT NULL)"];
        if (result) {
            NSLog(@"创建表成功");
        }else{
            NSLog(@"创建表失败");
        }
        self.db = db;
    }
}
- (void)insert
{
    NSString *insertStr = [NSString stringWithFormat:
                           @"INSERT INTO poem (poemIndex, title) VALUES ('%@', '%@');", self.index, self.titleLabel.text];
    BOOL res = [self.db executeUpdate:insertStr];
    
    if (!res) {
        NSLog(@"插入失败");
    } else {
        NSLog(@"插入成功");
    }
}
-(void)delete
{
    NSString *deleteSql = [NSString stringWithFormat:
                           @"delete from poem where  poemIndex= '%@'",
                           self.index];
    BOOL res = [self.db executeUpdate:deleteSql];
    
    if (!res) {
        NSLog(@"删除失败");
    } else {
        NSLog(@"删除成功");
    }
}

- (void) transitionWithType:(NSString *) type WithSubtype:(NSString *) subtype ForView : (UIView *) view
{
    CATransition *animation = [CATransition animation];
    
    animation.duration = 1;
    
    animation.type = type;
    if (subtype != nil) {
        
        animation.subtype = subtype;
    }
    animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
    
    [view.layer addAnimation:animation forKey:@"animation"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [KVNProgress setConfiguration:self.basicConfiguration];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
@end
