//
//  ALCommonHelper.h
//  ALaCocoaOta
//
//  Created by 旮旯 on 2019/3/25.
//  Copyright © 2019年 旮旯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/utsname.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface ALCommonHelper : NSObject

//判断手机型号
+ (NSString *)iphoneType ;
//打电话
+ (void)phoneCall:(NSString *)phone ;

+ (void)map:(NSString *)endLatitude endLontitude:(NSString *)endLontitude baidulat:(NSString *)baidulat baidulog:(NSString *)baidulog name:(NSString *)name ;

+(void)copyToBoard:(NSString *)content;

///是否有访问相册权限
+(BOOL)photoAuthize ;

+(BOOL)cameraAuthize ;

+ (NSString *)createUUID ;

+ (NSString *)getWeekDay:(NSDate *)inputDate ;

+ (NSInteger )compareDayWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate ;

+ (NSArray *)getDayArrayLeftDate:(NSDate *)aLeftDate rightDate:(NSDate *)aRightDate ;

+ (NSInteger )compareMonthWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate ;

+ (BOOL)isFirstInstallApp;

+ (void)getNetworkPermissions:(void (^)(BOOL))completion ;
@end

NS_ASSUME_NONNULL_END
