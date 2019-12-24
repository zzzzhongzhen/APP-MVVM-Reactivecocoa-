//
//  NSLayoutConstraint+Adapt.h
//  ALHomestayPro
//
//  Created by 旮旯 on 2019/12/19.
//  Copyright © 2019 旮旯. All rights reserved.
//

#import <UIKit/UIKit.h>
// 基准屏幕宽度
#define kRefereWidth 375.0
#define kRefereHieght 667.0

// 以屏幕宽度为固定比例关系，来计算对应的值。假设：基准屏幕宽度375，floatV=10；当前屏幕宽度为750时，那么返回的值为20
#define AdaptW(floatValue) (floatValue*[[UIScreen mainScreen] bounds].size.width/kRefereWidth)
#define AdaptH(floatValue) (floatValue*[[UIScreen mainScreen] bounds].size.height/kRefereHieght)

NS_ASSUME_NONNULL_BEGIN

@interface NSLayoutConstraint (Adapt)

/// 自动进行比例适配    乘以x/标准宽度 的比例  都是以iphone6为基准
@property (nonatomic) IBInspectable BOOL adaptVertical;
/// 自动进行比例适配    乘以x/标准高度 的比例
@property (nonatomic) IBInspectable BOOL adaptHorizontal;

@end

NS_ASSUME_NONNULL_END
