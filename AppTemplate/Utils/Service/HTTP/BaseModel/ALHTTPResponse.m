//
//  ALHTTPResponse.m
//  ALaCocoaOta
//
//  Created by 旮旯 on 2019/3/28.
//  Copyright © 2019年 旮旯. All rights reserved.
//

#import "ALHTTPResponse.h"
#import "ALHTTPServiceConstant.h"

@interface ALHTTPResponse ()

@property (nonatomic, readwrite, strong) id parsedResult;
/// 自己服务器返回的状态码
@property (nonatomic, readwrite, assign) MHHTTPResponseCode code;
/// 自己服务器返回的信息
@property (nonatomic, readwrite, copy) NSString *msg;

@end

@implementation ALHTTPResponse

- (instancetype)initWithResponseObject:(id)responseObject parsedResult:(id)parsedResult
{
    self = [super init];
    if (self) {
        self.parsedResult = parsedResult ?:NSNull.null;
        self.code = [responseObject[MHHTTPServiceResponseCodeKey] integerValue];
        self.msg = responseObject[MHHTTPServiceResponseMsgKey];
    }
    return self;
}
@end
