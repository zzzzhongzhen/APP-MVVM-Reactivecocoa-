//
//  NSURLSessionTask+BindDeallocSignal.m
//  ALHomestayPro
//
//  Created by 旮旯 on 2019/12/9.
//  Copyright © 2019 旮旯. All rights reserved.
//

#import "NSURLSessionTask+BindDeallocSignal.h"

@interface NSURLSessionTask ()

//@property (nonatomic, weak)ALViewController *bindVC;

@end

//static void *MHExtensionBindDeallocSignal = &MHExtensionBindDeallocSignal;

@implementation NSURLSessionTask (BindDeallocSignal)

//- (ALViewController *)bindVC {
//    return objc_getAssociatedObject(self, MHExtensionBindDeallocSignal);
//}
//-(void)setBindVC:(ALViewController *)bindVC {
//    __weak typeof(self)weakself = self;
//    objc_setAssociatedObject(weakself, MHExtensionBindDeallocSignal, bindVC, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
- (void)bindViewControllerDealloc {
//    ALViewController *bindVC = (ALViewController *)[ALControllerHelper currentViewController];
//    //监听页面销毁  页面销毁 当前页面所有请求都取消
//    //当有弹框的时候
//    if ([bindVC isKindOfClass:ALViewController.class]) {
//        @weakify(self);
//        [bindVC.viewModel.willDeallocSignal subscribeNext:^(id x) {
//            @strongify(self);
//            [self cancel];
//        }];
//    }
}

@end
