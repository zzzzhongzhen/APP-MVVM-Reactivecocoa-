//
//  ALHTTPRequest.m
//  ALaCocoaOta
//
//  Created by 旮旯 on 2019/3/28.
//  Copyright © 2019年 旮旯. All rights reserved.
//

#import "ALHTTPRequest.h"

@interface ALHTTPRequest ()
/// 请求参数
@property (nonatomic, readwrite, strong) ALURLParameters *urlParameters;

@end

@implementation ALHTTPRequest

+(instancetype)requestWithParameters:(ALURLParameters *)parameters{
    return [[self alloc] initRequestWithParameters:parameters];
}

-(instancetype)initRequestWithParameters:(ALURLParameters *)parameters{
    
    self = [super init];
    if (self) {
        self.urlParameters = parameters;
    }
    return self;
}
+(instancetype)blankRequest {
    return [[self alloc] init];
}

@end

/// 网络服务层分类 方便MHHTTPRequest 主动发起请求
@implementation ALHTTPRequest (ALHTTPService)
/// 请求数据
-(RACSignal *) enqueueResultClass:(nullable Class /*subclass of MHObject*/) resultClass {
    return [[ALHTTPService sharedInstance] enqueueRequest:self resultClass:resultClass];
}
@end

