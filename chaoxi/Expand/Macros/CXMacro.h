//
//  CXMacro.h
//  chaoxi
//
//  Created by fizz on 15/10/29.
//  Copyright © 2015年 chaox. All rights reserved.
//

#ifndef CXMacro_h
#define CXMacro_h

#define Prefix CX
/** 字体*/
#define CXFont(x) [UIFont systemFontOfSize:x]
#define CXBoldFont(x) [UIFont boldSystemFontOfSize:x]

/** 颜色*/
#define CXRGBColor(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define CXRGBAColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define CXRGB16Color(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

/** 输出 */
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"\n%s [Line %d] \n" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

/** 获取硬件信息*/
#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)

#define zoomRate ([[UIScreen mainScreen] bounds].size.width / 375.0f)

#define WidthRate ([[UIScreen mainScreen] bounds].size.width / 375.0f)
#define HeightRate ([[UIScreen mainScreen] bounds].size.height / 667.0f)

#define CXCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])
#define CXCurrentSystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]


/** 适配*/
#define CXiOS_5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define CXiOS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define CXiOS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define CXiOS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define CXiOS_9_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)

#define CXiPhone4_OR_4s    (SXSCREEN_H == 480)
#define CXiPhone5_OR_5c_OR_5s   (SXSCREEN_H == 568)
#define CXiPhone6_OR_6s   (SXSCREEN_H == 667)
#define CXiPhone6Plus_OR_6sPlus   (SXSCREEN_H == 736)
#define CXiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

/** 弱指针*/
#define CXWeakSelf(weakSelf) __weak __typeof(&*self)weakSelf = self;

/** 加载本地文件*/
#define CXLoadImage(file,type) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:type]]
#define CXLoadArray(file,type) [UIImage arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:type]]
#define CXLoadDict(file,type) [UIImage dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:type]]

/** 多线程GCD*/
#define CXGlobalGCD(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define CXMainGCD(block) dispatch_async(dispatch_get_main_queue(),block)

/** 数据存储*/
#define CXUserDefaults [NSUserDefaults standardUserDefaults]
#define CXCacheDir [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
#define CXDocumentDir [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
#define CXTempDir NSTemporaryDirectory()

#define CX @"春风十里不如你"
#define ISFIRSTRADIO @"已经是第一首了"
#define ISLASTRADIO @"已经是最后一首了"

#endif 
