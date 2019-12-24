//
//  MHMacros.h
//  MHaCocoaOta
//
//  Created by 旮旯 on 2018/8/27.
//  Copyright © 2018年 旮旯. All rights reserved.
//

#ifndef MHMacros_h
#define MHMacros_h
#import <AdSupport/AdSupport.h>
/// 应用名称
#define MH_APP_NAME    ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"])
/// 应用版本号
#define MH_APP_VERSION ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])
/// 应用build
#define MH_APP_BUILD   ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"])
//Vindor标示符
#define IDFV  ([[[UIDevice currentDevice] identifierForVendor] UUIDString])
//广告标识符
#define IDFA  ([[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString])
//deviceToken
#define DeviceToken  ([ALFileManager userdefalutforkey:@"deviceToken"])

#define USER_ACCOUNT_PATH   [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"useraccount.archive"]

#define USER_ACCOUNT_PATH   [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"useraccount.archive"]


// 输出日志 (格式: [时间] [哪个方法] [哪行] [输出内容])
#ifdef DEBUG
#define NSLog(format, ...)  printf("\n[%s] %s [第%d行] 💕 %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String]);
#else

#define NSLog(format, ...)

#endif
// 打印方法
#define MHLogFunc NSLog(@"%s", __func__)
// 打印请求错误信息
#define MHLogError(error) NSLog(@"Error: %@", error)
// 销毁打印
#define MHDealloc NSLog(@"\n =========+++ %@  销毁了 +++======== \n",[self class])

#define MHLogLastError(db) NSLog(@"lastError: %@, lastErrorCode: %d, lastErrorMessage: %@", [db lastError], [db lastErrorCode], [db lastErrorMessage]);


/// 类型相关
#define MH_IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define MH_IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define MH_IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

/// 屏幕尺寸相关
#define MH_SCREEN_WIDTH  ([[UIScreen mainScreen] bounds].size.width)
#define MH_SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define MH_SCREEN_BOUNDS ([[UIScreen mainScreen] bounds])
#define MH_SCREEN_MAX_LENGTH (MAX(MH_SCREEN_WIDTH, MH_SCREEN_HEIGHT))
#define MH_SCREEN_MIN_LENGTH (MIN(MH_SCREEN_WIDTH, MH_SCREEN_HEIGHT))

/// 手机类型相关
#define MH_IS_IPHONE_4_OR_LESS  (MH_IS_IPHONE && MH_SCREEN_MAX_LENGTH  < 568.0)
#define MH_IS_IPHONE_5          (MH_IS_IPHONE && MH_SCREEN_MAX_LENGTH == 568.0)
#define MH_IS_IPHONE_6          (MH_IS_IPHONE && MH_SCREEN_MAX_LENGTH == 667.0)
#define MH_IS_IPHONE_6P         (MH_IS_IPHONE && MH_SCREEN_MAX_LENGTH == 736.0)
#define MH_IS_IPHONE_X_OR_MORE          (MH_IS_IPHONE && MH_SCREEN_MAX_LENGTH >= 812.0)

////遗留问题,之前项目带过来的,太多不好替换
//#define kWidth (MH_SCREEN_WIDTH/375.0)
//#define kHeight (MH_IS_IPHONE_X_OR_MORE ? kWidth : (MH_SCREEN_HEIGHT/667.0))
////
//#define DWDisbaleAutoAdjustScrollViewInsets(scrollView, vc)\
//do { \
//_Pragma("clang diagnostic push") \
//_Pragma("clang diagnostic ignored \"-Wdeprecated-declarations\"") \
//if (@available(iOS 11.0,*))  {\
//scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;\
//} else {\
//vc.automaticallyAdjustsScrollViewInsets = NO;\
//}\
//_Pragma("clang diagnostic pop")\
//} while (0);
  
/// 导航条高度
#define MH_APPLICATION_TOP_BAR_HEIGHT (MH_IS_IPHONE_X_OR_MORE?88.0f:64.0f)
/// tabBar高度
#define MH_APPLICATION_TAB_BAR_HEIGHT (MH_IS_IPHONE_X_OR_MORE?83.0f:49.0f)

#define MH_APPLICATION_TAB_BAR_DIFFRENCE (MH_IS_IPHONE_X_OR_MORE?34.f:.0f)
/// 状态栏高度
#define MH_APPLICATION_STATUS_BAR_HEIGHT (MH_IS_IPHONE_X_OR_MORE?44.f:20.0f)

#define MH_APPLICATION_STATUS_BAR_Diffrence (MH_IS_IPHONE_X_OR_MORE?36.f:0.f)

/// 工具条高度 (常见的高度)
#define MH_APPLICATION_TOOL_BAR_HEIGHT_44  44.0f
#define MH_APPLICATION_TOOL_BAR_HEIGHT_49  49.0f

#define LoadNibView(nibName) [[[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil] lastObject]
#define LoadNibCell(nibName) [UINib nibWithNibName:nibName bundle:[NSBundle mainBundle]]


///------
/// iOS Version
///------
#define MHIOSVersion ([[[UIDevice currentDevice] systemVersion] floatValue])

#define MH_iOS9_VERSTION_LATER ([UIDevice currentDevice].systemVersion.floatValue >= 9.0)
#define MH_iOS10_VERSTION_LATER ([UIDevice currentDevice].systemVersion.floatValue >= 10.0)
#define MH_iOS11_VERSTION_LATER ([UIDevice currentDevice].systemVersion.floatValue >= 11.0)

#define MH_SYSTEM_VERSION_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define MH_SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define MH_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define MH_SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define MH_SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


// KVO获取监听对象的属性 有自动提示
// 宏里面的#，会自动把后面的参数变成c语言的字符串
#define MHKeyPath(objc,keyPath) @(((void)objc.keyPath ,#keyPath))

#define MH_DATEFORMATTER [AppDelegate dateFormatter]
// 颜色
#define MHColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
// 颜色+透明度
#define MHColorAlpha(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
// 随机色
#define MHRandomColor MHColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
// 根据rgbValue获取对应的颜色
#define MHColorFromRGB(__rgbValue) [UIColor colorWithRed:((float)((__rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((__rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(__rgbValue & 0xFF))/255.0 alpha:1.0]

#define MHColorFromRGBAlpha(rgbValue, a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]


// AppCaches 文件夹路径
#define MHCachesDirectory [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
// App DocumentDirectory 文件夹路径
#define MHDocumentDirectory [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject]

// 系统放大倍数
#define MHScale [[UIScreen mainScreen] scale]

// 设置图片
#define MHImageNamed(__imageName) [UIImage imageNamed:__imageName]

/// 根据hex 获取颜色
#define MHColorFromHexString(__hexString__) ([UIColor colorFromHexString:__hexString__])

//  通知中心
#define MHNotificationCenter [NSNotificationCenter defaultCenter]


/// 全局细下滑线颜色 以及分割线颜色
#define MHGlobalBottomLineColor     [UIColor colorFromHexString:@"#D9D9D9"]

// 是否为空对象
#define MHObjectIsNil(__object)  ((nil == __object) || [__object isKindOfClass:[NSNull class]])

// 字符串为空
#define MHStringIsEmpty(__string) ((__string.length == 0) || MHObjectIsNil(__string))

// 字符串不为空
#define MHStringIsNotEmpty(__string)  (!MHStringIsEmpty(__string))

// 数组为空
#define MHArrayIsEmpty(__array) ((MHObjectIsNil(__array)) || (__array.count==0))

/// 适配iPhone X + iOS 11
#define  MHAdjustsScrollViewInsets_Never(__scrollView)\
do {\
_Pragma("clang diagnostic push")\
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")\
if ([__scrollView respondsToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
NSMethodSignature *signature = [UIScrollView instanceMethodSignatureForSelector:@selector(setContentInsetAdjustmentBehavior:)];\
NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];\
NSInteger argument = 2;\
invocation.target = __scrollView;\
invocation.selector = @selector(setContentInsetAdjustmentBehavior:);\
[invocation setArgument:&argument atIndex:2];\
[invocation retainArguments];\
[invocation invoke];\
}\
_Pragma("clang diagnostic pop")\
} while (0)


//// --------------------  下面是公共配置  --------------------
/// 项目重要数据备份的文件夹名称（Documents/ALadinDoc）利用NSFileManager来访问
#define MH_ALA_DOC_NAME  @"ALadinDoc"
/// 项目轻量数据数据备份的文件夹（Library/Caches/ALadinCache）利用NSFileManager来访问
#define MH_ALA_CACHE_NAME  @"ALadinCache"

/// AppDelegate
#define MHSharedAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

#define UUID @"UUIDKey"

#define VersionCode  13


////  整个应用的主题配置（颜色+字体）MAIN 代表全局都可以修改 
#define MH_MAIN_COLOR [UIColor colorFromHexString:@"#007bff"] //项目的主题颜色
/// 整个应用的视图的背景色 BackgroundColor
//#define MH_MAIN_BACKGROUNDCOLOR [UIColor colorFromHexString:@"#ededed"]

#define MH_MAIN_BACKGROUNDCOLOR [UIColor colorFromHexString:@"#f7f7f7"]

/// 整个应用的分割线颜色
#define MH_MAIN_LINE_COLOR_1 MHColorFromRGBAlpha(0xdadada, 0.7)

#define MH_MAIN_TEXTCOLOR [UIColor colorFromHexString:@"#333333"]

#define MH_REDCOLOR [UIColor redColor]

#define MH_WHITECOLOR [UIColor whiteColor]

#define MH_BLACKCOLOR [UIColor blackColor]

#define MH_CLEARCOLOR [UIColor clearColor]

/// ---- YYWebImage Option
/// 手动设置image
#define MHWebImageOptionManually (YYWebImageOptionAllowInvalidSSLCertificates|YYWebImageOptionAllowBackgroundTask|YYWebImageOptionSetImageWithFadeAnimation|YYWebImageOptionAvoidSetImage)

/// 自动设置Image
#define MHWebImageOptionAutomatic (YYWebImageOptionAllowInvalidSSLCertificates|YYWebImageOptionAllowBackgroundTask|YYWebImageOptionSetImageWithFadeAnimation)

/// 其他常量配置
#import "ALConstant.h"

#endif /* MHMacros_h */
