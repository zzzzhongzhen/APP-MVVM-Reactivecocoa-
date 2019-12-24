//
//  ALAdModel.h
//  AppTemplate
//
//  Created by 旮旯 on 2019/12/24.
//  Copyright © 2019 旮旯. All rights reserved.
//

#import "ALBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ALAdModel : ALBaseModel

@property (nonatomic, copy) NSString *ad_id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *ad_image;
@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, copy) NSString *end_time;
@property (nonatomic, copy) NSString *click_url;
@property (nonatomic, copy) NSString *width;
@property (nonatomic, copy) NSString *height;

@end

NS_ASSUME_NONNULL_END
