//
//  ALTableViewController.h
//  ALaCocoaOta
//
//  Created by 旮旯 on 2018/8/27.
//  Copyright © 2018年 旮旯. All rights reserved.
//

#import "ALViewController.h"
#import "ALTableView.h"
#import "ALTableViewModel.h"
#import "JKSkeletonLoader.h"

@interface ALTableViewController : ALViewController<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, readonly, weak) ALTableView *tableView;

/// `tableView` 的内容缩进，default is UIEdgeInsetsMake(0,0,0,0)，you can override it
@property (nonatomic, readonly, assign) UIEdgeInsets contentInset;
/// `tableView的`上边距 ，default is MH_APPLICATION_TOP_BAR_HEIGHT，you can override it
@property (nonatomic, readonly, assign) CGFloat tableviewTop;
/// `tableView的`下边距 ，default is 0，you can override it
@property (nonatomic, readonly, assign) CGFloat tableviewBottom;

- (void)reloadData;

/// dequeueReusableCell
- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;

/// configure cell data
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object;

- (void)resetAllData ;

- (void)requestRemoteDataAtMorePage ;

@end
