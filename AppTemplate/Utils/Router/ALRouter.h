//
//  ALRouter.h
//  WeChat
//
//  Created by senba on 2017/9/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  ViewModel -- ViewController

#import <Foundation/Foundation.h>
#import "ALViewController.h"

@interface ALRouter : NSObject
/**
 初始化单例对象

 @return ALRouter
 */
+ (instancetype)sharedInstance;
/**
 根据viewModel返回对应的viewController

 @param viewModel The view model
 @return 当前viewModel对应的viewController
 */

- (ALViewController *)viewControllerForViewModel:(ALViewModel *)viewModel;
@end
