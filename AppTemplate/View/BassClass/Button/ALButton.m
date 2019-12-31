//
//  ALButton.m
//  ALaCocoaOta
//
//  Created by 旮旯 on 2019/3/8.
//  Copyright © 2019年 旮旯. All rights reserved.
//  自定义的按钮,如果没有绑定RACCommand则自定义高亮状态

#import "ALButton.h"

@implementation ALButton

+(instancetype)commonInit {
    ALButton *button = [ALButton buttonWithType:UIButtonTypeCustom];
    button.contentMode = UIViewContentModeScaleAspectFit;
    return button;
}
/// 自定义高亮状态
- (void)setHighlighted:(BOOL)highlighted {
    if (!self.rac_command) {
        if (highlighted) {
            self.alpha = 0.3;
        }else{
            self.alpha = 1;
        }
    }
}
-(void)setEnabled:(BOOL)enabled {
    if (enabled) {
        self.alpha = 1;
    }else{
        self.alpha = 0.3;
    }
}

@end
