//
//  ALProfileViewModel.h
//  ALHomestayPro
//
//  Created by 旮旯 on 2019/9/20.
//  Copyright © 2019 旮旯. All rights reserved.
//

#import "ALTableViewModel.h"
#import "ALUser.h"
NS_ASSUME_NONNULL_BEGIN

@interface ALProfileViewModel : ALTableViewModel

@property (nonatomic, strong) ALUser *user;
-(RACSignal *)reuestUserInfo ;

@end

NS_ASSUME_NONNULL_END
