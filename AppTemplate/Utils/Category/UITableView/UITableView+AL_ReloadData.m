//
//  UITableView+AL_ReloadData.m
//  ALanDinOTA
//
//  Created by 旮旯 on 2017/9/15.
//  Copyright © 2017年 旮旯. All rights reserved.
//

#import "UITableView+AL_ReloadData.h"
#import <objc/runtime.h>

@implementation UITableView (AL_ReloadData)

- (NSString *)backColor {
    return objc_getAssociatedObject(self, @selector(backColor));
}
-(void)setBackColor:(NSString *)backColor
{
    objc_setAssociatedObject(self, @selector(backColor), backColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)imageName {
    return objc_getAssociatedObject(self, @selector(imageName));
}
-(void)setImageName:(NSString *)imageName
{
    objc_setAssociatedObject(self, @selector(imageName), imageName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIView *)placeholderView {
    return objc_getAssociatedObject(self, @selector(placeholderView));
}
- (void)setPlaceholderView:(UIView *)placeholderView {
    objc_setAssociatedObject(self, @selector(placeholderView), placeholderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)firstReload {
    return [objc_getAssociatedObject(self, @selector(firstReload)) boolValue];
}

- (void)setFirstReload:(BOOL)firstReload {
    objc_setAssociatedObject(self, @selector(firstReload), @(firstReload), OBJC_ASSOCIATION_ASSIGN);
}
- (BOOL)shouldCoverHeadView {
    return [objc_getAssociatedObject(self, @selector(shouldCoverHeadView)) boolValue];
}

- (void)setShouldCoverHeadView:(BOOL)shouldCoverHeadView {
    objc_setAssociatedObject(self, @selector(shouldCoverHeadView), @(shouldCoverHeadView), OBJC_ASSOCIATION_ASSIGN);
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
//        id obj = [[self alloc]init];
//        [obj swizzeMethod:@selector(reloadData) withMethod:@selector(al_realoadData)];
        
    });
}

- (void)swizzeMethod:(SEL)origSelector withMethod:(SEL)newSelector
{
    Class class = [self class];
    Method originalMethod = class_getInstanceMethod(class, origSelector);
    Method swizzledMethod = class_getInstanceMethod(class, newSelector);
    
    BOOL didAddMethod = class_addMethod(class, origSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class, newSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
}
-(void)al_realoadData
{
    [self reloadData];
    if (!self.firstReload) {
        [self checkEmpty];
    }
    self.firstReload = NO;
}
- (void)checkEmpty {
    BOOL isEmpty = YES;
    
    NSInteger totalRows = 0;
    id <UITableViewDataSource> dataSource = self.dataSource;
    NSInteger sections = 1;//默认一组
    if ([dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        sections = [dataSource numberOfSectionsInTableView:self] - 1;//获取当前TableView组数
    }
    for (NSInteger i = 0; i <= sections; i++) {
        NSInteger rows = [dataSource tableView:self numberOfRowsInSection:sections];//获取当前TableView各组行数
        if (rows) {
            totalRows += rows;
            isEmpty = NO;//若行数存在，不为空
        }
    }
    if (isEmpty) {//若为空，加载占位图
        [self.placeholderView removeFromSuperview];
        
        UIView *placeholderView = [[UIView alloc] init];
        placeholderView.backgroundColor = self.backColor?self.backColor:[UIColor whiteColor];
        self.placeholderView = placeholderView;
        [self addSubview:self.placeholderView];
        [self.placeholderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            if (self.shouldCoverHeadView) {
                make.top.mas_equalTo(0);
            }else{
                if (self.tableHeaderView) {
                    make.top.equalTo(self.tableHeaderView.mas_bottom).with.offset(0);
                } else {
                    make.top.mas_equalTo(0);
                }
            }
            make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width, self.height));
        }];
        if (!self.imageName || self.imageName.length<=0) {
            self.imageName = @"wushuju_icon";
        }
        UIImage *image = [UIImage imageNamed:self.imageName];
        UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
        imageview.contentMode = UIViewContentModeScaleAspectFill;
        [placeholderView addSubview:imageview];
        [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.placeholderView.centerX);
            make.top.mas_equalTo(100);
            make.size.mas_equalTo(CGSizeMake(image.size.width, image.size.height));
        }];
        self.mj_footer.hidden = YES;
    } else {//不为空，隐藏占位图
        self.placeholderView.hidden = YES;
        [self.placeholderView removeFromSuperview];
        if (totalRows<3) {
            self.mj_footer.hidden = YES;
        }else{
            self.mj_footer.hidden = NO;
        }
    }
}
@end
