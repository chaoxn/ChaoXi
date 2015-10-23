/********************************************************************
 文件名称 : NSString+Category.h 文件
 作 者   :  Neo
 创建时间 : 2015-4-15
 文件描述 : NSString金额转换处理类
 *********************************************************************/

#import <Foundation/Foundation.h>

@interface NSString (Category)

/**
 *  判断字符串是否全是数字
 *
 *  @param string <#string description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)isPureInt:(NSString*)string;

//判断是否为浮点形：
+ (BOOL)isPureFloat:(NSString*)string;

#pragma mark 现金字符转化为数字 eg： 123,456,33.00  to 12345633.00
+ (double)cashStrToNum:(NSString *)cashStr;

#pragma mark 数字转化为现金   eg: 12345633.00 to 123,456,33.00
+ (NSString *)numberToCashStr:(double)cash;

#pragma mark 数字转化为现金  可选保留几位小数   eg: 12345633.349 to 123,456,33.124
+ (NSString *)numberToCashStr:(double)cash afertPoint:(NSUInteger )length ;

#pragma mark 将数字转化为金额
+ (NSString *)feneStringWithDigitStr:(NSString *)digitString;

#pragma mark 元转化为万元
+ (NSString *)translateNum:(NSString *)num;

#pragma mark 判断字串是否为空
+ (BOOL)emptyOrNull:(NSString *)str;

+ (NSString *)PreOfMonthWithString:(NSString *)month;

@end
