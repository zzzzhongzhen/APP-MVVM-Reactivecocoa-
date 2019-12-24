//
//  ALTextField.m
//  ALanDinOTA
//
//  Created by 旮旯 on 2017/8/23.
//  Copyright © 2017年 旮旯. All rights reserved.
//

#import "ALTextField.h"

@implementation ALTextField

-(id)initWithFrame:(CGRect)frame Icon:(UIImageView*)icon
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 15)];
        [view addSubview:icon];
        self.leftView = view;
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    return self;
}

-(CGRect) leftViewRectForBounds:(CGRect)bounds {
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 17;// 右偏10
    return iconRect;
}
//- (CGRect)placeholderRectForBounds:(CGRect)bounds {
//    CGRect placeholderRect = [super placeholderRectForBounds:bounds];
//    placeholderRect.origin.x += 10;
//    return placeholderRect;
//}
//-(CGRect)textRectForBounds:(CGRect)bounds {
//    CGRect textRect = [super textRectForBounds:bounds];
//    textRect.origin.x += 10;
//    return textRect;
//}
@end
