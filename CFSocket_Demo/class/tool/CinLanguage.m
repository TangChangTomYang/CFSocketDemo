//
//  CinLanguage.m
//  CinCommon
//
//  Created by WangYanwei on 14-1-4.
//  Copyright (c) 2014年 p. All rights reserved.
//
#import "CinLanguage.h"
//#import "CinLogger.h"

#define kCurrent                    @"CurrentLanguage"
#define kDefault                    @"DefaultLanguage"
#define kList                       @"LanguageList"
#define kConfigPlistPath            [NSString stringWithFormat:@"%@/%@", NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0], @"CinLanguage.plist"]
#define kLanguagePlistVersionKey       @"LanguagePlistVersion"

@interface CinLanguage ()

@property (nonatomic, copy) NSString *currentLanguage;
@property (nonatomic, copy) NSString *defaultLanguage;
@property (nonatomic, copy) NSString *systemLanguage;
@property (nonatomic, retain) NSDictionary *languageList;
@property (nonatomic, retain) NSDictionary *languageDic;

@end

@implementation CinLanguage


static CinLanguage *_cLanguage = nil;
+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _cLanguage = [[self alloc] init];
    });
    return _cLanguage;
}

#pragma mark - init
- (id)init {
    self = [super init];
    if (self) {
        [self loadConfigFromPlist];
        [self loadDataFromPlist];
    }
    return self;
}

- (void)dealloc {
    self.currentLanguage = nil;
    self.defaultLanguage = nil;
    self.systemLanguage = nil;
    self.languageList = nil;
    self.languageDic = nil;
}

- (NSString *)description {
    NSMutableString *s = [[NSMutableString alloc] init];
    [s appendFormat:@"CurrentLanguage:%@\r\n", self.currentLanguage];
    [s appendFormat:@"DefaultLanguage:%@\r\n", self.defaultLanguage];
    [s appendFormat:@"SystemLanguage:%@\r\n", self.systemLanguage];
    [s appendFormat:@"LanguageList:\r\n%@\r\n", self.languageList];
    return s;
}

#pragma mark - Public

- (NSString *)getUserSelectedLanguage {
    return self.currentLanguage;
}

- (NSString *)getCurrentLanguage {
    return @"zh-Hans-CN";//再造手机银行无国际化要求
    NSString *language = self.currentLanguage;
    
    if ([language isEqualToString:kLanguageSystem])
    {
        language = self.systemLanguage;
    }
    if ([self.languageList objectForKey:language] == nil){
        language = self.defaultLanguage;
    }
    if ([language isEqualToString:kLanguageEnglish])
        return @"en";
    
    if ([language isEqualToString:@"zh-Hans"]){
        return @"zh-Hans";
    }
    if ([language containsString:@"zh-Hant"]){
        return @"zh-Hant";
    }
    // iOS 9以上，系统识别中文为zh-Hans-CN //by wuyh 2018-4-3
    if ([language isEqualToString:@"zh-Hans-CN"]) {
        return @"zh-Hans-CN";
    }
    // 新添波斯语
    if ([language isEqualToString:kLanguageFarsi]) {
        return @"farsi";
    }
    return language;
}

- (NSString *)getCurrentLanguageTag {
    NSString *key = [self getCurrentLanguage];
    if ([key isEqualToString:@"en"]) {
        key = kLanguageEnglish;
    } else if ([key isEqualToString:@"zh-Hant"]) {
        key = kLanguageChineseTri;
    }
    return [self.languageList objectForKey:key];
}

- (NSArray *)getLanguageList {
    return self.languageList.allKeys;
}

- (void)changeLanguage:(NSString *)language {
    if ([self.currentLanguage isEqualToString:language])
        return;
    [self changeLanguageInPlist:language];
    self.currentLanguage = language;
    [self loadDataFromPlist];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SettingChangeLanguage" object:language];
}

- (NSString *)getValue:(NSString *)key {
    if (![self.languageDic objectForKey:[key lowercaseString]]) {
        NSLog(@"CinLanguage -- Error Not Found the key ----key:%@,value:%@",key,[self.languageDic objectForKey:[key lowercaseString]]);
    }
    return [self.languageDic objectForKey:[key lowercaseString]]?[self.languageDic objectForKey:[key lowercaseString]]:@"";
}

- (NSString *)getValueWithFormat:(NSString *)key, ... {
    va_list params;
    va_start(params, key);
    NSString *msg = @"";
    if ([self getValue:key]) {
        msg = [[NSString alloc] initWithFormat:[self getValue:key] arguments:params];
    } else {
        NSLog(@"CinLanguage-- Error Not Found the key ---key:%@,value:%@",key,[self getValue:key]);
    }
    va_end(params);
    return msg;
}

#pragma mark - Private
- (void)loadConfigFromPlist {
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:kConfigPlistPath];
    if (data == nil){
        data = [self getConfigPlist];
    } else {
        // 如果存在version则判断版本号，
        NSString *version = [data objectForKey:kLanguagePlistVersionKey];
        if (!version || version.integerValue < kLanguagePlistVersion.integerValue) {
            //1.不存在版本号，2.存在版本号，但版本号更新了。
            data = [self getConfigPlist];
        }
    }
    self.currentLanguage = [data objectForKey:kCurrent];
    self.defaultLanguage = [data objectForKey:kDefault];
    self.systemLanguage = [self getSystemLanguage];
    [data removeObjectForKey:kCurrent];
    [data removeObjectForKey:kDefault];
    self.languageList = data;
}

- (void)loadDataFromPlist {
    NSString *path = [[NSBundle mainBundle] pathForResource:[self getCurrentLanguage] ofType:@"strings"];
    self.languageDic = [NSDictionary dictionaryWithContentsOfFile:path];
}

- (NSMutableDictionary *)getConfigPlist {
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setObject:kLanguagePlistVersion forKey:kLanguagePlistVersionKey];
    [data setObject:kLanguageSystem forKey:kCurrent];
    [data setObject:kLanguageEnglish forKey:kDefault];
    
    [data setObject:kLanguageSystemTag forKey:kLanguageSystem];
    [data setObject:kLanguageEnglishTag forKey:kLanguageEnglish];
    [data setObject:kLanguageChineseTag forKey:kLanguageChinese];
    [data setObject:kLanguageChineseTriTag forKey:kLanguageChineseTri];
    [data setObject:kLanguageFarsiTag forKey:kLanguageFarsi];   //新添波斯语
    
    [data writeToFile:kConfigPlistPath atomically:YES];
    return data;
}

- (NSString *)getSystemLanguage {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    return [languages objectAtIndex:0];
}

- (void)changeLanguageInPlist:(NSString *)language {
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:kConfigPlistPath];
    [data setObject:language forKey:kCurrent];
    [data writeToFile:kConfigPlistPath atomically:YES];
}

- (NSInteger)getCurrentLanguageIndex {
    return [[[CinLanguage sharedInstance] getCurrentLanguageTag] intValue];
}

@end
