//
//  NSString+SBExtension.m
//  WeChat
//
//  Created by senba on 2017/8/4.
//  Copyright © 2017年 Senba. All rights reserved.
//

#import "NSString+SBExtension.h"

@implementation NSString (SBExtension)
- (NSString *)sb_removeBothEndsWhitespace {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)sb_removeBothEndsWhitespaceAndNewline {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)sb_trimWhitespace {
    NSMutableString *str = [self mutableCopy];
    CFStringTrimWhitespace((__bridge CFMutableStringRef)str);
    return str;
}

- (NSString *)sb_URLEncoding {
    NSString * result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault,
                                                                                              (CFStringRef)self,
                                                                                              NULL,
                                                                                              CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                              kCFStringEncodingUTF8 ));
    return result;
}

- (NSString *)sb_trimAllWhitespace {
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

+(NSString *)removeFloatAllZero:(double)testNumber{
    NSString * outNumber = [NSString stringWithFormat:@"%@",@(testNumber)];
    //价格格式化显示
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc]init];
    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    formatter.groupingSize = 9;
    NSString * formatterString = [formatter stringFromNumber:[NSNumber numberWithDouble:[outNumber doubleValue]]];
    //获取要截取的字符串位置
    NSRange range = [formatterString rangeOfString:@"."];
    if (range.length >0 ) {
        NSString * result = [formatterString substringFromIndex:range.location];
        if (result.length >= 4) {
            formatterString = [formatterString substringToIndex:formatterString.length - 1];
        }
    }
    return  formatterString;
}
+(NSString *)getEncryptIdCard:(NSString *)idcard {
    if (MHStringIsEmpty(idcard)) {
        return idcard;
    }
    NSMutableString *mstr = [NSMutableString stringWithString:idcard];
    if (idcard.length>15) {
        [mstr replaceCharactersInRange:NSMakeRange(6, 8) withString:@"********"];
    }
    return mstr.copy;
}

@end
