//
//  ALControl.h
//  ALaCocoaOta
//
//  Created by 旮旯 on 2019/3/8.
//  Copyright © 2019年 旮旯. All rights reserved.
//

#import "ALView.h"
#import "YYGestureRecognizer.h"

NS_ASSUME_NONNULL_BEGIN

@interface ALControl : ALView

/// 图片
@property (nonatomic, readwrite , strong) UIImage *image;

/// 点击回调
@property (nonatomic, readwrite, copy) void (^touchBlock)(ALControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event);
/// 长按回调
@property (nonatomic, readwrite, copy) void (^longPressBlock)(ALControl *view, CGPoint point);

@end

NS_ASSUME_NONNULL_END
