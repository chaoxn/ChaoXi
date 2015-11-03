/********************************************************************
 文件名称 : UIView+Category.m 文件
 作   者 : ChaoX
 创建时间 : 15/2/12
 文件描述 : UIView扩展类
 *********************************************************************/


#import "UIView+Utils.h"

@implementation UIView (Utils)

@dynamic width,height,size;

//获取origin
- (CGPoint)origin
{
    return self.frame.origin;
}

//获取origin.x
- (CGFloat)originX
{
    return self.frame.origin.x;
}

//获取origin.y
- (CGFloat)originY
{
    return self.frame.origin.y;
}

//设置origin
- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    
    frame.origin = origin;
    
    self.frame = frame;
}
//设置origin.x
- (void)setOriginX:(CGFloat)originX
{
    CGRect frame = self.frame;
    
    frame.origin.x = originX;
    
    self.frame = frame;
}

//设置origin.y
- (void)setOriginY:(CGFloat)originY
{
    CGRect frame = self.frame;
    
    frame.origin.y = originY;
    
    self.frame = frame;
}

//获取size
- (CGSize)size
{
    return self.frame.size;
}

//获取size.width
- (CGFloat)sizeWidth
{
    return self.frame.size.width;
}

//获取size.height
- (CGFloat)sizeHeight
{
    return self.frame.size.height;
}


//设置size
- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    
    frame.size = size;
    
    self.frame = frame;
}


//设置size.height
- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    
    frame.size.height = height;
    
    self.frame = frame;
}


//设置size.width
- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    
    frame.size.width = width;
    
    self.frame = frame;
}

//AutoLayout 
- (void)updateConstraint:(NSLayoutAttribute )attribute constantValue:(CGFloat )value {
    
    if (self.superview.translatesAutoresizingMaskIntoConstraints) {
      
    for (NSLayoutConstraint *constraint in self.superview.constraints) {
        
        if (constraint.firstAttribute == attribute) {
            
            constraint.constant = value;
        }
    }
        
        [self layoutIfNeeded];
    }
    
}

//屏幕截图
- (UIImage *)screenshot
{
    UIGraphicsBeginImageContext(CGSizeMake(640, 1136));
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [self.layer renderInContext:ctx];
    
    UIImage *anImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return anImage;
}
@end
