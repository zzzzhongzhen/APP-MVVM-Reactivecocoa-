//
//  NSLayoutConstraint+Adapt.m
//  ALHomestayPro
//
//  Created by 旮旯 on 2019/12/19.
//  Copyright © 2019 旮旯. All rights reserved.
//

#import "NSLayoutConstraint+Adapt.h"

//定义常量 必须是C语言字符串
static char *AdapterScreenVerticalKey = "AdapterScreenVerticalKey";
static char *AdapterScreenHorizontalKey = "AdapterScreenHorizontalKey";

@implementation NSLayoutConstraint (Adapt)

//+(void)load {
//    swizzleSelector(self, @selector(setConstant:), @selector(al_setConstant:));
//}
//static inline void swizzleSelector(Class theClass, SEL originalSelector, SEL swizzledSelector) {
//    Method originalMethod = class_getInstanceMethod(theClass, originalSelector);
//    Method swizzledMethod = class_getInstanceMethod(theClass, swizzledSelector);
//
//    BOOL didAddMethod = class_addMethod(theClass, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
//
//    if (didAddMethod) {
//        class_replaceMethod(theClass, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
//    }else{
//        method_exchangeImplementations(originalMethod, swizzledMethod);
//    }
//
//}
//- (void)al_setConstant:(CGFloat)constant {
//    _constant = AdaptW(constant);
//}
-(void)setAdaptVertical:(BOOL)adaptVertical {
    NSNumber *number = @(adaptVertical);
    objc_setAssociatedObject(self, AdapterScreenVerticalKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (adaptVertical) {
        self.constant = AdaptW(self.constant);
    }
}
-(void)setAdaptHorizontal:(BOOL)adaptHorizontal {
    NSNumber *number = @(adaptHorizontal);
    objc_setAssociatedObject(self, AdapterScreenHorizontalKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (adaptHorizontal) {
        self.constant = AdaptH(self.constant);
    }
}
-(BOOL)adaptVertical {
    NSNumber *number = objc_getAssociatedObject(self, AdapterScreenVerticalKey);
    return number.boolValue;
}
-(BOOL)adaptHorizontal {
    NSNumber *number = objc_getAssociatedObject(self, AdapterScreenHorizontalKey);
    return number.boolValue;

}
@end
