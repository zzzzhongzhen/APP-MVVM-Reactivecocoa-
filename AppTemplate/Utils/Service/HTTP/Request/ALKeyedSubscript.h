//
//  ALKeyedSubscript.h
//  ALaCocoaOta
//
//  Created by 旮旯 on 2019/3/28.
//  Copyright © 2019年 旮旯. All rights reserved.
//  参数

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ALKeyedSubscript : NSObject

/// 类方法
+ (instancetype) subscript;
/// 拼接一个字典
+ (instancetype)subscriptWithDictionary:(NSDictionary *) dict;
-(instancetype)initWithDictionary:(NSDictionary *) dict;
- (id)objectForKeyedSubscript:(id)key;
- (void)setObject:(id _Nullable)obj forKeyedSubscript:(id <NSCopying>)key;

/// 转换为字典
- (NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
