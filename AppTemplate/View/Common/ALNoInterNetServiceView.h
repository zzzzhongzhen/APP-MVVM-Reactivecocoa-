//
//  ALNoInterNetServiceView.h
//  ALaCocoaOta
//
//  Created by 旮旯 on 2019/5/6.
//  Copyright © 2019 旮旯. All rights reserved.
//

#import "ALView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ALNoInterNetServiceView : ALView

@property (nonatomic, strong) void(^tryAgain)(void);


@end

NS_ASSUME_NONNULL_END
