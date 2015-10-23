/********************************************************************
 文件名称 : UITextField+Style.m 文件
 作   者 : WuQiaoqiao
 创建时间 : 15/5/28
 文件描述 : 类
 *********************************************************************/

#import "UIView+BorderStyle.h"

#define kTextFieldBgBorderWidth 0.5f
#define kTextFieldBgBorderColor [UIColor lightGrayColor]

@implementation UIView (BorderStyle)

- (void)setCustomBorderStyle:(UIViewCustomBorderStyle )style {

    if (style == UIViewCustomTextFieldBorderStyle) {
        
        self.layer.borderWidth = kTextFieldBgBorderWidth;
        self.layer.borderColor = [kTextFieldBgBorderColor CGColor];
    }
}

@end
