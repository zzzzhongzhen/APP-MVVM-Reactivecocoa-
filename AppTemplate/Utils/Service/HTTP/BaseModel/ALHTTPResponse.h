//
//  ALHTTPResponse.h
//  ALaCocoaOta
//
//  Created by 旮旯 on 2019/3/28.
//  Copyright © 2019年 旮旯. All rights reserved.
//

#import "ALBaseModel.h"

/// 请求数据返回的状态码
typedef NS_ENUM(NSUInteger, MHHTTPResponseCode) {
    MHHTTPResponseCodeSuccess = 200 ,                     /// 请求成功
    MHHTTPResponseCodeNotLogin = 10002,                     /// 用户尚未登录 请登录
    MHHTTPResponseCodeNotCerticate = 10003,                     /// 用户认证失败 请重新登录
    MHHTTPResponseCodeRoomCantOrder = 20202,                     /// 房型暂不可订
    MHHTTPResponseCodeNoRoom = 20205,                     /// 房间被抢光了了，请选择其他房间预订
    MHHTTPResponseCodeOrderNoCancel = 20802,                     /// 抱歉，订单已过了了可免费取消时间
    MHHTTPResponseCodeNoOrder = 20801,                     /// 抱歉，系统查询没有此订单。如有疑问致电客服
    MHHTTPResponseCodeAcountNeedLogin = 1101,                     /// 您的账号在其他设备登录，需要重新登录!请注意账号安全。
    MHHTTPResponseCodeOrderTimeOut = 10011,                     /// 该订单已经超时不能进⾏支付
    MHHTTPResponseCodeParametersVerifyFailure = 105,      /// 参数验证失败
    MHHTTPResponseCodeCouponNotExsit = 24003,      /// 优惠券不存在
    MHHTTPResponseCodeDuplicateCoupon = 24004,      /// 已领取过不能重复领取
    MHHTTPResponseCodeOrderCanotChange = 20212,      /// 订单已处理
    MHHTTPResponseCodeorderCanotPay = 20902,      /// 该订单已处理,不能进行支付
    MHHTTPResponseCodeorderPriceChanged = 20213,      /// 该订单的房间价格发生变动

};


NS_ASSUME_NONNULL_BEGIN

@interface ALHTTPResponse : ALBaseModel
/// 切记：若没有数据是NSNull 而不是nil .对应于服务器json数据的 data
@property (nonatomic, readonly, strong) id parsedResult;
/// 服务器返回的状态码 对应于服务器json数据的 code
@property (nonatomic, readonly, assign) MHHTTPResponseCode code;
/// 服务器返回的信息 对应于服务器json数据的 code
@property (nonatomic, readonly, copy) NSString *msg;

- (instancetype)initWithResponseObject:(id)responseObject parsedResult:(id)parsedResult;

@end

NS_ASSUME_NONNULL_END
