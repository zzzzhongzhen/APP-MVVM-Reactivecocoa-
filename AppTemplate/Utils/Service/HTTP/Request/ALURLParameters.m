//
//  ALURLParameters.m
//  ALaCocoaOta
//
//  Created by 旮旯 on 2019/3/28.
//  Copyright © 2019年 旮旯. All rights reserved.
//

#import "ALURLParameters.h"
#import "ALHTTPService.h"

@implementation SBURLExtendsParameters

+ (instancetype)extendsParameters {
    return [[self alloc] init];
}
- (instancetype)init {
    self = [super init];
    if (self) {}
    return self;
}
-(NSString *)uuid {
    return [ALFileManager userdefalutforkey:UUID];
}
@end

@implementation ALURLParameters

//token和secret暂时先放在body里
-(NSDictionary *)parameters {
    NSMutableDictionary *muatbleDic = _parameters.mutableCopy;
    [muatbleDic setValue:[ALHTTPService sharedInstance].currentUser.token forKey:@"token"];

    return muatbleDic.copy;
}

+(instancetype)urlParametersWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters
{
    return [[self alloc] initUrlParametersWithMethod:method path:path parameters:parameters];
}
-(instancetype)initUrlParametersWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters
{
    self = [super init];
    if (self) {
        self.method = method;
        self.path = path;
        self.validLogin = YES;
        self.parameters = parameters;
        self.extendsParameters = [[SBURLExtendsParameters alloc] init];
    }
    return self;
}

@end
