//
//  NSDateUtils.h
//  CinCommon
//
//  Created by ProbeStar on 13-11-16.
//  Copyright (c) 2013年 p. All rights reserved.
//

//注意：所有的long long类型的date参数的单位均是秒
#import <Foundation/Foundation.h>

@interface NSDateUtils : NSObject

+ (NSDate *)dateFromyyyyMMddHHmmssString:(NSString *)str;

+ (NSString *)dateFromyyyyMMddHHmmDate:(long long)date;

+ (NSDate *)dateFromyyyyMMddString:(NSString *)str;

+ (NSString *)getyyyyMMddDate:(long long )date;

+ (NSString *)getyyyyMMddLongLongValueFromDate:(NSDate *)date;

+ (NSString *)getMMddDate:(long long )date ;

+ (NSString *)get24Time:(long long)date;

+ (NSString *)get12Time:(long long)date;

//根据系统24or12小时设置的格式返回时间串
+ (NSString *)get24Or12TimeBySystemSetting:(long long)date;

+ (NSString *)get24Or12TimeHHmmStr:(long long)date;

//判断系统时间是否为12小时制。Return：YES12小时制；NO24小时制
+ (BOOL)is12HourClockIniOS;

+ (NSString *)getTimeStrByDate:(NSDate *)date;

//返回date与当前日期相差的天数 返回0当天天，1昨天，2前天，以此类推
+ (NSInteger)getDaysFromAnotherDay:(long long)date;

#pragma mark - Get Single Value
//返回197001001至date的天数。date：1970到现在的秒数
//+ (long long)getDaysFrom1970:(long long)date;

+ (NSInteger)getYear:(long long)date;

+ (NSInteger)getMonth:(long long)date;

+ (NSInteger)getDay:(long long)date;

//获得星期几，1星期天；2星期一。。。。。7星期六
+ (NSInteger)getWeekDay:(long long)date;

+ (NSInteger)getHour:(long long)date;

+ (NSInteger)getMinute:(long long)date;

+ (NSInteger)getSecond:(long long)date;

#pragma mark -
#pragma mark - 朋友圈显示时间转换

+ (NSString *)getSocialTime:(long long)date;

#pragma mark -
#pragma mark - DialogListTime

+ (NSString *)getDialogListTime:(long long)lastMessageTime;
+ (NSString *)getDialogDay:(long long)lastMessageTime;
+ (NSString *)getDialogViewControllerTime:(long long)lastMessageTime;
//获取当前时间与最后一条会话的时间差
+ (NSInteger)getDialogTime:(long long)lastMessageTime;

//判断相邻会话是否在一分钟内 yes:在一分钟，no：不在一分钟内，需要显示时间
+ (BOOL)isDialogTimeInOneMinute:(long long)lastMessageTime andCurrentTime:(long long)currentTime;
// 判断两个时间戳是否在同一天
+ (BOOL)isSameDay:(long long)iTime1 Time2:(long long)iTime2;
+ (NSString *)getHistoryMessageDate:(long long )date;
#pragma mark -
#pragma mark - video时间转换 
//00:00:00
+ (NSString *)videoTimeOfTimeInterval:(NSTimeInterval)timeInterval;

+ (NSString *)getTimeStrWithSystemShortFormatByDate:(NSDate *)date;

+ (NSString *)getCollectionTimeForDate:(long long)date;

+ (BOOL)checkTheDateIsToday:(NSString *)string;
@end
