//
//  ALTabBar.m
//  ALaCocoaOta
//
//  Created by 旮旯 on 2018/8/27.
//  Copyright © 2018年 旮旯. All rights reserved.
//

#import "ALTabBar.h"

@interface ALTabBar ()
/// divider
@property (nonatomic, readwrite, weak) UIView *divider ;
@end

@implementation ALTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        /// 去掉tabBar的分割线,以及背景图片
        self.backgroundColor = MH_WHITECOLOR;
        if( @available(iOS 13, *)) {
            UITabBarAppearance *appearance = self.standardAppearance.copy;
            appearance.backgroundImage = [UIImage new];
            appearance.shadowImage = [UIImage new];
            appearance.shadowColor = UIColor.clearColor;
            self.standardAppearance = appearance;
        } else {
            [self setShadowImage:[UIImage new]];
          //        [self setBackgroundImage:[UIImage mh_resizableImage:@"tabbarBkg_5x49"]];
            [self setBackgroundImage:[UIImage new]];
        }
        /// 添加细线,
        UIView *divider = [[UIView alloc] init];
        divider.backgroundColor = MHColor(167.0f, 167.0f, 170.0f);
        [self addSubview:divider];
        self.divider = divider;
    }
    return self;
}


#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self bringSubviewToFront:self.divider];
    self.divider.mh_height = MHGlobalBottomLineHeight;
    self.divider.mh_width = MH_SCREEN_WIDTH;
}

@end
