/********************************************************************
 文件名称 : CashTextField.h 文件
 作   者 : ChaoX
 创建时间 : 2014/10/24
 文件描述 : 现金输入框类
 *********************************************************************/

#import <UIKit/UIKit.h>

//system

//view

//modle

//other

typedef double CashValue;




@interface CashTextField : UITextField
{
    
}
@property (nonatomic,strong)NSString *inputString;//输入的字符串
@property (nonatomic,strong)NSString *displayString;//显示的字符串


/**
 *  @author ChaoX, 15-06-10 14:06:13
 *
 *  获取金额double数值(小数后两位)
 *
 *  @return 返回Double数值
 */
- (double)cashOfDouble;

/**
 *  @author ChaoX, 15-06-10 14:06:47
 *
 *  获取金额NSString数值(没有逗号隔开)
 *
 *  @return 获取金额NSString数值(没有逗号隔开)
 */
- (NSString *)cashOfNSString;

/**
 *  @author ChaoX, 15-06-10 14:06:55
 *
 *  获取金额NSString数值(逗号隔开)
 *
 *  @return 获取金额NSString数值(逗号隔开)
 */
- (NSString *)cashOfAccountantNSString;

/**
 *  @author ChaoX, 15-06-10 14:06:02
 *
 *  获取中文大写金额
 *
 *  @return 获取中文大写金额
 */
- (NSString *)cashOfChineseCapital;

@end

