//
//  ALURLParameters.h
//  ALaCocoaOta
//
//  Created by 旮旯 on 2019/3/28.
//  Copyright © 2019年 旮旯. All rights reserved.
// 网络服务层 -参数

#import <Foundation/Foundation.h>
#import "ALKeyedSubscript.h"
#import "ALUser.h"

NS_ASSUME_NONNULL_BEGIN

/// 请求Method
/// GET 请求
#define MH_HTTTP_METHOD_GET @"GET"
/// HEAD
#define MH_HTTTP_METHOD_HEAD @"HEAD"
/// POST
#define MH_HTTTP_METHOD_POST @"POST"
/// DELETE
#define MH_HTTTP_METHOD_DELETE @"DELETE"

/// 项目额外的配置参数拓展
@interface SBURLExtendsParameters : NSObject

/// 类方法
+ (instancetype)extendsParameters;

/// 用户token，默认空字符串
@property (nonatomic, readwrite, copy) NSString *oauth_token;

@property (nonatomic, readwrite, copy) NSString *oauth_token_secret;

@property (nonatomic, readwrite, copy) NSString *uuid;

@end

@interface ALURLParameters : NSObject
/// 路径 （v14/order）
@property (nonatomic, readwrite, strong) NSString *path;
/// 参数列表
@property (nonatomic, readwrite, strong) NSDictionary *parameters;
/// 方法 （POST/GET）
@property (nonatomic, readwrite, strong) NSString *method;
/// 是否需要传oauthtoken 验证登录
@property (nonatomic, readwrite, assign) BOOL validLogin;

/// 拓展的参数属性
@property (nonatomic, readwrite, strong) SBURLExtendsParameters *extendsParameters;
/**
 参数配置（统一用这个方法配置参数）
 @param method 方法名 （GET/POST/...）
 @param path 文件路径 （user/info）
 @param parameters 具体参数 @{user_id:10013}
 @return 返回一个参数实例
 */
+(instancetype)urlParametersWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters;


@end

NS_ASSUME_NONNULL_END
