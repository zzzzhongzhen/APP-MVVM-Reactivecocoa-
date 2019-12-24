//
//  ALWebViewModel.m
//  ALaCocoaOta
//
//  Created by 旮旯 on 2019/3/29.
//  Copyright © 2019年 旮旯. All rights reserved.
//

#import "ALWebViewModel.h"

@implementation ALWebViewModel

- (instancetype)initWithServices:(id<ALViewModelServices>)services params:(NSDictionary *)params {
    self = [super initWithServices:services params:params];
    if (self) {
        self.request = params[MHViewModelRequestKey];
        self.banner_id = params[MHViewModelIDKey];
        self.title = params[MHViewModelOtherKey];
        self.shouldShowShareButton = YES;
        self.model = @"2";
    }
    return self;
}
-(void)initialize {
    [super initialize];
    self.prefersNavigationBackBtnHidden = YES;
}
@end
