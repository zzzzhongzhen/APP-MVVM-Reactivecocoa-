//
//  ALRouter.m
//  ALaCocoaOta
//
//  Created by 旮旯 on 2018/10/11.
//  Copyright © 2018年 旮旯. All rights reserved.
//

#import "ALRouter.h"


@interface ALRouter ()

/// viewModel到viewController的映射
@property (nonatomic, copy) NSDictionary *viewModelViewMappings;

@end

@implementation ALRouter

static ALRouter *sharedInstance_ = nil;

+ (id)allocWithZone:(struct _NSZone *)zone
{ 
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance_ = [super allocWithZone:zone];
    });
    return sharedInstance_;
}

- (id)copyWithZone:(NSZone *)zone
{
    return sharedInstance_;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance_ = [[self alloc] init];
    });
    return sharedInstance_;
}
- (ALViewController *)viewControllerForViewModel:(ALViewModel *)viewModel {
    NSString *viewController = self.viewModelViewMappings[NSStringFromClass(viewModel.class)];
    NSParameterAssert([NSClassFromString(viewController) isSubclassOfClass:[ALViewController class]]);
    NSParameterAssert([NSClassFromString(viewController) instancesRespondToSelector:@selector(initWithViewModel:)]);
    return [[NSClassFromString(viewController) alloc] initWithViewModel:viewModel];
}
/// 这里是viewModel -> ViewController的映射
/// 当push present resetRoot时必须在这添加映射关系
- (NSDictionary *)viewModelViewMappings {
    return @{@"ALNewFeatureViewModel":@"ALNewFeatureViewController",
             @"ALRootViewModel":@"ALRootTabBarViewController",
             @"ALHomeViewModel":@"ALHotelViewController",
             @"ALRegisterPhoneViewModel":@"ALRegisterPhoneViewController",
             @"ALLoginViewModel":@"ALLoginViewController",
             @"ALRegisterCodeViewModel":@"ALRegisterCodeViewController",
             @"ALForgetPassWordViewModel":@"ALForgetPasswordViewController",
             @"ALSetPassWordViewModel":@"ALSetPassWordViewController",
             @"ALLoginAuthenticationViewModel":@"ALLoginAuthenticationViewController",
             @"ALSettingViewModel":@"ALSettingViewController",
             @"ALWebViewModel":@"ALWebViewController",
             @"ALEditNickNameViewModel":@"ALEditNickNameViewController",
             @"ALChangePassWordViewModel":@"ALChangePassWordViewController",
             @"ALOpenGateTableViewModel":@"ALOpenGateRecordViewController",
             @"ALOrderRecordViewModel":@"ALOrderRecordViewController",
             @"ALOpenGateDetailViewModel":@"ALOpenGateRecordDetailViewController",
             @"ALAddNewOrderViewModel":@"ALAddNewOrderViewController",
             @"ALSwitchHomeStayViewModel":@"ALSwitchHomeStayViewController",
             @"ALOrderDetailViewModel":@"ALOrderDetailNewViewController",
             @"ALSelectRoomTypeViewModel":@"ALSelectRoomTypeViewController",
             @"ALRoomDetailViewModel":@"ALRoomDetailViewController",
             @"ALOpenGateRequestViewModel":@"ALOpenGateRequestViewController",
             @"ALOpengateReqDetailViewModel":@"ALOpengateReqDetailViewController",
             @"ALHomeStayDetailViewModel":@"ALHomeStayDetailViewController",
             @"ALHomeStayManagerViewModel":@"ALHomeStayManagerViewController",
             @"ALHomeStayManagerDetailViewModel":@"ALHomeStayManagerDetailViewController",
             @"ALStopOpenViewModel":@"ALStopOpenViewController",
             @"ALOpenGateRecordSearchViewModel":@"ALOpenGateRecordSearchViewController",
             @"ALSelectDateViewModel":@"ALSelectDateViewController",
             @"ALEditHomeStayViewModel":@"ALEditHomeStayViewController",
             @"ALOrderSourceStaticsViewModel":@"ALOrderSourceStaticsViewController",
             @"ALRoomStatusCalendarViewModel":@"ALRoomStatusCalendarViewController",
             @"ALMessageMenuViewModel":@"ALMessageMenuViewController",
             @"ALMessageListViewModel":@"ALMessageListViewController",
             @"ALOrderRecordDetailViewModel":@"ALOrderRecordDetailViewController",
             @"ALHomeTodayOrderViewModel":@"ALHomeTodayOrderViewController",
             @"ALPasswordManagerViewModel":@"ALPasswordManagerViewController",
             };
}

@end
