//
//  ALOrderViewController.m
//  ALHomestayPro
//
//  Created by 旮旯 on 2019/9/20.
//  Copyright © 2019 旮旯. All rights reserved.
//

#import "ALOrderViewController.h"

@interface ALOrderViewController ()

@end

@implementation ALOrderViewController

@dynamic viewModel;
#pragma mark ============ LifeCyle ============
- (void)viewDidLoad {
    [super viewDidLoad];

    [self _setup];
}
#pragma mark ============ Setup ============
-(void)bindViewModel {
    [super bindViewModel];
}
- (void)_setup {
}
#pragma mark ============ Delegate ============
- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:@"ALOrderListTableViewCell"];
}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return AdaptW(210);
}
@end
