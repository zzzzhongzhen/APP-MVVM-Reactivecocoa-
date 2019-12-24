//
//  ALView.m
//  ALaCocoaOta
//
//  Created by 旮旯 on 2019/3/8.
//  Copyright © 2019年 旮旯. All rights reserved.
//

#import "ALView.h"

@implementation ALView

+ (instancetype)getInstance_XIB{//获取IB创建的view的方法
    return [self mh_viewFromXib];
}

@end
