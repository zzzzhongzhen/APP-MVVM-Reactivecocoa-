//
//  ALTabBarController.h
//  ALaCocoaOta
//
//  Created by 旮旯 on 2018/8/27.
//  Copyright © 2018年 旮旯. All rights reserved.
//  自定义`TabBarController` ,这里将`UITabBarController`作为自己的子控制器，其目的就是为了保证的继承的连续性，否则像平常我们自定义`UITabBarController`都是继承`UITabBarController`.


#import "ALViewController.h"


@interface ALTabBarController : ALViewController<UITabBarControllerDelegate>

@property (nonatomic, readonly, strong) UITabBarController *tabBarController;

@end
