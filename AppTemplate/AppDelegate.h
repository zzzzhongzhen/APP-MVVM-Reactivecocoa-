//
//  AppDelegate.h
//  ALHomestayPro
//
//  Created by 旮旯 on 2019/9/20.
//  Copyright © 2019 旮旯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALNavigationControllerStack.h"
#import "ALViewModelServicesImpl.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/// APP管理的导航栏的堆栈
@property (nonatomic, readonly, strong) ALNavigationControllerStack *navigationControllerStack;

/// APP的服务层
@property (nonatomic, readwrite, strong) ALViewModelServicesImpl *services;


/// 获取AppDelegate
+ (AppDelegate *)sharedDelegate;

+ (NSDateFormatter *)dateFormatter;

@end

