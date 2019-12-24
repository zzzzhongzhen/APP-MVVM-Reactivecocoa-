//
//  ALHomeViewController.m
//  ALHomestayPro
//
//  Created by 旮旯 on 2019/9/20.
//  Copyright © 2019 旮旯. All rights reserved.
//

#import "ALHomeViewController.h"

@interface ALHomeViewController ()
@end

@implementation ALHomeViewController

@dynamic viewModel;
#pragma mark ============ LifeCycle ============
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _setup];    
}

#pragma mark ============ Setup ============
- (void)bindViewModel {
    [super bindViewModel];
}
- (void)_setup {
}
@end
