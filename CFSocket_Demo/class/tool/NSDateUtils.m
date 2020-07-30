//
//  NSDateUtils.m
//  CinCommon
//
//  Created by ProbeStar on 13-11-16.
//  Copyright (c) 2013年 p. All rights reserved.
//

#import "NSDateUtils.h"
#import "CinLanguage.h"

@implementation NSDateUtils

+ (NSDateFormatter*)dateFormater {
    NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *dateFormatter = threadDictionary[@"mydateformatter"];
    if(!dateFormatter){
        @synchronized(self){
            if(!dateFormatter){
                dateFormatter = [[NSDateFormatter alloc] init];
                threadDictionary[@"mydateformatter"] = dateFormatter;
            }
        }
    }
     return dateFormatter;
}

+ (NSDate *)dateFromyyyyMMddHHmmssString:(NSString *)str {
    NSDateFormatter *dateFormatter = [NSDateUtils dateFormater];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setCalendar: [NSCalendar autoupdatingCurrentCalendar]];
    NSDate *date = [dateFormatter dateFromString:str];
    return date;
}

+ (NSString *)dateFromyyyyMMddHHmmDate:(long long)date {
    NSDateFormatter *dateFormatter= [NSDateUtils dateFormater];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [dateFormatter setCalendar: [NSCalendar autoupdatingCurrentCalendar]];
    return [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:date]];
}


+ (NSDate *)dateFromyyyyMMddString:(NSString *)str {
    NSDate *date = [[self shareyyyyMMddNSDateFormatter] dateFromString:str];
    return date;
}

+ (NSString *)getyyyyMMddDate:(long long )date {
    NSDateFormatter *dateFormatter= [NSDateUtils dateFormater];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setCalendar: [NSCalendar autoupdatingCurrentCalendar]];
    return [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:date]];
}

+ (NSString *)getyyyyMMddLongLongValueFromDate:(NSDate *)date {
    NSString *yyyyMMddStr = [[self shareyyyyMMddNSDateFormatter] stringFromDate:date];
    return yyyyMMddStr;
}

+ (NSString *)getMMddDate:(long long )date {
    NSDateFormatter *dateFormatter= [NSDateUtils dateFormater];
    [dateFormatter setDateFormat:@"MM/dd"];
    [dateFormatter setCalendar: [NSCalendar autoupdatingCurrentCalendar]];
    return [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:date]];
}

+ (NSString *)getddMMMMDate:(long long )date {//显示英文月份全称 如09-Septemper
    NSDateFormatter *dateFormatter= [NSDateUtils dateFormater];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormatter setDateFormat:@"dd-MMMM"];
    [dateFormatter setCalendar: [NSCalendar autoupdatingCurrentCalendar]];
    return [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:date]];
}

+ (NSString *)getddMMMDate:(long long )date {//显示英文月份简称 如09-Sep
    NSDateFormatter *dateFormatter= [NSDateUtils dateFormater];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormatter setDateFormat:@"dd/MMM"];
    [dateFormatter setCalendar: [NSCalendar autoupdatingCurrentCalendar]];
    return [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:date]];
}

+ (NSString *)get24Time:(long long)date {
    NSDateFormatter *dateFormatter= [NSDateUtils dateFormater];
    [dateFormatter setDateFormat:@"HH:mm"];
    [dateFormatter setCalendar: [NSCalendar autoupdatingCurrentCalendar]];
    return [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:date]];
}


+ (NSString *)gethhmm12Time:(long long)date {
    NSDateFormatter *dateFormatter= [NSDateUtils dateFormater];
    [dateFormatter setDateFormat:@"hh:mm"];
    [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:[[CinLanguage sharedInstance] getCurrentLanguage]]];
    [dateFormatter setCalendar: [NSCalendar autoupdatingCurrentCalendar]];
    return [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:date]];
}

+ (NSString *)get12Time:(long long)date {
    NSDateFormatter *dateFormatter= [NSDateUtils dateFormater];
    [dateFormatter setDateFormat:@"ahh:mm"];
    [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:[[CinLanguage sharedInstance] getCurrentLanguage]]];
    [dateFormatter setCalendar: [NSCalendar autoupdatingCurrentCalendar]];
    return [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:date]];
}

+ (NSString *)get24Or12TimeBySystemSetting:(long long)date
{
    if( [self is12HourClockIniOS]){
        return  [self get12Time:date];
    }else{
        return  [self get24Time:date];
    }
}

+ (NSString *)get24Or12TimeHHmmStr:(long long)date
{
    if( [self is12HourClockIniOS]){
        return  [self gethhmm12Time:date];
    }else{
        return  [self get24Time:date];
    }
}

+ (BOOL)is12HourClockIniOS{
    NSString *formatStringForHours = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale autoupdatingCurrentLocale]];
    NSRange containsA = [formatStringForHours rangeOfString:@"a"];
    return containsA.location != NSNotFound;
}

+ (NSString *)getTimeStrByDate:(NSDate *)date {
    if (date == nil)
        return @"";
    
    NSMutableString *displayStr = [NSMutableString string];
    NSDate *now = [NSDate date];
    NSTimeInterval time = [now timeIntervalSinceDate:date];
    
    
    NSDateFormatter *dateFormatter = [NSDateUtils dateFormater];
    [dateFormatter setCalendar: [NSCalendar autoupdatingCurrentCalendar]];
    
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *timeStr = [dateFormatter stringFromDate:date];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    
    [dateFormatter setDateFormat:@"HH"];
    int nowHour = [[dateFormatter stringFromDate:now] intValue];
    int days_ago = ((int)time + 3600*(24-nowHour))/(3600*24);
    
    if (days_ago == 0) {
        [displayStr appendString:[NSString stringWithFormat:@"今天 %@", timeStr]];
    } else if(days_ago == 1) {
        [displayStr appendString:[NSString stringWithFormat:@"昨天%@", timeStr]];
    } else if(days_ago == 2) {
        [displayStr appendString:[NSString stringWithFormat:@"前天 %@", timeStr]];
    } else {
        if(dateStr&&dateStr.length > 0)
            [displayStr appendString:dateStr];
    }
    return displayStr;
}

+ (NSString *)getCollectionTimeForDate:(long long)date{
    
    NSDate *timeDate = [[NSDate alloc]initWithTimeIntervalSince1970:date/1000];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"YYYY/MM/dd"];
    
    //获取传过来的时间的date
    NSString *createDate = [format stringFromDate:timeDate];
    
    //获取今天
    NSDate *nowDate = [NSDate date];
    NSString *today = [format stringFromDate:nowDate];
    
    //获取昨天
    NSDate *yesterdayDate = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60)];
    NSString *yesterday = [format stringFromDate:yesterdayDate];
    // 获取前天
    NSDate *beforeyesterdayDate = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60*2)];
    NSString *beforeyesterday = [format stringFromDate:beforeyesterdayDate];
    
    if ([createDate isEqualToString:today]) {
        return [NSString stringWithFormat:@"今天"];
    }else if ([createDate isEqualToString:yesterday]){
        return [NSString stringWithFormat:@"昨天"];
    }else if ([createDate isEqualToString:beforeyesterday]){
        return [NSString stringWithFormat:@"前天"];
    }else{
        return [NSString stringWithFormat:@"%@",createDate];
    }
}

//返回0 当天，1昨天，2前天，以此类推
//之前那样用时间差来整除一天的秒数，计算出来的天数有误差
+ (NSInteger)getDaysFromAnotherDay:(long long)date {
    //    return [self getDaysFrom1970:date] - [self getDaysFrom1970:[[NSDate date] timeIntervalSince1970]];
    //    NSDateComponents *comps = [[NSDateComponents alloc] init];
    //    [comps setDay:[NSDateUtils getDay:date]];
    //    [comps setMonth:[NSDateUtils getMonth:date]];
    //    [comps setYear:[NSDateUtils getYear:date]];
    //    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    //    NSDate *endDate = [[NSDate alloc] init];
    //    NSDate *startDate = [gregorian dateFromComponents:comps];
    //    [comps release];
    //    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    //    NSDateComponents *comps2 = [gregorian components:unitFlags fromDate:startDate toDate:endDate options:0];
    //    [gregorian release];
    //    [endDate release];
    ////    int days = [comps2 day];
    //    NSTimeInterval interval = [endDate timeIntervalSinceDate:startDate];
    //    NSInteger days = ((NSInteger)interval)/(3600*24);
    NSDateFormatter *dateFormatter = [NSDateUtils dateFormater];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setCalendar: [NSCalendar autoupdatingCurrentCalendar]];
    NSDate *today = [dateFormatter dateFromString:[dateFormatter stringFromDate:[NSDate date]]];
    NSDate *startDate = [dateFormatter dateFromString:[NSDateUtils getyyyyMMddDate:date]];
//    NSDate *formatterStartDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:startDate]];
    NSTimeInterval interval = [today timeIntervalSinceDate:startDate];
    NSInteger days = ((NSInteger)interval)/(3600*24);
    return days;
}

#pragma mark - Get Single Value
//+ (long long)getDaysFrom1970:(long long)date {
//    return date / 86400;
//}

+ (NSInteger)getYear:(long long)date {
    return [[self getNSDateComponents:date] year];
}

+ (NSInteger)getMonth:(long long)date {
    return [[self getNSDateComponents:date] month];
}

+ (NSInteger)getDay:(long long)date {
    return [[self getNSDateComponents:date] day];
}

+ (NSInteger)getWeekDay:(long long)date {
    return [[self getNSDateComponents:date] weekday];
}

+ (NSInteger)getHour:(long long)date {
    return [[self getNSDateComponents:date] hour];
}

+ (NSInteger)getMinute:(long long)date {
    return [[self getNSDateComponents:date] minute];
}

+ (NSInteger)getSecond:(long long)date {
    return [[self getNSDateComponents:date] second];
}

+ (NSDateComponents *)getNSDateComponents:(long long)date {
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *comps = [[self shareNSCalendar] components:unitFlags fromDate:[NSDate dateWithTimeIntervalSince1970:date]];
    return comps;
}

#pragma mark - Share Instance 减少创建NSDateFormatter、NSCalendar等的开销

+ (NSCalendar *)shareNSCalendar
{
    static NSCalendar *calendar = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    });
    return calendar;
}

+ (NSDateFormatter *)shareyyyyMMddNSDateFormatter
{
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter= [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMdd"];
        [dateFormatter setCalendar:[NSCalendar autoupdatingCurrentCalendar]];
    });
    return dateFormatter;
}

#pragma mark -
#pragma mark - 朋友圈显示时间转换

+ (NSString *)getSocialTime:(long long)date{
    NSString *timeStr = nil;
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:date];

    //获取当前时间
    NSDate *daten = [NSDate date];
    //当前秒数
    double localTime = [daten timeIntervalSince1970];
    //服务器秒数
    double serverTime = (double)( date / 1000 );
    double c = fabs(localTime-serverTime);
    if (c < 60*60) {//小于一小时
        int n = c/(60);
        timeStr = [NSString stringWithFormat:@"%d分钟前",n];
    }else if (c >= 60*60 && c< 60*60*24){//小于一天
        int n = c/(60*60);
        timeStr = [NSString stringWithFormat:@"%d小时前",n];
    }else{
        int n = c/(60*60*24);
        timeStr = [NSString stringWithFormat:@"%d天前",n];
    }
//    if (c<60) {//小于1分钟
//        timeStr = [NSString stringWithFormat:@"%@",NSInternational(@"General_Now")];
//    }else if (c >=60 && c<60*60){//小于一小时
//        int n = c/(60);
//        timeStr = NSInternationalFormat(@"General_Minute", [NSString stringWithFormat:@"%d",n]);
//    }else if (c >= 60*60 && c< 60*60*24){//小于一天
//        int n = c/(60*60);
//        if (n == 1) {
//            timeStr = NSInternationalFormat(@"General_Hour", [NSString stringWithFormat:@"%d",n]);
//        }else{
//            timeStr = NSInternationalFormat(@"General_Hour", [NSString stringWithFormat:@"%d",n]);
//        }
//    }else if ([self isYesterdayWithDate:createDate]){
//        timeStr = NSInternationalFormat(@"Social_Yesterday", [self get12Time:serverTime]);
//    }else{//大于两天
//        //当前年份
//        NSInteger localYear = [self getYear:localTime];
//        //服务器年份
//        NSInteger serverYear = [self getYear:serverTime];
//        timeStr = [NSString stringWithFormat:@"%ld/%ld/%ld %@",(long)[self getYear:serverTime],(long)[self getMonth:serverTime],(long)[self getDay:serverTime],[self get24Time:serverTime]];
//
//    }
    return timeStr;
}

/**
 *  判断某个时间是否为昨天
 */
+ (BOOL)isYesterdayWithDate:(NSDate *)testDate
{
    NSDate *now = [NSDate date];
    
    // date ==  2014-04-30 10:05:28 --> 2014-04-30 00:00:00
    // now == 2014-05-01 09:22:10 --> 2014-05-01 00:00:00
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    // 2014-04-30
    NSString *dateStr = [fmt stringFromDate:testDate];
    // 2014-10-18
    NSString *nowStr = [fmt stringFromDate:now];
    
    // 2014-10-30 00:00:00
    NSDate *date = [fmt dateFromString:dateStr];
    // 2014-10-18 00:00:00
    now = [fmt dateFromString:nowStr];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *cmps = [calendar components:unit fromDate:date toDate:now options:0];
    
    return cmps.year == 0 && cmps.month == 0 && cmps.day == 1;
}
#pragma mark -
#pragma mark - DialogList Time
//当天消息显示几点几分，如13:20,昨天消息显示昨天，如yesterday；
//前两天消息显示日-月，如18-September(中文模式就是09-18),跨年的消息显示日-月-年，
//英文 31-Dec-2013(中文模式是2013-12-31)
+ (NSString *)getDialogListTime:(long long)lastMessageTime {
    NSString *timeDisplayStr;
    long long temp = [NSDateUtils getDaysFromAnotherDay:lastMessageTime];
    NSString *currentLanguage = [[CinLanguage sharedInstance] getCurrentLanguage];
    if(temp == 0){
        timeDisplayStr = [NSDateUtils get24Or12TimeBySystemSetting:lastMessageTime];
    }else if(temp == 1){
        timeDisplayStr = @"昨天";
    }else if ((temp >= 2 && temp <= 6) || (temp <= -2 && temp >= -6)){
        NSInteger week = [NSDateUtils getWeekDay:lastMessageTime];
        switch (week) {
            case 1: //星期天
                timeDisplayStr = @"general_week_sunday";
                break;
            case 2: //星期一
                timeDisplayStr = @"general_week_monday";
                break;
            case 3: //星期二
                timeDisplayStr = @"general_week_tuesday";
                break;
            case 4: //星期三
                timeDisplayStr = @"general_week_wednesday";
                break;
            case 5: //星期四
                timeDisplayStr = @"general_week_thursday";
                break;
            case 6: //星期五
                timeDisplayStr = @"general_week_friday";
                break;
            case 7: //星期六
                timeDisplayStr = @"general_week_saturday";
                break;
        }
        //            timeDisplayStr = NSInternational(@"general_beforeyesterday");
    }else{
        if([currentLanguage rangeOfString:@"zh-Hans"].location != NSNotFound) {
            timeDisplayStr = [NSDateUtils getMMddDate:lastMessageTime];
        } else {
            timeDisplayStr = [NSDateUtils getddMMMDate:lastMessageTime];
        }
        NSInteger tempYear = [NSDateUtils getYear:lastMessageTime];
        //            NSDate *nowDate = [NSDate date];
        //            NSInteger currentYear = [NSDateUtils getYear:[nowDate timeIntervalSince1970]];
        //            if (tempYear < currentYear) {
        NSString *year = [NSString stringWithFormat:@"%ld",(long)tempYear];
        if ([currentLanguage rangeOfString:@"zh-Hans"].location != NSNotFound) {
            timeDisplayStr = [NSString stringWithFormat:@"%@/%@",year,timeDisplayStr];
        } else {
            NSString *timeStr = [NSDateUtils getddMMMDate:lastMessageTime];
            timeDisplayStr = [NSString stringWithFormat:@"%@/%@",timeStr,year];
        }
    }
    //        }
    
    return timeDisplayStr;
}

+ (NSString *)getDialogViewControllerTime:(long long)lastMessageTime {
    NSString *timeDisplayStr;
    long long temp = [NSDateUtils getDaysFromAnotherDay:lastMessageTime];
    NSString *currentLanguage = [[CinLanguage sharedInstance] getCurrentLanguage];
    NSString *hhmmTimeStr = [NSDateUtils get24Or12TimeBySystemSetting:lastMessageTime];
    if(temp == 0){
        timeDisplayStr = hhmmTimeStr;
    }else if(temp == 1){
        timeDisplayStr = [NSString stringWithFormat:@"昨天 %@",hhmmTimeStr];
    }else{
        if([currentLanguage rangeOfString:@"zh-Hans"].location != NSNotFound) {
            timeDisplayStr = [NSString stringWithFormat:@"%ld月%ld日 %@",(long)[self getMonth:lastMessageTime],(long)[self getDay:lastMessageTime],hhmmTimeStr];
        } else {
            timeDisplayStr = [NSString stringWithFormat:@"%ldMonth%ldDay %@",(long)[self getMonth:lastMessageTime],(long)[self getDay:lastMessageTime],hhmmTimeStr];
        }
        NSInteger tempYear = [NSDateUtils getYear:lastMessageTime];
        NSDate *nowDate = [NSDate date];
        NSInteger currentYear = [NSDateUtils getYear:[nowDate timeIntervalSince1970]];
        if (tempYear < currentYear) {
            NSString *year = [NSString stringWithFormat:@"%ld",(long)tempYear];
            if ([currentLanguage rangeOfString:@"zh-Hans"].location != NSNotFound) {
                timeDisplayStr = [NSString stringWithFormat:@"%@年%@",year,timeDisplayStr];
            } else {
                NSString *timeStr = [NSDateUtils getddMMMDate:lastMessageTime];
                timeDisplayStr = [NSString stringWithFormat:@"%@Year%@",timeStr,year];
            }
        }
    }
    
    return timeDisplayStr;
}

+ (NSString *)getDialogDay:(long long)lastMessageTime {
    NSString *timeDisplayStr;
    NSInteger temp = [NSDateUtils getDaysFromAnotherDay:lastMessageTime];
    NSString *currentLanguage = [[CinLanguage sharedInstance] getCurrentLanguage];
    if(temp == 0){
        timeDisplayStr = @"今天";
    }else if(temp == 1){
        timeDisplayStr = @"昨天";
    }else{
        if([currentLanguage isEqualToString:@"zh-Hans"]) {
            timeDisplayStr = [NSDateUtils getMMddDate:lastMessageTime];
        } else {
            timeDisplayStr = [NSDateUtils getddMMMDate:lastMessageTime];
        }
    }
    NSInteger tempYear = [NSDateUtils getYear:lastMessageTime];
    NSDate *nowDate = [NSDate date];
    NSInteger currentYear = [NSDateUtils getYear:[nowDate timeIntervalSince1970]];
    if (tempYear < currentYear) {
        NSString *year = [NSString stringWithFormat:@"%ld",(long)tempYear];
        if ([currentLanguage isEqualToString:@"zh-Hans"]) {
            timeDisplayStr = [NSString stringWithFormat:@"%@-%@",year,timeDisplayStr];
        } else {
            NSString *timeStr = [NSDateUtils getddMMMDate:lastMessageTime];
            timeDisplayStr = [NSString stringWithFormat:@"%@-%@",timeStr,year];
        }
    }
    return timeDisplayStr;
}

+ (NSInteger)getDialogTime:(long long)lastMessageTime
{
    NSInteger currentMintues = [self getHour:[[NSDate date] timeIntervalSince1970]];
    NSInteger seconds = (currentMintues - [self getHour:lastMessageTime])*60*60;
    
    seconds += ([self getMinute:[[NSDate date] timeIntervalSince1970]] - [self getMinute:lastMessageTime])*60;
    seconds += ([self getSecond:[[NSDate date] timeIntervalSince1970]] - [self getSecond:lastMessageTime]);
    return seconds;
}

+ (BOOL)isDialogTimeInOneMinute:(long long)lastMessageTime andCurrentTime:(long long)currentTime
{
    
    //
    //    NSInteger minutes =
    //
    //    NSInteger seconds = (labs([self getHour:currentTime] - [self getHour:lastMessageTime]))*60*60;
    //
    //    seconds += ([self getMinute:currentTime] - [self getMinute:lastMessageTime])*60;
    //    seconds += ([self getSecond:currentTime] - [self getSecond:lastMessageTime]);
    //
    if (currentTime>10000000000) {
        currentTime/=1000;
    }
    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:currentTime];
    NSDate *lastMessageDate = [NSDate dateWithTimeIntervalSince1970:lastMessageTime];
    
    NSTimeInterval interval = [currentDate timeIntervalSinceDate:lastMessageDate];
    NSInteger seconds = ((NSInteger)interval)/1;
    
    if (seconds>=60 || seconds <= -60) {
        return NO;
    }
    else
    {
        return YES;
    }
}

+ (NSString *)videoTimeOfTimeInterval:(NSTimeInterval)timeInterval {
    NSDateComponents *components = [self componetsWithTimeInterval:timeInterval];
    if (components.hour > 0) {
        return [NSString stringWithFormat:@"%ld:%02ld:%02ld", (long)components.hour, (long)components.minute, (long)components.second];
    } else {
        return [NSString stringWithFormat:@"%ld:%02ld", (long)components.minute, (long)components.second];
    }
}

+ (NSDateComponents *)componetsWithTimeInterval:(NSTimeInterval)timeInterval {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] initWithTimeInterval:timeInterval sinceDate:date1];
    
    unsigned int unitFlags =
    NSSecondCalendarUnit | NSMinuteCalendarUnit | NSHourCalendarUnit |
    NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    
    return [calendar components:unitFlags
                       fromDate:date1
                         toDate:date2
                        options:0];
}


+ (NSString *)getTimeStrWithSystemShortFormatByDate:(NSDate *)date {
    if (date == nil)
        return @"";
    NSMutableString *displayStr = [NSMutableString string];
    
    
    NSString *timeStr=[NSDateUtils get24Or12TimeBySystemSetting:[date timeIntervalSince1970]];
    //    NSDate *now = [NSDate date];
    //    NSTimeInterval time = [now timeIntervalSinceDate:date];
    //    [dateFormatter setDateFormat:@"HH"];
    //    int nowHour = [[dateFormatter stringFromDate:now] intValue];
    //    int days_ago = ((int)time + 3600*(24-nowHour))/(3600*24);
    NSInteger days_ago = [self compareDate:date];
    if (days_ago == 0) {
        [displayStr appendString:[NSString stringWithFormat:@"今天 %@",timeStr]];
    } else if(days_ago == 1) {
        [displayStr appendString:[NSString stringWithFormat:@"昨天 %@",timeStr]];
    } else {
        
        NSDateFormatter* fmt = [NSDateUtils dateFormater];
        fmt.dateStyle = NSDateFormatterShortStyle;
        fmt.timeStyle = NSDateFormatterShortStyle;
        //        fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_IN"];
        fmt.locale = [NSLocale currentLocale];
        [displayStr appendString:[fmt stringFromDate:date]];
        
        //        NSDateFormatter *dateFormatter = [NSDateUtils dateFormater];
        //        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        //        NSString *dateStr = [dateFormatter stringFromDate:date];
        //        if(dateStr&&dateStr.length > 0)
        //            [displayStr appendString:[NSString stringWithFormat:@"%@ %@",dateStr,timeStr]];
    }
    return displayStr;
}

+(NSInteger)compareDate:(NSDate *)date{
    
    NSTimeInterval secondsPerDay = 60 * 60 * 24;
    NSDate *today = [NSDate date];
    NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:-secondsPerDay];
    
    
    NSDateFormatter *formatter = [NSDateUtils dateFormater];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString * todayString = [formatter stringFromDate:today];
    //    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [formatter stringFromDate:yesterday];
    //    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString *refDateString = [formatter stringFromDate:date];
    //    NSString * refDateString = [[date description] substringToIndex:10];
    
    //description
    //        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //        debugLog(@" %@ ;%@",[date description],[formatter stringFromDate:date]);
    
    if ([refDateString isEqualToString:todayString])
    {
        return 0;
    }
    else if ([refDateString isEqualToString:yesterdayString])
    {
        return 1;
    }
    else
    {
        return -1;
    }
    
}

+ (BOOL)checkTheDateIsToday:(NSString *)string{
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [format dateFromString:string];
    BOOL isToday = [[NSCalendar currentCalendar] isDateInToday:date];
    if(isToday) {
        return YES;
    }
    return NO;
}

+ (BOOL)isSameDay:(long long)iTime1 Time2:(long long)iTime2
{
    //传入时间毫秒数
    NSDate *pDate1 = [NSDate dateWithTimeIntervalSince1970:iTime1/1000];
    NSDate *pDate2 = [NSDate dateWithTimeIntervalSince1970:iTime2/1000];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:pDate1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:pDate2];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}

+ (NSString *)getHistoryMessageDate:(long long )date {
    NSDateFormatter *dateFormatter= [NSDateUtils dateFormater];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    [dateFormatter setCalendar: [NSCalendar autoupdatingCurrentCalendar]];
    return [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:date]];
}

@end
