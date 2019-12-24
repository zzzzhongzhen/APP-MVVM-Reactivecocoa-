//
//  DwAdView.m
//  DouWan
//
//  Created by 旮旯 on 2018/1/25.
//  Copyright © 2018年 旮旯. All rights reserved.
//

#import "ALAdView.h"

@interface ALAdView()
{
    int showtime;  
}
@end

@implementation ALAdView

- (NSTimer *)countTimer {
    
    if (!_countTimer) {
        _countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    }
    return _countTimer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        showtime = 3;
        // 1.广告图片
        _adView = [[UIImageView alloc] initWithFrame:frame];
        _adView.userInteractionEnabled = YES;
        _adView.contentMode = UIViewContentModeScaleAspectFill;
        _adView.clipsToBounds = YES;
        // 为广告页面添加一个点击手势，跳转到广告页面
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToAd)];
        [_adView addGestureRecognizer:tap];
        
        // 2.跳过按钮
        CGFloat btnW = 60;
        CGFloat btnH = 30;
        _countBtn = [[UIButton alloc] initWithFrame:CGRectMake(MH_SCREEN_WIDTH - btnW - 24, MH_APPLICATION_STATUS_BAR_Diffrence+btnH, btnW, btnH)];
        [_countBtn addTarget:self action:@selector(removeAdvertView) forControlEvents:UIControlEventTouchUpInside];
        [_countBtn setTitle:[NSString stringWithFormat:@"跳过%d", showtime] forState:UIControlStateNormal];
        _countBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_countBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _countBtn.backgroundColor = [UIColor colorWithRed:38 /255.0 green:38 /255.0 blue:38 /255.0 alpha:0.6];
        _countBtn.layer.cornerRadius = 4;
        
        [self addSubview:_adView];
        [self addSubview:_countBtn];
        
    }
    return self;
}

- (void)setFilePath:(NSString *)filePath {
    
    _filePath = filePath;
    _adView.image = [UIImage imageWithContentsOfFile:filePath];
}

- (void)pushToAd {
    [self removeAdvertView];
    if (self.pushToAdBlock) {
        self.pushToAdBlock();
    }
}
- (void)countDown {
    _count --;
    if (_count <= 0) {
        [self.countTimer invalidate];
        self.countTimer = nil;
        [self removeAdvertView];
    }else{
        [_countBtn setTitle:[NSString stringWithFormat:@"跳过%d",_count] forState:UIControlStateNormal];
    }
}

// 广告页面的跳过按钮倒计时功能可以通过定时器或者GCD实现
- (void)show {

    [self startTimer];
    UIWindow *window = MHSharedAppDelegate.window;
    [window addSubview:self];
}

// 定时器倒计时
- (void)startTimer {
    
    _count = showtime;
    [[NSRunLoop mainRunLoop] addTimer:self.countTimer forMode:NSRunLoopCommonModes];
}
// 移除广告页面
- (void)removeAdvertView {
    // 停掉定时器
    [self.countTimer invalidate];
    self.countTimer = nil;
    [UIView animateWithDuration:0.3f animations:^{
        
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
//        POST_NOTIFICATION(MHGuideViewHasRemove);
    }];
    
}
@end
