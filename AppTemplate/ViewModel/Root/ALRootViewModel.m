//
//  ALRootViewModel.m
//  ALaCocoaOta
//
//  Created by 旮旯 on 2018/8/27.
//  Copyright © 2018年 旮旯. All rights reserved.
//

#import "ALRootViewModel.h"

@interface ALRootViewModel()
/// The view model of `Home` interface.
@property (nonatomic, strong, readwrite) ALHomeViewModel *homeViewModel;

/// The view model of `Order` interface.
@property (nonatomic, strong, readwrite) ALOrderViewModel *orderViewModel;

/// The view model of `profile` interface.
@property (nonatomic, strong, readwrite) ALProfileViewModel *profileViewModel;

@end

@implementation ALRootViewModel

- (void)initialize {
    [super initialize];
    
    self.homeViewModel = [[ALHomeViewModel alloc] initWithServices:self.services params:nil];
    self.orderViewModel = [[ALOrderViewModel alloc] initWithServices:self.services params:nil];
    self.profileViewModel = [[ALProfileViewModel alloc] initWithServices:self.services params:nil];
}
@end
