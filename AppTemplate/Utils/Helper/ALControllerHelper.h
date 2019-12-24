//
//  ALControllerHelper.h
//  ALaCocoaOta
//
//  Created by 旮旯 on 2019/3/25.
//  Copyright © 2019年 旮旯. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ALControllerHelper : NSObject

/// 获取当前正在显示控制器
+ (UIViewController *)currentViewController;

/// 获取MHNavigationControllerStack管理的栈顶导航栏控制器
+ (UINavigationController *)topNavigationController;

/// 获取MHNavigationControllerStack管理的栈顶导航栏控制器的 顶部控制器，理论上这个应该是 MHViewController的子类，但是他不一定是当前正在显示的视图控制器
+ (ALViewController *)topViewController;

+ (ALViewController *)lastViewController ;//当前控制器的上一个控制器

@end

NS_ASSUME_NONNULL_END
