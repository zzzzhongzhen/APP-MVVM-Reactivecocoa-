//
//  NSURLSessionTask+BindDeallocSignal.h
//  ALHomestayPro
//
//  Created by 旮旯 on 2019/12/9.
//  Copyright © 2019 旮旯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSURLSessionTask (BindDeallocSignal)

- (void)bindViewControllerDealloc ;

@end

NS_ASSUME_NONNULL_END
