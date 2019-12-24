//
//  ALLoginViewModel.h
//  ALaCocoaOta
//
//  Created by 旮旯 on 2019/4/21.
//  Copyright © 2019年 旮旯. All rights reserved.
//

#import "ALViewModel.h"
#import "ALHTTPService+LoginRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface ALLoginViewModel : ALViewModel

@property (nonatomic, readwrite, strong) RACCommand *loginCommand;
/// 验证码命令
@property (nonatomic, readwrite, strong) RACCommand *captchaCommand;

@property (nonatomic, readwrite, strong) RACCommand *agreementCommand;

@property (nonatomic, readwrite, strong) RACCommand *registerCommand;

@property (nonatomic, readwrite, strong) RACCommand *forgetPassWordCommand;

/// phone
@property (nonatomic, readonly, copy) NSString *phone;
/// password
@property (nonatomic, readonly, copy) NSString *password;
/// 登录按钮有效性
@property (nonatomic, readwrite, strong) RACSignal *validLoginSignal;
/// 验证码按钮能否点击
@property (nonatomic, readwrite, strong) RACSignal *validCaptchaSignal;

@property (nonatomic, readwrite, copy) NSString *yinsiUrl;
@property (nonatomic, readwrite, copy) NSString *fuwuUrl;

@end

NS_ASSUME_NONNULL_END
