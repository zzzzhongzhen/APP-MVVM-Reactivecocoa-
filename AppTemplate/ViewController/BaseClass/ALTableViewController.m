//
//  ALTableViewController.m
//  ALaCocoaOta
//
//  Created by 旮旯 on 2018/8/27.
//  Copyright © 2018年 旮旯. All rights reserved.
//

#import "ALTableViewController.h"
#import "UITableView+AL_ReloadData.h"
#import "JKSkeletonLoader.h"

@interface ALTableViewController ()
/// tableView
@property (nonatomic, readwrite, weak)   ALTableView *tableView;
/// contentInset defaul is (64 , 0 , 0 , 0)
@property (nonatomic, readwrite, assign) UIEdgeInsets contentInset;
/// tableviewTop defaul is 64
@property (nonatomic, readwrite, assign) CGFloat tableviewTop;
/// tableviewBottom defaul is 0
@property (nonatomic, readwrite, assign) CGFloat tableviewBottom;
///上一次请求的数据数量
@property (nonatomic, readwrite, assign) NSInteger lastDataSourceCount;
/// 视图模型
@property (nonatomic, readonly, strong) ALTableViewModel *viewModel;

@property (nonatomic, readonly, strong) JKSkeletonLoader *skeletonLoader;

@end

@implementation ALTableViewController

@dynamic viewModel;

#pragma mark ============ LifeCycle ============
- (void)dealloc
{
    // set nil
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置子控件
    [self _su_setupSubViews];

}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}
/// override
- (void)bindViewModel
{
    [super bindViewModel];
    
    /// observe viewModel's dataSource
    @weakify(self)
    [[[RACObserve(self.viewModel, dataSource) skip:1]
      deliverOnMainThread]
     subscribeNext:^(id x) {
        @strongify(self);
        // 刷新数据
        [self reloadData];
        [self.skeletonLoader removeLoaderFromTargetView:self.tableView];
     }];
    
    [self.viewModel.requestRemoteDataAtMorePageSubject subscribeNext:^(id x) {
        @strongify(self);
        [self requestRemoteDataAtMorePage];
    }];
    [self.viewModel.resetAllDataSubject subscribeNext:^(id x) {
        @strongify(self);
        [self resetAllData];
    }];
}
#pragma mark ============ Inherit ============
-(instancetype)initWithViewModel:(ALViewModel *)viewModel {
    self =  [super initWithViewModel:viewModel];
    if (self) {
        _skeletonLoader = [[JKSkeletonLoader alloc] init];
        if ([viewModel shouldRequestRemoteDataOnViewDidLoad]) {
            @weakify(self);
            [[self rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
                @strongify(self);
                if (self.viewModel.shouldAddLodingAnimate) {
                    [self addLoadingAnimate];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.viewModel.requestRemoteDataCommand execute:@1];
                    });
                }else{
                    [self.viewModel.requestRemoteDataCommand execute:@1];
                }
            }];
        }
    }
    return self;
}
#pragma mark - 设置子控件
- (void)_su_setupSubViews {
    ALTableView *tableView = [[ALTableView alloc] initWithFrame:CGRectMake(0, self.tableviewTop, MH_SCREEN_WIDTH, self.view.height-self.tableviewTop-self.tableviewBottom) style:self.viewModel.style];
    
    tableView.backgroundColor = MH_MAIN_BACKGROUNDCOLOR;
    tableView.separatorStyle = self.viewModel.separatorStyle;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.imageName = self.viewModel.emptyDataImageName;
    tableView.backColor = self.viewModel.emptyDataBackColor;
    tableView.shouldCoverHeadView = self.viewModel.shouldCoverHeadView;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.contentInset = self.contentInset;
    
    /// 添加加载和刷新控件
    if (self.viewModel.shouldPullDownToRefresh) {
        /// 下拉刷新
        @weakify(self);
        [self.tableView mh_addHeaderRefresh:^(MJRefreshNormalHeader *header) {
            /// 加载下拉刷新的数据
            @strongify(self);
            [self tableViewDidTriggerHeaderRefresh];
        }];
        if (self.viewModel.shouldLoadDataFistRefresh) {
            [self.tableView.mj_header beginRefreshing];
        }
    }
    if (self.viewModel.shouldPullUpToLoadMore) {
        /// 上拉加载
        @weakify(self);
        [self.tableView mh_addFooterRefresh:^(MJRefreshAutoNormalFooter *footer) {
            /// 加载上拉刷新的数据
            @strongify(self);
            [self tableViewDidTriggerFooterRefresh];
        }];
        /// 隐藏footer or 无更多数据
        RAC(self.tableView.mj_footer, hidden) = [[RACObserve(self.viewModel, dataSource)
                                                  deliverOnMainThread]
                                                 map:^(NSArray *dataSource) {
                                                     @strongify(self);
                                                     /// 无数据，默认隐藏mj_footer
                                                     NSUInteger count = dataSource.count;
                                                     if (count<self.viewModel.perPage) {
                                                         return @1;
                                                     }
                                                     if (self.viewModel.shouldEndRefreshingWithNoMoreData) {
                                                         return @0;
                                                     }
                                                     if (self.viewModel.totalNum<=self.viewModel.dataSource.count) {
                                                         return @1;
                                                     }
                                                     return @0;
                                                 }];
    }
    if (@available(iOS 11.0, *)) {
        /// 适配 iPhone X + iOS 11，
        if (!self.viewModel.prefersLargeTitle) {
            MHAdjustsScrollViewInsets_Never(tableView);
        }
    }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        self.automaticallyAdjustsScrollViewInsets = NO;
#pragma clang diagnostic pop
    }
    //fixed:estimatedRowHeight最好是设置为零,否则会导致tableview刷新之后contentSize计算不准确,出现抖动,只有在滚动之后才会得到正确的contentSize
    //http://www.cppcns.com/ruanjian/ios/216879.html
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    
}
#pragma mark - 上下拉刷新事件
/// 下拉事件
- (void)tableViewDidTriggerHeaderRefresh{
    @weakify(self)
    [[[self.viewModel.requestRemoteDataCommand
       execute:@1]
      deliverOnMainThread]
     subscribeNext:^(id x) {
         @strongify(self)
         self.viewModel.page = 1;
         /// 重置没有更多的状态
         if (self.viewModel.shouldEndRefreshingWithNoMoreData) [self.tableView.mj_footer resetNoMoreData];
     } error:^(NSError *error) {
         @strongify(self)
         /// 已经在bindViewModel中添加了对viewModel.dataSource的变化的监听来刷新数据,所以reload = NO即可
         [self.tableView.mj_header endRefreshing];
     } completed:^{
         @strongify(self)
         /// 已经在bindViewModel中添加了对viewModel.dataSource的变化的监听来刷新数据,所以只要结束刷新即可
         [self.tableView.mj_header endRefreshing];
         /// 请求完成
         [self _requestDataCompleted];
     }];
}
/// 上拉事件
- (void)tableViewDidTriggerFooterRefresh{
    @weakify(self);
    [[[self.viewModel.requestRemoteDataCommand
       execute:@(self.viewModel.page + 1)]
      deliverOnMainThread]  
     subscribeNext:^(id x) {
         @strongify(self)
         self.viewModel.page += 1;
     } error:^(NSError *error) {
         @strongify(self);
         [self.tableView.mj_footer endRefreshing];
     } completed:^{
         @strongify(self)
         [self.tableView.mj_footer endRefreshing];
         [self _requestDataCompleted];
     }];
    
}
#pragma mark - 重置数据
- (void)resetAllData {
    self.tableView.contentOffset = CGPointMake(0, 0);
    if (self.viewModel.shouldAddLodingAnimate) {
        [self addLoadingAnimate];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self tableViewDidTriggerHeaderRefresh];
        });
    }else{
        [self tableViewDidTriggerHeaderRefresh];
    }
}
#pragma mark - 刷新数据

- (void)requestRemoteDataAtMorePage{
    
    NSString *originPage = [MHLimitPageCount copy];
    int page = (int)self.viewModel.page;
    MHLimitPageCount = [NSString stringWithFormat:@"%d",(page*[MHLimitPageCount intValue])];
    @weakify(self);
    [[[self.viewModel.requestRemoteDataCommand
       execute:@1]
      deliverOnMainThread]
     subscribeNext:^(id x) {
     } error:^(NSError *error) {
         @strongify(self);
         self.viewModel.page = self.viewModel.dataSource.count<1?1:((self.viewModel.dataSource.count-1)/originPage.integerValue+1);
         MHLimitPageCount = originPage;
     } completed:^{
         @strongify(self)
         self.viewModel.page = self.viewModel.dataSource.count<1?1:((self.viewModel.dataSource.count-1)/originPage.integerValue+1);
         MHLimitPageCount = originPage;
         [self _requestDataCompleted];
     }];
}
                                
#pragma mark - 辅助方法
/// 请求完成
- (void)_requestDataCompleted {
    if (self.viewModel.totalNum<=self.viewModel.dataSource.count && self.viewModel.shouldEndRefreshingWithNoMoreData) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}
#pragma mark - 设置加载动画
- (void)addLoadingAnimate {
    self.viewModel.dataSource = @[@"",@"",@""];
    [self.skeletonLoader addLoaderToTargetView:self.tableView];
}
#pragma mark - sub class can override it
- (UIEdgeInsets)contentInset{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGFloat)tableviewTop {
    return MH_APPLICATION_TOP_BAR_HEIGHT;
}
- (CGFloat)tableviewBottom {
    return 0.f;
}
/// reload tableView data
- (void)reloadData{
    
    if (self.viewModel.shouldALRealoadData) {
        [self.tableView al_realoadData];
    }else{
        [self.tableView reloadData];
    }
}

/// duqueueReusavleCell
- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
}

/// configure cell data
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.viewModel.shouldMultiSections) return self.viewModel.dataSource ? self.viewModel.dataSource.count : 0;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.viewModel.shouldMultiSections) return [self.viewModel.dataSource[section] count];
    return self.viewModel.dataSource.count; 
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self tableView:tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    // fetch object
    id object = nil;
    if (self.viewModel.shouldMultiSections) object = self.viewModel.dataSource[indexPath.section][indexPath.row];
    
    if (self.viewModel.dataSource.count && self.viewModel.dataSource.count > indexPath.row) {
        if (!self.viewModel.shouldMultiSections) object = self.viewModel.dataSource[indexPath.row];
    }

    /// bind model
    [self configureCell:cell atIndexPath:indexPath withObject:(id)object];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // execute commond
    [self.viewModel.didSelectCommand execute:indexPath];
}

//禁止sectionheader悬浮
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.viewModel.shouldForbidSuspend) {
        CGFloat sectionHeaderHeight = 50;
        if(scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0,0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}
@end
