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
#import "FMDatabaseQueue+Extension.h"


@interface PoeViewController ()<UIAlertViewDelegate>

@property (nonatomic, retain) FMDatabase *db;
@property (nonatomic, retain) NSString *index;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) Poem *model;
@property (nonatomic, strong) PoeViewModel *viewModel ;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger height;

@end

@implementation PoeViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.scrollView.backgroundColor = [UIColor orangeColor];

    [self initModel];
    [self initViewModel];
    
    if(![SCCatWaitingHUD sharedInstance].isAnimating)
    {
        [[SCCatWaitingHUD sharedInstance] animateWithInteractionEnabled:YES];
    }
    
    [self.scrollView addSubview:self.contentLabel];
    [self.saveButton setBackgroundImage:[UIImage imageNamed:@"bushoucang"] forState:UIControlStateNormal];
    [self.saveButton setBackgroundImage:[UIImage imageNamed:@"shouchang"] forState:UIControlStateSelected];
}

- (void)initModel
{
    [[FMDatabaseQueue shareInstense] inDatabase:^(FMDatabase *db) {
        
        [db executeUpdate:createPoeSQL];
    }];

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

- (void)timerFired:(NSTimer *)sender
{
    self.height += 1;
}

- (IBAction)refreshAction:(UIButton *)sender
{
    self.height = 0;
    if(![SCCatWaitingHUD sharedInstance].isAnimating)
    {
        [[SCCatWaitingHUD sharedInstance] animateWithInteractionEnabled:YES];
    }
    
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
        [[SCCatWaitingHUD sharedInstance] stop];
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
        
        self.contentLabel.text = str;
        
        [self.timer setFireDate:[NSDate distantPast]];
        
        UITapGestureRecognizer * tap = [UITapGestureRecognizer new];
        
        [[tap rac_gestureSignal] subscribeNext:^(UITapGestureRecognizer * tap) {
            
//            [self.timer setFireDate:[NSDate distantFuture]];
        }];
        
        [self.contentLabel addGestureRecognizer:tap];
        
        [RACObserve(self, height) subscribeNext:^(NSNumber *x) {
           
            if ([x  integerValue] == 0) {
                
                self.contentLabel.frame = CGRectMake(0, 10, ScreenWidth ,actualSize.height);
            }
            
            if (actualSize.height > 0) {
            
                self.contentLabel.frame = CGRectMake(0, 150-[x integerValue], ScreenWidth ,actualSize.height);
            }
            
            int actual = (int)actualSize.height;

            if ([x intValue] == actual-100 && [x integerValue] > 0) {
                
                [self.timer setFireDate:[NSDate distantFuture]];
                self.height = 0;
            }
            
        }];
        
        [[RACObserve(self.scrollView, contentOffset) filter:^BOOL(id value) {
          
            return [value CGPointValue].y <= 0;
        }] subscribeNext:^(id x) {
            
//            @strongify(self)
            CGPoint contentOffset = [x CGPointValue];
            //FIXME:-优化
            
        }];
        
    }];
}

- (IBAction)saveAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    sender.selected ? [self saveData] : [self deleteData];
}

- (BOOL )saveData
{
    __block BOOL isSuccess = NO;
    
    [[FMDatabaseQueue shareInstense] inDatabase:^(FMDatabase *db) {
       
        isSuccess = [db executeUpdate: insertPoeSQL, self.index, self.titleLabel.text];
        
        if (!isSuccess) {
            NSLog(@"插入失败");
        } else {
            NSLog(@"插入成功");
        }
    }];
    
    return isSuccess;
}

// FIXME: SQL 语句优化
- (BOOL)deleteData {
    
    __block BOOL isSuccess = NO;
    
    [[FMDatabaseQueue shareInstense] inDatabase:^(FMDatabase *db) {
        
        isSuccess = [db executeUpdate:[NSString stringWithFormat:
                                       @"delete from poem where  poemIndex= '%@'",
                                       self.index]];
        
        if (!isSuccess) {
            NSLog(@"删除失败");
        } else {
            NSLog(@"删除成功");
        }
    }];
    
    return isSuccess;
}

- (void) transitionWithType:(NSString *) type WithSubtype:(NSString *) subtype ForView:(UIView *) view
{
    CATransition *animation = [CATransition animation];
    
    animation.duration = 0.2;
    
    animation.type = type;
    if (subtype != nil) {
        
        animation.subtype = subtype;
    }
    animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
    
    [view.layer addAnimation:animation forKey:@"animation"];
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
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
    if (!_viewModel) {
        _viewModel = [[PoeViewModel alloc]init];
    }
    return _viewModel;
}

- (NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.12 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
