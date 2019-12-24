//
//  UIView+MHExtension.m
//  MHDevLibExample
//
//  Created by apple on 16/6/14.
//  Copyright © 2016年 Mike_He. All rights reserved.
//

#import "UIView+MHExtension.h"
#import <objc/runtime.h>

static void *MHExtensionBorderColorKey = &MHExtensionBorderColorKey;

@implementation UIView (MHExtension)
/**
 * 判断一个控件是否真正显示在主窗口
 */
- (BOOL)mh_isShowingOnKeyWindow
{
    // 主窗口
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    // 以主窗口左上角为坐标原点, 计算self的矩形框
    CGRect newFrame = [keyWindow convertRect:self.frame fromView:self.superview];
    CGRect winBounds = keyWindow.bounds;
    
    // 主窗口的bounds 和 self的矩形框 是否有重叠
    BOOL intersects = CGRectIntersectsRect(newFrame, winBounds);
    
    return !self.isHidden && self.alpha > 0.01 && self.window == keyWindow && intersects;
}

/**
 * xib创建的view
 */
+ (instancetype)mh_viewFromXib
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}


+ (instancetype)mh_viewFromXibWithFrame:(CGRect)frame {
    UIView *view = [self mh_viewFromXib];
    view.frame = frame;
    return view;
}

- (UITapGestureRecognizer *)addTapGestureRecogniserWithTarget:(id)target action:(SEL)action {
    [self setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tapGesture];
    return tapGesture;
}
- (void)addIOS11StyleCorner {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}
- (void)addCornerRadiusWithDirection:(UIRectCorner)corner radius:(CGFloat)radius {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
    
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}
/**
 * xib中显示的属性
 */
- (UIColor *)borderColor {
    return objc_getAssociatedObject(self, MHExtensionBorderColorKey);
}
-(void)setBorderColor:(UIColor *)borderColor {
    objc_setAssociatedObject(self, MHExtensionBorderColorKey, borderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.layer setBorderColor:borderColor.CGColor];
}
-(void)setBorderWidth:(CGFloat)borderWidth {
    [self.layer setBorderWidth:borderWidth];
}
-(void)setCornerRadius:(CGFloat)cornerRadius {
    [self.layer setCornerRadius:cornerRadius];
}
- (void)setMasksToBounds:(BOOL)masksToBounds {
    [self.layer setMasksToBounds:masksToBounds];
}
-(void)setIsMainBackColor:(BOOL)isMainBackColor {
    if (isMainBackColor) {
        self.backgroundColor = MH_MAIN_COLOR;
    }
}
-(void)setIsMainGreyBackColor:(BOOL)isMainGreyBackColor {
    if (isMainGreyBackColor) {
        self.backgroundColor = MH_MAIN_BACKGROUNDCOLOR;
    }
}


@end
