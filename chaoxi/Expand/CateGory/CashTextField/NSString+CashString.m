/********************************************************************
 文件名称 : NSString+CashString.m 文件
 作   者 : youjunjie
 创建时间 : 2014/10/24
 文件描述 : 现金NSString扩展类
 *********************************************************************/

#import "NSString+CashString.h"

@implementation NSString (CashString)

#pragma mark 判断是否为整形
+ (BOOL)isPureInt:(NSString*)string
{
    if (string)
    {
        NSScanner* scan = [NSScanner scannerWithString:string];
        int val;
        return[scan scanInt:&val] && [scan isAtEnd];
    }
    return NO;
}

#pragma mark 判断是否为double：
+ (BOOL)isPureDouble:(NSString*)string
{
    if (string)
    {
        NSScanner* scan = [NSScanner scannerWithString:string];
        double val;
        return[scan scanDouble:&val] && [scan isAtEnd];
    }
    return NO;
}

#pragma mark 现金字符转化为数字 eg： 123,456,33.00  to 12345633.00
+ (double)cashStringToDouble:(NSString *)cash
{
    if (cash && cash.length > 0)
    {
        NSString *numStr = [cash stringByReplacingOccurrencesOfString:@"," withString:@""];
        double cashTemp = numStr.doubleValue;
        return cashTemp;
    }
    return 0;
}

#pragma mark 数字转化为现金   eg: 123456333.00 to 123,456,333.00  0 to 0.00
+ (NSString *)doubleToCashString:(double)cash
{
    NSString *result = @"";
    if (cash >= 0)
    {
        NSMutableString *cashMutableString = [[NSMutableString alloc]initWithFormat:@"%.0f",cash];
        if (cashMutableString && cash >= 1000)
        {
            //实现方式 double转变为小数两位，再转化为string，把string长度求余，然后按照余数开始每隔3位打一个逗号
            NSUInteger len = cashMutableString.length;
            NSUInteger offset = len % 3;
            offset = (offset == 0 ? 3:offset);//如果为0，需要跳到3（不需要在开头打逗号吧）
            while (offset < (len - 3))
            {
                [cashMutableString insertString:@"," atIndex:offset];
//                NSLog(@"%@",cashMutableString);
                offset +=3;
                offset ++;//加了逗号偏移
                len ++;//加了逗号偏移
            }
        }
        result = [[NSString alloc]initWithString:cashMutableString];
        cashMutableString = nil;
    }
    return result;
}

#pragma mark 把现金string转化为金额String，只对整数加入逗号
+ (NSString *)stringToCashString:(NSString *)cash
{
    NSString *result = @"";
    if (cash && cash.length > 0)
    {
        //拆分小数和整数
        NSString *integerCash = @"";
        NSString *decimalsCash = nil;
        
        NSArray *subArray = [cash componentsSeparatedByString:@"."];
        int len = (int)subArray.count;
        integerCash = [subArray objectAtIndex:0];
        if (len == 2) {
            decimalsCash = [subArray objectAtIndex:1];
        }
        
        NSMutableString *cashMutableString = [[NSMutableString alloc]initWithFormat:@"%@",integerCash];
        if (cashMutableString && cashMutableString.length > 3)
        {
            //实现方式 double转变为小数两位，再转化为string，把string长度求余，然后按照余数开始每隔3位打一个逗号
            NSUInteger len = cashMutableString.length;
            NSUInteger offset = len % 3;
            offset = (offset == 0 ? 3:offset);//如果为0，需要跳到3（不需要在开头打逗号吧）
            while (offset <= (len - 3))
            {
                [cashMutableString insertString:@"," atIndex:offset];
//                NSLog(@"%@",cashMutableString);
                offset +=3;
                offset ++;//加了逗号偏移
                len ++;//加了逗号偏移
            }
        }
        
        if (nil != decimalsCash)
        {
            [cashMutableString appendString:@"."];
            [cashMutableString appendString:decimalsCash];
        }
        result = [[NSString alloc]initWithString:cashMutableString];
        cashMutableString = nil;
    }
    return result;
}

#pragma mark 把现金string转化为金额String，对整数加入逗号,并且保留两位小数
+ (NSString *)stringToCash:(NSString *)cash
{
    double cashDouble = [NSString cashStringToDouble:cash];
    NSString *cashString = [NSString doubleToCashString:cashDouble];
    return cashString;
}

#pragma mark 把0到9的数字转化为大写数字  eg: 0to零 "1" to @"一"
+ (NSString *)convertDigitalToCapital:(int)number
{
    NSString *result = @"";
    if (number <= 9 && number >= 0)
    {
        NSArray *array = @[@"零",@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九"];
        result = [array objectAtIndex:number];
    }
    return result;
}

#pragma mark 把0到9的数字转化为中文大写数字  eg: 0to零 "1" to @"壹"
+ (NSString *)convertDigitalToChineseCapital:(int)number
{
    NSString *result = @"";
    if (number <= 9 && number >= 0)
    {
        NSArray *array = @[@"零", @"壹", @"贰", @"叁", @"肆", @"伍", @"陆", @"柒", @"捌", @"玖"];
        result = [array objectAtIndex:number];
    }
    return result;
}

#pragma mark 将数字转化为金额
+ (NSString *)moneyStringWithDigitStr:(NSString *)digitString
{
    //数字字符
    NSArray *digitalCapitalArray = @[@"零", @"壹", @"贰", @"叁", @"肆", @"伍", @"陆", @"柒", @"捌", @"玖"];
    //金钱金额
    NSArray *chineseCashArray = @[@"元", @"拾", @"佰", @"仟", @"万", @"拾", @"佰", @"仟", @"亿", @"拾", @"佰", @"仟", @"万"];
    
    NSString *integerCash = nil;
    NSString *decimalsCash = nil;
    NSArray *cashArray = [digitString componentsSeparatedByString:@"."];
    if (cashArray) {
        NSUInteger cashCount = cashArray.count;
        if (cashCount >= 1 )
        {
            integerCash = [cashArray objectAtIndex:0];
        }
        if (cashCount ==2)
        {
            decimalsCash = [cashArray objectAtIndex:1];
        }
    }
    
    NSMutableString *processString = [[NSMutableString alloc] initWithString:integerCash];
    NSMutableString *resultString = [NSMutableString string];
    
    int i = 0;
    NSUInteger j = processString.length;
    
    // str:165047523
    // 1亿 6仟 5佰 0拾 4万 7仟 5佰 2拾 3分 ——> 壹亿 陆仟 伍佰 零拾 肆万 柒仟 伍佰 贰拾 叁分
    //处理数字
    while (processString.length!= 0)
    {
        //添加元
        [resultString insertString:[chineseCashArray objectAtIndex:i] atIndex:0];
        i++;
        
        // Obtain a character (a number), then the number corresponding uppercase characters restructuring to the ‘resultString’
        j--;
        NSString *specifiedNumberStrAtIndex = [processString substringWithRange:NSMakeRange(j, 1)];
        int specifiedNumber = [specifiedNumberStrAtIndex intValue];
        
        int number = specifiedNumber % 10;
        
        [resultString insertString:[digitalCapitalArray objectAtIndex:number] atIndex:0];
        
        // Delete of a character, so that the next time through the loop with
        [processString deleteCharactersInRange:NSMakeRange(j, 1)];
    }
    
    NSString *moneyString = [NSString stringWithFormat:@"%@",resultString];
    
    // To use regular expressions to replace specific characters
    NSError *error=nil;
    NSArray *expressions = [NSArray arrayWithObjects:@"零[拾佰仟]", @"零+亿", @"零+万", @"零+分", @"零+",@"亿万",nil];
    NSArray *changes = [NSArray arrayWithObjects:@"零", @"亿",@"万",@"",@"零",@"亿",nil];
    
    for (int k = 0; k < 6; k++)
    {
        NSRegularExpression *reg=[[NSRegularExpression alloc] initWithPattern:[expressions objectAtIndex:k] options:NSRegularExpressionCaseInsensitive error:&error];
        
        moneyString = [reg stringByReplacingMatchesInString:moneyString options:0 range:NSMakeRange(0, moneyString.length) withTemplate:[changes objectAtIndex:k]];
    }
    if([digitString intValue]>0)
    {
        moneyString= [moneyString stringByReplacingOccurrencesOfString:@"零元" withString:@"元"];
    }
    
    //小数点后面
    if (decimalsCash && decimalsCash.length > 0 && decimalsCash.intValue > 0)
    {
        NSMutableString *decimalsCashString = [[NSMutableString alloc]init];
        
        NSString *jiao = [decimalsCash substringWithRange:NSMakeRange(0, 1)];
        int jiaonumber = [jiao intValue];
        [decimalsCashString appendString:[digitalCapitalArray objectAtIndex:jiaonumber]];
        [decimalsCashString appendString:@"角"];
        
        if (decimalsCash.length > 1)
        {
            NSString *fen = [decimalsCash substringWithRange:NSMakeRange(1, 1)];
            int fenNum = fen.intValue;
            if (fenNum > 0)
            {
                [decimalsCashString appendString:[digitalCapitalArray objectAtIndex:fenNum]];
                [decimalsCashString appendString:@"分"];
            }
        }
        
        moneyString= [moneyString stringByAppendingString:decimalsCashString];
    }
    else
    {
         moneyString= [moneyString stringByAppendingString:@"整"];
    }
    
    return moneyString;
}

//验证输入string允许输入最后一位为小数点，允许小数点后两位  eg:0. 12.89 1.0    不允许：00.9 1.213
+ (BOOL)verificationInputString:(NSString *)inputString
{
    //允许为空@""
    if (inputString && inputString.length == 0) {
        return YES;
    }
    
    NSString * regex        = @"([0]([.][0-9]{0,2})?)|([1-9][0-9]{0,9}([.][0-9]{0,2})?)";
    NSPredicate * pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch            = [pred evaluateWithObject: inputString];
    if (isMatch)
    {
        return YES;
    }
    return NO;
}

#pragma mark 清理小数点后两位之后尾部的0  eg:12.9800 to 12.98    12.9不处理  12.988不处理
+ (NSString *)clearTailZero:(NSString *)str
{
    if (str)
    {
        NSUInteger len = str.length;
        if (len > 0)
        {
            NSRange range = [str rangeOfString:@"."];
            if (range.length ==1)
            {
                if (range.location + 2 < len-1)
                {
                    //截取多余位数
                    NSString *tailStr = [str substringFromIndex: range.location+ 2+1];
                    
                    if ([NSString isPureInt:tailStr])
                    {
                        double tailStrDouble = tailStr.doubleValue;
                        if (tailStrDouble == 0)
                        {
                            //说明后面都是0，可以去掉
                            NSString *resultStr = [str substringToIndex:range.location+3];
                            return resultStr;
                        }
                    }
                }
            }
        }
    }
    
    return str;
}

#pragma mark 去除头部字符0
+ (NSString *)trimLeadZero:(NSString *)str
{
    if (str) {
        
        //找到前面有多少0
        NSInteger skipX = -1;
        NSInteger len = str.length;
        
        for (int i =0; i<len; i++)
        {
            NSString *leadStr = [str substringWithRange:NSMakeRange(i, 1)];
            if ([leadStr isEqual:@"0"]) {
                skipX = i;
                continue;
            }else{
                break;
            }
        }
        //剪切前面的0
        if (skipX == len-1) {
            return @"";
        }else if (skipX > -1) {
            NSString *result = [str substringWithRange:NSMakeRange(skipX+1, len-skipX-1)];
            return result;
        }
    }
    
    return str;
}


@end
