//
//  ALNavigationController.h
//  ALaCocoaOta
//
//  Created by 旮旯 on 2018/8/27.
//  Copyright © 2018年 旮旯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALNavigationController : UINavigationController

@property (nonatomic , strong , readwrite) UIButton * backBtn;

/// 显示导航栏的细线
- (void)showNavigationBottomLine;
/// 隐藏导航栏的细线
- (void)hideNavigationBottomLine;
//导航栏设置透明度  不能在viewwillappear中设置 在viewdidload中
-(void)setNavgationBarClear:(CGFloat)alpha ;

-(void)back;

@end
