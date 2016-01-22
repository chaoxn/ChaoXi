//
//  VideoDetailController.h
//  chaoxi
//
//  Created by fizz on 15/10/30.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoDetailController : UIViewController<UINavigationControllerDelegate>

@property (nonatomic, strong) NSString *radioid;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property(nonatomic,assign) CGRect finalCellRect;

@property(nonatomic, assign) id <UINavigationControllerDelegate> delegate;

@end
