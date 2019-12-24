//
//  ALViewModel.h
//  ALaCocoaOta
//
//  Created by 旮旯 on 2018/8/27.
//  Copyright © 2018年 旮旯. All rights reserved.
//

/// MVVM View
/// The base map of 'params'
/// The `params` parameter in `-initWithParams:` method.
/// Key-Values's key
/// 传递唯一ID的key：例如：商品id 用户id...
FOUNDATION_EXTERN NSString *const MHViewModelIDKey;
/// 传递导航栏title的key：例如 导航栏的title...
FOUNDATION_EXTERN NSString *const MHViewModelTitleKey;
/// 传递数据模型的key：例如 商品模型的传递 用户模型的传递...
FOUNDATION_EXTERN NSString *const MHViewModelUtilKey;
/// 传递webView Request的key：例如 webView request...
FOUNDATION_EXTERN NSString *const MHViewModelRequestKey;
//自定义的参数
FOUNDATION_EXTERN NSString *const MHViewModelOtherKey;

#import <Foundation/Foundation.h>
#import "ALConstant.h"

@protocol ALViewModelServices;
@interface ALViewModel : NSObject
/**
 viewModel的初始化方法

 @param services ALViewModelServices
 @param params params
 @return self
 */
- (instancetype)initWithServices:(id<ALViewModelServices>)services params:(NSDictionary *)params;
/**
 整个应用的服务层
 */
@property (nonatomic, readonly, strong) id<ALViewModelServices> services; 
/**
 控制器的属性集合
 */
@property (nonatomic, readonly, strong) NSDictionary *params;
/// navItem.title
@property (nonatomic, readwrite, copy) NSString *title;
/// 返回按钮图片的名字,有默认值
@property (nonatomic, readwrite, copy) NSString *backItemImageName;
/// The callback block. 当Push/Present时，通过block反向传值
@property (nonatomic, readwrite, copy) VoidBlock_id callback;

/// A RACSubject object, which representing all errors occurred in view model.
@property (nonatomic, readonly, strong) RACSubject *errors;
/// FDFullscreenPopGesture
/// stack. (是否取消掉左滑pop到上一层的功能（栈底控制器无效），默认为NO，不取消)
@property (nonatomic, readwrite, assign) BOOL interactivePopDisabled;
/// 是否隐藏该控制器的导航栏 默认是不隐藏 (NO)
@property (nonatomic, readwrite, assign) BOOL prefersNavigationBarHidden;
//是否设置该控制器的导航栏为透明
@property (nonatomic, readwrite, assign) BOOL prefersNavigationBarClear;
//返回按钮是否隐藏
@property (nonatomic, readwrite, assign) BOOL prefersNavigationBackBtnHidden;
/// 是否显示大标题
@property (nonatomic, readwrite, assign) BOOL prefersLargeTitle;
/** should fetch local data when viewModel init  . default is YES */
@property (nonatomic, readwrite, assign) BOOL shouldFetchLocalDataOnViewModelInitialize;
/** 是否需要在控制器viewDidLoad default is YES*/
@property (nonatomic, readwrite, assign) BOOL shouldRequestRemoteDataOnViewDidLoad;
/** 是否需要在控制器WillAppear 请求数据 default is NO*/
//@property (nonatomic, readwrite, assign) BOOL shouldRequestRemoteDataOnViewWillAppear;

/// 是否隐藏该控制器的导航栏底部的分割线 默认不隐藏 （NO）
@property (nonatomic, readwrite, assign) BOOL prefersNavigationBarBottomLineHidden;
/// IQKeyboardManager
/// 是否让IQKeyboardManager的管理键盘的事件 默认是YES（键盘管理）
@property (nonatomic, readwrite, assign) BOOL keyboardEnable;
/// 是否键盘弹起的时候，点击其他局域键盘弹起 默认是 YES
@property (nonatomic, readwrite, assign) BOOL shouldResignOnTouchOutside;
/// To set keyboard distance from textField. can't be less than zero. Default is 10.0.
/// keyboardDistanceFromTextField
@property (nonatomic, readwrite, assign) CGFloat keyboardDistanceFromTextField;

@property (nonatomic, strong, readonly) RACSubject *willDisappearSignal;
@property (nonatomic, strong, readonly) RACSubject *willDeallocSignal;

///无网络界面点击刷新调用该block  需要子viewModel去实现
@property (nonatomic, strong, readwrite) void (^retryRequestHandle)(void);

/**
 viewModel子类的自定制方法,在initWithServices之后调用
 */
- (void)initialize;
///跳转到登陆
- (void)pushToLogin;
@end
