//
//  ALHttpService.m
//  ALaCocoaOta
//
//  Created by 旮旯 on 2018/8/27.
//  Copyright © 2018年 旮旯. All rights reserved.
//

#import "ALHTTPService.h"
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import <CocoaSecurity/CocoaSecurity.h>
#import "ALLoginViewModel.h"

/**
 * 知识点
 //- (RACSignal *)replayLast 就是用Capacity为1的RACReplaySubject来替换- (RACSignal *)replay的`subject。
 其作用是使后来订阅者只收到最后的历史值。
 //- (RACSignal *)replayLazily和- (RACSignal *)replay的区别就是replayLazily会在第一次订阅的时候才订阅sourceSignal。
 //  replay、replayLast、replayLazily的区别 ReactiveCocoa提供了这三个简便的方法允许多个订阅者订阅一个信号，却不会重复执行订阅代码，并且能给新加的订阅者提供订阅前的值。
 replay和replayLast使信号变成热信号，且会提供所有值(-replay) 或者最新的值(-replayLast) 给订阅者。
 replayLazily 会提供所有的值给订阅者 replayLazily还是冷信号 避免了冷信号的副作用
 *
 */

/// The Http request error domain
NSString *const MHHTTPServiceErrorDomain = @"MHHTTPServiceErrorDomain";
/// 请求成功，但statusCode != 0
NSString *const MHHTTPServiceErrorResponseCodeKey = @"MHHTTPServiceErrorResponseCodeKey";
NSString * const MHHTTPServiceErrorMessagesKey = @"MHHTTPServiceErrorMessagesKey";


NSString * const MHHTTPServiceErrorRequestURLKey = @"MHHTTPServiceErrorRequestURLKey";
NSString * const MHHTTPServiceErrorHTTPStatusCodeKey = @"MHHTTPServiceErrorHTTPStatusCodeKey";
NSString * const MHHTTPServiceErrorDescriptionKey = @"MHHTTPServiceErrorDescriptionKey";

/// 连接服务器失败 default
NSInteger const MHHTTPServiceErrorConnectionFailed = 668;
NSInteger const MHHTTPServiceErrorJSONParsingFailed = 669;

NSInteger const MHHTTPServiceErrorBadRequest = 670;
NSInteger const MHHTTPServiceErrorRequestForbidden = 671;
/// 服务器请求失败
NSInteger const MHHTTPServiceErrorServiceRequestFailed = 672;
NSInteger const MHHTTPServiceErrorSecureConnectionFailed = 673;

@interface ALHTTPService ()
/// currentLoginUser
@property (nonatomic, readwrite, strong) ALUser *currentUser;
@property(nonatomic, strong, readwrite) ALKeyedSubscript *dataTaskDic;
@property(nonatomic, strong, readwrite) NSMutableArray *retryTaskArray;

@end

@implementation ALHTTPService

static id service_ = nil;
#pragma mark -  HTTPService
+(instancetype) sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service_ = [[self alloc] initWithBaseURL:[NSURL URLWithString:AL_DOMAIN] sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    });
    return service_;
}
+ (id)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service_ = [super allocWithZone:zone];
    });
    return service_;
}
- (id)copyWithZone:(NSZone *)zone {
    return service_;
}
-(ALKeyedSubscript *)dataTaskDic {
    if (!_dataTaskDic) {
        _dataTaskDic = [ALKeyedSubscript subscript];
    }
    return _dataTaskDic;
}
-(NSMutableArray *)retryTaskArray {
    if (!_retryTaskArray) {
        _retryTaskArray = [NSMutableArray array];
    }
    return _retryTaskArray;
}

- (void)saveUser:(ALUser *)user {
    /// 记录用户数据
    self.currentUser = user;
    /// 保存
    BOOL status = [NSKeyedArchiver archiveRootObject:user toFile:MHFilePathFromWeChatDoc(MHUserDataFileName)];
    NSLog(@"Save login user data， the status is %@",status?@"Success...":@"Failure...");
}
- (void)deleteUser {
    /// 删除
    self.currentUser = nil;
    BOOL status = [[NSFileManager defaultManager] removeItemAtPath:MHFilePathFromWeChatDoc(MHUserDataFileName) error:nil];
    NSLog(@"Delete login user data ， the status is %@",status?@"Success...":@"Failure...");
    
    //发出登录状态改变通知
    POST_NOTIFICATION(MHLoginStatusChangeNoti);
}
- (ALUser *)currentUser{
    if (!_currentUser) {
        _currentUser = [NSKeyedUnarchiver unarchiveObjectWithFile:MHFilePathFromWeChatDoc(MHUserDataFileName) exception:nil];
    }
    return _currentUser;
}
- (void)monitorNetWorkStatus {
    AFNetworkReachabilityManager * mgr = [AFNetworkReachabilityManager sharedManager];
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态发生改变的时候调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WIFI");
                self.networkStatus = AFNetworkReachabilityStatusReachableViaWiFi;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"流量");
                self.networkStatus = AFNetworkReachabilityStatusReachableViaWWAN;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                self.networkStatus = AFNetworkReachabilityStatusNotReachable;
                break;
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络!");
                self.networkStatus = AFNetworkReachabilityStatusUnknown;
                break;
            default:
                break;
        }
    }];
    // 开始监控
    [mgr startMonitoring];
}
- (void)retry {
    if (self.retryTaskArray.count) {
        [self.retryTaskArray enumerateObjectsUsingBlock:^(NSURLSessionTask *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            [task resume];
        }];
    }
}
- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(nullable NSURLSessionConfiguration *)configuration{
    if (self = [super initWithBaseURL:url sessionConfiguration:configuration]) {
        /// 配置
        [self _configHTTPService];
        [self monitorNetWorkStatus];
        self.noNetworkSubject = [RACSubject subject];
    }
    return self;
}
/// config service
- (void)_configHTTPService{
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
#if DEBUG
    responseSerializer.removesKeysWithNullValues = NO;
#else
    responseSerializer.removesKeysWithNullValues = YES;
#endif
    responseSerializer.readingOptions = NSJSONReadingAllowFragments;
    /// config
    self.responseSerializer = responseSerializer;
    self.requestSerializer = [AFJSONRequestSerializer serializer];

    /// 安全策略
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    //如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO
    //主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    securityPolicy.validatesDomainName = NO;
    self.securityPolicy = securityPolicy;
    /// 支持解析
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                      @"text/json",
                                                      @"text/javascript",
                                                      @"text/html",
                                                      @"text/plain",
                                                      @"text/html; charset=UTF-8",
                                                      nil];
}
-(void)enqueueBlankRequest {
    // 模拟网络请求，以弹窗提示是否使用网络数据
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    }];
    [sessionDataTask resume];
}
#pragma mark - Request

-(RACSignal *) enqueueRequest:(ALHTTPRequest *) request resultClass:(Class /*subclass of ALObject*/) resultClass {
//    if (self.networkStatus==AFNetworkReachabilityStatusNotReachable) {
//        return [RACSignal error:[NSError errorWithDomain:MHHTTPServiceErrorDomain code:-100 userInfo:nil]];
//    }
    /// request 必须的有值
    if (!request) return [RACSignal error:[NSError errorWithDomain:MHHTTPServiceErrorDomain code:-1 userInfo:nil]];
                                                                            
    @weakify(self);
    /// 覆盖manager请求序列化
    self.requestSerializer = [self _requestSerializerWithRequest:request];
    //同一请求在同一时间取消上次的请求
//    NSString *URL = [self.baseURL.absoluteString stringByAppendingString:request.urlParameters.path];
//    NSURLSessionDataTask *lastTask = [self.dataTaskDic objectForKeyedSubscript:URL];
//    if (lastTask) {
//        [lastTask cancel];
//        [self.dataTaskDic setObject:NULL forKeyedSubscript:URL];
//    }
//    [self.dataTaskDic setObject:task forKeyedSubscript:task.currentRequest.URL.absoluteString];
//    NSLog(@"set: URL===url:%@ paremter:%@",task.currentRequest.URL.absoluteString,parameters);
    
    /// 发起请求
    /// concat:按一定顺序拼接信号，当多个信号发出的时候，有顺序的接收信号。 这里传进去的参数，不是parameters而是之前通过
    /// urlParametersWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters;穿进去的参数
    return [[[self enqueueRequestWithPath:request.urlParameters.path parameters:request.urlParameters.parameters method:request.urlParameters.method]
             reduceEach:^RACStream *(NSURLResponse *response, NSDictionary * responseObject){
                 @strongify(self);
                 /// 请求成功 这里解析数据
                 return [[self parsedResponseOfClass:resultClass fromJSON:responseObject]
                         map:^(id parsedResult) {
                             ALHTTPResponse *parsedResponse = [[ALHTTPResponse alloc] initWithResponseObject:responseObject parsedResult:parsedResult];
                             NSAssert(parsedResponse != nil, @"Could not create MHHTTPResponse with response %@ and parsedResult %@", response, parsedResult);
                             return parsedResponse;
                         }];
             }]
            concat];
}
/// 请求数据
- (RACSignal *)enqueueRequestWithPath:(NSString *)path parameters:(id)parameters method:(NSString *)method {
    @weakify(self);
    /// 创建信号
    RACSignal *signal = [RACSignal createSignal:^(id<RACSubscriber> subscriber) {
        @strongify(self);
        /// 获取request
        NSError *serializationError = nil;
        NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:path relativeToURL:self.baseURL] absoluteString] parameters:parameters error:&serializationError];
        
        if (serializationError) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                [MBProgressHUD mh_hideHUD];
                [subscriber sendError:serializationError];
            });
#pragma clang diagnostic pop
            return [RACDisposable disposableWithBlock:^{
            }];
        }
        /// 获取请求任务
        __block NSURLSessionDataTask *task = nil;
        task = [self dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (error) {
                if (error.code == -999) {
                    //退出页面取消该请求,不做任何提示
                    [MBProgressHUD mh_hideHUD];
                    [subscriber sendCompleted];
                }else {
                    [self.noNetworkSubject sendNext:@1];
                    NSError *parseError = [self _errorFromRequestWithTask:task httpResponse:(NSHTTPURLResponse *)response responseObject:responseObject error:error];
                    [self HTTPRequestLog:responseObject path:request.URL body:parameters error:parseError];
                    [subscriber sendError:parseError];
                }
            } else {
                [self.noNetworkSubject sendNext:@0];
                /// 断言
                NSAssert([responseObject isKindOfClass:NSDictionary.class]&&!MHObjectIsNil(responseObject), @"responseObject is not an NSDictionary: %@", responseObject);
                /// 在这里判断数据是否正确
                /// 判断
                NSInteger statusCode = [responseObject[MHHTTPServiceResponseCodeKey] integerValue];
                if (statusCode == MHHTTPResponseCodeSuccess) {
                    //[MBProgressHUD mh_hideHUD];
                    [self HTTPRequestLog:responseObject path:request.URL body:parameters error:nil];
                    /// 打包成元祖 回调数据
                    [subscriber sendNext:RACTuplePack(response,responseObject)];
                    [subscriber sendCompleted];
                }else{
                    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                    userInfo[MHHTTPServiceErrorResponseCodeKey] = @(statusCode);
                    NSString *msgTips = responseObject[MHHTTPServiceResponseMsgKey];
            #if defined(DEBUG)||defined(_DEBUG)
                    /// 调试模式
                    msgTips = MHStringIsNotEmpty(msgTips)?[NSString stringWithFormat:@"%@(%zd)",msgTips,statusCode]:[NSString stringWithFormat:@"服务器出错了，请稍后重试(%zd)~",statusCode];
            #else
                    /// 发布模式
                    msgTips = MHStringIsNotEmpty(msgTips)?msgTips:@"服务器出错了，请稍后重试~";
            #endif
                    userInfo[MHHTTPServiceErrorMessagesKey] = msgTips;
                    if (task.currentRequest.URL != nil)   userInfo[MHHTTPServiceErrorRequestURLKey] = task.currentRequest.URL.absoluteString;
                    if (task.error != nil) userInfo[NSUnderlyingErrorKey] = task.error;
                    NSError *requestError = [NSError errorWithDomain:MHHTTPServiceErrorDomain code:statusCode userInfo:userInfo];
                    [self HTTPRequestLog:responseObject path:request.URL body:parameters error:requestError];
//                    [MBProgressHUD mh_hideHUD];
                    [MBProgressHUD mh_showTips:msgTips];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if (statusCode == MHHTTPResponseCodeNotLogin || statusCode == MHHTTPResponseCodeNotCerticate || statusCode == MHHTTPResponseCodeAcountNeedLogin) {
                            [self deleteUser];
                            ALLoginViewModel *viewModel = [[ALLoginViewModel alloc] initWithServices:MHSharedAppDelegate.services params:nil];
                            [MHSharedAppDelegate.services resetRootViewModel:viewModel];
                        }
                    });
                    [subscriber sendError:requestError];
                }
            }
        }];
        /// 开启请求任务
        [task resume];
//        /// 开启监听页面销毁信号
//        [task bindViewControllerDealloc];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
    /// replayLazily:replayLazily会在第一次订阅的时候才订阅sourceSignal
    /// 会提供所有的值给订阅者 replayLazily还是冷信号 避免了冷信号的副作用
    /// 但是replayLazily会导致调用信号里返回的RACDisposable 不起作用
    /// 用RACMulticastConnection必须使用autoconnect而不能使用connect, autoconnect会生成一个冷信号,但是避免了冷信号的副作用,而且RACDisposable会调用,connect会生成一个热信号,也就是不订阅也会执行信号里的请求,且RACDisposable不会调用,不符合需求
    
    RACMulticastConnection *multicastConnection = [signal publish];
    //生成一个冷连接信号
    RACSignal *connectionColdSignal = [multicastConnection autoconnect];

    return [connectionColdSignal
            setNameWithFormat:@"-enqueueRequestWithPath: %@ parameters: %@ method: %@", path, parameters , method];
}
                                    
#pragma mark Parsing (数据解析)
- (NSError *)parsingErrorWithFailureReason:(NSString *)localizedFailureReason {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[NSLocalizedDescriptionKey] = NSLocalizedString(@"Could not parse the service response.", @"");
    if (localizedFailureReason != nil) userInfo[NSLocalizedFailureReasonErrorKey] = localizedFailureReason;
    return [NSError errorWithDomain:MHHTTPServiceErrorDomain code:MHHTTPServiceErrorJSONParsingFailed userInfo:userInfo];
}

/// 解析数据
- (RACSignal *)parsedResponseOfClass:(Class)resultClass fromJSON:(NSDictionary *)responseObject {
    /// 必须是MHObject的子类 且 最外层responseObject必须是字典
    NSParameterAssert((resultClass == nil || [resultClass isSubclassOfClass:ALObject.class]));
    /// 这里主要解析的是 data:对应的数据
    responseObject = responseObject[MHHTTPServiceResponseDataKey];
    
    /// 解析
    return [RACSignal createSignal:^ id (id<RACSubscriber> subscriber) {
        /// 解析字典
        void (^parseJSONDictionary)(NSDictionary *) = ^(NSDictionary *JSONDictionary) {
            if (resultClass == nil) {
                [subscriber sendNext:JSONDictionary];
                return;
            }
            NSArray * JSONArray = JSONDictionary[MHHTTPServiceResponseDataListKey];
            //如果data{"list":[]}这种格式 只有list一个键值对且list是个数组
            if ([JSONArray isKindOfClass:[NSArray class]] && JSONDictionary.allKeys.count == 1) {
                /// 字典数组 转对应的模型
                NSArray *parsedObjects = [NSArray yy_modelArrayWithClass:resultClass.class json:JSONArray];
                
                /// 这里还需要解析是否是ALObject的子类
                for (id parsedObject in parsedObjects) {
                    /// 确保解析出来的类 也是 ALObject
                    NSAssert([parsedObject isKindOfClass:ALObject.class], @"Parsed model object is not an MHObject: %@", parsedObject);
                }
                [subscriber sendNext:parsedObjects];
                
            }else{
                /// 字典转模型
                ALObject *parsedObject = [resultClass yy_modelWithDictionary:JSONDictionary];
                if (parsedObject == nil) {
                    // 模型解析失败
                    NSError *error = [NSError errorWithDomain:@"" code:2222 userInfo:@{}];
                    [subscriber sendError:error];
                    return;
                }
                /// 确保解析出来的类 也是 BaseModel
                NSAssert([parsedObject isKindOfClass:ALObject.class], @"Parsed model object is not an BaseModel: %@", parsedObject);
                /// 发送数据
                [subscriber sendNext:parsedObject];
            }
        };
        
        if ([responseObject isKindOfClass:NSArray.class]) {
            
            if (resultClass == nil) {
                [subscriber sendNext:responseObject];
            }else{
                /// 数组 保证数组里面装的是同一种 NSDcitionary
                for (NSDictionary *JSONDictionary in responseObject) {
                    if (![JSONDictionary isKindOfClass:NSDictionary.class]) {
                        NSString *failureReason = [NSString stringWithFormat:NSLocalizedString(@"Invalid JSON array element: %@", @""), JSONDictionary];
                        [subscriber sendError:[self parsingErrorWithFailureReason:failureReason]];
                        return nil;
                    }
                }
                
                /// 字典数组 转对应的模型
                NSArray *parsedObjects = [NSArray yy_modelArrayWithClass:resultClass.class json:responseObject];
                
                /// 这里还需要解析是否是ALObject的子类
                for (id parsedObject in parsedObjects) {
                    /// 确保解析出来的类 也是 BaseModel
                    NSAssert([parsedObject isKindOfClass:ALObject.class], @"Parsed model object is not an BaseModel: %@", parsedObject);
                }
                [subscriber sendNext:parsedObjects];
            }
            [subscriber sendCompleted];
        } else if ([responseObject isKindOfClass:NSDictionary.class]) {
            /// 解析字典
            parseJSONDictionary(responseObject);
            [subscriber sendCompleted];
        } else if (responseObject == nil || [responseObject isKindOfClass:[NSNull class]]) {
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        } else {
            NSString *failureReason = [NSString stringWithFormat:NSLocalizedString(@"Response wasn't an array or dictionary (%@): %@", @""), [responseObject class], responseObject];
            [subscriber sendError:[self parsingErrorWithFailureReason:failureReason]];
        }
        return nil;
    }];
}
#pragma mark - Error Handling
/// 请求错误解析
- (NSError *)_errorFromRequestWithTask:(NSURLSessionTask *)task httpResponse:(NSHTTPURLResponse *)httpResponse responseObject:(NSDictionary *)responseObject error:(NSError *)error {
    /// 不一定有值，则HttpCode = 0;
    NSInteger HTTPCode = httpResponse.statusCode;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    /// default errorCode is MHHTTPServiceErrorConnectionFailed，意味着连接不上服务器
    NSInteger errorCode = MHHTTPServiceErrorConnectionFailed;
    NSString *errorDesc = @"服务器出错了，请稍后重试~";
    /// 其实这里需要处理后台数据错误，一般包在 responseObject
    /// HttpCode错误码解析 https://www.guhei.net/post/jb1153
    /// 1xx : 请求消息 [100  102]
    /// 2xx : 请求成功 [200  206]
    /// 3xx : 请求重定向[300  307]
    /// 4xx : 请求错误  [400  417] 、[422 426] 、449、451
    /// 5xx 、600: 服务器错误 [500 510] 、600
    NSInteger httpFirstCode = HTTPCode/100;
    if (httpFirstCode>0) {
        if (httpFirstCode==4) {
            /// 请求出错了，请稍后重试
            if (HTTPCode == 408) {
#if defined(DEBUG)||defined(_DEBUG)
                errorDesc = @"请求超时，请稍后再试(408)~"; /// 调试模式
#else
                errorDesc = @"请求超时，请稍后再试~";      /// 发布模式
#endif
            }else{
#if defined(DEBUG)||defined(_DEBUG)
                errorDesc = [NSString stringWithFormat:@"请求出错了，请稍后重试(%zd)~",HTTPCode];                   /// 调试模式
#else
                errorDesc = @"请求出错了，请稍后重试~";      /// 发布模式
#endif
            }
        }else if (httpFirstCode == 5 || httpFirstCode == 6){
            /// 服务器出错了，请稍后重试
#if defined(DEBUG)||defined(_DEBUG)
            errorDesc = [NSString stringWithFormat:@"服务器出错了，请稍后重试(%zd)~",HTTPCode];                      /// 调试模式
#else
            errorDesc = @"服务器出错了，请稍后重试~";       /// 发布模式
#endif
            
        }else if (!self.reachabilityManager.isReachable){
            /// 网络不给力，请检查网络
            errorDesc = @"网络开小差了，请稍后重试~";
        }
    }else{
        if (!self.reachabilityManager.isReachable){
            /// 网络不给力，请检查网络
            errorDesc = @"网络开小差了，请稍后重试~";
        }
    }
    switch (HTTPCode) {
        case 400:{
            errorCode = MHHTTPServiceErrorBadRequest;           /// 请求失败
            break;
        }
        case 403:{
            errorCode = MHHTTPServiceErrorRequestForbidden;     /// 服务器拒绝请求
            break;
        }
        case 422:{
            errorCode = MHHTTPServiceErrorServiceRequestFailed; /// 请求出错
            break;
        }
        default:
            /// 从error中解析
            if ([error.domain isEqual:NSURLErrorDomain]) {
#if defined(DEBUG)||defined(_DEBUG)
                errorDesc = [NSString stringWithFormat:@"请求出错了，请稍后重试(%zd)~",error.code];                   /// 调试模式
#else
                errorDesc = @"请求出错了，请稍后重试~";        /// 发布模式
#endif
                switch (error.code) {
                    case NSURLErrorSecureConnectionFailed:
                    case NSURLErrorServerCertificateHasBadDate:
                    case NSURLErrorServerCertificateHasUnknownRoot:
                    case NSURLErrorServerCertificateUntrusted:
                    case NSURLErrorServerCertificateNotYetValid:
                    case NSURLErrorClientCertificateRejected:
                    case NSURLErrorClientCertificateRequired:
                        errorCode = MHHTTPServiceErrorSecureConnectionFailed; /// 建立安全连接出错了
                        break;
                    case NSURLErrorTimedOut:{
#if defined(DEBUG)||defined(_DEBUG)
                        errorDesc = @"请求超时，请稍后再试(-1001)~"; /// 调试模式
#else
                        errorDesc = @"请求超时，请稍后再试~";        /// 发布模式
#endif
                        break;
                    }
                    case NSURLErrorNotConnectedToInternet:{
#if defined(DEBUG)||defined(_DEBUG)
                        errorDesc = @"网络开小差了，请稍后重试(-1009)~"; /// 调试模式
#else
                        errorDesc = @"网络开小差了，请稍后重试~";        /// 发布模式
#endif
                        break;
                    }
                }
            }
    }
    userInfo[MHHTTPServiceErrorHTTPStatusCodeKey] = @(HTTPCode);
    userInfo[MHHTTPServiceErrorDescriptionKey] = errorDesc;
    if (task.currentRequest.URL != nil) userInfo[MHHTTPServiceErrorRequestURLKey] = task.currentRequest.URL.absoluteString;
    if (task.error != nil) userInfo[NSUnderlyingErrorKey] = task.error;
    if (![task.currentRequest.URL.absoluteString containsString:@"owner/getUserInfo"] &&
        ![task.currentRequest.URL.absoluteString containsString:@"owner/logout"]) {
        [MBProgressHUD mh_showTips:errorDesc];
    }
    return [NSError errorWithDomain:MHHTTPServiceErrorDomain code:errorCode userInfo:userInfo];
}

/// 序列化
- (AFHTTPRequestSerializer *)_requestSerializerWithRequest:(ALHTTPRequest *) request{
    /// 获取基础参数（参数+拓展参数）
    NSMutableDictionary *parameters = [self _parametersWithRequest:request];
    /// 获取带签名的参数
//    NSString *sign = [self _signWithParameters:parameters];
    /// 赋值
//    parameters[MHHTTPServiceSignKey] = [sign length]?sign:@"";
    /// 请求序列化
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    /// 配置请求头
    for (NSString *key in parameters) {
        NSString *value = [[parameters[key] mh_stringValueExtension] copy];
        if (value.length==0) continue;
        /// value只能是字符串，否则崩溃
        [requestSerializer setValue:value forHTTPHeaderField:key];
    }
    return requestSerializer;
}
/// 基础的请求参数
-(NSMutableDictionary *)_parametersWithRequest:(ALHTTPRequest *)request{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    /// 模型转字典
    
    NSMutableDictionary *extendsUrlParams = (NSMutableDictionary *)[request.urlParameters.extendsParameters yy_modelToJSONObject];
    if ([extendsUrlParams count]) {
        [parameters addEntriesFromDictionary:extendsUrlParams];
    }
    if ([request.urlParameters.parameters count]) {
        [parameters addEntriesFromDictionary:request.urlParameters.parameters];
    }
    return parameters;
}
#pragma mark - Parameter 签名 MD5 生成一个 sign
/// 带签名的请求参数
-(NSString *)_signWithParameters:(NSDictionary *) parameters {
    /// 按照ASCII码排序
    NSArray *sortedKeys = [[parameters allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    NSMutableArray *kvs = [NSMutableArray array];
    for (id key in sortedKeys) {
        /// value 为 empty 跳过
        if(MHObjectIsNil(parameters[key])) continue;
        NSString * value = [parameters[key] mh_stringValueExtension];
        if (MHObjectIsNil(value)||!MHStringIsNotEmpty(value)) continue;
        value = [value sb_removeBothEndsWhitespaceAndNewline];
        value = [value sb_URLEncoding];
        [kvs addObject:[NSString stringWithFormat:@"%@=%@",key,value]];
    }
    /// 拼接私钥
    NSString *paramString = [kvs componentsJoinedByString:@"&"];
    NSString *keyValue = MHHTTPServiceKeyValue;
    NSString *signedString = [NSString stringWithFormat:@"%@&%@=%@",paramString,MHHTTPServiceKey,keyValue];
    
    /// md5
    return [CocoaSecurity md5:signedString].hexLower;
}

#pragma mark - 打印请求日志
- (void)HTTPRequestLog:(NSDictionary *)responseObject path:(NSURL *)url body:params error:(NSError *)error {
    NSLog(@">>>>>>>>>>>>>>>>>>>>>👇 REQUEST START 👇>>>>>>>>>>>>>>>>>>>>>>>>>>");
    NSLog(@"requestURL=========>:%@", url);
    NSLog(@"requestBody======>:%@", params);
    NSLog(@"response=========>:%@", responseObject);
    if (error) {
        NSLog(@"error============>:%@", error);
    }
    NSLog(@"Request===========>%@", error?@"失败":@"成功");
    NSLog(@"<<<<<<<<<<<<<<<<<<<<<👆 REQUEST FINISH 👆<<<<<<<<<<<<<<<<<<<<<<<<<<");
}

@end
