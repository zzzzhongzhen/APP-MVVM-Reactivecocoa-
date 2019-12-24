//
//  ALOrderViewModel.m
//  ALHomestayPro
//
//  Created by 旮旯 on 2019/9/20.
//  Copyright © 2019 旮旯. All rights reserved.
//

#import "ALOrderViewModel.h"
#import "ALTableModel.h"

@interface ALOrderViewModel ()

@property (nonatomic, strong)NSArray *orderList;

@end

@implementation ALOrderViewModel

-(void)initialize {
    [super initialize];
    
    self.title = @"";
    self.prefersNavigationBarHidden = NO;
    self.prefersNavigationBackBtnHidden = YES;
    self.prefersNavigationBarClear = YES;
    self.prefersNavigationBarBottomLineHidden = YES;
    self.shouldPullUpToLoadMore = YES;
    self.shouldPullDownToRefresh = YES;
    self.shouldEndRefreshingWithNoMoreData = YES;
    self.shouldLoadDataFistRefresh = NO;
    self.shouldResignOnTouchOutside = NO;
    self.keyboardDistanceFromTextField = 40;
    self.emptyDataBackColor = MH_MAIN_BACKGROUNDCOLOR;
    self.shouldAddLodingAnimate = YES;
    
    @weakify(self);
    RAC(self,orderList) = self.requestRemoteDataCommand.executionSignals.switchToLatest;
    
    RAC(self,dataSource) = [RACObserve(self, orderList) map:^(NSArray *hotelList) {
        @strongify(self);
        return [self dataSourceWithModel:hotelList];
    }];
    
    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSIndexPath *input) {
        return [RACSignal empty];
    }];
}
-(RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    NSArray * (^mapHotelList)(ALTableModel *) = ^(ALTableModel *model) {
        self.totalNum = model.totalCount;
        NSArray *products = model.list;
        if (page == 1) {
            /// 下拉刷新
        } else {
            /// 上拉加载
            products = @[(self.orderList ?: @[]).rac_sequence, products.rac_sequence].rac_sequence.flatten.array;
        }
        return products;
    };
    return [[self.services.client requestSetPassWordWithPassword:@""] map:mapHotelList];
}
#pragma mark ============ 请求结果转viewmodel ============
- (NSArray *)dataSourceWithModel:(NSArray *)list {
//    if (MHObjectIsNil(list)) return nil;
//    NSArray *viewModels = [list.rac_sequence map:^(ALOrderListModel *itemModel) {
//        ALOrderCellViewModel *viewModel = [[ALOrderCellViewModel alloc] initWithListModel:itemModel];
//        return viewModel;
//    }].array;
//    return viewModels ?: @[];
    return  @[];
}

@end
