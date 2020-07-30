//
//  CinChatModeDAO.h
//  CFSocket_Demo
//
//  Created by edz on 2020/7/29.
//  Copyright © 2020 EDZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CinChatModeDAO : NSObject
+ (instancetype)sharedInstance;

- (BOOL)createTable:(long long)chatID;

-(NSMutableArray *)getNewMsgArrFromIndex:(int64_t)index count:(NSInteger)count chatID:(long long)chatID;

@end
 
