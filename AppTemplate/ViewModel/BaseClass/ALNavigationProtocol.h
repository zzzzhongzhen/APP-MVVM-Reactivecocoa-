//
//  ALNavigationProtocol.h
//  WeChat
//
//  Created by 旮旯 on 2018/8/27.
//  Copyright © 2018年 旮旯. All rights reserved.

//  关于导航栏跳转（Push/Pop   Present/Dismiss）的协议

#import <Foundation/Foundation.h>
#import "ALViewModel.h"
#import "ALConstant.h"

@protocol ALNavigationProtocol <NSObject>
/**
 push方法

 @param viewModel 对应控制器的viewModel
 @param animated nullable
 */
- (void)pushViewModel:(ALViewModel *)viewModel animated:(BOOL)animated;
/**
 pop方法

 @param animated nullable
 */
- (void)popViewModelAnimated:(BOOL)animated;
/**
 返回到根控制器

 @param animated nullable
 */
- (void)popToRootViewModelAnimated:(BOOL)animated;
/**
 presentViewController

 @param viewModel viewmodel
 @param animated nullable
 @param completion nullable
 */
- (void)presentViewModel:(ALViewModel *)viewModel animated:(BOOL)animated completion:(VoidBlock)completion;
/**
 dissmissViewController

 @param animated nullable
 @param completion nullable
 */
- (void)dismissViewModelAnimated:(BOOL)animated completion:(VoidBlock)completion;

/**
 重置window的根视图

 @param viewModel 根式图对应的ViewModel
 */
- (void)resetRootViewModel:(ALViewModel *)viewModel;

@end
