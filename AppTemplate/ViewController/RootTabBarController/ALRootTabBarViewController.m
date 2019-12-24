//
//  ALRootTabBarViewController.m
//  ALaCocoaOta
//
//  Created by 旮旯 on 2018/8/27.
//  Copyright © 2018年 旮旯. All rights reserved.
//

#import "ALRootTabBarViewController.h"
#import "ALRootViewModel.h"
#import "ALNavigationController.h"
#import "ALHomeViewController.h"
#import "ALOrderViewController.h"
#import "ALProfileViewController.h"
#import <PPBadgeView/PPBadgeView.h>

@interface ALRootTabBarViewController ()<UITabBarControllerDelegate>

@property (nonatomic, strong, readwrite) ALRootViewModel *viewModel;

@end

@implementation ALRootTabBarViewController

@dynamic viewModel; //防止出readonly警告,让编译器去父类寻找setter和getter方法

#pragma mark ============ lifeCycle ============
- (void)viewDidLoad {
    [super viewDidLoad];

    [self _setupAllChildViewController];
    
    self.tabBarController.delegate = self;
}
#pragma mark ============ Private ============
- (void)_setupAllChildViewController {
    NSArray *titlesArray = @[@"首页", @"订单", @"个人中心"];
    NSArray *imageNamesArray = @[@"shouye_weixuanzhong",
                                 @"dingdan_weixuanzhong-",
                                 @"wode_weixuanzhong-"];
    NSArray *selectedImageNamesArray = @[@"shouye_xuanzhong",
                                         @"dingdan_xuanzhong-",
                                         @"wode_xuanzhong-"];
    UINavigationController *homeNavigationController = ({
        ALHomeViewController *hotelVC = [[ALHomeViewController alloc] initWithViewModel:self.viewModel.homeViewModel];
        [[ALNavigationController alloc] initWithRootViewController:hotelVC];
    });
    [self _configViewController:homeNavigationController imageName:imageNamesArray[0] selectedImageName:selectedImageNamesArray[0] title:titlesArray[0]];

    UINavigationController *orderNavigationController = ({
        ALOrderViewController *orderVC = [[ALOrderViewController alloc] initWithViewModel:self.viewModel.orderViewModel];
        [[ALNavigationController alloc] initWithRootViewController:orderVC];
        
    });
    [self _configViewController:orderNavigationController imageName:imageNamesArray[1] selectedImageName:selectedImageNamesArray[1] title:titlesArray[1]];
    
    UINavigationController *profileNavigationController = ({
        ALProfileViewController *profileVC = [[ALProfileViewController alloc] initWithViewModel:self.viewModel.profileViewModel];
        [[ALNavigationController alloc] initWithRootViewController:profileVC];
    });
    [self _configViewController:profileNavigationController imageName:imageNamesArray[2] selectedImageName:selectedImageNamesArray[2] title:titlesArray[2]];

    self.tabBarController.viewControllers = @[homeNavigationController,orderNavigationController,profileNavigationController];
    [MHSharedAppDelegate.navigationControllerStack pushNavigationController:homeNavigationController];
    
    @weakify(self);
    [[MHNotificationCenter rac_addObserverForName:MHChangeTabbarIndex object:nil] subscribeNext:^(id x) {
        @strongify(self);
        self.tabBarController.selectedIndex = 1;
        [self tabBarController:self.tabBarController didSelectViewController:orderNavigationController];
    }];
    [[MHNotificationCenter rac_addObserverForName:MHHasNotiComeNoti object:nil] subscribeNext:^(NSNotification *x) {
        @strongify(self);
        if ([x.object intValue]) {
            [ALFileManager setUserdefalutObject:@"1" forkey:MHHasNotiComeNoti];
            [self.tabBarController.tabBar.items[2] pp_addDotWithColor:MH_REDCOLOR];
            [self.tabBarController.tabBar.items[2] pp_setBadgeHeight:6];
        }else{
            [ALFileManager setUserdefalutObject:@"0" forkey:MHHasNotiComeNoti];
            [self.tabBarController.tabBar.items[2] pp_hiddenBadge];
        }
    }];
    if ([[ALFileManager userdefalutforkey:MHHasNotiComeNoti] intValue]>0) {
        [self.tabBarController.tabBar.items[2] pp_addDotWithColor:MH_REDCOLOR];
        [self.tabBarController.tabBar.items[2] pp_setBadgeHeight:6];
    }else{
        [self.tabBarController.tabBar.items[2] pp_hiddenBadge];
    }
}
#pragma mark - 配置ViewController
- (void)_configViewController:(UIViewController *)viewController imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName title:(NSString *)title {
    
    UIImage *image = [UIImage imageNamed:imageName];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.image = image;
    
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.selectedImage = selectedImage;
//    viewController.tabBarItem.title = title;
    
    NSDictionary *normalAttr = @{NSForegroundColorAttributeName:MHColorFromHexString(@"#929292"),
                                 NSFontAttributeName:MHRegularFont_12};
    NSDictionary *selectedAttr = @{NSForegroundColorAttributeName:MH_MAIN_COLOR,
                                   NSFontAttributeName:MHRegularFont_12};
    [viewController.tabBarItem setTitleTextAttributes:normalAttr forState:UIControlStateNormal];
    [viewController.tabBarItem setTitleTextAttributes:selectedAttr forState:UIControlStateSelected];

    [viewController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, 0)];
    [viewController.tabBarItem setImageInsets:UIEdgeInsetsMake(8, 0, -8, 0)];
}
#pragma mark ============ Delegate ============
-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    [MHSharedAppDelegate.navigationControllerStack popNavigationController];//防止重复添加
    [MHSharedAppDelegate.navigationControllerStack pushNavigationController:(UINavigationController *)viewController];
    
}
@end
