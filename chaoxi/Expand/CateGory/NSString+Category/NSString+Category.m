/********************************************************************
 文件名称 : NSString+Category.h 文件
 作 者   :  ChaoX
 创建时间 : 2015-4-15
 文件描述 : NSString金额转换处理类
 *********************************************************************/

#import "NSString+Category.h"

@implementation NSString (Category)


/**
 *  判断是否为整形：
 *
 *  @param string <#string description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形：
+ (BOOL)isPureFloat:(NSString*)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}


#pragma mark 现金字符转化为数字 eg： 123,456,33.00  to 12345633.00
+ (double)cashStrToNum:(NSString *)cashStr
{
    //去掉逗号
    NSString *numStr = [cashStr stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    double num = numStr.doubleValue;
    
    return num;
    
}

#pragma mark 数字转化为现金   eg: 12345633.00 to 123,456,33.00
+ (NSString *)numberToCashStr:(double)cash
{
    NSString *numStr = [NSString numberToCashStr:cash afertPoint:2];
    
    return numStr;
}

#pragma mark 数字转化为现金  可选保留几位小数   eg: 12345633.00 to 123,456,33.00
+ (NSString *)numberToCashStr:(double)cash afertPoint:(NSUInteger )length {


    NSString *numStr = nil;
    
    @autoreleasepool {
        
        NSString *formatStr = @"%0.";
        formatStr = [formatStr stringByAppendingFormat:@"%ldf", (unsigned long)length];
        formatStr = [NSString stringWithFormat:formatStr, cash];
        
        NSMutableString *numToStr = [[NSMutableString alloc]initWithFormat:@"%@",formatStr];
        
        if (numToStr)
        {
            
            NSUInteger len = numToStr.length;
            NSInteger cursor = len;
            
            //先找小数点，如果没有小数点就从最后开始找了，，，，往前找，，3位加一个逗号
            NSRange range = [numToStr rangeOfString:@"."];
            
            if (range.length == 1)
            {
                cursor = range.location;
            }
            
            while (cursor > 0)
            {
                //如果有3位长度，，那么加逗号
                if (cursor > 3)
                {
                    NSInteger locatio = cursor - 3;
                    
                    [numToStr insertString:@"," atIndex:locatio];
                }
                
                cursor = cursor - 3;
            }
            
            numStr = [[NSString alloc]initWithString:numToStr];
        }
    }
    
    
    return numStr;

}

/**
 *  把1到5的数字转化为大写数字
 *
 *  @param number 1到5的阿拉伯数字
 *
 *  @return 函数名 eg:一到五的大写数字
 */
+ (NSString *)convertLowerToCapital:(int )number
{
    NSString* capitalNumber = nil;
    switch (number) {
        case 1:
            capitalNumber = @"一";
            break;
        case 2:
            capitalNumber = @"二";
            break;
        case 3:
            capitalNumber = @"三";
            break;
        case 4:
            capitalNumber = @"四";
            break;
        case 5:
            capitalNumber = @"五";
            break;
        default:
            break;
    }
    return capitalNumber;
}


#pragma mark 将数字转化为金额
+ (NSString *)feneStringWithDigitStr:(NSString *)digitString
{
    //数字字符
    NSArray *digitalCapitalArray = @[@"零", @"壹", @"贰", @"叁", @"肆", @"伍", @"陆", @"柒", @"捌", @"玖"];
    //金钱金额
    NSArray *chineseCashArray = @[@"", @"拾", @"佰", @"仟", @"万", @"拾", @"佰", @"仟", @"亿", @"拾", @"佰", @"仟", @"万"];
    
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
        moneyString= [moneyString stringByReplacingOccurrencesOfString:@"零" withString:@""];
    }
    
    //小数点后面
    if (decimalsCash && decimalsCash.length > 0 && decimalsCash.intValue > 0)
    {
        
        NSMutableString *decimalsCashString = [[NSMutableString alloc]init];
        
        [decimalsCashString appendString:@"点"];
        
        NSString *jiao = [decimalsCash substringWithRange:NSMakeRange(0, 1)];
        int jiaonumber = [jiao intValue];
        [decimalsCashString appendString:[digitalCapitalArray objectAtIndex:jiaonumber]];
//            [decimalsCashString appendString:@"角"];
        
        if (decimalsCash.length > 1)
        {
            NSString *fen = [decimalsCash substringWithRange:NSMakeRange(1, 1)];
            int fenNum = fen.intValue;
            if (fenNum > 0)
            {
                [decimalsCashString appendString:[digitalCapitalArray objectAtIndex:fenNum]];
//                    [decimalsCashString appendString:@"分"];
            }
        }
        
        moneyString= [moneyString stringByAppendingString:decimalsCashString];
    }
        moneyString= [moneyString stringByAppendingString:@"份"];
    return moneyString;
}



#pragma mark 判断字串是否为空
+ (BOOL)emptyOrNull:(NSString *)str
{
    return str == nil || (NSNull *)str == [NSNull null] || str.length == 0 || [str isEqualToString:@"(null)"];
}

#pragma mark 元转化为万元
+ (NSString *)translateNum:(NSString *)num
{
    NSString *resultNum;
    num = [num stringByReplacingOccurrencesOfString:@"," withString:@""];
    double numInt = [num doubleValue];
    double resultInt = numInt/10000;
    resultNum = [NSString stringWithFormat:@"%.2f",resultInt];
    return resultNum;
}

+ (NSString *)PreOfMonthWithString:(NSString *)month
{
    NSArray *monthArr = @[@"JAN",@"FEB",@"MAR",@"APR",@"MAY",@"JUN",@"JUL",@"AUG",@"SEP",@"OCT",@"NOV",@"DEC"];
    
    NSInteger monthIndex = [month integerValue];
    
    NSString *monthStr = monthArr[monthIndex-1];
    
    return monthStr;
}

@end
