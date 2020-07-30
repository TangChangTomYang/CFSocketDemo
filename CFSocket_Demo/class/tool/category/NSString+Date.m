//
//  NSString+Date.m
//  CFSocket_Demo
//
//  Created by edz on 2020/7/28.
//  Copyright © 2020 EDZ. All rights reserved.
//

#import "NSString+Date.h"

 
@implementation NSString (Date)

+(NSString*)gettimestampWithFormatter:(TimeFormatter)formatteratype{
    NSDate* date = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    switch (formatteratype) {
        case TimeFormatter0:
        {
            [formatter setDateFormat:@"yyyyMMddHHMMSS"];
        }
            break;
        case TimeFormatter1:
        {
             [formatter setDateFormat:@"yyyy/MM/dd/HH/MM/SS"];
        }
            break;
        case TimeFormatter2:
        {
            [formatter setDateFormat:@"yyyy-MM-dd-HH-MM-SS"];

        }
            break ;
        case TimeFormatter3:
        {
            [formatter setDateFormat:@"yyyy-MM-dd-HH-MM"];

        }
        default:
            break;
    }
   
    NSString * datePath = [formatter stringFromDate:date];
    return datePath ;
    
}

 
@end
