//
//  CXLineView.h
//  chaoxi
//
//  Created by fizz on 15/12/24.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LineType) {
    
    LineType_Top = 1,
    LineType_Bottom,
    LineType_Left,
    LineType_Right
};

@interface CXLineView : UIView

@end
