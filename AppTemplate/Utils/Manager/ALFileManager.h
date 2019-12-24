//
//  ALFileManager.h
//  ALaCocoaOta
//
//  Created by 旮旯 on 2019/4/1.
//  Copyright © 2019年 旮旯. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^cleanCacheBlock)();

NS_ASSUME_NONNULL_BEGIN

@interface ALFileManager : NSObject

#pragma mark - File manager methods
/**
 *  文件管理器
 */
+ (NSFileManager *)fileManager;
/**
 *  该路径是否存在
 */
+ (BOOL)isPathExist:(NSString *)path;
/**
 *  该文件是否存在
 */
+ (BOOL)isFileExist:(NSString *)path;
/**
 *  该文件夹是否存在
 */
+ (BOOL)isDirectoryExist:(NSString *)path;
/**
 *  移除该文件
 */
+ (BOOL)removeFile:(NSString *)path;
/**
 *  创建目录
 */
+ (BOOL)createDirectoryAtPath:(NSString *)path;
/**
 *  文件个数
 */
+ (NSUInteger)fileCountInPath:(NSString *)path;
/**
 *  目录大小
 */
+ (unsigned long long)folderSizeAtPath:(NSString *)path;

+(float)folderCacheSizeAtPath ;

///清理缓存
+(void)cleanCache:(cleanCacheBlock)block ;

#pragma mark User default
+ (void)setUserdefalutObject:(nullable id)obj forkey:(NSString *)key;

+ (id)userdefalutforkey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
