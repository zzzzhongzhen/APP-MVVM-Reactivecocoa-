//
//  UIScrollView+MHLRefresh.h
//  ALaCocoaOta
//
//  Created by 旮旯 on 2018/9/10.
//  Copyright © 2018年 旮旯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh/MJRefresh.h>

@interface UIScrollView (MHLRefresh)

/// 添加下拉刷新控件
- (MJRefreshNormalHeader *)mh_addHeaderRefresh:(void(^)(MJRefreshNormalHeader *header))refreshingBlock;
/// 添加上拉加载控件
- (MJRefreshAutoNormalFooter *)mh_addFooterRefresh:(void(^)(MJRefreshAutoNormalFooter *footer))refreshingBlock;

@end
