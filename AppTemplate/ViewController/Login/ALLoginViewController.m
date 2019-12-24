//
//  ALLoginViewController.m
//  ALaCocoaOta
//
//  Created by 旮旯 on 2019/4/21.
//  Copyright © 2019年 旮旯. All rights reserved.
//

#import "ALLoginViewController.h"
#import "ALLoginViewModel.h"

@interface ALLoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *closeBtnTop;
@property (weak, nonatomic) IBOutlet UITextField *phoneTxd;
@property (weak, nonatomic) IBOutlet UITextField *codeTxd;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UILabel *agreementLab;

@property (nonatomic, strong) ALLoginViewModel *viewModel;
@property (nonatomic, strong) YYLabel *yyagreementLab;

@end

@implementation ALLoginViewController

@dynamic viewModel;
#pragma mark ============ LifeCycle ============
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _setup];
}
#pragma mark ============ setup ============
- (void)bindViewModel {
    [super bindViewModel];
    /// 手机
    RAC(self.viewModel , phone) = [RACSignal merge:@[RACObserve(self.phoneTxd, text),self.phoneTxd.rac_textSignal]];
    
    /// 密码
    RAC(self.viewModel ,password) = [RACSignal merge:@[RACObserve(self.codeTxd, text),self.codeTxd.rac_textSignal]];
    
    /// 登录按钮有效性
    RAC(self.loginBtn , enabled) = self.viewModel.validLoginSignal;
    RAC(self.loginBtn , backgroundColor) = [self.viewModel.validLoginSignal map:^id(NSNumber *value) {
        return value.integerValue?MH_MAIN_COLOR:MH_MAIN_BACKGROUNDCOLOR;
    }];
    
    @weakify(self);
    [[self.phoneTxd rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(UITextField *x) {
        @strongify(self);
        if (x.text.length>=11) {
            self.phoneTxd.text =  [x.text substringToIndex:11];
            [self.codeTxd becomeFirstResponder];
        }
    }];

//    [self.phoneTxd.rac_textSignal subscribeNext:^(NSString *x) {
//        @strongify(self);
//        if (x.length>11) {
//            self.phoneTxd.text =  [x substringToIndex:11];
//            [self.codeTxd becomeFirstResponder];
//        }
//    }];
    [self.codeTxd.rac_textSignal subscribeNext:^(NSString *x) {
        @strongify(self);
        if (x.length>16) {
            self.codeTxd.text =  [x substringToIndex:16];
        }
    }];
}
- (void)_setup {
    self.view.backgroundColor = MH_WHITECOLOR;
    self.closeBtnTop.constant = MH_APPLICATION_STATUS_BAR_HEIGHT+10;
    
    [self.yyagreementLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}
- (YYLabel *)yyagreementLab {
    if (!_yyagreementLab) {
        _yyagreementLab = [YYLabel new];
        [self.agreementLab addSubview:_yyagreementLab];
        
        NSString *agree = @"《服务协议》";
        NSString *yingshi = @"《隐私政策》";
        NSString *str = @"登录即代表您已同意我们的《服务协议》和《隐私政策》";
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attributeStr yy_setUnderlineStyle:NSUnderlineStyleSingle range:[str rangeOfString:agree]];
        [attributeStr yy_setUnderlineStyle:NSUnderlineStyleSingle range:[str rangeOfString:yingshi]];
        [attributeStr yy_setFont:MHRegularFont_11 range:NSMakeRange(0, str.length)];
        [attributeStr yy_setColor:MHColorFromRGB(0x999999) range:NSMakeRange(0, str.length)];
        [attributeStr yy_setTextHighlightRange:[str rangeOfString:agree] color:MH_MAIN_COLOR backgroundColor:MH_CLEARCOLOR tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            [self.viewModel.agreementCommand execute:@"fuwu"];
        }];
        [attributeStr yy_setTextHighlightRange:[str rangeOfString:yingshi] color:MH_MAIN_COLOR backgroundColor:MH_CLEARCOLOR tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            [self.viewModel.agreementCommand execute:@"yinsi"];
        }];
        [_yyagreementLab setAttributedText:attributeStr];
        _yyagreementLab.textAlignment = NSTextAlignmentCenter;

    }
    return _yyagreementLab;
}

#pragma mark ============ Private ============

- (IBAction)closeClick:(id)sender {
    [self.viewModel.services dismissViewModelAnimated:YES completion:nil];
}
- (IBAction)loginClick:(id)sender {
    [self.viewModel.loginCommand execute:@1];
}
- (IBAction)registerClick:(id)sender {
    [self.viewModel.registerCommand execute:@1];
}
- (IBAction)vercodeLoginBtn:(id)sender {
    [self.viewModel.services dismissViewModelAnimated:YES completion:nil];
//    ALLoginAuthenticationViewModel *authViewModel = [[ALLoginAuthenticationViewModel alloc] initWithServices:self.viewModel.services params:@{}];
//    [self.viewModel.services pushViewModel:authViewModel animated:YES];
}
- (IBAction)forgetPassWordClick:(id)sender {
    [self.viewModel.forgetPassWordCommand execute:@1];
}

@end
