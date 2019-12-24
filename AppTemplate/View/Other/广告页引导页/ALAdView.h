//
//  DwAdView.h
//  DouWan
//
//  Created by 旮旯 on 2018/1/25.
//  Copyright © 2018年 旮旯. All rights reserved.
//

#import "ALView.h"

@interface ALAdView : ALView

@property (nonatomic, strong) NSTimer *countTimer;
@property (nonatomic, strong) UIImageView *adView;
@property (nonatomic, strong) UIButton *countBtn;
@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, assign) int count;
@property (nonatomic, copy) void(^pushToAdBlock)(void);

- (void)show;

@end
