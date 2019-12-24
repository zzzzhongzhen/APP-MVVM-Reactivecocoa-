//
//  ALNavigationControllerStack.h
//  ALaCocoaOta
//
//  Created by 旮旯 on 2018/8/27.
//  Copyright © 2018年 旮旯. All rights reserved.
//


#import <Foundation/Foundation.h>

//  `view` 层维护一个 `ALNavigationController` 的堆栈 ALNavigationControllerStack ，不管是 push/pop 还是 present/dismiss ，都使用栈顶的 ALNavigationController 来执行导航操作，且并且保证 present 出来的是一个 ALNavigationController 。
@protocol ALViewModelServices;

@interface ALNavigationControllerStack : NSObject
/**
 初始化方法

 @param services Model层的
 @return a new navigation controller stack
 */
- (instancetype)initWithServices:(id<ALViewModelServices>)services;

- (void)pushNavigationController:(UINavigationController *)navigationController;

- (UINavigationController *)popNavigationController;

- (UINavigationController *)topNavigationController;

@end
