//
//  NSString+Date.h
//  CFSocket_Demo
//
//  Created by edz on 2020/7/28.
//  Copyright © 2020 EDZ. All rights reserved.
//

 
#import <Foundation/Foundation.h>

 
typedef enum TimeFormatter{
    TimeFormatter0 =0,  // @"yyyyMMddHHMMSS"
    TimeFormatter1,     // @"yyyy/MM/dd/HH/MM/SS"
    TimeFormatter2,     // @"yyyy-MM-dd-HH-MM-SS"
    TimeFormatter3      // @"yyyy-MM-dd-HH-MM"
}TimeFormatter;

@interface NSString (Date)

+(NSString*)gettimestampOfType:(TimeFormatter)type;
@end
