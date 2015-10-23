/********************************************************************
 文件名称 : UIFont+Category.h 文件
 作 者   :
 创建时间 : 2012-00-00
 文件描述 : UIFont扩展类
 *********************************************************************/

#import "UIFont+Category.h"

@implementation UIFont (Category)


+ (UIFont *)fontOfHeitiScOfSize:(float)size
{
    UIFont *font = [UIFont fontWithName:@"STHeitiSC-Light" size:size];
    return font;
}


+ (UIFont *)fontOfMediumOfSize:(float)size
{
    UIFont *font = [UIFont fontWithName:@"STHeitiSC-Medium" size:size];
    return font;
}


+ (UIFont *)fontOfArialOfSize:(float)size
{
    UIFont *font = [UIFont fontWithName:@"Arial" size:size];
    return font;
}

+ (UIFont *)fontOfImpactOfSize:(CGFloat )size {

    UIFont *font = [UIFont fontWithName:@"Impact" size:size];
    return font;
}

@end
