//
//  ALViewController.m
//  ALaCocoaOta
//
//  Created by 旮旯 on 2018/8/27.
//  Copyright © 2018年 旮旯. All rights reserved.
//

#import "ALViewController.h"
#import "ALNavigationController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface ALViewController ()


@end

@implementation ALViewController
#pragma mark ============ lifeCycle ============

- (void)dealloc {
    [self.viewModel.willDeallocSignal sendNext:@1];
    MHDealloc;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    ALViewController *viewController = [super allocWithZone:zone];
    @weakify(viewController)
    [[viewController
      rac_signalForSelector:@selector(viewDidLoad)]
     subscribeNext:^(id x) {
         @strongify(viewController)
         [viewController bindViewModel];
     }];
    return viewController;
}

- (instancetype)initWithViewModel:(ALViewModel *)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    /// 隐藏导航栏细线
    self.viewModel.prefersNavigationBarBottomLineHidden?[(ALNavigationController *)self.navigationController hideNavigationBottomLine]:[(ALNavigationController *)self.navigationController showNavigationBottomLine];
    if (@available(iOS 11.0, *)) {
        self.navigationController.navigationBar.prefersLargeTitles = self.viewModel.prefersLargeTitle;
    }
    /// 配置键盘
    IQKeyboardManager.sharedManager.enable = self.viewModel.keyboardEnable;
    IQKeyboardManager.sharedManager.shouldResignOnTouchOutside = self.viewModel.shouldResignOnTouchOutside;
    IQKeyboardManager.sharedManager.keyboardDistanceFromTextField = self.viewModel.keyboardDistanceFromTextField;
    
    [(ALNavigationController *)self.navigationController backBtn].hidden = self.viewModel.prefersNavigationBackBtnHidden;
    [[(ALNavigationController *)self.navigationController backBtn] setImage:MHImageNamed(MHStringIsEmpty(self.viewModel.backItemImageName)?@"return_icon":self.viewModel.backItemImageName) forState:UIControlStateNormal];
    /// 这里做友盟统计
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.viewModel.willDisappearSignal sendNext:nil];
    // pop 截图
    if ([self isMovingFromParentViewController]) {
        self.snapshot = [self.navigationController.view snapshotViewAfterScreenUpdates:NO];
    }
    if (@available(iOS 11.0, *)) {
        self.navigationController.navigationBar.prefersLargeTitles = NO;
    }
    /// 这里做友盟统计
    //    [MobClick endLogPageView:SBPageName(self)];
    [(ALNavigationController *)self.navigationController backBtn].hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.view.backgroundColor = MH_MAIN_BACKGROUNDCOLOR;
    
    /// 导航栏隐藏 只能在ViewDidLoad里面加载，无法动态
    self.fd_prefersNavigationBarHidden = self.viewModel.prefersNavigationBarHidden;
    /// pop手势
//    self.fd_interactivePopDisabled = self.viewModel.interactivePopDisabled;
    RAC(self,fd_interactivePopDisabled) = RACObserve(self.viewModel, interactivePopDisabled);
    if (self.viewModel.prefersNavigationBarClear) {
        [(ALNavigationController *)self.navigationController setNavgationBarClear:0];
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] init];
    @weakify(self);
    [[[(ALNavigationController *)self.navigationController rac_signalForSelector:@selector(back)] filter:^BOOL(id value) {
        @strongify(self);
        if ([ALControllerHelper currentViewController] == self) {
            return YES;
        }
        return NO;
    }] subscribeNext:^(id x) {
        @strongify(self);
        [self back];
    }];
}
-(UIView *)noNetworkView {
    if (!_noNetworkView) {
        _noNetworkView = [[UIView alloc] initWithFrame:CGRectMake(0, MH_APPLICATION_TOP_BAR_HEIGHT, MH_SCREEN_WIDTH, MH_SCREEN_HEIGHT)];
        _noNetworkView.backgroundColor = MH_WHITECOLOR;
        _noNetworkView.userInteractionEnabled = YES;
        UIImage *image = MHImageNamed(@"wangluoyichang_icon");
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, (MH_SCREEN_HEIGHT-image.size.height/image.size.width*(MH_SCREEN_WIDTH-100))/2, MH_SCREEN_WIDTH-100, image.size.height/image.size.width*(MH_SCREEN_WIDTH-100))];
        imageView.userInteractionEnabled = YES;
        imageView.image = image;
        [_noNetworkView addSubview:imageView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            if (self.viewModel.retryRequestHandle) {
                self.viewModel.retryRequestHandle();
            }
        }];
        [imageView addGestureRecognizer:tap];
    }
    return _noNetworkView;
}
// bind the viewModel
- (void)bindViewModel{
    /// set navgation title
    
    NSLog(@"--- %@" , self.viewModel.title);
    @weakify(self);
    
    RAC(self.navigationItem , title) = RACObserve(self, viewModel.title);
    /// 绑定错误信息
    [self.viewModel.errors subscribeNext:^(NSError *error) {
        /// 这里可以统一处理某个错误，例如用户授权失效的的操作
        NSLog(@"...错误...");
    }];
    /// 动态改变是否允许侧滑返回手势
    [[[RACObserve(self.viewModel, interactivePopDisabled) distinctUntilChanged] deliverOnMainThread] subscribeNext:^(NSNumber * x) {
        @strongify(self);
        self.fd_interactivePopDisabled = x.boolValue;
    }];
    [self.viewModel.services.client.noNetworkSubject subscribeNext:^(NSNumber *x) {
        @strongify(self);
        if (x.integerValue) {
            if (self.viewModel.retryRequestHandle) {
                [self.view addSubview:self.noNetworkView];
            }
        }else{
            [self.noNetworkView removeFromSuperview];
            self.noNetworkView = nil;
        }
    }];
}
- (void)back {
    if (self.presentingViewController) {
        [self.viewModel.services dismissViewModelAnimated:YES completion:nil];
    } else {
        [self.viewModel.services popViewModelAnimated:YES];
    }
}
@end
