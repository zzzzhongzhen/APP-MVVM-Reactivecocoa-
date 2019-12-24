//
//  ALNavigationControllerStack.m
//  ALaCocoaOta
//
//  Created by 旮旯 on 2018/8/27.
//  Copyright © 2018年 旮旯. All rights reserved.
//

#import "ALNavigationControllerStack.h"
#import "ALViewController.h"
#import "ALRouter.h"
#import "ALNavigationController.h"
#import "ALTabBarController.h"

@interface ALNavigationControllerStack ()

@property (nonatomic, strong) id<ALViewModelServices> services;
@property (nonatomic, strong) NSMutableArray *navigationControllers;

@end

@implementation ALNavigationControllerStack

- (instancetype)initWithServices:(id<ALViewModelServices>)services {
    self = [super init];
    if (self) {
        self.services = services;
        self.navigationControllers = [[NSMutableArray alloc] init];
        [self registerNavigationHooks];
    }
    return self;

}
- (void)pushNavigationController:(UINavigationController *)navigationController {
    
    if ([self.navigationControllers containsObject:navigationController]) return;
    [self.navigationControllers addObject:navigationController];
}

- (UINavigationController *)popNavigationController {
    UINavigationController *navigationController = self.navigationControllers.lastObject;
    [self.navigationControllers removeLastObject];
    
    return navigationController;
}
- (UINavigationController *)topNavigationController {
    return self.navigationControllers.lastObject;
}
- (void)registerNavigationHooks {
    @weakify(self);
    
    [[(NSObject *)self.services
      rac_signalForSelector:@selector(pushViewModel:animated:)]
     subscribeNext:^(RACTuple *tuple) {
         @strongify(self)
         ALViewController *topViewController = (ALViewController *)[self.navigationControllers.lastObject topViewController];
         if (topViewController.tabBarController) {
             topViewController.snapshot = [topViewController.tabBarController.view snapshotViewAfterScreenUpdates:NO];
         } else {
             topViewController.snapshot = [[self.navigationControllers.lastObject view] snapshotViewAfterScreenUpdates:NO];
         }
         UIViewController *viewController = (UIViewController *)[ALRouter.sharedInstance viewControllerForViewModel:tuple.first];
         [self.topNavigationController pushViewController:viewController animated:[tuple.second boolValue]];
     }];
    
    [[(NSObject *)self.services
      rac_signalForSelector:@selector(popViewModelAnimated:)]
     subscribeNext:^(RACTuple *tuple) {
         @strongify(self)
         [self.navigationControllers.lastObject popViewControllerAnimated:[tuple.first boolValue]];
     }];
    
    [[(NSObject *)self.services
      rac_signalForSelector:@selector(popToRootViewModelAnimated:)]
     subscribeNext:^(RACTuple *tuple) {
         @strongify(self)
         [self.navigationControllers.lastObject popToRootViewControllerAnimated:[tuple.first boolValue]];
     }];
    
    [[(NSObject *)self.services
      rac_signalForSelector:@selector(presentViewModel:animated:completion:)]
     subscribeNext:^(RACTuple *tuple) {
         @strongify(self)
         UIViewController *viewController = (UIViewController *)[ALRouter.sharedInstance viewControllerForViewModel:tuple.first];
         
         UINavigationController *presentingViewController = self.navigationControllers.lastObject;
         if (![viewController isKindOfClass:UINavigationController.class]) {
             viewController = [[ALNavigationController alloc] initWithRootViewController:viewController];
         }
         [self pushNavigationController:(UINavigationController *)viewController];
        ///适配iOS13: iOS 13 的 presentViewController 默认有视差效果，模态出来的界面现在默认都下滑返回
         viewController.modalPresentationStyle = UIModalPresentationFullScreen;
         [presentingViewController presentViewController:viewController animated:[tuple.second boolValue] completion:tuple.third];
     }];
    
    [[(NSObject *)self.services
      rac_signalForSelector:@selector(dismissViewModelAnimated:completion:)]
     subscribeNext:^(RACTuple *tuple) {
         @strongify(self)
         [self popNavigationController];
         [self.navigationControllers.lastObject dismissViewControllerAnimated:[tuple.first boolValue] completion:tuple.second];
     }];
    
    [[(NSObject *)self.services
      rac_signalForSelector:@selector(resetRootViewModel:)]
     subscribeNext:^(RACTuple *tuple) {
         @strongify(self)
         [self.navigationControllers removeAllObjects];
         /// VM映射VC
         UIViewController *viewController = (UIViewController *)[ALRouter.sharedInstance viewControllerForViewModel:tuple.first];
         if (![viewController isKindOfClass:[UINavigationController class]] &&
             ![viewController isKindOfClass:[ALTabBarController class]]) {
             viewController = [[ALNavigationController alloc] initWithRootViewController:viewController];
             [self pushNavigationController:(UINavigationController *)viewController];
         }
        
        CATransition *transtion = [CATransition animation];
        transtion.duration = 0.3;
        transtion.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        MHSharedAppDelegate.window.rootViewController = viewController;
        [MHSharedAppDelegate.window.layer addAnimation:transtion forKey:@"animation"];
     }];
}

@end
