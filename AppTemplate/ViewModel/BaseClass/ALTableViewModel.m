//
//  ALTableViewModel.m
//  ALaCocoaOta
//
//  Created by 旮旯 on 2018/9/7.
//  Copyright © 2018年 旮旯. All rights reserved.
//

#import "ALTableViewModel.h"

@interface ALTableViewModel()
/// request remote data cmd
@property (nonatomic, readwrite, strong) RACCommand *requestRemoteDataCommand;

@property (nonatomic, readwrite, strong) RACSubject *requestRemoteDataAtMorePageSubject;

@property (nonatomic, readwrite, strong) RACSubject *resetAllDataSubject;

@end

@implementation ALTableViewModel
- (void)initialize {
    [super initialize];
    
    self.page = 1;
    self.perPage = [MHLimitPageCount integerValue];
    self.shouldEndRefreshingWithNoMoreData = YES;
    self.shouldALRealoadData = YES;
    self.shouldLoadDataFistRefresh = YES;
    self.shouldAddLodingAnimate = NO;
    /// request remote data
    @weakify(self)
    self.requestRemoteDataCommand = [[RACCommand alloc] initWithSignalBlock:^(NSNumber *page) {
        @strongify(self)
        return [[self requestRemoteDataSignalWithPage:page.unsignedIntegerValue] takeUntil:self.rac_willDeallocSignal];
    }];
    self.requestRemoteDataAtMorePageSubject = [RACSubject subject];
    self.resetAllDataSubject = [RACSubject subject];

    /// 过滤错误信息
    [[self.requestRemoteDataCommand.errors
      filter:[self requestRemoteDataErrorsFilter]]
     subscribe:self.errors];
    
}

/// sub class can ovrride it
- (BOOL (^)(NSError *error))requestRemoteDataErrorsFilter {
    return ^(NSError *error) {
        return YES;
    };
}

- (id)fetchLocalData {
    return nil;
}

- (NSUInteger)offsetForPage:(NSUInteger)page {
    return (page - 1) * self.perPage;
}


- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    return [RACSignal empty];
}
@end
