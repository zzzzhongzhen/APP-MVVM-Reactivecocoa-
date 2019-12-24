//
//  AdVertiseManager.m
//  DouWan
//
//  Created by 旮旯 on 2018/1/25.
//  Copyright © 2018年 旮旯. All rights reserved.
//

#import "AdVertiseManager.h"
#import "ALAdView.h"
#import "ALWebViewModel.h"
#import "ALAdModel.h"

@implementation AdVertiseManager

+ (instancetype)shareInstance{
    static AdVertiseManager *_staticObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _staticObject = [[AdVertiseManager alloc]init];
    });
    return _staticObject;
}
/**
 *  设置启动页广告
 */
- (void)setupAdvert {
    // 1.判断沙盒中是否存在广告图片，如果存在，直接显示
    NSString *filePath = [self getFilePathWithImageName:[ALFileManager userdefalutforkey:MHAdFilePath]];
    BOOL isExist = [self isFileExistWithFilePath:filePath];
    if (isExist) { // 图片存在
        NSDictionary *data = [ALFileManager userdefalutforkey:MHAdContens];
        if (data && [data isKindOfClass:NSDictionary.class]) {
            NSString *start_time = data[@"start_time"];
            NSString *end_time = data[@"end_time"];
            
            if ([self isFileInDateRange:start_time endDate:end_time]) {//图片在开始和结束时间段内
                ALAdView *advertView = [[ALAdView alloc] initWithFrame:MHSharedAppDelegate.window.bounds];
                advertView.filePath = filePath;
                advertView.pushToAdBlock = ^{
                    NSString *ad_id = data[@"ad_id"];
                    NSString *url = data[@"url"];
                    NSString *title = data[@"title"];
                    
                    if (MHStringIsNotEmpty(url)) {
                        if ([url containsString:@"http"] || [url containsString:@"https"]) {
                            ad_id = MHStringIsEmpty(ad_id)?@"":ad_id;
                            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
                            ALWebViewModel *web = [[ALWebViewModel alloc] initWithServices:MHSharedAppDelegate.services params:@{MHViewModelIDKey:ad_id, MHViewModelRequestKey:request,MHViewModelOtherKey:MHStringIsEmpty(title)?@"":title}];
                            web.model = @"3";
                            web.shouldShowShareButton = MHStringIsNotEmpty(ad_id);
                            [MHSharedAppDelegate.services pushViewModel:web animated:YES];
                        }else{
//                            ALHotelListViewModel *hotelListViewModel = [[ALHotelListViewModel alloc] initWithServices:MHSharedAppDelegate.services params:@{}];
//                            [MHSharedAppDelegate.services pushViewModel:hotelListViewModel animated:YES];
                        }
                    }
                };
                [advertView show];
            }else{
                if ([self isOutOfEndDate:end_time]) {
                    [self deleteOldImage];//图片过期
                }
            }
        }
    }
    // 2.无论沙盒中是否存在广告图片，都需要重新调用广告接口，判断广告是否更新
    [self getAdvertisingImage];
}
/**
 *  判断文件是否存在
 */
- (BOOL)isFileExistWithFilePath:(NSString *)filePath {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = FALSE;
    return [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
}
/**
 *  判断文件是否过期
 */
-(BOOL)isFileOutOfDate:(NSString *)filePath {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:filePath error:&error];
    NSDate *fileCreateDate = [fileAttributes objectForKey:NSFileCreationDate];
    BOOL isAday = [NSDate date].timeIntervalSince1970 - fileCreateDate.timeIntervalSince1970 > 60 * 60 * 24;
    return isAday;
}
/**
 *  判断当前时间是否大于后台返回的结束时间
 */
-(BOOL)isOutOfEndDate:(NSString *)endDateStr {
    [MH_DATEFORMATTER setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSUInteger endDateInterval = [MH_DATEFORMATTER dateFromString:endDateStr].timeIntervalSince1970;
    NSUInteger nowDateInteval = [NSDate date].timeIntervalSince1970;
    
    return nowDateInteval>endDateInterval;
}
/**
 *  判断文件是否在某一时间段内
 */
- (BOOL)isFileInDateRange:(NSString *)startDateStr endDate:(NSString *)endDateStr {
    [MH_DATEFORMATTER setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSUInteger startDateInterval = [MH_DATEFORMATTER dateFromString:startDateStr].timeIntervalSince1970;
    NSUInteger endDateInterval = [MH_DATEFORMATTER dateFromString:endDateStr].timeIntervalSince1970;
    NSUInteger nowDateInteval = [NSDate date].timeIntervalSince1970;
    if (nowDateInteval > startDateInterval && nowDateInteval < endDateInterval) {
        return YES;
    }
    return NO;
}
/**
 *  初始化广告页面
 */
- (void)getAdvertisingImage {
    //20190615150238yur8p2.jpg
//    [[MHSharedAppDelegate.services.client requestAdContent:@"1"] subscribeNext:^(NSArray *x) {
//        if (!x.count) {
//            [self deleteOldImage];
//        }else{
//            ALAdModel *model = x.firstObject;
//            NSString *imageUrl = model.ad_image;
//            // 获取图片名:43-130P5122Z60-50.jpg
//            NSArray *stringArr = [imageUrl componentsSeparatedByString:@"/"];
//            NSString *imageName = stringArr.lastObject;
//            // 拼接沙盒路径
//            NSString *filePath = [self getFilePathWithImageName:imageName];
//            BOOL isExist = [self isFileExistWithFilePath:filePath];
//            if (!isExist){ // 如果该图片不存在，则删除老图片，下载新图片
//                [self downloadAdImageWithUrl:imageUrl imageName:imageName model:model];
//            }
//        }
//    } error:^(NSError *error) {
//    }];
}
/**
 *  下载新图片
 */
- (void)downloadAdImageWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName model:(ALAdModel *)model{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage *image = [UIImage imageWithData:data];
        NSString *filePath = [self getFilePathWithImageName:imageName]; // 保存文件的名称

        dispatch_async(dispatch_get_main_queue(), ^{
            if ([UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {// 保存成功
                NSLog(@"保存成功");
                [self deleteOldImage];
                [ALFileManager setUserdefalutObject:imageName forkey:MHAdFilePath];
                // 如果有广告链接，将广告链接也保存下来
                NSDictionary *dic = @{@"ad_id":model.ad_id,@"url":model.click_url,@"title":model.title,@"start_time":model.start_time,@"end_time":model.end_time};
                [ALFileManager setUserdefalutObject:dic forkey:MHAdContens];
                
            }else{
                NSLog(@"保存失败");
            }
        });
    });
}
/**
 *  删除旧图片
 */
- (void)deleteOldImage {
    
    NSString *imageName = [ALFileManager userdefalutforkey:MHAdFilePath];
    if (!MHStringIsEmpty(imageName)) {
        NSString *filePath = [self getFilePathWithImageName:imageName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:filePath error:nil];
        [ALFileManager setUserdefalutObject:nil forkey:MHAdContens];
        [ALFileManager setUserdefalutObject:nil forkey:MHAdFilePath];
    }
}

/**
 *  根据图片名拼接文件路径
 */
- (NSString *)getFilePathWithImageName:(NSString *)imageName {
    
    if (imageName) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
        return filePath;
    }
    return nil;
}

@end
