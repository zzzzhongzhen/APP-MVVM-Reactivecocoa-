
//
//  ALCommonHelper.m
//  ALaCocoaOta
//
//  Created by 旮旯 on 2019/3/25.
//  Copyright © 2019年 旮旯. All rights reserved.
//

#import "ALCommonHelper.h"
#import <CoreTelephony/CTCellularData.h>

@implementation ALCommonHelper
+ (NSString *)iphoneType {
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    //型号标识符
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,3"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPhone9,4"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
    
    if ([platform isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
    
    if ([platform isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
    
    if ([platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
    
    if ([platform isEqualToString:@"iPhone10,3"]) return @"iPhone X";
    
    if ([platform isEqualToString:@"iPhone10,6"]) return @"iPhone X";
    
    if ([platform isEqualToString:@"iPad1,1"]) return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"]) return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"]) return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"]) return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,4"]) return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"]) return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,6"]) return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,7"]) return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"]) return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"]) return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"]) return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"]) return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"]) return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"]) return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"]) return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,2"]) return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"]) return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"]) return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,5"]) return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,6"]) return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,7"]) return@"iPad Mini 3";
    
    if ([platform isEqualToString:@"iPad4,8"]) return@"iPad Mini 3";
    
    if ([platform isEqualToString:@"iPad4,9"]) return@"iPad Mini 3";
    
    if ([platform isEqualToString:@"iPad5,1"]) return@"iPad Mini 4";
    
    if ([platform isEqualToString:@"iPad5,2"]) return@"iPad Mini 4";
    
    if ([platform isEqualToString:@"iPad5,3"]) return @"iPad Air 2";
    
    if ([platform isEqualToString:@"iPad5,4"]) return @"iPad Air 2";
    
    if ([platform isEqualToString:@"iPad6,3"]) return @"iPad Pro 9.7";
    
    if ([platform isEqualToString:@"iPad6,4"]) return @"iPad Pro 9.7";
    
    if ([platform isEqualToString:@"iPad6,7"]) return @"iPad Pro 12.9";
    
    if ([platform isEqualToString:@"iPad6,8"]) return @"iPad Pro 12.9";
    
    if ([platform isEqualToString:@"iPad6,11"]) return @"iPad 5";
    
    if ([platform isEqualToString:@"iPad6,12"]) return @"iPad 5";
    
    if ([platform isEqualToString:@"iPad7,1"]) return @"iPad Pro 12.9 2nd";
    
    if ([platform isEqualToString:@"iPad7,2"]) return @"iPad Pro 12.9 2nd";
    
    if ([platform isEqualToString:@"iPad7,3"]) return @"iPad Pro 10.5";
    
    if ([platform isEqualToString:@"iPad7,4"]) return @"iPad Pro 10.5";
    
    if ([platform isEqualToString:@"iPad7,5"]) return @"iPad 6";
    
    if ([platform isEqualToString:@"iPad7,6"]) return @"iPad 6";
    
    if ([platform isEqualToString:@"i386"])  return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"])  return @"iPhone Simulator";
        
    return platform;
    
}
+ (void)phoneCall:(NSString *)phone {
    NSMutableString * string = [[NSMutableString alloc] initWithFormat:@"tel:%@",phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
    
}
+ (void)map:(NSString *)endLatitude endLontitude:(NSString *)endLontitude baidulat:(NSString *)baidulat baidulog:(NSString *)baidulog name:(NSString *)name{
    NSMutableArray *mapArray  =[NSMutableArray arrayWithObject:@"使用苹果地图导航"];
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"baidumap://map/"]]){
        [mapArray addObject:@"使用百度地图导航"];
    }
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"iosamap://"]]){
        [mapArray addObject:@"使用高德地图导航"];
    }
    if (mapArray.count<=0) {
        [ALAlertHelper mh_showAlertViewWithTitle:@"提示" message:@"您未安装地图APP，请先安装地图APP" confirmTitle:@"确认"];
    }else{
        [ALAlertHelper mh_showCustomAlertWith:UIAlertControllerStyleActionSheet title:nil message:nil actionTitles:mapArray cancelTitle:@"取消" clickIndex:^(NSInteger index){
            if ([mapArray[index] isEqualToString:@"使用百度地图导航"]) {
                //百度地图
                NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%@,%@|name:%@&mode=driving",baidulat,baidulog,name] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
                
            }else if ([mapArray[index] isEqualToString:@"使用高德地图导航"]){
                //高德地图
                NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=阿拉丁OTA&poiname=%@&lat=%@&lon=%@&dev=0&style=2",name,endLatitude,endLontitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
            }else if ([mapArray[index] isEqualToString:@"使用苹果地图导航"]){
                // 苹果地图
                CLLocationCoordinate2D coodinate = CLLocationCoordinate2DMake(endLatitude.floatValue, endLontitude.floatValue);
                MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
                MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coodinate addressDictionary:nil]];
                toLocation.name = name;
                [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                               launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                                               MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
            }
        }];

    }

}
+(void)copyToBoard:(NSString *)content {
    if (MHStringIsEmpty(content)) {
        [MBProgressHUD mh_showTips:@"复制的内容为空!"];
        return;
    }
    [MBProgressHUD mh_showTips:@"已复制到剪切板"];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = content;
}
+(BOOL)photoAuthize {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        //无权限
        return NO;
    }else{
        return YES;
    }
}
+(BOOL)cameraAuthize {
    //======判断 访问相机 权限是否开启=======
    AVAuthorizationStatus authStatus =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    //===无权限====
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
        return NO;
    }else{
        return YES;
    }
}
+ (NSString *)createUUID {
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuid_string_ref];
    uuid = [uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
    CFRelease(uuid_ref);
    CFRelease(uuid_string_ref);
    
    return [uuid lowercaseString];
}
+ (NSString *)getWeekDay:(NSDate *)inputDate {
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    NSCalendar *ncalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [ncalendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [ncalendar components:calendarUnit fromDate:inputDate];
    return [weekdays objectAtIndex:theComponents.weekday];
}
+ (NSInteger )compareDayWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    
    NSString *hour = [startDate stringWithFormat:@"HH"];
    NSString *str = [startDate stringWithFormat:@"yyyy-MM-dd"];
    [MH_DATEFORMATTER setDateFormat:@"yyyy-MM-dd"];
    startDate = [MH_DATEFORMATTER dateFromString:str];
    
    NSString *str1 = [endDate stringWithFormat:@"yyyy-MM-dd"];
    [MH_DATEFORMATTER setDateFormat:@"yyyy-MM-dd"];
    endDate = [MH_DATEFORMATTER dateFromString:str1];

    //利用NSCalendar比较日期的差异
    NSCalendar *calendar = [NSCalendar currentCalendar];
    /** * 要比较的时间单位,常用如下,可以同时传：
     * NSCalendarUnitDay : 天
     * NSCalendarUnitYear : 年
     * NSCalendarUnitMonth : 月
     * NSCalendarUnitHour : 时
     * NSCalendarUnitMinute : 分
     * NSCalendarUnitSecond : 秒 */
    NSCalendarUnit unit = NSCalendarUnitDay;
    //只比较天数差异
    //比较的结果是NSDateComponents类对象
    NSDateComponents *delta = [calendar components:unit fromDate:startDate toDate:endDate options:0];
    return [hour integerValue]<6?(delta.day+1):delta.day;
}
+ (NSInteger )compareMonthWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    NSString *str = [startDate stringWithFormat:@"yyyy-MM"];
    [MH_DATEFORMATTER setDateFormat:@"yyyy-MM"];
    startDate = [MH_DATEFORMATTER dateFromString:str];
    
    NSString *str1 = [endDate stringWithFormat:@"yyyy-MM"];
    [MH_DATEFORMATTER setDateFormat:@"yyyy-MM"];
    endDate = [MH_DATEFORMATTER dateFromString:str1];

    //利用NSCalendar比较日期的差异
    NSCalendar *calendar = [NSCalendar currentCalendar];
    /** * 要比较的时间单位,常用如下,可以同时传：
     * NSCalendarUnitDay : 天
     * NSCalendarUnitYear : 年
     * NSCalendarUnitMonth : 月
     * NSCalendarUnitHour : 时
     * NSCalendarUnitMinute : 分
     * NSCalendarUnitSecond : 秒 */
    NSCalendarUnit unit = NSCalendarUnitMonth;
    //只比较月差异
    //比较的结果是NSDateComponents类对象
    NSDateComponents *delta = [calendar components:unit fromDate:startDate toDate:endDate options:0];
    return delta.month;
}

//获取两个日期之间的所有日期，精确到天
+ (NSArray *)getDayArrayLeftDate:(NSDate *)aLeftDate rightDate:(NSDate *)aRightDate{
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    NSDate *minumDate = aLeftDate;
    NSDate *maxDate = aRightDate;
    NSCalendar *greCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *minCompontents =  [greCalendar components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:minumDate];
            
    while ([minumDate compare:maxDate] == NSOrderedAscending) {
        
        NSDate *beginningOfWeek = [greCalendar dateFromComponents:minCompontents];
        NSDateFormatter *dateday = [[NSDateFormatter alloc]init];
        [dateday setDateFormat:@"yyyy-MM-dd"];
        NSString *currentDateStr = [dateday stringFromDate:beginningOfWeek];
        [resultArray addObject:currentDateStr];

        [minCompontents setDay:(minCompontents.day+1)];
        minumDate = [greCalendar dateFromComponents:minCompontents];
    }
    return resultArray.copy;
}
+ (BOOL)isFirstInstallApp {
    if (![ALFileManager userdefalutforkey:MHFirstInstallApp]) {
        [ALFileManager setUserdefalutObject:MHFirstInstallApp forkey:MHFirstInstallApp];
        return YES;
    }
    return NO;
}
+ (void)getNetworkPermissions:(void (^)(BOOL))completion {
    
    CTCellularData *cellularData = [[CTCellularData alloc] init];
    CTCellularDataRestrictedState authState = cellularData.restrictedState;
    if (authState == kCTCellularDataRestrictedStateUnknown) {
        cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state){
            if (state == kCTCellularDataNotRestricted) {
                //权限开启
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(YES);
                    }
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(NO);
                    }
                });
            }
        };
    } else if (authState == kCTCellularDataNotRestricted){
        //权限被关闭
        if (completion) {
            completion(YES);
        }
    } else {
        //权限未知
        if (completion) {
            completion(NO);
        }
    }
}
@end
