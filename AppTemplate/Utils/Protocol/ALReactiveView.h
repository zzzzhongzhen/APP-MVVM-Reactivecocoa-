//
//  ALReactiveView.h
//  ALaCocoaOta
//
//  Created by 旮旯 on 2019/3/8.
//  Copyright © 2019年 旮旯. All rights reserved.
//

#ifndef ALReactiveView_h
#define ALReactiveView_h

#import <Foundation/Foundation.h>
//绑定viewmodel协议
@protocol ALReactiveView <NSObject>
/// Binds the given view model to the view.
///
/// viewModel - The view model
- (void)bindViewModel:(id)viewModel;

@end
#endif /* ALReactiveView_h */
