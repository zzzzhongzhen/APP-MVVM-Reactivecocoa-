//
//  ALProfileViewController.m
//  ALHomestayPro
//
//  Created by 旮旯 on 2019/9/26.
//  Copyright © 2019 旮旯. All rights reserved.
//

#import "ALProfileViewController.h"
#import "ALProfileViewModel.h"

@interface ALProfileViewController ()

@property (nonatomic, strong) ALProfileViewModel *viewModel;

@end

@implementation ALProfileViewController

@dynamic viewModel;
#pragma mark ============ LifeCycle ============
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _setup];
}
#pragma mark ============ setup ============
- (void)_setup {
    
}
-(void)bindViewModel {
    [super bindViewModel];
    
}
@end
