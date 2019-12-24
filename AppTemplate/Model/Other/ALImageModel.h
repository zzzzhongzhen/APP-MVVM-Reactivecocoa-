//
//  ALImageModel.h
//  ALaCocoaOta
//
//  Created by 旮旯 on 2019/4/1.
//  Copyright © 2019年 旮旯. All rights reserved.
//

#import "ALBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ALImageModel : ALBaseModel

@property (nonatomic, copy) NSString *image_id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *width;
@property (nonatomic, copy) NSString *height;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *body;

@end

NS_ASSUME_NONNULL_END
