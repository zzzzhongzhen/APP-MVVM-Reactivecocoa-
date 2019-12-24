//
//  ALLineView.m
//  ALaCocoaOta
//
//  Created by 旮旯 on 2019/3/8.
//  Copyright © 2019年 旮旯. All rights reserved.
//

#import "ALLineView.h"

@implementation ALLineView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = MH_MAIN_LINE_COLOR_1;
//        self.height = MHGlobalBottomLineHeight;
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = MH_MAIN_LINE_COLOR_1;
//        self.height = MHGlobalBottomLineHeight;
    }
    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
}
@end
