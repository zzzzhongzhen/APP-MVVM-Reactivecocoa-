//
//  ZZDropDownCustomView.m
//  ALaDinOTA
//
//  Created by 旮旯 on 2018/8/8.
//  Copyright © 2018年 旮旯. All rights reserved.
//

typedef NS_ENUM(NSUInteger, ZZDropCellSelectStatus) {
    ZZDropCellSelectStatusClose = 0,//关闭了下拉列表
    ZZDropCellSelectStatusOpen = 1,//打开了下拉列表
    ZZDropCellSelectStatusCloseSelect = 2//关闭了下拉列表,但是选择了内容
};

#import "ZZDropDownCustomView.h"

@interface ZZDropDownCustomViewCell()

@property (nonatomic, strong) UIButton *titleButton;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIColor *unSelectedColor;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, strong) UIImage *indicatorDownImage;
@property (nonatomic, strong) UIImage *indicatorUpImage;
@property (nonatomic, assign) ZZDropCellSelectStatus buttonStatus;
@property (nonatomic, copy) void (^selectMenuBlock)(void);
- (void)commonDefineWithunSelectedColor:(UIColor *)unSelectedColor
                            selectColor:(UIColor *)selectColor
                               textFont:(UIFont *)textFont
                     indicatorDownImage:(UIImage *)indicatorDownImage
                       indicatorUpImage:(UIImage *)indicatorUpImage;
@end

@implementation ZZDropDownCustomViewCell

- (UIButton *)titleButton {
    if (!_titleButton) {
        _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleButton.clipsToBounds = YES;
        [_titleButton addTarget:self action:@selector(tapMenu:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _titleButton;
}
-(void)commonDefineWithunSelectedColor:(UIColor *)unSelectedColor selectColor:(UIColor *)selectColor textFont:(UIFont *)textFont indicatorDownImage:(UIImage *)indicatorDownImage indicatorUpImage:(UIImage *)indicatorUpImage {
    _unSelectedColor = unSelectedColor;
    _selectedColor = selectColor;
    _textFont = textFont;
    _indicatorDownImage = indicatorDownImage;
    _indicatorUpImage = indicatorUpImage;
    self.titleButton.titleLabel.font = _textFont;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.titleButton];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}
- (void)tapMenu:(UIButton *)sender {
    if (self.selectMenuBlock) {
        self.selectMenuBlock();
    }
}
- (void)setButtonStatus:(ZZDropCellSelectStatus)buttonStatus {
    _buttonStatus = buttonStatus;
    switch (buttonStatus) {
        case ZZDropCellSelectStatusOpen:{
            [self.titleButton setTitleColor:_selectedColor forState:UIControlStateNormal];
            [self.titleButton setEdgeImage:_indicatorDownImage forState:UIControlStateNormal edgeInsetStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5 imageTopEdge:5];
        }
            break;
        case ZZDropCellSelectStatusClose:{
            [self.titleButton setTitleColor:_unSelectedColor forState:UIControlStateNormal];
            [self.titleButton setEdgeImage:_indicatorDownImage forState:UIControlStateNormal edgeInsetStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5 imageTopEdge:5];
        }
            break;
        case ZZDropCellSelectStatusCloseSelect:{
            [self.titleButton setTitleColor:_selectedColor forState:UIControlStateNormal];
            [self.titleButton setEdgeImage:_indicatorDownImage forState:UIControlStateNormal edgeInsetStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5 imageTopEdge:5];
        }
            break;
        default:
            break;
    }
}

@end


@interface ZZDropDownCustomView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, assign) NSInteger numberOfColum;
@property (nonatomic, strong) UIView *presentView;//当前屏幕显示的view
@property (nonatomic, assign) NSInteger presentIndex;//当前点击的index
@property (nonatomic, strong) NSMutableArray *buttonStatusArray;//存储按钮状态
@property (nonatomic, strong) NSMutableArray *viewDataSource;//存储返回的view集合
@property (nonatomic, strong) NSMutableArray *titleDataSource;//存储标题
@property (nonatomic, strong) NSMutableArray *heightDataSource;//存储view高度
@property (nonatomic, strong) NSMutableArray *staticTitleDataSource;//初始的title的数组

@end

#define ZUnSelectedColor [UIColor blackColor]
#define ZSelectedColor [UIColor colorWithRed:246/255.0 green:79/255.0 blue:0/255.0 alpha:1]
#define ZTextFont [UIFont boldSystemFontOfSize:13]
#define AnimateDuration 0.2

static NSString *CustomViewCell = @"CustomViewCell";

@implementation ZZDropDownCustomView

#pragma mark - Initilaztion
- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height{
    return [self initWithOrigin:origin width:[UIScreen mainScreen].bounds.size.width andHeight:height];
}
- (instancetype)initWithOrigin:(CGPoint)origin width:(CGFloat)width andHeight:(CGFloat)height {
    self = [self initWithFrame:CGRectMake(origin.x, origin.y, width, height)];
    if (self) {
        _unSelectedColor = ZUnSelectedColor;
        _selectedColor = ZSelectedColor;
        _textFont = ZTextFont;
    }
    return self;
}
- (void)reloadData {
    if (!self.dataSource) {
        return;
    }
    [self __reloadData];
}
- (void)__reloadData {
    [self setDataSource:self.dataSource];
    [self.menuCollectionView reloadData];
}
#pragma mark - LifeCycle
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.menuCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}
-(void)setDataSource:(id<ZZDropDownMenuDataSource>)dataSource {
    if (!dataSource) {
        return;
    }
    _dataSource = dataSource;
    _titleDataSource = [NSMutableArray array];
    _buttonStatusArray = [NSMutableArray array];
    _viewDataSource = [NSMutableArray array];
    _heightDataSource = [NSMutableArray array];
    
    _numberOfColum = [_dataSource numberofColum:self];
    for (int i = 0; i < _numberOfColum; i ++) {
        UIView *view = [_dataSource menu:self viewForColumAtIndex:i];
        view.clipsToBounds = YES;
        //如果返回的view为空,则赋值一个默认的view
        if (!view) {
            view = [[UIView alloc] initWithFrame:CGRectZero];
        }
        [_viewDataSource addObject:view];
        NSString *title = [_dataSource menu:self titleForColumAtIndex:i];
        if (!title) {
            title = @"";
        }
        [_titleDataSource addObject:title];
        if (_staticTitleDataSource && ![title isEqualToString:_staticTitleDataSource[i]]) {
            [_buttonStatusArray addObject:@(ZZDropCellSelectStatusCloseSelect)];
        }else{
            [_buttonStatusArray addObject:@(ZZDropCellSelectStatusClose)];
        }
        [_heightDataSource addObject:@([_dataSource menu:self heightForViewAtIndex:i])];
    }
    if (!_staticTitleDataSource) {
        _staticTitleDataSource = _titleDataSource;
    }
}
- (void)dealloc {
    
}
#pragma mark - UITableviewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _numberOfColum;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZZDropDownCustomViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CustomViewCell forIndexPath:indexPath];
    [cell commonDefineWithunSelectedColor:_unSelectedColor selectColor:_selectedColor textFont:_textFont indicatorDownImage:_indicatorDownImage indicatorUpImage:_indicatorUpImage];
    [cell.titleButton setTitle:_titleDataSource[indexPath.row] forState:UIControlStateNormal];
    cell.buttonStatus = [_buttonStatusArray[indexPath.row] integerValue];
    cell.selectMenuBlock = ^(){
        _presentIndex = indexPath.row;
        if ([self.delegate respondsToSelector:@selector(menu:didSelectRowAtIndex:)]) {
            [self.delegate menu:self didSelectRowAtIndex:_presentIndex];
        }
        [self setAllButtonStatusExcept];
    };
    return cell;
}
/**
 *  更新状态
 */
- (void)setAllButtonStatusExcept {
    [self.buttonStatusArray enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *title = _titleDataSource[idx];
        if (_presentIndex != idx){
            if (_staticTitleDataSource && ![title isEqualToString:_staticTitleDataSource[idx]]) {
                [_buttonStatusArray replaceObjectAtIndex:idx withObject:@(ZZDropCellSelectStatusCloseSelect)];
            }else{
                [_buttonStatusArray replaceObjectAtIndex:idx withObject:@(ZZDropCellSelectStatusClose)];
            }
        }else{
            if ([obj integerValue] == ZZDropCellSelectStatusOpen) {
                if (_staticTitleDataSource && ![title isEqualToString:_staticTitleDataSource[idx]]) {
                    [_buttonStatusArray replaceObjectAtIndex:idx withObject:@(ZZDropCellSelectStatusCloseSelect)];
                }else{
                    [_buttonStatusArray replaceObjectAtIndex:idx withObject:@(ZZDropCellSelectStatusClose)];
                }
                [self dissMissPresentView];
            }else{
                [_buttonStatusArray replaceObjectAtIndex:idx withObject:@(ZZDropCellSelectStatusOpen)];
                [self dissMissPresentView];
                _presentView = _viewDataSource[_presentIndex];
                [self presentFilterView:_presentView];
            }
        }
    }];
    [self.menuCollectionView reloadData];
}

- (void)presentFilterView:(UIView *)filterView {
    
    if (!filterView) return;
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
    [[UIApplication sharedApplication].keyWindow addSubview:filterView];
    [filterView layoutIfNeeded];//刷新布局
    
    __block CGFloat H = [_heightDataSource[_presentIndex] floatValue];
    CGRect rect = filterView.frame;
    rect.origin.y = CGRectGetMaxY(self.frame);
    rect.size.height = 0;
    filterView.frame = rect;
    [self __presentFilterView:filterView H:H];
}
- (void)__presentFilterView:(UIView *)filterView H:(CGFloat)h{
    [UIView animateWithDuration:AnimateDuration animations:^{
        CGRect rect = filterView.frame;
        rect.size.height = h;
        filterView.frame = rect;
    }];
}
- (void)dissMissPresentView {
    if (_presentView) [self __presentFilterView:_presentView H:0]; //[_presentView removeFromSuperview]
    if (_maskView) [self.maskView removeFromSuperview];
}
-(UICollectionView *)menuCollectionView {
    if (!_menuCollectionView) {
        _menuCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:self.layout];
        _menuCollectionView.backgroundColor = [UIColor clearColor];
        _menuCollectionView.delegate = self;
        _menuCollectionView.dataSource = self;
        _menuCollectionView.showsVerticalScrollIndicator = NO;
        _menuCollectionView.showsHorizontalScrollIndicator = NO;
        _menuCollectionView.scrollEnabled = NO;
        [_menuCollectionView registerClass:[ZZDropDownCustomViewCell class] forCellWithReuseIdentifier:CustomViewCell];
        [self addSubview:self.menuCollectionView];
    }
    return _menuCollectionView;
}
-(UICollectionViewFlowLayout *)layout
{
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width/_numberOfColum, self.frame.size.height);
        _layout.minimumInteritemSpacing = 0;
        _layout.minimumLineSpacing = 0;
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _layout;
}
-(UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame),CGRectGetWidth(self.frame) , [UIScreen mainScreen].bounds.size.height-CGRectGetMaxY(self.frame))];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.5;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setAllButtonStatusExcept)];
        [_maskView addGestureRecognizer:ges];
    }
    return _maskView;
}
@end
