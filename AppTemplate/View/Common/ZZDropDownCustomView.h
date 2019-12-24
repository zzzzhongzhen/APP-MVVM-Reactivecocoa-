//
//  ZZDropDownCustomView.h
//  ALaDinOTA
//
//  Created by 旮旯 on 2018/8/8.
//  Copyright © 2018年 旮旯. All rights reserved.
//

#import "UIButton+ImageTitleSpacing.h"

@interface ZZDropDownCustomViewCell : UICollectionViewCell

@end

@class ZZDropDownCustomView;

@protocol ZZDropDownMenuDelegate<NSObject>
@optional
- (void)menu:(ZZDropDownCustomView *)menu didSelectRowAtIndex:(NSInteger)index;

@end

/**
 *  数据源代理方法
 */
@protocol ZZDropDownMenuDataSource<NSObject>
@required
/**
 *  返回每一个item所对应的view
 */
- (UIView *)menu:(ZZDropDownCustomView *)menu viewForColumAtIndex:(NSInteger)index;
/**
 *  返回item的个数
 */
- (NSInteger)numberofColum:(ZZDropDownCustomView *)menu;
/**
 *  返回item的标题
 */
- (NSString *)menu:(ZZDropDownCustomView *)menu titleForColumAtIndex:(NSInteger)index;
/**
 *  返回item对应view的高度
 */
- (CGFloat)menu:(ZZDropDownCustomView *)menu heightForViewAtIndex:(NSInteger)index;

@end

@interface ZZDropDownCustomView : UIView
/**
 *  菜单列表
 */
@property (nonatomic, strong) UICollectionView *menuCollectionView;
/**
 *  菜单数据源,图片或者文字
 */
@property (nonatomic, strong) NSArray *titleArrays;
/**
 *  未选中菜单按钮文字颜色
 */
@property (nonatomic, strong) UIColor *unSelectedColor;
/**
 *  选中菜单按钮文字颜色
 */
@property (nonatomic, strong) UIColor *selectedColor;
/**
 *  文字字体
 */
@property (nonatomic, strong) UIFont *textFont;
/**
 *  下拉箭头图片
 */
@property (nonatomic, strong) UIImage *indicatorDownImage;
/**
 *  上拉箭头图片
 */
@property (nonatomic, strong) UIImage *indicatorUpImage;

@property (nonatomic, weak) id <ZZDropDownMenuDelegate> delegate;

@property (nonatomic, weak) id <ZZDropDownMenuDataSource> dataSource;

/**
 *  初始化方法
 */
- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height;

- (instancetype)initWithOrigin:(CGPoint)origin width:(CGFloat)width andHeight:(CGFloat)height;

- (void)dissMissPresentView;

- (void)reloadData;
@end


