//
//  RACSignal+ALHTTPResponseAddtion.m
//  ALaCocoaOta
//
//  Created by 旮旯 on 2019/4/1.
//  Copyright © 2019年 旮旯. All rights reserved.
//

#import "RACSignal+ALHTTPResponseAddtion.h"
#import "ALHTTPResponse.h"
#import "ALHomeViewModel.h"

@implementation RACSignal (ALHTTPResponseAddtion)

- (RACSignal *)mh_parsedResults {
    return [self map:^(ALHTTPResponse *response) {
        NSAssert([response isKindOfClass:ALHTTPResponse.class], @"Expected %@ to be an MHHTTPResponse.", response);
        return response.parsedResult;
    }] ;
}

@end
