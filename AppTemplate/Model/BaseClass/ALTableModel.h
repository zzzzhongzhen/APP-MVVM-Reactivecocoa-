//
//  ALTableModel.h
//  ALHomestayPro
//
//  Created by 旮旯 on 2019/10/16.
//  Copyright © 2019 旮旯. All rights reserved.
//

#import "ALBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ALTableModel : ALBaseModel

@property (nonatomic, assign) NSUInteger totalCount;

@property (nonatomic, strong) NSArray *list;

@end

NS_ASSUME_NONNULL_END
