//
//  ALAlertHelper.h
//  ALaCocoaOta
//
//  Created by 旮旯 on 2019/3/25.
//  Copyright © 2019年 旮旯. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ALAlertHelper : NSObject
/**
 弹出alertController，并且只有一个action按钮，切记只是警示作用，无事件处理
 
 @param title title
 @param message message
 @param confirmTitle confirmTitle 按钮的title
 */
+ (void)mh_showAlertViewWithTitle:(NSString *_Nullable)title message:(NSString *)message confirmTitle:(NSString *)confirmTitle;


/**
 弹出alertController，并且只有一个action按钮，有处理事件
 
 @param title title
 @param message message
 @param confirmTitle confirmTitle 按钮title
 @param confirmAction 按钮的点击事件处理
 */
+ (void)mh_showAlertViewWithTitle:(NSString *_Nullable)title message:(NSString *)message confirmTitle:(NSString *)confirmTitle confirmAction:(void(^)())confirmAction;


/**
 弹出alertController，并且有两个个action按钮，分别有处理事件
 
 @param title title
 @param message Message
 @param confirmTitle 右边按钮的title
 @param cancelTitle 左边按钮的title
 @param confirmAction 右边按钮的点击事件
 @param cancelAction 左边按钮的点击事件
 */
+ (void)mh_showAlertViewWithTitle:(NSString *)title message:(NSString *)message confirmTitle:(NSString *)confirmTitle cancelTitle:(NSString *)cancelTitle confirmAction:(void(^)())confirmAction cancelAction:(void(^)())cancelAction;

+ (void)mh_showAlertViewWithTitle:(NSString *)title message:(NSString *)message confirmTitle:(NSString *)confirmTitle cancelTitle:(NSString *)cancelTitle confirmAction:(void(^)())confirmAction cancelAction:(void(^)())cancelAction showViewController:(UIViewController *_Nullable)viewController ;

/**
 弹出alertController，并且有多个action按钮，分别有处理事件
 
 @param title title
 @param message Message
 @param actionArray 处理事件的title
 @param cancelTitle 取消按钮的title
 @param tapAction 所有按钮的点击事件
 */

+ (void)mh_showCustomAlertWith:(UIAlertControllerStyle)style title:(NSString *_Nullable)title message:(NSString *_Nullable)message actionTitles:(NSArray *)actionArray cancelTitle:(NSString *)cancelTitle clickIndex:(void(^)())tapAction;


+ (void)mh_showCustomAlertWith:(UIAlertControllerStyle)style title:(NSString *)title message:(NSString *)message actionTitles:(NSArray *)actionArray cancelTitle:(NSString *)cancelTitle messageLeftAligMent:(BOOL)messageLeftAligMent clickIndex:(void(^)())tapAction ;

+ (void)openPhotoLibraryAuthority ;

+ (void)openCameraAuthority ;

+ (void)openLocationAuthority ;

@end

NS_ASSUME_NONNULL_END
