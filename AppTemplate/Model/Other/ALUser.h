//
//  ALUser.h
//  ALaCocoaOta
//
//  Created by 旮旯 on 2019/4/1.
//  Copyright © 2019年 旮旯. All rights reserved.
//

#import "ALBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ALUser : ALBaseModel

@property (nonatomic,copy) NSString *token;
@property (nonatomic,copy) NSString *nickName;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSString *homestayName;
@property (nonatomic,copy) NSString *homestayId;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *registerType;
@property (nonatomic,copy) NSString *callcenter;
@property (nonatomic,copy) NSString *creatSourceTime;
@property (nonatomic,strong) NSNumber *messageCount;


@property (nonatomic,assign) BOOL isPassWord;

@end

NS_ASSUME_NONNULL_END
