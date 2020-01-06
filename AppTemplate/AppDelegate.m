//
//  AppDelegate.m
//  ALHomestayPro
//
//  Created by 旮旯 on 2019/9/20.
//  Copyright © 2019 旮旯. All rights reserved.
//

#import "AppDelegate.h"
#import "ALRootViewModel.h"
#import "ALLoginViewModel.h"
#import <UMPush/UMessage.h>
#import <UMCommon/UMCommon.h>

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

/// APP管理的导航栏的堆栈
@property (nonatomic, readwrite, strong) ALNavigationControllerStack *navigationControllerStack;
@property (nonatomic, readwrite, strong) id<RACSubscriber> sub;

@end

static NSDateFormatter *formatter = nil;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //初始化服务层
    self.services =  [[ALViewModelServicesImpl alloc] init];
    //初始化导航堆栈
    self.navigationControllerStack = [[ALNavigationControllerStack alloc] initWithServices:self.services];
    ///第一次安装提前请求弹出数据权限框
    if ([ALCommonHelper isFirstInstallApp]) {
        [self.services.client enqueueBlankRequest];
    }
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // 让窗口可见
    [self.window makeKeyAndVisible];
    [self.services resetRootViewModel:[self _createInitialViewModel]];
    
    
    return YES;
}
- (ALViewModel *)_createInitialViewModel {
    if (self.services.client.currentUser) {
        ALRootViewModel *rootViewModel = [[ALRootViewModel alloc] initWithServices:self.services params:nil];
        return rootViewModel;
    }
    ALLoginViewModel *loginViewModel = [[ALLoginViewModel alloc] initWithServices:self.services params:@{MHViewModelIDKey:@(1)}];
    return loginViewModel;
}
//iOS10以下使用这两个方法接收通知
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
    
    completionHandler(UIBackgroundFetchResultNewData);
}
//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [UMessage setAutoAlert:NO];  
        //应用处于前台时的远程推送接受
        [UMessage didReceiveRemoteNotification:userInfo];
        POST_NOTIFICATIONWithObject(MHHasNotiComeNoti, @1);
    }
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}
//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
//    NSDictionary * userInfo = response.notification.request.content.userInfo;
//    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//    }
}
#pragma mark - 获取推送DeviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    ///适配iOS13
    if (![deviceToken isKindOfClass:[NSData class]]) return;
    const unsigned *tokenBytes = (const unsigned *)[deviceToken bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    NSLog(@"deviceToken:%@",hexToken);
//    @weakify(self);
    [[RACObserve(self.services.client, networkStatus) distinctUntilChanged] subscribeNext:^(id x) {
        NSString *deviceTokenStr = DeviceToken;
//        @strongify(self);
        if (![deviceTokenStr isEqualToString:hexToken]) {
            //上传devicetoken和设备信息
//            [[self.services.client requestPutDeviceTokenWithDeviceToken:hexToken] subscribeNext:^(id x) {
//                [ALFileManager setUserdefalutObject:hexToken forkey:@"deviceToken"];
//            }];
        }
    }];
    [UMessage registerDeviceToken:deviceToken];
}

+(AppDelegate *)sharedDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}
+(NSDateFormatter *)dateFormatter {
    //性能考虑,全局使用一个
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
    });
    return formatter;
}
- (void)applicationWillResignActive:(UIApplication *)application {
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    //查询有没有消息 改变个人中心图标的红点状态
    if (self.services.client.currentUser) {
//        [[self.services.client requestGetUserInfo] subscribeNext:^(ALUser *x) {
//         }];
    }
}
- (void)applicationWillTerminate:(UIApplication *)application {

}

@end
