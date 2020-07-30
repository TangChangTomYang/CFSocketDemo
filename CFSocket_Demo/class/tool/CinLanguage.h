//
//  CinLanguage.h
//  CinCommon
//
//  Created by WangYanwei on 14-1-4.
//  Copyright (c) 2014年 p. All rights reserved.
//

#import <UIKit/UIDevice.h>
 

//#import "CinUIDevice.h"

#define NSInternational(key)                        [[CinLanguage sharedCinLanguage] getValue:key]
#define NSInternationalFormat(key,...)              [[CinLanguage sharedCinLanguage] getValueWithFormat:key, __VA_ARGS__]
#define iOS_Version                                 [[[UIDevice currentDevice] systemVersion] floatValue]

#define kLanguageSystem                             @"system"
#define kLanguageEnglish                            iOS_Version >= 9.0 ? @"en-CN" : @"en"
// 系统为iOS11时，系统语言为英语，系统AppleLanguages 获取的值为en-CN //by wuyh 2018-3-27
// 没有测试iOS9,暂用9判断
#define kLanguageChineseTri                         iOS_Version >= 9.0 ? @"zh-Hant-CN" : @"zh-Hant"
//#define kLanguageChinese                            @"zh-Hans"
#define kLanguageChinese                            iOS_Version >= 9.0 ? @"zh-Hans-CN" : @"zh-Hans"

#define kLanguageFarsi                              @"farsi" //波斯语   //by wuyh 2018-3-27, 原类型未使用，此次复用修改
#define kLanguageMarathi                            @"mr"

#define kLanguageSystemTag                          @"-1"
#define kLanguageEnglishTag                         @"0"
#define kLanguageChineseTag                         @"1"
#define kLanguageFarsiTag                           @"2"    //波斯语使用 "2"
#define kLanguageMarathiTag                         @"3"
#define kLanguageChineseTriTag                      @"4"

#define kLanguagePlistVersion    @"1"   // 语言plist版本


@interface CinLanguage : NSObject

+ (instancetype)sharedInstance;

//返回用户选择的语言，可能会返回kLanguageSystem
- (NSString *)getUserSelectedLanguage;

//返回具体的语言，比如kLanguageEnglish、kLanguageChinese，肯定不会返回kLanguageSystem
- (NSString *)getCurrentLanguage;

- (NSString *)getCurrentLanguageTag;

- (NSArray *)getLanguageList;

- (void)changeLanguage:(NSString *)language;

- (NSString *)getValue:(NSString *)key;

- (NSString *)getValueWithFormat:(NSString *)key, ...;

- (NSInteger)getCurrentLanguageIndex;

@end
