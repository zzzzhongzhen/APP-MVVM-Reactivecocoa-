//
//  ALTabBarController.m
//  ALaCocoaOta
//
//  Created by 旮旯 on 2018/8/27.
//  Copyright © 2018年 旮旯. All rights reserved.
//

#import "ALTabBarController.h"
#import "ALTabBar.h"

@interface ALTabBarController ()
/// tabBarController
@property (nonatomic, strong, readwrite) UITabBarController *tabBarController;

@end

@implementation ALTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarController = [[UITabBarController alloc] init];
    /// 添加子控制器
    [self.view addSubview:self.tabBarController.view];
    [self addChildViewController:self.tabBarController];
    [self.tabBarController didMoveToParentViewController:self];
    // kvc替换系统的tabBar
    ALTabBar *tabbar = [[ALTabBar alloc] init];
    //kvc实质是修改了系统的_tabBar
    [self.tabBarController setValue:tabbar forKeyPath:@"tabBar"];
}

#pragma mark - Ovveride
- (BOOL)shouldAutorotate {//视图是否可以选择
    return self.tabBarController.selectedViewController.shouldAutorotate;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.tabBarController.selectedViewController.supportedInterfaceOrientations;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.tabBarController.selectedViewController.preferredStatusBarStyle;
}

- (BOOL)prefersStatusBarHidden{
    return self.tabBarController.selectedViewController.prefersStatusBarHidden;
}
@end
