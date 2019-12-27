//
//
//  MBProgressHUD+MHExtension.m
//
//  Created by apple on 16/5/10.
//  Copyright © 2016年 CoderMikeHe. All rights reserved.
//

#import "MBProgressHUD+MHExtension.h"
#import "NSError+MHExtension.h"
#import <YYImage/YYImage.h>

static NSString *lastTips = @"";
static NSDate *lastShowTime = nil;
static id<RACSubscriber> _concatSubscriber = nil;

static RACSignal *concatSignal = nil;

@implementation MBProgressHUD (MHExtension)

#pragma mark - Added To  window
/// 提示信息
+ (MBProgressHUD *)mh_showTips:(NSString *)tipStr{
    return [self mh_showTips:tipStr addedToView:[ALControllerHelper currentViewController].view];
}
/// 提示错误
+ (MBProgressHUD *)mh_showErrorTips:(NSError *)error{
    return [self mh_showErrorTips:error addedToView:[ALControllerHelper currentViewController].view];
}
/// 进度view
+ (MBProgressHUD *)mh_showProgressHUD:(NSString *)titleStr
{
//    return [self mh_showCustomGifHud:titleStr];
    return [self mh_showProgressHUD:titleStr addedToView:[ALControllerHelper currentViewController].view];
}
+ (MBProgressHUD *)mh_showCustomGifHud:(NSString *)tipstr {
    MBProgressHUD *hud = [self mh_showProgressHUD:tipstr addedToView:nil];
    hud.mode = MBProgressHUDModeCustomView;
    hud.label.text = tipstr;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor clearColor];
    UIImage *image = [YYImage imageNamed:@"loading.gif"];
    UIImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    hud.customView = imageView;
    return hud;
}
/// hide hud
+ (void)mh_hideHUD
{
    [self mh_hideHUDForView:[ALControllerHelper currentViewController].view];
}

#pragma mark - Added To Special View
/// 提示信息
+ (MBProgressHUD *)mh_showTips:(NSString *)tipStr addedToView:(UIView *)view
{
    return [self _configureHUDWithTips:tipStr isAutomaticHide:YES addedToView:view];
}

/// 提示错误
+ (MBProgressHUD *)mh_showErrorTips:(NSError *)error addedToView:(UIView *)view
{
    return [self _configureHUDWithTips:[self mh_tipsFromError:error] isAutomaticHide:YES addedToView:view];
}
/// 进度view
+ (MBProgressHUD *)mh_showProgressHUD:(NSString *)titleStr addedToView:(UIView *)view{
    return [self _configureHUDWithTips:titleStr isAutomaticHide:NO addedToView:view];
}
// 隐藏HUD
+ (void)mh_hideHUDForView:(UIView *)view
{
    [self hideHUDForView:[self _willShowingToViewWithSourceView:view] animated:YES];
}
#pragma mark - 辅助方法
/// 获取将要显示的view
+ (UIView *)_willShowingToViewWithSourceView:(UIView *)sourceView
{
    if (sourceView) return sourceView;
    
    sourceView =  [[UIApplication sharedApplication].delegate window];
    if (!sourceView) sourceView = [[[UIApplication sharedApplication] windows] lastObject];
    
    return sourceView;
}
+ (instancetype )_configureHUDWithTips:(NSString *)tipStr isAutomaticHide:(BOOL) isAutomaticHide addedToView:(UIView *)view {
    if (isAutomaticHide) {
        //提示信息
        if ([lastTips isEqualToString:tipStr]) {
            //两个相同的提示在1秒内只显示一次
            NSDate *now = [NSDate date];
            if ([[now dateByAddingSeconds:-1] compare:lastShowTime] == NSOrderedAscending) {
                lastTips = tipStr;
                lastShowTime = [NSDate date];
                return nil;
            }
        }
        lastTips = tipStr;
        lastShowTime = [NSDate date];
        return [self _showHUDWithTips:tipStr isAutomaticHide:isAutomaticHide addedToView:view];
    }else{
        //进度view
        [[self createMBProgressHUD:tipStr isAutomaticHide:isAutomaticHide addedToView:view] subscribeNext:^(id x) {
            
        }];
    }
    return nil;
}
                               
+ (instancetype )_showHUDWithTips:(NSString *)tipStr isAutomaticHide:(BOOL) isAutomaticHide addedToView:(UIView *)view
{
    if (!concatSignal) {
        //concat 让提示tips按顺序依次显示  当同时有多个提示tips的时候可以防止闪烁
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            concatSignal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                _concatSubscriber = subscriber;
                [subscriber sendNext:[self createMBProgressHUD:tipStr isAutomaticHide:isAutomaticHide addedToView:view]];
                return [RACDisposable disposableWithBlock:^{
                }];
            }] concat];
            [concatSignal subscribeNext:^(id x) {
                
            }];
        });
    }else{
        [_concatSubscriber sendNext:[self createMBProgressHUD:tipStr isAutomaticHide:isAutomaticHide addedToView:view]];
    }
    return nil;
}
+(RACSignal *)createMBProgressHUD:(NSString *)tipStr isAutomaticHide:(BOOL) isAutomaticHide addedToView:(UIView *)view {
    __block UIView *sView = view;
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            sView = [self _willShowingToViewWithSourceView:sView];
            /// show之前 hid掉之前的
            [self mh_hideHUDForView:sView];
            
            MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:sView animated:YES];
            HUD.mode = isAutomaticHide?MBProgressHUDModeText:MBProgressHUDModeIndeterminate;
            HUD.animationType = MBProgressHUDAnimationZoom;
            HUD.label.font = isAutomaticHide?MHMediumFont(17.0f):MHMediumFont(15.0f);
            HUD.label.textColor = [UIColor whiteColor];
            HUD.contentColor = [UIColor whiteColor];
            HUD.label.text = tipStr;
            HUD.label.numberOfLines = 0;
            HUD.bezelView.layer.cornerRadius = 8.0f;
            HUD.bezelView.layer.masksToBounds = YES;
            HUD.bezelView.color = MHColorAlpha(0, 0, 0, .6f);
            HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
            HUD.minSize =isAutomaticHide?CGSizeMake([UIScreen mainScreen].bounds.size.width-96.0f, 60):CGSizeMake(120, 120);
            HUD.margin = 18.2f;
            HUD.removeFromSuperViewOnHide = YES;
            HUD.top = MH_APPLICATION_TOP_BAR_HEIGHT;
            HUD.bezelView.center = HUD.center;

            [subscriber sendNext:HUD];
            if (isAutomaticHide){
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [HUD hideAnimated:YES];
//                    [HUD hideAnimated:YES afterDelay:1.4f];
                    [subscriber sendCompleted];
                });
            }else{
                [subscriber sendCompleted];
            }
        return nil;
    }];
}
#pragma mark - 辅助属性
+ (NSString *)mh_tipsFromError:(NSError *)error{
    return [NSError mh_tipsFromError:error];
}
@end
