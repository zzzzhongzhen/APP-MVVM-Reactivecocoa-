//
//  RACSignal+ALHTTPResponseAddtion.h
//  ALaCocoaOta
//
//  Created by 旮旯 on 2019/4/1.
//  Copyright © 2019年 旮旯. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface RACSignal (ALHTTPResponseAddtion)

- (RACSignal *)mh_parsedResults;

@end

NS_ASSUME_NONNULL_END
