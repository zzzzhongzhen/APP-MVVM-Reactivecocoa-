//
//  ALProfileViewModel.m
//  ALHomestayPro
//
//  Created by 旮旯 on 2019/9/20.
//  Copyright © 2019 旮旯. All rights reserved.
//

#import "ALProfileViewModel.h"

@implementation ALProfileViewModel

-(void)initialize {
    [super initialize];
    
    self.prefersNavigationBarHidden = YES;
    self.dataSource = @[@"订单统计",@"房源管理",@"常见问题",@"客服中心",@"设置"];
}
//-(RACSignal *)reuestUserInfo {
//    return [self.services.client requestGetUserInfo];
//}
@end
