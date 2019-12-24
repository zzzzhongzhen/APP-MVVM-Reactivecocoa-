//
//  UIView+Animation.m
//  ALHomestayPro
//
//  Created by 旮旯 on 2019/11/7.
//  Copyright © 2019 旮旯. All rights reserved.
//

#import "UIView+Animation.h"

@implementation UIView (Animation)

- (void)mh_addFadeAndScaleAnimation {
    self.alpha = 0;
    self.layer.shouldRasterize = YES;
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
    } completion:^(BOOL finished2) {
        self.layer.shouldRasterize = NO;
    }];
}

@end
