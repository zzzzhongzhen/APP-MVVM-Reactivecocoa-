//
//  ALRootViewModel.h
//  ALaCocoaOta
//
//  Created by 旮旯 on 2018/8/27.
//  Copyright © 2018年 旮旯. All rights reserved.
//

#import "ALViewModel.h"
#import "ALHomeViewModel.h"
#import "ALOrderViewModel.h"
#import "ALProfileViewModel.h"

@interface ALRootViewModel : ALViewModel
/// The view model of `Home` interface.
@property (nonatomic, strong, readonly) ALHomeViewModel *homeViewModel;

/// The view model of `Order` interface.
@property (nonatomic, strong, readonly) ALOrderViewModel *orderViewModel;

/// The view model of `profile` interface.
@property (nonatomic, strong, readonly) ALProfileViewModel *profileViewModel;

@end
