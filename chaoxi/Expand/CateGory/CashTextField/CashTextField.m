/********************************************************************
 文件名称 : CashTextField.m 文件
 作   者 : WuQiaoqiao
 创建时间 : 2014/10/24
 文件描述 : 类
 *********************************************************************/

#import "CashTextField.h"

//system

//view

//modle

//other
#import  <objc/runtime.h>
#import "NSString+CashString.h"

@interface MessageInterceptor : NSObject {
    
}
@property (nonatomic, readonly, copy) NSArray * interceptedProtocols;
@property (nonatomic, weak) id receiver;
@property (nonatomic, weak) id middleMan;

- (instancetype)initWithInterceptedProtocol:(Protocol *)interceptedProtocol;
- (instancetype)initWithInterceptedProtocols:(Protocol *)firstInterceptedProtocol, ... NS_REQUIRES_NIL_TERMINATION;
- (instancetype)initWithArrayOfInterceptedProtocols:(NSArray *)arrayOfInterceptedProtocols;

@end

static inline BOOL selector_belongsToProtocol(SEL selector, Protocol * protocol);
@implementation MessageInterceptor

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    if ([self.middleMan respondsToSelector:aSelector] &&
        [self isSelectorContainedInInterceptedProtocols:aSelector])
        return self.middleMan;
    
    if ([self.receiver respondsToSelector:aSelector])
        return self.receiver;
    
    id result = [super forwardingTargetForSelector:aSelector];
    return result;
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ([self.middleMan respondsToSelector:aSelector] &&
        [self isSelectorContainedInInterceptedProtocols:aSelector])
        return YES;
    
    if ([self.receiver respondsToSelector:aSelector])
        return YES;
    BOOL result = [super respondsToSelector:aSelector];
    return result;
}

- (instancetype)initWithInterceptedProtocol:(Protocol *)interceptedProtocol
{
    self = [super init];
    if (self) {
        _interceptedProtocols = @[interceptedProtocol];
    }
    return self;
}

- (instancetype)initWithInterceptedProtocols:(Protocol *)firstInterceptedProtocol, ...;
{
    self = [super init];
    if (self) {
        NSMutableArray * mutableProtocols = [NSMutableArray array];
        Protocol * eachInterceptedProtocol;
        va_list argumentList;
        if (firstInterceptedProtocol)
        {
            [mutableProtocols addObject:firstInterceptedProtocol];
            va_start(argumentList, firstInterceptedProtocol);
            while ((eachInterceptedProtocol = va_arg(argumentList, id))) {
                [mutableProtocols addObject:eachInterceptedProtocol];
            }
            va_end(argumentList);
        }
        _interceptedProtocols = [mutableProtocols copy];
    }
    return self;
}

- (instancetype)initWithArrayOfInterceptedProtocols:(NSArray *)arrayOfInterceptedProtocols
{
    self = [super init];
    if (self) {
        _interceptedProtocols = [arrayOfInterceptedProtocols copy];
    }
    return self;
}

- (void)dealloc
{
    _interceptedProtocols = nil;
}

- (BOOL)isSelectorContainedInInterceptedProtocols:(SEL)aSelector
{
    __block BOOL isSelectorContainedInInterceptedProtocols = NO;
    [self.interceptedProtocols enumerateObjectsUsingBlock:^(Protocol * protocol, NSUInteger idx, BOOL *stop) {
        isSelectorContainedInInterceptedProtocols = selector_belongsToProtocol(aSelector, protocol);
        * stop = isSelectorContainedInInterceptedProtocols;
    }];
    return isSelectorContainedInInterceptedProtocols;
}
@end

BOOL selector_belongsToProtocol(SEL selector, Protocol * protocol)
{
    // Reference: https://gist.github.com/numist/3838169
    for (int optionbits = 0; optionbits < (1 << 2); optionbits++) {
        BOOL required = optionbits & 1;
        BOOL instance = !(optionbits & (1 << 1));
        struct objc_method_description hasMethod = protocol_getMethodDescription(protocol, selector, required, instance);
        if (hasMethod.name || hasMethod.types) {
            return YES;
        }
    }
    return NO;
}

//LLONG_MIN:  -9223372036854775808
//LLONG_MAX:  9223372036854775807
//static  double kDefaultMinCash = 0;//最小输入值
//static  double kDefaultMaxCash = 10000000000;//最大输入限制100亿

@interface CashTextField()<UITextFieldDelegate>
{
    MessageInterceptor * delegateInterceptor;
    
    BOOL isHaveDian;//是否有小数点
}
@end

@implementation CashTextField

#pragma mark ---------------------退出清空--------------------
#pragma mark 释放
- (void)dealloc
{
    self.delegate = nil;
}

#pragma mark ---------------------初始化----------------------
- (void)initTextData
{
    /* Message interceptor to intercept scrollView delegate messages */
    delegateInterceptor = [[MessageInterceptor alloc] initWithInterceptedProtocol:@protocol(UITextFieldDelegate)];
    delegateInterceptor.middleMan = self;
    delegateInterceptor.receiver = self.delegate;
    super.delegate = (id)delegateInterceptor;
    
//    self.tintColor = [UIColor clearColor];
    
    self.inputString = @"";
    self.displayString = @"";
}

#pragma mark ---------------------System---------------------
#pragma mark 初始化
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initTextData];
    }
    return self;
}

#pragma mark 从xib加载
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initTextData];
}


#pragma mark ---------------------功能函数--------------------
#pragma mark ---------------------手势事件--------------------
#pragma mark ---------------------按钮事件--------------------
#pragma mark ---------------------代理方法--------------------

- (NSRange) selectedRangeInTextView:(UITextView*)textView
{
    UITextPosition* beginning = textView.beginningOfDocument;
    
    UITextRange* selectedRange = textView.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    UITextPosition* selectionEnd = selectedRange.end;
    
    const NSInteger location = [textView offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [textView offsetFromPosition:selectionStart toPosition:selectionEnd];
    
    return NSMakeRange(location, length);
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *textFieldString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    //剪出逗号后面末尾的0
    textFieldString = [NSString clearTailZero:textFieldString];
    
    //清除逗号
    NSString *textFieldStringOfDouble = [textFieldString stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    //清除前面的0
    textFieldStringOfDouble = [NSString trimLeadZero:textFieldStringOfDouble];

    //验证输入后的数据是否符合要求
    BOOL verification = [NSString verificationInputString:textFieldStringOfDouble];
    
    //验证是否在限定范围
    if (verification)
    {
        //添加逗号
        NSString *cash = [NSString stringToCashString:textFieldStringOfDouble];
        //NSLog(@"range: %@  replaceStr: %@",NSStringFromRange(range),string);
        
//        //获取当前的光标
//        UITextRange *selectedTextRange = textField.selectedTextRange;
//        NSUInteger location = [textField offsetFromPosition:textField.beginningOfDocument toPosition:selectedTextRange.start];
//        NSUInteger length = [textField offsetFromPosition:selectedTextRange.start toPosition:selectedTextRange.end];
//        NSRange selectedRange = NSMakeRange(location, length);
//        NSLog(@"selectedRange: %@", NSStringFromRange(selectedRange));
        
        self.text = cash;
        
        //重设光标
        double stringLen = string.length;
        if (stringLen > 0)
        {
            double offsetLocation = range.location+1;
            if (cash.length > textFieldString.length)
            {
                offsetLocation ++;
            }
            
            //控制超过最大，返回初试位置
            if (offsetLocation > cash.length)
            {
                offsetLocation = cash.length;
            }
            
            UITextPosition *beginning = textField.beginningOfDocument;
            UITextPosition *start = [textField positionFromPosition:beginning offset:offsetLocation];
            UITextPosition *end = [textField positionFromPosition:start offset:range.length];
            UITextRange *textRange = [textField textRangeFromPosition:start toPosition:end];
            
            textField.selectedTextRange = textRange;
        }
        else if(stringLen == 0)
        {
            //删除
            double offsetLocation = range.location;
            if (cash.length < textFieldString.length)
            {
                offsetLocation --;
            }
            UITextPosition *beginning = textField.beginningOfDocument;
            UITextPosition *start = [textField positionFromPosition:beginning offset:offsetLocation];
            UITextPosition *end = [textField positionFromPosition:start offset:0];
            UITextRange *textRange = [textField textRangeFromPosition:start toPosition:end];
            textField.selectedTextRange = textRange;
        }
        
        
        
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)])
    {
        [self.delegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    
    return NO;
}

//-(void)textFieldDidEndEditing:(UITextField *)textField
//{
//    if (self.text.length > 0) {
//        double cashDouble = [NSString cashStringToDouble:textField.text];
//        
//        textField.text = [NSString doubleToCashString:cashDouble];
//    }
//
//    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldDidEndEditing:)])
//    {
//        [self.delegate textFieldDidEndEditing:textField];
//    }
//}

//禁用copy cut select paste
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(paste:) || action == @selector(cut:) || action == @selector(copy:) || action == @selector(select:)  || action == @selector(selectAll:)  )
        return NO;
    return [super canPerformAction:action withSender:sender];
}

#pragma mark ---------------------属性相关--------------------

- (NSString *)description
{
    NSString *desc = [[NSString alloc]initWithFormat:@"inputString = %@***showString=%@",self.inputString,self.text];
    return desc;
}

- (void)setText:(NSString *)text
{
    [super setText:text];
}

- (id)delegate
{
    return delegateInterceptor.receiver;
}
- (void)setDelegate:(id<UITextFieldDelegate>)delegate
{
    if(delegateInterceptor) {
        super.delegate = nil;
        delegateInterceptor.receiver = delegate;
        super.delegate = (id)delegateInterceptor;
    }
    else {
        super.delegate = delegate;
    }
}
#pragma mark ---------------------接口API--------------------
//获取金额double数值(小数后两位)
- (double)cashOfDouble
{
    NSString *textString = self.text;
    double result = [NSString cashStringToDouble:textString];
    return result;
}

//获取金额NSString数值(没有逗号隔开)
- (NSString *)cashOfNSString
{
    double cashDouble = [self cashOfDouble];
    NSString *cashOfStr = [[NSString alloc]initWithFormat:@"%.0f",cashDouble];
    return cashOfStr;
}

//获取金额NSString数值(逗号隔开)
- (NSString *)cashOfAccountantNSString
{
    double cashDouble = [self cashOfDouble];
    NSString *cashOfStr = [NSString doubleToCashString:cashDouble];
    return cashOfStr;
}

//获取中文大写金额
- (NSString *)cashOfChineseCapital
{
    NSString *textString = self.text;
    if (textString.length > 0) {
        NSString *cashOfStr = [self cashOfNSString];
        NSString *result = [NSString moneyStringWithDigitStr:cashOfStr];
        return result;
    }else{
        return @"";
    }
}


@end






