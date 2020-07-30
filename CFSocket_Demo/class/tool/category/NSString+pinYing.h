//
//  NSString+pinYing.h
//  CFSocket_Demo
//
//  Created by edz on 2020/7/28.
//  Copyright © 2020 EDZ. All rights reserved.
//

 


#import <Foundation/Foundation.h>
 

@interface NSString (pinYing)

//汉字转拼音
+ (NSString *)transformToPinYinWithChinese:(NSString *)chinese;
@end

 
