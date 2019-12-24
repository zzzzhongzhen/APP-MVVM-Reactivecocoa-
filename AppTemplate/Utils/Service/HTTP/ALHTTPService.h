//
//  ALHttpService.h
//  ALaCocoaOta
//
//  Created by 旮旯 on 2018/8/27.
//  Copyright © 2018年 旮旯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALHTTPRequest.h"
#import "ALHTTPResponse.h"
#import "ALHTTPServiceConstant.h"
#import "RACSignal+ALHTTPResponseAddtion.h"
#import "NSURLSessionTask+BindDeallocSignal.h"
#import "ALUser.h"

// The domain for all errors originating in MHHTTPService.
FOUNDATION_EXTERN NSString *const MHHTTPServiceErrorDomain;
///
FOUNDATION_EXTERN NSString *const MHHTTPServiceErrorResponseCodeKey;
FOUNDATION_EXTERN NSString *const MHHTTPServiceErrorHTTPPResponseMsgKey ;

// A user info key associated with the NSURL of the request that failed.
FOUNDATION_EXTERN NSString * const MHHTTPServiceErrorRequestURLKey ;
// A user info key associated with an NSNumber, indicating the HTTP status code
// that was returned with the error.
FOUNDATION_EXTERN NSString * const MHHTTPServiceErrorHTTPStatusCodeKey ;
/// The descriptive message returned from the API, e.g., "Validation Failed".
FOUNDATION_EXTERN NSString * const MHHTTPServiceErrorDescriptionKey ;
/// An array of specific message strings returned from the API, e.g.,
/// "No commits between joshaber:master and joshaber:feature".
FOUNDATION_EXTERN NSString * const MHHTTPServiceErrorMessagesKey ;

/// 连接服务器失败 default
FOUNDATION_EXTERN NSInteger const MHHTTPServiceErrorConnectionFailed ;

FOUNDATION_EXTERN NSInteger const MHHTTPServiceErrorJSONParsingFailed ;
// (HTTP error 400).
FOUNDATION_EXTERN NSInteger const MHHTTPServiceErrorBadRequest ;
// (HTTP error 403).
FOUNDATION_EXTERN NSInteger const MHHTTPServiceErrorRequestForbidden ;
// (HTTP error 422)
FOUNDATION_EXTERN NSInteger const MHHTTPServiceErrorServiceRequestFailed ;
//
FOUNDATION_EXTERN NSInteger const MHHTTPServiceErrorSecureConnectionFailed ;



@interface ALHTTPService : AFHTTPSessionManager
/// 单例
+(instancetype) sharedInstance;

/// 获取当前用户
- (ALUser *)currentUser;

- (void)saveUser:(ALUser *)user;

- (void)deleteUser ;

-(void)enqueueBlankRequest ;
//当前网络状态  需要的地方可监听改参数
@property(nonatomic, assign) AFNetworkReachabilityStatus networkStatus;
//无网信号
@property(nonatomic, strong) RACSubject *noNetworkSubject;
//所有的请求任务合集
@property(nonatomic, strong, readonly) ALKeyedSubscript *dataTaskDic;
//请求失败需要重试的URL合集
@property(nonatomic, strong, readonly) NSMutableArray *retryTaskArray;

@end

/// 请求类
@interface ALHTTPService (Request)

/// 1.后台返回数据的保证为👇固定格式 且`data:{}`必须为`字典`或者`NSNull`;
/// {
///    code：0,
///    msg: "",
///    data:{
///    }
/// }
/// 这个方法返回的 signal 将会 send `ALHTTPResponse`这个实例，`parsedResult`就是对应键data对应的值， 如果你想获得里面的parsedResult实例，请使用以下方法
/// [[self enqueueRequest:request resultClass:ALUser.class] mh_parsedResults];
/// 这样取出来的就是 ALUser对象

/// 2.使用方法如下
/*
 /// 1. 配置参数
 ALKeyedSubscript *subscript = [ALKeyedSubscript subscript];
 subscript[@"page"] = @1;
 
 /// 2. 配置参数模型
 ALURLParameters *paramters = [ALURLParameters urlParametersWithMethod:@"GET" path:SUProduct parameters:subscript.dictionary];
 
 /// 3. 创建请求
 /// 3.1 resultClass 传入对象必须得是 ALObject的子类
 /// 3.2 resultClass 传入nil ，那么回调回来的值就是，服务器返回来的数据
 [[[[ALHTTPRequest requestWithParameters:paramters]
 enqueueResultClass:[SBGoodsData class]]
 sb_parsedResults]
 subscribeNext:^(SBGoodsData * goodsData) {
 /// 成功回调
 
 } error:^(NSError *error) {
 /// 失败回调
 
 } completed:^{
 /// 完成
 
 }];
 
 */

-(RACSignal *)enqueueRequest:(ALHTTPRequest *) request
                 resultClass:(Class /*subclass of MHObject*/) resultClass;


@end
