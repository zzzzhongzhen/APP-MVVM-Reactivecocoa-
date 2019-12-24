//
//  ALTableViewModel.h
//  ALaCocoaOta
//
//  Created by 旮旯 on 2018/9/7.
//  Copyright © 2018年 旮旯. All rights reserved.
//

#import "ALViewModel.h"

@interface ALTableViewModel : ALViewModel

/// The data source of table view. 这里不能用NSMutableArray，因为NSMutableArray不支持KVO，不能被RACObserve
@property (nonatomic, readwrite, copy) NSArray *dataSource;

/// tableView‘s style defalut is UITableViewStylePlain , 只适合 UITableView 有效
@property (nonatomic, readwrite, assign) UITableViewStyle style;

@property (nonatomic, readwrite, assign) NSInteger separatorStyle;

/// 需要支持下来刷新 defalut is NO
@property (nonatomic, readwrite, assign) BOOL shouldPullDownToRefresh;
/// 刚初始化完下拉控件后需要马上刷新数据吗
@property (nonatomic, readwrite, assign) BOOL shouldLoadDataFistRefresh;

/// 需要支持上拉加载 defalut is NO
@property (nonatomic, readwrite, assign) BOOL shouldPullUpToLoadMore;
/// 是否数据是多段 (It's effect tableView's dataSource 'numberOfSectionsInTableView:') defalut is NO
@property (nonatomic, readwrite, assign) BOOL shouldMultiSections;
/// 是否在上拉加载后的数据,dataSource.count < pageSize 提示没有更多的数据.default is YES 默认做法是数据不够时，隐藏mj_footer
@property (nonatomic, readwrite, assign) BOOL shouldEndRefreshingWithNoMoreData;
//是否允许sectionHeader悬浮  defalut is NO
@property (nonatomic, readwrite, assign) BOOL shouldForbidSuspend;

/// 当前页 defalut is 1
@property (nonatomic, readwrite, assign) NSUInteger page;
/// 每一页的数据 defalut is 20
@property (nonatomic, readwrite, assign) NSUInteger perPage;
/// 总的数据量 用于判断是否展示无数据的footer
@property (nonatomic, readwrite, assign) NSUInteger totalNum;
/// 请求服务器数据的命令
@property (nonatomic, readonly, strong) RACCommand *requestRemoteDataCommand;
///重置所有数据  reset
@property (nonatomic, readonly, strong) RACSubject *resetAllDataSubject;
///刷新数据  尤其是当有分页的时候刷新某一cell需要调用这个方法
@property (nonatomic, readonly, strong) RACSubject *requestRemoteDataAtMorePageSubject;
/// 选中命令 eg:  didSelectRowAtIndexPath:
@property (nonatomic, readwrite, strong) RACCommand *didSelectCommand;
///列表无数据的话自动填充无数据占位图  如tableview都多个section或者有tableviewheader慎用  defalut is YES
@property (nonatomic, readwrite, assign) BOOL shouldALRealoadData;
///列表数据的加载动画 ,当第一次加载和重置数据的时候可以设置为YES  default is NO
@property (nonatomic, readwrite, assign) BOOL shouldAddLodingAnimate;

@property (nonatomic, readwrite, copy) NSString *emptyDataImageName;
@property (nonatomic, readwrite, strong) UIColor *emptyDataBackColor;
@property (nonatomic, readwrite, assign) BOOL shouldCoverHeadView;

/** fetch the local data */
- (id)fetchLocalData;

/// 请求错误信息过滤
- (BOOL (^)(NSError *error))requestRemoteDataErrorsFilter;

/// 当前页之前的所有数据
- (NSUInteger)offsetForPage:(NSUInteger)page;
/** request remote data or local data, sub class can override it
 *  page - 请求第几页的数据
 */
- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page;
@end
