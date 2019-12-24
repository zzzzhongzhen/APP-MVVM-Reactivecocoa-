//
//  ALViewModelServicesImpl.m
//  WeChat
//
//  Created by senba on 2017/9/10.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "ALViewModelServicesImpl.h"

@implementation ALViewModelServicesImpl
@synthesize client = _client;
- (instancetype)init
{
    self = [super init];
    if (self) {
         _client = [ALHTTPService sharedInstance];
    }
    return self;
}

#pragma mark - SBNavigationProtocol empty operation
- (void)pushViewModel:(ALViewModel *)viewModel animated:(BOOL)animated {}

- (void)popViewModelAnimated:(BOOL)animated {}

- (void)popToRootViewModelAnimated:(BOOL)animated {}

- (void)presentViewModel:(ALViewModel *)viewModel animated:(BOOL)animated completion:(VoidBlock)completion {}

- (void)dismissViewModelAnimated:(BOOL)animated completion:(VoidBlock)completion {}

- (void)resetRootViewModel:(ALViewModel *)viewModel {}

@end
