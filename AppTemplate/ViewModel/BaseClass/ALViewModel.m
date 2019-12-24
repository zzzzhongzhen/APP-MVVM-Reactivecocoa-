//
//  ALViewModel.m
//  ALaCocoaOta
//
//  Created by 旮旯 on 2018/8/27.
//  Copyright © 2018年 旮旯. All rights reserved.
//

#import "ALViewModel.h"
#import "ALLoginViewModel.h"

/// MVVM View
/// The base map of 'params'
/// The `params` parameter in `-initWithParams:` method.
/// Key-Values's key
/// 传递唯一ID的key：例如：商品id 用户id...
NSString *const MHViewModelIDKey = @"MHViewModelIDKey";
/// 传递导航栏title的key：例如 导航栏的title...
NSString *const MHViewModelTitleKey = @"MHViewModelTitleKey";
/// 传递数据模型的key：例如 商品模型的传递 用户模型的传递...
NSString *const MHViewModelUtilKey = @"MHViewModelUtilKey";
/// 传递webView Request的key：例如 webView request...
NSString *const MHViewModelRequestKey = @"MHViewModelRequestKey";
// 自定义的参数
NSString *const MHViewModelOtherKey = @"MHViewModelOtherKey";

@interface ALViewModel()

@property (nonatomic, readwrite, strong) id<ALViewModelServices> services;

@property (nonatomic, readwrite, strong) NSDictionary *params;
/// A RACSubject object, which representing all errors occurred in view model.
@property (nonatomic, readwrite, strong) RACSubject *errors;
/// The `View` willDisappearSignal
@property (nonatomic, readwrite, strong) RACSubject *willDisappearSignal;
@property (nonatomic, readwrite, strong) RACSubject *willDeallocSignal;

@end

@implementation ALViewModel
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    ALViewModel *viewModel = [super allocWithZone:zone];
    @weakify(viewModel);
    //监听初始化方法
    [[viewModel
      rac_signalForSelector:@selector(initWithServices:params:)]
        subscribeNext:^(id x) {
            @strongify(viewModel);
            [viewModel initialize];
            
    }];
    return viewModel;
}
- (instancetype)initWithServices:(id<ALViewModelServices>)services params:(NSDictionary *)params {
    self = [super init];
    if (self) {
        self.title = params[MHViewModelTitleKey];
        /// 默认在viewDidLoad里面加载本地和服务器的数据
        self.shouldFetchLocalDataOnViewModelInitialize = YES;
        self.shouldRequestRemoteDataOnViewDidLoad = YES;
//        self.shouldRequestRemoteDataOnViewWillAppear = NO;
        self.prefersNavigationBackBtnHidden = NO;
        /// 允许IQKeyboardMananger接管键盘弹出事件
        self.keyboardEnable = YES;
        self.shouldResignOnTouchOutside = YES;
        self.keyboardDistanceFromTextField = 10.0f;
        
        /// 赋值
        self.services = services;
        self.params   = params;
    }
    return self;
}
//子类重写
-(void)initialize{}

- (RACSubject *)errors {
    if (!_errors) _errors = [RACSubject subject];
    return _errors;
}

- (RACSubject *)willDisappearSignal {
    if (!_willDisappearSignal) _willDisappearSignal = [RACSubject subject];
    return _willDisappearSignal;
}
- (RACSubject *)willDeallocSignal {
    if (!_willDeallocSignal) _willDeallocSignal = [RACSubject subject];
    return _willDeallocSignal;
}

- (void)pushToLogin {
    ALLoginViewModel *loginViewModel = [[ALLoginViewModel alloc] initWithServices:self.services params:nil];
    [self.services presentViewModel:loginViewModel animated:YES completion:nil];
}
@end
