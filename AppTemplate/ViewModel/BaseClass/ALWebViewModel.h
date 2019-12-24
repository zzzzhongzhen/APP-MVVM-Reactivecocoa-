//
//  ALWebViewModel.h
//  ALaCocoaOta
//
//  Created by 旮旯 on 2019/3/29.
//  Copyright © 2019年 旮旯. All rights reserved.
//

#import "ALViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ALWebViewModel : ALViewModel

/// web url quest
@property (nonatomic, readwrite, copy) NSURLRequest *request;

/// 下拉刷新 defalut is NO
@property (nonatomic, readwrite, assign) BOOL shouldPullDownToRefresh;

/// 是否取消导航栏的title等于webView的title。默认是不取消，default is NO
@property (nonatomic, readwrite, assign) BOOL shouldDisableWebViewTitle;

/// 是否取消关闭按钮。默认是不取消，default is NO
@property (nonatomic, readwrite, assign) BOOL shouldDisableWebViewClose;
///banner点进来的 用于分享
@property (nonatomic, readwrite, copy) NSString *banner_id;

@property (nonatomic, readwrite, assign) BOOL shouldShowShareButton;
///分享的时候需要传的参数
@property (nonatomic, readwrite, copy) NSString *model;

@property (nonatomic, readwrite, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END
