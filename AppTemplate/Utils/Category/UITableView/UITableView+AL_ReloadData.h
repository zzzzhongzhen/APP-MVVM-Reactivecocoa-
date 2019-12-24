//
//  UITableView+AL_ReloadData.h
//  ALanDinOTA
//
//  Created by 旮旯 on 2017/9/15.
//  Copyright © 2017年 旮旯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (AL_ReloadData)

@property (nonatomic, assign) BOOL firstReload;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) UIColor *backColor;
@property (nonatomic, strong) UIView *placeholderView;
@property (nonatomic, assign) BOOL shouldCoverHeadView;

-(void)al_realoadData;

@end
