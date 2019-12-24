//
//  UIButton+ImageTitleSpacing.h
//  DouWan
//
//  Created by 旮旯 on 2017/12/2.
//  Copyright © 2017年 旮旯. All rights reserved.
//
typedef NS_ENUM(NSUInteger, MKButtonEdgeInsetsStyle) {
    MKButtonEdgeInsetsStyleTop, // image在上，label在下
    MKButtonEdgeInsetsStyleLeft, // image在左，label在右
    MKButtonEdgeInsetsStyleBottom, // image在下，label在上
    MKButtonEdgeInsetsStyleRight // image在右，label在左
};

#import <UIKit/UIKit.h>

@interface UIButton (ImageTitleSpacing)

/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
- (void)setEdgeImage:(UIImage *)image forState:(UIControlState)state edgeInsetStyle:(MKButtonEdgeInsetsStyle)style imageTitleSpace:(CGFloat)space;
/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 *  @param topspace image距上的偏移量
 */

- (void)setEdgeImage:(UIImage *)image forState:(UIControlState)state edgeInsetStyle:(MKButtonEdgeInsetsStyle)style imageTitleSpace:(CGFloat)space imageTopEdge:(CGFloat)topspace ;
@end
