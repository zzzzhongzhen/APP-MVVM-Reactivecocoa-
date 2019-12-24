//
//  ALHTTPService+LoginRequest.m
//  ALHomestayPro
//
//  Created by 旮旯 on 2019/10/23.
//  Copyright © 2019 旮旯. All rights reserved.
//

#import "ALHTTPService+LoginRequest.h"


@implementation ALHTTPService (LoginRequest)

- (RACSignal *)requestLoginWithPhone:(NSString *)phone code:(NSString *_Nullable)code password:(NSString *_Nullable)password type:(NSString *)type {
    
    ALKeyedSubscript *subscript = [ALKeyedSubscript subscript];
    subscript[@"phone"] = phone;
    subscript[@"code"] = code;
    subscript[@"type"] = type;
    subscript[@"password"] = [password md5String];
    subscript[@"deviceId"] = [ALFileManager userdefalutforkey:@"deviceId"];

    ALURLParameters *paramters = [ALURLParameters urlParametersWithMethod:MH_HTTTP_METHOD_POST path:@"" parameters:subscript.dictionary];
    return [[[ALHTTPRequest requestWithParameters:paramters]
             enqueueResultClass:[ALUser class]]
            mh_parsedResults];
}

@end
