//
//  ALKeyedSubscript.m
//  ALaCocoaOta
//
//  Created by 旮旯 on 2019/3/28.
//  Copyright © 2019年 旮旯. All rights reserved.
//

@interface ALKeyedSubscript ()
/// 字典
@property (nonatomic, readwrite, strong) NSMutableDictionary *kvs;

@end

#import "ALKeyedSubscript.h"

@implementation ALKeyedSubscript

+ (instancetype) subscript {
    return [[self alloc] init];
}

+ (instancetype) subscriptWithDictionary:(NSDictionary *) dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.kvs = [NSMutableDictionary dictionary];
    }
    return self;
}

-(instancetype)initWithDictionary:(NSDictionary *) dict {
    self = [super init];
    if (self) {
        self.kvs = [NSMutableDictionary dictionary];
        if ([dict count]) {
            [self.kvs addEntriesFromDictionary:dict];
        }
    }
    return self;
}

- (id)objectForKeyedSubscript:(id)key {
    return key ? [self.kvs objectForKey:key] : nil;
}

- (void)setObject:(id _Nullable)obj forKeyedSubscript:(id <NSCopying>)key {
    
    if (key) {
        if (obj) {
            if ([obj isKindOfClass:NSString.class]) {
                NSString *str = (NSString *)obj;
                if (!MHStringIsEmpty(str)) {
                    [self.kvs setObject:obj forKey:key];
                }
            }else{
                [self.kvs setObject:obj forKey:key];
            }
        } else {
            [self.kvs removeObjectForKey:key];
        }
    }
}

- (NSDictionary *)dictionary {
    return self.kvs.copy;
}

@end
