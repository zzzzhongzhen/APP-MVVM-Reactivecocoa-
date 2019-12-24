//
//  UIButton+ImageTitleSpacing.m
//  DouWan
//
//  Created by 旮旯 on 2017/12/2.
//  Copyright © 2017年 旮旯. All rights reserved.
//

#import "UIButton+ImageTitleSpacing.h"

@implementation UIButton (ImageTitleSpacing)

- (void)setEdgeImage:(UIImage *)image forState:(UIControlState)state edgeInsetStyle:(MKButtonEdgeInsetsStyle)style imageTitleSpace:(CGFloat)space {
    [self setEdgeImage:image forState:state edgeInsetStyle:style imageTitleSpace:space imageTopEdge:0.f];
}
- (void)setEdgeImage:(UIImage *)image forState:(UIControlState)state edgeInsetStyle:(MKButtonEdgeInsetsStyle)style imageTitleSpace:(CGFloat)space imageTopEdge:(CGFloat)topspace {
    
    [self setImage:image forState:state];
    // 1. 得到imageView和titleLabel的宽、高
    CGFloat imageWith = image.size.width;
    CGFloat imageHeight = image.size.height;
    
    CGFloat labelWidth = 0.0;
    CGFloat labelHeight = 0.0;

    ///如果说不先获取图片的尺寸获取label的尺寸就不准确???
    CGFloat kImageViewW = self.imageView.bounds.size.width;
    labelWidth = self.titleLabel.bounds.size.width;
    labelHeight = self.titleLabel.bounds.size.height;
    
    //        labelWidth = self.titleLabel.intrinsicContentSize.width;
    //        labelHeight = self.titleLabel.intrinsicContentSize.height;
    labelWidth = labelWidth>(self.frame.size.width-15)?(self.frame.size.width-15):labelWidth;
    labelHeight = labelHeight>self.frame.size.height?self.frame.size.height:labelHeight;

    // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    
    // 3. 根据style和space得到imageEdgeInsets和labelEdgeInsets的值
    switch (style) {
        case MKButtonEdgeInsetsStyleTop:
        {
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-space/2.0, 0, 0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-space/2.0, 0);
        }
            break;
        case MKButtonEdgeInsetsStyleLeft:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
        }
            break;
        case MKButtonEdgeInsetsStyleBottom:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight-space/2.0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(-imageHeight-space/2.0, -imageWith, 0, 0);
        }
            break;
        case MKButtonEdgeInsetsStyleRight:
        {
            imageEdgeInsets = UIEdgeInsetsMake(topspace, labelWidth+space/2.0, 0, -labelWidth-space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith-space/2.0, 0, imageWith+space/2.0);
        }
            break;
        default:
            break;
    }
    // 4. 赋值
    self.titleEdgeInsets = labelEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;

}

@end
