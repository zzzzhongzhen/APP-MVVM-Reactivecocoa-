//
//  ALHTTPRequest.h
//  ALaCocoaOta
//
//  Created by 旮旯 on 2019/3/28.
//  Copyright © 2019年 旮旯. All rights reserved.
// 网络服务层 - 请求

#import <Foundation/Foundation.h>
#import "ALURLParameters.h"

NS_ASSUME_NONNULL_BEGIN

@interface ALHTTPRequest : NSObject

/// 请求参数
@property (nonatomic, readonly, strong) ALURLParameters *urlParameters;
/**
 获取请求类
 @param parameters  参数模型
 @return 请求类
 */
+(instancetype)requestWithParameters:(ALURLParameters *)parameters;

/// 空白请求,用于提前弹出数据权限框
+(instancetype)blankRequest;

@end
/// MHHTTPService的分类
@interface ALHTTPRequest (ALHTTPService)
/// 入队
- (RACSignal *) enqueueResultClass:(nullable Class /*subclass of MHObject*/) resultClass;

@end

NS_ASSUME_NONNULL_END
