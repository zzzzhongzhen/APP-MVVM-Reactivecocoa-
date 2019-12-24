//
//  ALBaseModel.h
//  ALaCocoaOta
//
//  Created by 旮旯 on 2019/3/10.
//  Copyright © 2019年 旮旯. All rights reserved.
//  实现了NSCopying 和 NSMutableCopying协议的model基类

#import "ALObject.h"
#import <YYModel/YYModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface ALBaseModel : ALObject<NSCopying,NSMutableCopying>

@property (nonatomic, copy) NSString *success;
@property (nonatomic, copy) NSString *message;

@end

NS_ASSUME_NONNULL_END
