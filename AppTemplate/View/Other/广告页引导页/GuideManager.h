//
//  GuideManager.h
//  Unicorn_User
//
//  Created by 提谱旅行 on 16/9/28.
//  Copyright © 2016年 旮旯网络. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdVertiseManager.h"

@interface GuideManager : NSObject

+ (instancetype)shared;

/**
 *  清除显示过的标记
 */
- (void)clearMark;

///显示引导页
- (void)showGuideViewWithImages ;

- (BOOL)shouldShowGuideView ;

///显示广告页
- (void)showAdsView ;


@end
