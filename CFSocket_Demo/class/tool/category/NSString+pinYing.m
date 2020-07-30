//
//  NSString+pinYing.m
//  CFSocket_Demo
//
//  Created by edz on 2020/7/28.
//  Copyright © 2020 EDZ. All rights reserved.
//

#import "NSString+pinYing.h"
 
@implementation NSString (pinYing)

+ (NSString *)transformToPinYinWithChinese:(NSString *)chinese{
    if (chinese) {
        NSMutableString *pinyin = [chinese mutableCopy];
        CFStringTransform((__bridge CFMutableStringRef)pinyin, 0, kCFStringTransformMandarinLatin, NO);
        CFStringTransform((__bridge CFMutableStringRef)pinyin, 0, kCFStringTransformStripDiacritics, NO);
        pinyin = [pinyin stringByReplacingOccurrencesOfString:@" " withString:@""];
        return pinyin;
    }
    else{
        return chinese;
    }
}

@end
