//
//  ALHTTPService+LoginRequest.h
//  ALHomestayPro
//
//  Created by 旮旯 on 2019/10/23.
//  Copyright © 2019 旮旯. All rights reserved.
//

#import "ALHTTPService.h"
#import "ALUser.h"
NS_ASSUME_NONNULL_BEGIN

@interface ALHTTPService (LoginRequest)

- (RACSignal *)requestLoginWithPhone:(NSString *)phone code:(NSString *_Nullable)code password:(NSString *_Nullable)password type:(NSString *)type ;
- (RACSignal *)requestGetVercodeWithPhone:(NSString *)phone type:(NSString *)type ;
- (RACSignal *)requestSetPassWordWithPassword:(NSString *)password ;
- (RACSignal *)requestCertificationCodeWithPhone:(NSString *)phone code:(NSString *_Nullable)code type:(NSString *)type ;

@end

NS_ASSUME_NONNULL_END
