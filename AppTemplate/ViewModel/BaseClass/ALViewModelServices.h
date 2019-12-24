//
//  ALViewModelServices.h
//  视图模型服务层测协议 （导航栏操作的服务层 + 网络的服务层 ）

#import <Foundation/Foundation.h>
#import "ALNavigationProtocol.h"
#import "ALHTTPService.h"

@protocol ALViewModelServices <NSObject,ALNavigationProtocol>
/// 全局通过这个Client来请求数据，处理用户信息
@property (nonatomic, readonly, strong) ALHTTPService *client;

@end
