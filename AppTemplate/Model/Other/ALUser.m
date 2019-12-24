//
//  ALUser.m
//  ALaCocoaOta
//
//  Created by 旮旯 on 2019/4/1.
//  Copyright © 2019年 旮旯. All rights reserved.
//

#import "ALUser.h"

@implementation ALUser

// 归档
- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.nickName forKey:@"nick_name"];
    [encoder encodeObject:self.phone forKey:@"phone"];
    [encoder encodeObject:self.userId forKey:@"userId"];
    [encoder encodeObject:self.messageCount forKey:@"messageCount"];

    [encoder encodeObject:self.token forKey:@"token"];
    [encoder encodeObject:self.homestayName forKey:@"homestayName"];
    [encoder encodeObject:self.homestayId forKey:@"homestayId"];
    [encoder encodeObject:self.creatSourceTime forKey:@"creatSourceTime"];
    [encoder encodeObject:self.callcenter forKey:@"callcenter"];
    [encoder encodeObject:self.registerType forKey:@"registerType"];


}

// 解档
- (instancetype)initWithCoder:(NSCoder *)decoder {
    
    self = [super init];
    
    if (self) {

        self.nickName = [decoder decodeObjectForKey:@"nick_name"];
        self.phone = [decoder decodeObjectForKey:@"phone"];
        self.userId = [decoder decodeObjectForKey:@"userId"];

        self.messageCount = [decoder decodeObjectForKey:@"messageCount"];
        self.token = [decoder decodeObjectForKey:@"token"];
        self.homestayName = [decoder decodeObjectForKey:@"homestayName"];
        self.homestayId = [decoder decodeObjectForKey:@"homestayId"];
        self.creatSourceTime = [decoder decodeObjectForKey:@"creatSourceTime"];
        self.callcenter = [decoder decodeObjectForKey:@"callcenter"];
        self.registerType = [decoder decodeObjectForKey:@"registerType"];

    }
    return self;
}
-(NSString *)FAQ {
    return @"http://zhifua.wdkj.com/qa-list.html";
}

@end
