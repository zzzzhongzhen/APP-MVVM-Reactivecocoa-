//
//  ALHomeViewModel.m
//  ALHomestayPro
//
//  Created by 旮旯 on 2019/9/20.
//  Copyright © 2019 旮旯. All rights reserved.
//

#import "ALHomeViewModel.h"
#import <YYModel/YYModel.h>

@interface ALHomeViewModel ()

@end

@implementation ALHomeViewModel

-(void)initialize {
    [super initialize];
}
-(RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    return [RACSignal empty];
}
@end
