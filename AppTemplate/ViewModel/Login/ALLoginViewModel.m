//
//  ALLoginViewModel.m
//  ALaCocoaOta
//
//  Created by 旮旯 on 2019/4/21.
//  Copyright © 2019年 旮旯. All rights reserved.
//

#import "ALLoginViewModel.h"
//#import "ALHTTPService+UserRequest.h"
#import "YYTimer.h"
#import "ALWebViewModel.h"
#import "ALRootViewModel.h"

@interface ALLoginViewModel ()

@property (nonatomic, readwrite, copy) NSString *phone;

@property (nonatomic, readwrite, copy) NSString *password;
/// valid (有效性)
@property (nonatomic, readwrite, assign) BOOL valid;

@end

@implementation ALLoginViewModel

-(void)initialize {
    [super initialize];
    
    self.prefersNavigationBarHidden = YES;
    @weakify(self);
    /// 登录命令
    self.loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber * selected) {
        @strongify(self);
        if (![NSString mh_isValidMobile:self.phone]) {
            [MBProgressHUD mh_showTips:@"您输入的手机号不合法"];
            return [RACSignal empty];
        }
        [MBProgressHUD mh_showProgressHUD:@"登录中..."];
        [[[self.services.client requestLoginWithPhone:self.phone code:NULL password:self.password type:@"2"] takeUntil:self.willDeallocSignal] subscribeNext:^(ALUser *x) {
            [MBProgressHUD mh_hideHUD];
            [[self.services client] saveUser:x];
            ALRootViewModel *rootViewModel = [[ALRootViewModel alloc] initWithServices:self.services params:nil];
            [self.services resetRootViewModel:rootViewModel];
        }];
        return [RACSignal empty];
    }];
    /// 按钮的有效性
    self.validLoginSignal = [[RACSignal
                              combineLatest:@[RACObserve(self, phone),RACObserve(self, password)]
                              reduce:^(NSString *phone , NSString *code) {
                                  return @(MHStringIsNotEmpty(code) && MHStringIsNotEmpty(phone));
                              }]
                             distinctUntilChanged];

    self.registerCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {

        return [RACSignal empty];
    }];
    self.forgetPassWordCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {

        return [RACSignal empty];
    }];
}

@end
