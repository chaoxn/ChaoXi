//
//  CXSliderViewCell.h
//  CXSilderViewDemo
//
//  Created by fizz on 15/11/16.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CELL_HEIGHT 100
#define CELL_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define CELL_CURRHEIGHT 240 
#define TITLE_HEIGHT 40
#define IMAGEVIEW_ORIGIN_Y -30
#define IMAGEVIEW_MOVE_DISTANCE 160

#define NAVIGATOR_LABEL_HEIGHT 25
#define NAVIGATOR_LABELCONTAINER_HEIGHT 125
#define SC_IMAGEVIEW_HEIGHT 360

#define DRAG_INTERVAL 170.0f
#define HEADER_HEIGHT 0.0f
#define RECT_RANGE 1000.0f

@interface CXSliderViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *title;

@property (nonatomic, strong) UILabel *desLabel;

@property (nonatomic, strong) UIImageView *cxImageView;

@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, strong) NSDictionary *dic;

@property (nonatomic, assign) int index;

@end
