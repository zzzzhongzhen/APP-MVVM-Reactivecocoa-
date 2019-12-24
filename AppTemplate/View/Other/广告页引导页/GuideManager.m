//
//  GuideManager.m
//  Unicorn_User
//
//  Created by 提谱旅行 on 16/9/28.
//  Copyright © 2016年 旮旯网络. All rights reserved.
//

#import "GuideManager.h"

static NSString *identifier = @"Cell";

@interface GuideViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *button;

@end

@implementation GuideViewCell

- (instancetype)init {
    self = [super init];
    if (self) {
        self.layer.masksToBounds = YES;
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.frame = [UIScreen mainScreen].bounds;
        _imageView.center = CGPointMake(MH_SCREEN_WIDTH/2, MH_SCREEN_HEIGHT/2);
    }
    return _imageView;
}

@end

@interface GuideManager ()<UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) UIImageView *adImageView;

@end

@implementation GuideManager

+ (instancetype)shared{
    static GuideManager *_staticObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _staticObject = [[GuideManager alloc]init];
    });
    return _staticObject;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:self.layout];
        _collectionView.bounces = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[GuideViewCell class] forCellWithReuseIdentifier:identifier];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)layout{
    if (!_layout) {
        CGRect screen = [UIScreen mainScreen].bounds;
        _layout = [UICollectionViewFlowLayout new];
        _layout.minimumInteritemSpacing = 0;
        _layout.minimumLineSpacing = 0;
        _layout.itemSize = screen.size;
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _layout;
}


- (void)clearMark {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *version = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [ud removeObjectForKey:[NSString stringWithFormat:@"TPGuide_%@", version]];
}

- (void)showGuideViewWithImages{
    NSArray *images = @[@"引导页1",@"引导页2",@"引导页3"];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *version = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];

    if ([self shouldShowGuideView]) {
        self.images = images;
        self.window = [UIApplication sharedApplication].keyWindow;
        
        [self.window addSubview:self.collectionView];
        [ud setBool:YES forKey:[NSString stringWithFormat:@"TPGuide_%@", version]];
        [ud synchronize];
    }
}
- (BOOL)shouldShowGuideView {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *version = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
    //根据版本号来区分是否要显示引导图
    BOOL noshow = [ud boolForKey:[NSString stringWithFormat:@"TPGuide_%@", version]];
    return !noshow && self.window == nil;
}
- (void)showAdsView {
    [[AdVertiseManager shareInstance] setupAdvert];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.images count];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.images.count-1) {
        [self removeSubViewForGuide];
    }
//    [self removeSubViewForGuide];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GuideViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    NSString *path = [self.images objectAtIndex:indexPath.row];
    UIImage *img = [UIImage imageNamed:path];
//    CGSize size = [self adapterSizeImageSize:img.size compareSize:[UIScreen mainScreen].bounds.size];
    cell.contentView.backgroundColor = MH_REDCOLOR;
    //自适应图片位置,图片可以是任意尺寸,会自动缩放.
//    cell.imageView.frame = CGRectMake(0, 0, size.width, size.height);
    cell.imageView.frame = CGRectMake(0, 0, MH_SCREEN_WIDTH, MH_SCREEN_HEIGHT);

    cell.imageView.image = img;
    cell.imageView.center = CGPointMake(MH_SCREEN_WIDTH/2, MH_SCREEN_HEIGHT/2);
    cell.imageView.contentMode = UIViewContentModeScaleToFill;
    return cell;
}

- (CGSize)adapterSizeImageSize:(CGSize)is compareSize:(CGSize)cs
{
    CGFloat w = cs.width;
    CGFloat h = cs.width / is.width * is.height;
    if (h < cs.height) {
        w = cs.height / h * w;
        h = cs.height;
    }
    return CGSizeMake(w, h);
}

- (void)removeSubViewForGuide{
    POST_NOTIFICATION(MHGuideViewHasRemove);
    [self.collectionView removeFromSuperview];
    [self setWindow:nil];
    [self setCollectionView:nil];
}
@end
