//
//  ALConstantEnum.h
//  ALaCocoaOta
//
//  Created by 旮旯 on 2019/3/13.
//  Copyright © 2019年 旮旯. All rights reserved.
//

#ifndef ALConstantEnum_h
#define ALConstantEnum_h
typedef NS_ENUM(NSUInteger, ALOrderStatus) {
    ALOrderStatusNotpass= -2,    /// 审核未通过
    ALOrderStatusCancel = -1,    /// 取消
    ALOrderStatusHasCompleted = 0,    ///填写完成
    ALOrderStatusPendingReview = 1,       /// 待审核
    ALOrderStatusNotCheckIn = 2,       /// 待入住
    ALOrderStatusHasCheckIn = 3,    /// 已入住
    ALOrderStatusHasCheckout = 4,       /// 退房
    ALOrderStatusHasDone = 5,     /// 订单完成
};


#endif /* ALConstantEnum_h */
