//
//  UILabel+MHExtension.h
//  ALaCocoaOta
//
//  Created by 旮旯 on 2019/3/15.
//  Copyright © 2019年 旮旯. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

IB_DESIGNABLE
@interface UILabel (MHExtension)

@property (nonatomic) IBInspectable CGFloat fontSize;

@property (nonatomic) IBInspectable CGFloat boldFontSize;


@property (nonatomic) IBInspectable BOOL textMainColor;

@property (nonatomic) IBInspectable BOOL regularTextColor;

-(void)setMoneyText:(NSString *)money ;

@end

NS_ASSUME_NONNULL_END
