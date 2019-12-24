//
//  UILabel+MHExtension.m
//  ALaCocoaOta
//
//  Created by 旮旯 on 2019/3/15.
//  Copyright © 2019年 旮旯. All rights reserved.
//

#import "UILabel+MHExtension.h"


static CGFloat pointSize;

@implementation UILabel (MHExtension)

-(void)setFontSize:(CGFloat)fontSize {
    self.font = MHLightFont(fontSize);
}
-(void)setBoldFontSize:(CGFloat)boldFontSize {
    self.font = MHSemiboldFont(boldFontSize);
}
-(void)setTextMainColor:(BOOL)textMainColor {
    if (textMainColor) {
        self.textColor = MH_MAIN_COLOR;
    }
}
- (void)setRegularTextColor:(BOOL)regularTextColor {
    if (regularTextColor) {
        self.textColor = MH_MAIN_TEXTCOLOR;
    }
}
-(void)setMoneyText:(NSString *)money {
    if (MHStringIsNotEmpty(money)) {
        if (!pointSize) {
            pointSize = self.font.pointSize;
        }
        NSString *mustr = [NSString stringWithFormat:@"¥%@",money];
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:mustr];
        [attributeStr addAttribute:NSFontAttributeName value:MHRegularFont(pointSize/2) range:[mustr rangeOfString:@"¥"]];
        [self setAttributedText:attributeStr];
    }
    
}
@end
