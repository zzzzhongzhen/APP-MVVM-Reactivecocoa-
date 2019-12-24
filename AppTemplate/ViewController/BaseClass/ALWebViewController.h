//
//  ALWebViewController.h
//  ALaCocoaOta
//
//  Created by 旮旯 on 2019/3/29.
//  Copyright © 2019年 旮旯. All rights reserved.
//

#import "ALViewController.h"
#import "ALWebViewModel.h"
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ALWebViewController : ALViewController<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

/// webView
@property (nonatomic, weak, readonly) WKWebView *webView;
/// 内容缩进 (64,0,0,0)
@property (nonatomic, readonly, assign) UIEdgeInsets contentInset;

@end

NS_ASSUME_NONNULL_END
