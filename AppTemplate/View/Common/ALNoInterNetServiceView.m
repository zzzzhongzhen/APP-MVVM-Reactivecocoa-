//
//  ALNoInterNetServiceView.m
//  ALaCocoaOta
//
//  Created by 旮旯 on 2019/5/6.
//  Copyright © 2019 旮旯. All rights reserved.
//

#import "ALNoInterNetServiceView.h"

@implementation ALNoInterNetServiceView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _setup];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setup];
    }
    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
}
- (void)_setup {
    self.backgroundColor = MH_WHITECOLOR;
    UIImage *image = MHImageNamed(@"wangluoyichang_icon");
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.userInteractionEnabled = YES;
    [self addSubview:imageView];

    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        if (self.tryAgain) {
            self.tryAgain();
        }
    }];
    [imageView addGestureRecognizer:ges];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.center);
        make.height.mas_equalTo(image.size.height);
        make.width.mas_equalTo(image.size.width);
    }];
}

@end
