//
//  ALConst.h
//  ALaCocoaOta
//
//  Created by 旮旯 on 2018/8/27.
//  Copyright © 2018年 旮旯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ALMacros.h"

typedef void(^VoidBlock)(void);

typedef void (^VoidBlock_id)(id);

//各种通知
FOUNDATION_EXTERN NSString * const MHLoginStatusChangeNoti;

FOUNDATION_EXTERN NSString * const MHEnterForeGroundNoti;

FOUNDATION_EXTERN NSString * const MHHasNotiComeNoti;

/// 全局分割线高度 .5
FOUNDATION_EXTERN CGFloat const MHGlobalBottomLineHeight;
///用户信息存储文件名称
FOUNDATION_EXTERN NSString * const MHUserDataFileName;
///每页显示的最大数据个数
FOUNDATION_EXTERN NSString * MHLimitPageCount;
///服务器APP版本
FOUNDATION_EXTERN NSString * const MHRemoterVersionCode;

FOUNDATION_EXTERN NSString * const MHGuideViewHasRemove;

FOUNDATION_EXTERN NSString *MHFirstInstallApp;

FOUNDATION_EXTERN NSString * const MHAdFilePath;

FOUNDATION_EXTERN NSString * const MHAdContens;

FOUNDATION_EXTERN NSString * const MHChangeTabbarIndex;

static inline void POST_NOTIFICATION(NSString *notiName) {
    [MHNotificationCenter postNotificationName:notiName object:nil];
}
static inline void POST_NOTIFICATIONWithObject(NSString *notiName,id obj) {
    [MHNotificationCenter postNotificationName:notiName object:obj];
}
/// 配图的占位图片
static inline UIImage *MHPicturePlaceholder()
{
    return [UIImage imageNamed:@"morentu"];
}

/// 辅助方法 创建一个文件夹
static inline void MHCreateDirectoryAtPath(NSString *path){
    BOOL isDir = NO;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
    if (isExist) {
        if (!isDir) {
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
            [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        }
    } else {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
}
/// 重要数据备份的文件夹路径，通过NSFileManager来访问
static inline NSString *MHWeChatDocDirPath(){
    return [MHDocumentDirectory stringByAppendingPathComponent:MH_ALA_DOC_NAME];
}
/// 通过NSFileManager来获取指定重要数据的路径
static inline NSString *MHFilePathFromWeChatDoc(NSString *filename){
    NSString *docPath = MHWeChatDocDirPath();
    MHCreateDirectoryAtPath(docPath);
    return [docPath stringByAppendingPathComponent:filename];
}
//
static inline NSString *MHStringReturnNoEmptyStr(NSString *string){
    if (MHStringIsEmpty(string)) {
        return @"";
    }
    return string;
}

