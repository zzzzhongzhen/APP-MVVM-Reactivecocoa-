//
//  ALBaseModel.m
//  ALaCocoaOta
//
//  Created by 旮旯 on 2019/3/10.
//  Copyright © 2019年 旮旯. All rights reserved.
//

#import "ALBaseModel.h"
#import <objc/runtime.h>

@implementation ALBaseModel

-(id)copyWithZone:(NSZone *)zone{
    ALBaseModel *model = [[[self class] allocWithZone:zone] init];
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i<count; i++) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:propertyName];
        if (value) {
            [model setValue:value forKey:propertyName];
        }
    }
    free(properties);
    return model;
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    ALBaseModel *model = [[[self class] allocWithZone:zone] init];
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i<count; i++) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:propertyName];
        if (value) {
            [model setValue:value forKey:propertyName];
        }
    }
    free(properties);
    return model;
}

@end
