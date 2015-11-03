/********************************************************************
 文件名称 : NSString+CashString.h 文件
 作   者 : ChaoX
 创建时间 : 2014/10/24
 文件描述 : 现金NSString扩展类
 *********************************************************************/

#import <Foundation/Foundation.h>

@interface NSString (CashString)

#pragma mark 判断字符串是否全是数字
+ (BOOL)isPureInt:(NSString*)string;

#pragma mark 判断是否为double：
+ (BOOL)isPureDouble:(NSString*)string;

#pragma mark 现金字符转化为数字 eg： 123,456,33.00  to 12345633.00
+ (double)cashStringToDouble:(NSString *)cash;

#pragma mark 数字转化为现金   eg: 12345633.00 to 123,456,33.00
+ (NSString *)doubleToCashString:(double)cash;

#pragma mark 把现金string转化为金额String，只对整数加入逗号
+ (NSString *)stringToCashString:(NSString *)cash;

#pragma mark 把现金string转化为金额String，对整数加入逗号,并且保留两位小数
+ (NSString *)stringToCash:(NSString *)cash;

#pragma mark 把0到9的数字转化为大写数字  eg: 0to零 "1" to @"一"
+ (NSString *)convertDigitalToCapital:(int )number;

#pragma mark 把0到9的数字转化为中文大写数字  eg: 0to零 "1" to @"壹"
+ (NSString *)convertDigitalToChineseCapital:(int)number;

#pragma mark 将数字转化为汉字金额
+ (NSString *)moneyStringWithDigitStr:(NSString *)digitString;

//验证输入string允许输入最后一位为小数点，允许小数点后两位  eg:0. 12.89 1.0    不允许：00.9 1.213
+ (BOOL)verificationInputString:(NSString *)inputString;

#pragma mark 清理小数点后两位之后尾部的0  eg:12.9800 to 12.98    12.9不处理  12.988不处理
+ (NSString *)clearTailZero:(NSString *)str;

#pragma mark 去除头部字符0
+ (NSString *)trimLeadZero:(NSString *)str;

@end
