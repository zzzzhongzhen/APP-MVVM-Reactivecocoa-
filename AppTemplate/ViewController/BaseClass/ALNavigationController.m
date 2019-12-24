//
//  ALNavigationController.m
//  ALaCocoaOta
//
//  Created by 旮旯 on 2018/8/27.
//  Copyright © 2018年 旮旯. All rights reserved.
//

#import "ALNavigationController.h"
#import "ALViewController.h"

@interface ALNavigationController ()
/// 导航栏分隔线
@property (nonatomic , weak , readwrite) UIImageView * navigationBottomLine;

@end

@implementation ALNavigationController
-(UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.backgroundColor = MH_CLEARCOLOR;
        _backBtn.frame = CGRectMake(0, 0, 55, MH_APPLICATION_TOP_BAR_HEIGHT-MH_APPLICATION_STATUS_BAR_HEIGHT);
        [_backBtn setContentEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}
- (void)back {
    
}
#pragma mark ============ lifeCycle ============
// 第一次使用这个类调用一次
+(void)initialize {
    // 2.设置UINavigationBar的主题
    [self _setupNavigationBarTheme];
    
    // 3.设置UIBarButtonItem的主题
    [self _setupBarButtonItemTheme];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// IOS11之前隐藏系统的导航栏分割线
    if (!MH_iOS11_VERSTION_LATER) {
        [self setnavBottomLineHidden];
    }
    [self _setupNavigationBarBottomLine];
    //添加返回按钮
    [self.navigationBar addSubview:self.backBtn];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark ============ Private ============

#pragma mark - 设置导航栏的分割线
- (void)_setupNavigationBarBottomLine {
    
    CGFloat navSystemLineH = .5f;
    UIImageView *navSystemLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.navigationBar.mh_height - navSystemLineH, MH_SCREEN_WIDTH, navSystemLineH)];
    navSystemLine.backgroundColor = MHColor(223.0f, 223.0f, 221.0f);

    [self.navigationBar addSubview:navSystemLine];
    self.navigationBottomLine = navSystemLine;
}

/**
 *  设置UINavigationBarTheme的主题
 */
+ (void) _setupNavigationBarTheme{
    UINavigationBar *appearance = [UINavigationBar appearance];
    
    /// 设置背景
    //!!!: 必须设置为透明  不然布局有问题 ios8以下  会崩溃/ 如果iOS8以下  请再_setup里面 设置透明 self.navigationBar.translucent = YES;
    [appearance setTranslucent:YES]; /// 必须设置YES
    
    // 设置导航栏的样式
    [appearance setBarStyle:UIBarStyleDefault];
    //设置导航栏文字按钮的渲染色
    [appearance setTintColor:MH_MAIN_TEXTCOLOR];
    // 设置导航栏的背景渲染色
//    CGFloat rgb = 0.1;
    [appearance setBarTintColor:[UIColor whiteColor]];
    
    // 设置文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSFontAttributeName] = MHRegularFont(17.0f);
    textAttrs[NSForegroundColorAttributeName] = MH_MAIN_TEXTCOLOR;

    // UIOffsetZero是结构体, 只要包装成NSValue对象, 才能放进字典\数组中
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset =  CGSizeZero;
    textAttrs[NSShadowAttributeName] = shadow;
    [appearance setTitleTextAttributes:textAttrs];
    [appearance setShadowImage:[UIImage new]];
}
- (void)setnavBottomLineHidden
{
    if ([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        NSArray *list=self.navigationBar.subviews;
        for (id obj in list){
            if ([UIDevice currentDevice].systemVersion.floatValue >= 10.0)
            {//10.0的系统字段不一样
                UIView *view =   (UIView*)obj;
                for (UIView *obj2 in view.subviews) {
                    if ([obj2 isKindOfClass:[UIImageView class]] && obj2.height<2) {
                        UIImageView *image =  (UIImageView*)obj2;
                        image.hidden = YES;
                    }
                }
            }else{
                if ([obj isKindOfClass:[UIImageView class]]){
                    UIImageView *imageView=(UIImageView *)obj;
                    NSArray *list2=imageView.subviews;
                    for (UIView *obj2 in list2){
                        if ([obj2 isKindOfClass:[UIImageView class]]&& obj2.height<2){
                            UIImageView *imageView2=(UIImageView *)obj2;
                            imageView2.hidden=YES;
                        }
                    }
                }
            }
        }
    }
}

/**
 *  设置UIBarButtonItem的主题
 */
+ (void)_setupBarButtonItemTheme{
    // 通过appearance对象能修改整个项目中所有UIBarButtonItem的样式
    UIBarButtonItem *appearance = [UIBarButtonItem appearance];
    CGFloat fontSize = 15.0f;
    
    /**设置文字属性**/
    // 设置普通状态的文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = MH_MAIN_TEXTCOLOR;
    textAttrs[NSFontAttributeName] = MHRegularFont(fontSize);
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset =  CGSizeZero;
    textAttrs[NSShadowAttributeName] = shadow;
    [appearance setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    
    // 设置高亮状态的文字属性
    NSMutableDictionary *highTextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
    highTextAttrs[NSForegroundColorAttributeName] = [[UIColor whiteColor] colorWithAlphaComponent:.5f];
    [appearance setTitleTextAttributes:highTextAttrs forState:UIControlStateHighlighted];
    
    // 设置不可用状态(disable)的文字属性
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
    disableTextAttrs[NSForegroundColorAttributeName] = [[UIColor whiteColor] colorWithAlphaComponent:.5f];
    [appearance setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
}
#pragma mark - Public Method
/// 显示导航栏的细线
- (void)showNavigationBottomLine { self.navigationBottomLine.hidden = NO; }
/// 隐藏导航栏的细线
- (void)hideNavigationBottomLine{ self.navigationBottomLine.hidden = YES; }
//导航栏设置透明度
-(void)setNavgationBarClear:(CGFloat)alpha {

    //用这种方法设置导航栏透明度为零后,其他控制器导航栏都变成透明了,改不过来这是为啥?????
    //        [self.navigationBar setBackgroundImage:[UIImage mh_imageAlwaysShowOriginalImageWithImageName:@"navBarBackground"]  forBarMetrics:UIBarMetricsDefault];
    [[self.navigationBar subviews].firstObject setAlpha:alpha];
    [[self.navigationBar subviews].firstObject.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.alpha = alpha;
    }];

    [[[self topViewController] rac_signalForSelector:@selector(viewWillAppear:)] subscribeNext:^(id x) {
        [[self.navigationBar subviews].firstObject setAlpha:alpha];
        [[self.navigationBar subviews].firstObject.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.alpha = alpha;
        }];

    }];
    [[[self topViewController] rac_signalForSelector:@selector(viewWillDisappear:)] subscribeNext:^(id x) {
        [[self.navigationBar subviews].firstObject setAlpha:1];
        [[self.navigationBar subviews].firstObject.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.alpha = 1;
        }];
        self.navigationBar.hidden = NO;
    }];


}
#pragma mark ============ PushMethod ============
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 如果现在push的不是栈底控制器(最先push进来的那个控制器)
    if (self.viewControllers.count > 0){
        /// 隐藏底部tabbar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    // push
    [super pushViewController:viewController animated:animated];
}

@end
