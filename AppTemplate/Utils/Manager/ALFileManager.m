//
//  ALFileManager.m
//  ALaCocoaOta
//
//  Created by 旮旯 on 2019/4/1.
//  Copyright © 2019年 旮旯. All rights reserved.
//

#import "ALFileManager.h"

@implementation ALFileManager

/**
 *  文件管理器
 */
+ (NSFileManager *)fileManager
{
    return [NSFileManager defaultManager];
}
/**
 *  该路径是否存在
 */
+ (BOOL)isPathExist:(NSString *)path
{
    return [[self fileManager] fileExistsAtPath:path];
}
/**
 *  该文件是否存在
 */
+ (BOOL)isFileExist:(NSString *)path
{
    BOOL isDirectory;
    return [[self fileManager] fileExistsAtPath:path isDirectory:&isDirectory] && !isDirectory;
}
/**
 *  该文件夹是否存在
 */
+ (BOOL)isDirectoryExist:(NSString *)path
{
    BOOL isDirectory;
    return [[self fileManager] fileExistsAtPath:path isDirectory:&isDirectory] && isDirectory;
}

/**
 *  移除该文件
 */
+ (BOOL)removeFile:(NSString *)path
{
    return [[self fileManager] removeItemAtPath:path error:nil];
}

/** 创建目录 */
+ (BOOL)createDirectoryAtPath:(NSString *)path
{
    return [[self fileManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
}

/**
 *  文件个数
 */
+ (NSUInteger)fileCountInPath:(NSString *)path
{
    NSUInteger count = 0;
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:path];
    for (__unused NSString *fileName in fileEnumerator) {
        count += 1;
    }
    return count;
}

/**
 *  计算某个目录大小
 */
+ (unsigned long long)folderSizeAtPath:(NSString *)path
{
    __block unsigned long long totalFileSize = 0;
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:path];
    for (NSString *fileName in fileEnumerator) {
        NSString *filePath = [path stringByAppendingPathComponent:fileName];
        NSDictionary *fileAttrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        totalFileSize += fileAttrs.fileSize;
    }
    return totalFileSize;
}
/** * 计算缓存大小 */
+(float)folderCacheSizeAtPath {
    NSString *folderPath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSFileManager * manager=[NSFileManager defaultManager];
    if (![manager fileExistsAtPath :folderPath]){
        return 0 ;
    }
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator ];
    NSString * fileName;
    long long folderSize = 0 ;
    
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
        
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        folderSize += [self fileSizeAtPath :fileAbsolutePath];
    }
    return folderSize/( 1024.0 * 1024.0 );
}
/** * 计算单个文件大小 */
+(long long)fileSizeAtPath:(NSString *)filePath{
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath :filePath]){
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize];
    }
    return 0 ;
}
/** * 清理缓存 */
+(void)cleanCache:(cleanCacheBlock)block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //文件路径
        NSString *directoryPath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSArray *subpaths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:nil];
        for (NSString *subPath in subpaths) {
            NSString *filePath = [directoryPath stringByAppendingPathComponent:subPath]; [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        }
        //返回主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            block();
        });
    });
}

#pragma mark User default
+ (void)setUserdefalutObject:(nullable id)obj forkey:(NSString *)key {

    NSAssert(!MHStringIsEmpty(key), @"Parsed key is nil: %@", key);
    if (MHObjectIsNil(obj)) {
        obj = @"";
    }
    [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)userdefalutforkey:(NSString *)key {

    NSAssert(!MHStringIsEmpty(key), @"Parsed key is nil: %@", key);
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

@end
