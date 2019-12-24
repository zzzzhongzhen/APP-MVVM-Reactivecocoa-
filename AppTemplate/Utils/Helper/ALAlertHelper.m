//
//  ALAlertHelper.m
//  ALaCocoaOta
//
//  Created by 旮旯 on 2019/3/25.
//  Copyright © 2019年 旮旯. All rights reserved.
//

#import "ALAlertHelper.h"
#import "UIAlertController+MHColor.h"
#import "ALControllerHelper.h"

@implementation ALAlertHelper


+ (void)mh_showAlertViewWithTitle:(NSString *)title message:(NSString *)message confirmTitle:(NSString *)confirmTitle {
    
    [self mh_showAlertViewWithTitle:title message:message confirmTitle:confirmTitle confirmAction:nil];
}

+ (void)mh_showAlertViewWithTitle:(NSString *)title message:(NSString *)message confirmTitle:(NSString *)confirmTitle confirmAction:(void(^)())confirmAction {
    
    [self mh_showAlertViewWithTitle:title message:message confirmTitle:confirmTitle cancelTitle:nil confirmAction:confirmAction cancelAction:NULL showViewController:nil];
}
+ (void)mh_showAlertViewWithTitle:(NSString *)title message:(NSString *)message confirmTitle:(NSString *)confirmTitle cancelTitle:(NSString *)cancelTitle confirmAction:(void(^)())confirmAction cancelAction:(void(^)())cancelAction {
    [self mh_showAlertViewWithTitle:title message:message confirmTitle:confirmTitle cancelTitle:cancelTitle confirmAction:confirmAction cancelAction:cancelAction showViewController:nil];
}
+ (void)mh_showAlertViewWithTitle:(NSString *)title message:(NSString *)message confirmTitle:(NSString *)confirmTitle cancelTitle:(NSString *)cancelTitle confirmAction:(void(^)())confirmAction cancelAction:(void(^)())cancelAction showViewController:(UIViewController *_Nullable)viewController{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    /// 配置alertController
//    alertController.titleColor = MHColorFromHexString(@"#3C3E44");
//    alertController.messageColor = MHColorFromHexString(@"#9A9A9C");
    
    /// 左边按钮
    if(cancelTitle.length>0){
        UIAlertAction *cancel= [UIAlertAction actionWithTitle:cancelTitle?cancelTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) { !cancelAction?:cancelAction(); }];
        cancel.textColor = MHColorFromHexString(@"#8E929D");
        [alertController addAction:cancel];
    }
    
    if (confirmTitle.length>0) {
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:confirmTitle?confirmTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) { !confirmAction?:confirmAction();}];
        confirm.textColor = MH_MAIN_COLOR;
        [alertController addAction:confirm];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (viewController) {
            [viewController presentViewController:alertController animated:YES completion:NULL];
        }else{
            [[ALControllerHelper currentViewController] presentViewController:alertController animated:YES completion:NULL];
        }
    });
}
+ (void)mh_showCustomAlertWith:(UIAlertControllerStyle)style title:(NSString *)title message:(NSString *)message actionTitles:(NSArray *)actionArray cancelTitle:(NSString *)cancelTitle clickIndex:(void(^)())tapAction {
    [ALAlertHelper mh_showCustomAlertWith:style title:title message:message actionTitles:actionArray cancelTitle:cancelTitle messageLeftAligMent:NO clickIndex:tapAction];
}
+ (void)mh_showCustomAlertWith:(UIAlertControllerStyle)style title:(NSString *)title message:(NSString *)message actionTitles:(NSArray *)actionArray cancelTitle:(NSString *)cancelTitle messageLeftAligMent:(BOOL)messageLeftAligMent clickIndex:(void(^)())tapAction {
    
    if (!actionArray.count && MHStringIsEmpty(cancelTitle)) {
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    //修改message
    if (messageLeftAligMent) {
        UIView *subView1 = alertController.view.subviews[0];
        if (subView1.subviews.count>0) {
            UIView *subView2 = subView1.subviews[0];
            if (subView2.subviews.count>0) {
                UIView *subView3 = subView2.subviews[0];
                if (subView3.subviews.count>0) {
                    UIView *subView4 = subView3.subviews[0];
                    if (subView4.subviews.count>0) {
                        UIView *subView5 = subView4.subviews[0];
                        if (subView5.subviews.count>1) {
                            //设置title的对齐方式
                            
                            //设置内容的对齐方式
                            if (MH_iOS11_VERSTION_LATER) {
                                UILabel *mes= subView5.subviews[2];
                                if([mes isKindOfClass:UILabel.class]){
                                    mes.textAlignment = NSTextAlignmentLeft;
                                }
                            }else{
                                UILabel *mes= subView5.subviews[1];
                                if([mes isKindOfClass:UILabel.class]){
                                    mes.textAlignment = NSTextAlignmentLeft;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    [actionArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (tapAction) {
                tapAction(idx);
            }
        }];
        [alertController addAction:action];
    }];
    if (!MHStringIsEmpty(cancelTitle)) {
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancel];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [[ALControllerHelper currentViewController] presentViewController:alertController animated:YES completion:NULL];
    });
}

+ (void)openPhotoLibraryAuthority {
    [self mh_showAlertViewWithTitle:@"为阿拉丁开启相册权限" message:@"当前服务需使用相册权限,请前往设置开启" confirmTitle:@"去开启" cancelTitle:@"暂不开启" confirmAction:^{
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL: url]) {
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL: url options:@{} completionHandler:nil];
            }else{
                [[UIApplication sharedApplication] openURL: url];
            }
        }
    } cancelAction:^{
    }];
}
+ (void)openCameraAuthority {
    [self mh_showAlertViewWithTitle:@"为阿拉丁开启相机权限" message:@"当前服务需使用相机权限,请前往设置开启" confirmTitle:@"去开启" cancelTitle:@"暂不开启" confirmAction:^{
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL: url]) {
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL: url options:@{} completionHandler:nil];
            }else{
                [[UIApplication sharedApplication] openURL: url];
            }
        }
    } cancelAction:^{
    }];
}

+ (void)openLocationAuthority {
    [ALAlertHelper mh_showAlertViewWithTitle:@"为阿拉丁开启定位服务" message:@"当前服务需使用定位功能,请前往设置开启" confirmTitle:@"去开启" cancelTitle:@"暂不开启" confirmAction:^{
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL: url]) {
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL: url options:@{} completionHandler:nil];
            }else{
                [[UIApplication sharedApplication] openURL: url];
            }
        }
    } cancelAction:^{
    }];
    
}
@end
