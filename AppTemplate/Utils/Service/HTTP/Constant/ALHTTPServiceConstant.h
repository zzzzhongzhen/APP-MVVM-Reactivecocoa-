//
//  ALHTTPServiceConstant.h
//  ALaCocoaOta
//
//  Created by 旮旯 on 2018/9/13.
//  Copyright © 2018年 旮旯. All rights reserved.
//

#ifndef ALHTTPServiceConstant_h
#define ALHTTPServiceConstant_h

/// 私钥key
#define MHHTTPServiceKey  @"privatekey"
/// 私钥Value
#define MHHTTPServiceKeyValue @""
/// 签名key
#define MHHTTPServiceSignKey @"sign"

/// 服务器返回的三个固定字段
/// 状态码key
#define MHHTTPServiceResponseCodeKey @"errCode"
/// 消息key
#define MHHTTPServiceResponseMsgKey    @"msg"
/// 数据data
#define MHHTTPServiceResponseDataKey   @"data"
/// 数据data{"list":[]}
#define MHHTTPServiceResponseDataListKey   @"list"


#endif /* ALHTTPServiceConstant_h */
