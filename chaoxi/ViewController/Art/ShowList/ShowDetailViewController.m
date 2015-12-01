//
//  ShowDetailViewController.m
//  chaoxi
//
//  Created by fizz on 15/11/30.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "ShowDetailViewController.h"
#import "UINavigationBar+Awesome.h"
#import "MuseumModel.h"
#import "ShowDetailViewModel.h"

#define APPEARHEIGHE 50
#define NAIHEIGHT 64

@interface ShowDetailViewController ()<UIScrollViewDelegate >

@property (nonatomic, strong) MuseumModel *model;
@property (nonatomic, strong) ShowDetailViewModel *viewModel;

@end

@implementation ShowDetailViewController

#pragma mark- life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    
    [self layoutSubviews];
    [self dateBinding];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.hidesBarsOnSwipe = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.hidesBarsOnSwipe = YES;
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
}



- (void)layoutSubviews
{
   
}

- (void)dateBinding
{
    @weakify(self);

    self.viewModel.detailID = self.detailID;
    
    [self.viewModel.requestCommand execute:nil];
    
    [[RACObserve(self.viewModel, model) filter:^BOOL(MuseumModel *value) {
        
        return value != nil;
    }]subscribeNext:^(MuseumModel *value) {
       
        @strongify(self);
        self.model = value;
        [self.headerImageView sd_setImageWithURL:self.model.coverUrl[@"url"]];
    }];
    
    RAC(self.titleLabel,text) = RACObserve(self.viewModel, model.nameBase);
    
    RAC(self.nameLabel, text) = RACObserve(self.viewModel, model.subName);
    
    RAC(self.tagFirstLabel, text) = [RACObserve(self.viewModel, model.tag) map:^id(NSArray *tags) {
        
        return [tags firstObject];
    }];
    
    RAC(self.tagSecLabel, text) = [RACObserve(self.viewModel, model.tag) map:^id(NSArray *tags) {
        
        return [tags lastObject];
    }];
    
    RAC(self.viewsCountLabel, text) = RACObserve(self.viewModel, model.views);
    
    RAC(self.commentCountLabel, text) = RACObserve(self.viewModel, model.commentCount);
    
    RAC(self.favoriteCountLabel, text) = RACObserve(self.viewModel, model.favoriteCount);
    
    RAC(self.timeLabel, text) = [[RACSignal combineLatest:@[RACObserve(self.viewModel, model.beginTime),
                                                                                         RACObserve(self.viewModel, model.endTime),
                                                                                        RACObserve(self.viewModel, model.timeAddInfo)]]
                                 map:^id(RACTuple *x) {
                                     
        NSRange range = NSMakeRange(0, 10);
        RACTupleUnpack(NSDictionary *begin, NSDictionary *end, NSString *timeAdd) = x;
        return [NSString stringWithFormat:@"%@至%@\n%@", [begin[@"iso"] substringWithRange:range], [end[@"iso"] substringWithRange:range], timeAdd];
    }];
    
    RAC(self.addressLabel, text) = [RACObserve(self.viewModel, model.gallery) map:^id(NSDictionary *value) {
       
        return value[@"nameBase"];
    }];
    
    RAC(self.detailAddressLabel, text) = [RACObserve(self.viewModel, model.gallery) map:^id(NSDictionary *value) {
        
        return value[@"address"][@"detailsAddress"];
    }];
    
    RAC(self.entrancePriceLabel, text) = [[RACSignal combineLatest:@[RACObserve(self.viewModel, model.entrancePrice),                              RACObserve(self.viewModel, model.priceAddInfo)]]
                                          
                                          map:^id(RACTuple *x) {
        
        RACTupleUnpack(NSString *entrancePrice, NSString *priceAdd) = x;
        return [entrancePrice isEqualToString:@"0"] ?  [NSString stringWithFormat:@"免费\n%@",priceAdd] : [NSString stringWithFormat:@"%@\n%@", entrancePrice, priceAdd];
    }];
    
    RAC(self.informationLabel, text) = [[RACObserve(self.viewModel, model.information) filter:^BOOL(NSString *value){
   
        return @(value.length > 0);
    }]map:^id(NSString *value) {
       
//        @strongify(self)
        
//            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:value];
//            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//            
//            [paragraphStyle setLineSpacing:6];//调整行间距
//            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [value length])];
//            
//            return attributedString;
        


            return value;
    }];
    
    [RACObserve(self, saveButton) subscribeNext:^(UIButton *sender) {
       
        [sender setImage:[UIImage imageNamed:@"saved"] forState:UIControlStateSelected];
    }];
    
    [[self.saveButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        
        @strongify(self);
        self.saveButton.selected = !self.saveButton.selected;
    }];
        
}
#pragma mark- 

#pragma mark- delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIColor * color = [UIColor colorWithRed:0.533  green:0.678  blue:0.678 alpha:1];
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY > APPEARHEIGHE) {
        
        CGFloat alpha = MIN(1, 1 - ((APPEARHEIGHE + NAIHEIGHT - offsetY) / NAIHEIGHT));
        for (UIView *view in self.navigationController.navigationBar.subviews) {
            if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
                view.backgroundColor = [color colorWithAlphaComponent:alpha];
            }
        }
    } else {
        for (UIView *view in self.navigationController.navigationBar.subviews) {
            if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
                view.backgroundColor = [color colorWithAlphaComponent:0];
            }
        }
    }
}

#pragma mark- setter & getter

- (MuseumModel *)model
{
    if (!_model) {
        _model = ({
            MuseumModel *model = [[MuseumModel alloc]init];
            model;
        });
    }
    return _model;
}

- (ShowDetailViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = ({
            ShowDetailViewModel *viewModel = [[ShowDetailViewModel alloc]init];
            viewModel;
        });
    }
    return _viewModel;
}

#pragma mark-

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
