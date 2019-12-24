//
//  ALTableModel.m
//  ALHomestayPro
//
//  Created by 旮旯 on 2019/10/16.
//  Copyright © 2019 旮旯. All rights reserved.
//

#import "ALTableModel.h"

@implementation ALTableModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list":[self class]};
}

@end
