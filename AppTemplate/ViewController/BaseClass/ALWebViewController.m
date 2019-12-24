
//
//  ALWebViewController.m
//  ALaCocoaOta
//
//  Created by 旮旯 on 2019/3/29.
//  Copyright © 2019年 旮旯. All rights reserved.
//

#import "ALWebViewController.h"
#import "ALLoginViewModel.h"
#import "ALNavigationController.h"

@interface ALWebViewController ()
/// webView
@property (nonatomic, weak, readwrite) WKWebView *webView;
/// 进度条
@property (nonatomic, readwrite, strong) UIProgressView *progressView;
/// 返回按钮
@property (nonatomic, readwrite, strong) UIBarButtonItem *backItem;
/// 分享按钮
@property (nonatomic, readwrite, strong) UIBarButtonItem *shareItem;
/// 关闭按钮 （点击关闭按钮  退出WebView）
@property (nonatomic, readwrite, strong) UIBarButtonItem *closeItem;
/// viewModel
@property (nonatomic, strong, readonly) ALWebViewModel *viewModel;

@property (nonatomic, strong) UIView *failView;

@end

@implementation ALWebViewController

@dynamic viewModel;

- (void)dealloc{
    MHDealloc;
    /// remove observer ,otherwise will crash
    [_webView stopLoading];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:self.progressView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.progressView removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// 添加断言，request错误 应用直接crash
    NSParameterAssert(self.viewModel.request);
    
    self.navigationItem.leftBarButtonItem = self.backItem;
    self.title = self.viewModel.title;

    if (self.viewModel.shouldShowShareButton) {
        self.navigationItem.rightBarButtonItem = self.shareItem;
    }
    
    NSString *userAgent = @"ios_app";//声明是以什么身份访问的网站
    
    if (!(MHIOSVersion>=9.0)) [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"userAgent":userAgent}];
    
    /// 注册JS
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    // Fixed : 自适应屏幕宽度js
    NSString *jsString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    WKUserScript *userScript = [[WKUserScript alloc] initWithSource:jsString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    // 添加自适应屏幕宽度js调用的方法
    [userContentController addUserScript:userScript];
    /// 赋值userContentController
    configuration.userContentController = userContentController;
    
//    WKWebView *webView = [[WKWebView alloc] initWithFrame:MH_SCREEN_BOUNDS configuration:configuration];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, MH_APPLICATION_TOP_BAR_HEIGHT, MH_SCREEN_WIDTH, MH_SCREEN_HEIGHT-MH_APPLICATION_TOP_BAR_HEIGHT) configuration:configuration];
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    
    if ((MHIOSVersion >= 9.0)) webView.customUserAgent = userAgent;
    self.webView = webView;
    [self.view addSubview:webView];
    
    /// oc调用js
    [webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
        NSLog(@"navigator.userAgent.result is ++++ %@", result);
    }];
    @weakify(self);
//    [RACObserve(self.webView, title) subscribeNext:^(id x) {
//        @strongify(self);
//        if (!self.viewModel.shouldDisableWebViewTitle) self.navigationItem.title = self.webView.title;
//    }];
    [RACObserve(self.webView, loading) subscribeNext:^(id x) {
        NSLog(@"--- webView is loading ---");
    }];
    [RACObserve(self.webView, estimatedProgress) subscribeNext:^(id x) {
        @strongify(self);
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        if(self.webView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }];
    
    /// 添加刷新控件
    if(self.viewModel.shouldPullDownToRefresh){
        [self.webView.scrollView mh_addHeaderRefresh:^(MJRefreshNormalHeader *header) {
            @strongify(self);
            [self.webView reload];
        }];
        [self.webView.scrollView.mj_header beginRefreshing];
    }
//    self.webView.scrollView.contentInset = self.contentInset;
    /// 适配 iPhone X + iOS 11，去掉安全区域
    MHAdjustsScrollViewInsets_Never(webView.scrollView);
    /// 加载请求数据
    [self.webView loadRequest:self.viewModel.request];
}
#pragma mark - 事件处理
- (void)_backItemDidClicked{ /// 返回按钮事件处理
    /// 可以返回到上一个网页，就返回到上一个网页
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }else{/// 不能返回上一个网页，就返回到上一个界面
        /// 判断 是Push还是Present进来的，
        if (self.presentingViewController) {
            [self.viewModel.services dismissViewModelAnimated:YES completion:NULL];
        } else {
            [self.viewModel.services popViewModelAnimated:YES];
        }
    }
}

- (void)_closeItemDidClicked{
    /// 判断 是Push还是Present进来的
    if (self.presentingViewController) {
        [self.viewModel.services dismissViewModelAnimated:YES completion:NULL];
    } else {
        [self.viewModel.services popViewModelAnimated:YES];
    }
}
- (void)_shareItemDidClicked {
}
- (UIEdgeInsets)contentInset{
    return UIEdgeInsetsMake(MH_APPLICATION_TOP_BAR_HEIGHT, 0, 0, 0);
}
-(UIView *)failView {
    if (!_failView) {
        _failView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MH_SCREEN_WIDTH, MH_SCREEN_HEIGHT-MH_APPLICATION_TOP_BAR_HEIGHT)];
        _failView.userInteractionEnabled = YES;
        _failView.backgroundColor = MH_WHITECOLOR;
        
        UIImage *image = MHImageNamed(@"wushuju_icon");
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        imageView.center = _failView.center;
        [_failView addSubview:imageView];
    }
    return _failView;
}
#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    /// js call OC function
    
}

#pragma mark - WKNavigationDelegate
/// 内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    /// 不显示关闭按钮
    if(self.viewModel.shouldDisableWebViewClose) return;
    
    UIBarButtonItem *backItem = self.navigationItem.leftBarButtonItems.firstObject;
    if (backItem) {
//        if ([self.webView canGoBack]) {
//            [self.navigationItem setLeftBarButtonItems:@[backItem, self.closeItem]];
//        } else {
            [self.navigationItem setLeftBarButtonItems:@[backItem]];
//        }
    }
}

// 导航完成时，会回调（也就是页面载入完成了）
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    if (self.viewModel.shouldPullDownToRefresh) [webView.scrollView.mj_header endRefreshing];
    [self.failView removeFromSuperview];
}

// 导航失败时会回调
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    if (self.viewModel.shouldPullDownToRefresh) [webView.scrollView.mj_header endRefreshing];
    [self.webView addSubview:self.failView];
}

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler {
    NSURLCredential *cred = [[NSURLCredential alloc] initWithTrust:challenge.protectionSpace.serverTrust];
    completionHandler(NSURLSessionAuthChallengeUseCredential, cred);
}

#pragma mark - WKUIDelegate
- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    /// CoderMike Fixed : 解决点击网页的链接 不跳转的Bug。
    WKFrameInfo *frameInfo = navigationAction.targetFrame;
    if (![frameInfo isMainFrame]) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

#pragma mark runJavaScript
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    [ALAlertHelper mh_showAlertViewWithTitle:nil message:message confirmTitle:@"我知道了"];
    completionHandler();
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    completionHandler(YES);
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    completionHandler(defaultText);
}



#pragma mark - Getter & Setter
- (UIProgressView *)progressView {
    if (!_progressView) {
        CGFloat progressViewW = MH_SCREEN_WIDTH;
        CGFloat progressViewH = 3;
        CGFloat progressViewX = 0;
        CGFloat progressViewY = CGRectGetHeight(self.navigationController.navigationBar.frame) - progressViewH + 1;
        UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(progressViewX, progressViewY, progressViewW, progressViewH)];
        progressView.progressTintColor = MH_MAIN_COLOR;
        progressView.trackTintColor = [UIColor clearColor];
        [self.view addSubview:progressView];
        self.progressView = progressView;
    }
    return _progressView;
}

- (UIBarButtonItem *)backItem
{
    if (_backItem == nil) {
        _backItem = [UIBarButtonItem mh_backItemWithTitle:@"返回" imageName:@"return_icon" target:self action:@selector(_backItemDidClicked)];
    }
    return _backItem;
}

- (UIBarButtonItem *)closeItem {
    if (!_closeItem) {
        _closeItem = [UIBarButtonItem mh_backItemWithTitle:@"" imageName:@"denglu_guanbi_icon" target:self action:@selector(_closeItemDidClicked)];
    }
    return _closeItem;
}
- (UIBarButtonItem *)shareItem
{
    if (_shareItem == nil) {
        _shareItem = [UIBarButtonItem mh_systemItemWithTitle:nil titleColor:nil imageName:@"fenxiang_hei_icon-" target:self selector:@selector(_shareItemDidClicked) textType:NO];
    }
    return _shareItem;
}


@end
