//
//  ALControllerHelper.m
//  ALaCocoaOta
//
//  Created by 旮旯 on 2019/3/25.
//  Copyright © 2019年 旮旯. All rights reserved.
//

#import "ALControllerHelper.h"
#import "ALRootTabBarViewController.h"

@implementation ALControllerHelper

+ (UIViewController *)currentViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    
    /// Fixed : 这里必须要判断一下，否则取出来永远都是 ALHomeViewController。这是架构上小缺(特)陷(性)。因为ALRootTabBarViewController的子控制器是UITabBarController，所以需要递归UITabBarController的所有的子控制器
    if ([resultVC isKindOfClass:[ALRootTabBarViewController class]]) {
        ALRootTabBarViewController *mainVc = (ALRootTabBarViewController *)resultVC;
        resultVC = [self _topViewController:mainVc.tabBarController];
    }
    //假设从A控制器通过present的方式跳转到了B控制器，那么 A.presentedViewController 就是B控制器
    while (resultVC.presentedViewController
           && ![resultVC.presentedViewController isKindOfClass:UIAlertController.class]) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

+ (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
}


+ (UINavigationController *)topNavigationController{
    return MHSharedAppDelegate.navigationControllerStack.topNavigationController;
}

+ (ALViewController *)topViewController
{
    ALViewController *topViewController = (ALViewController *)[self topNavigationController].topViewController;
    
    /// 确保解析出来的类 也是 ALViewController
    NSAssert([topViewController isKindOfClass:ALViewController.class], @"topViewController is not an MHViewController's subclass: %@", topViewController);
    
    return topViewController;
}
+ (ALViewController *)lastViewController {
    NSArray *vcArray = [self topNavigationController].viewControllers;
    
    return vcArray[vcArray.count-2];
}
@end
