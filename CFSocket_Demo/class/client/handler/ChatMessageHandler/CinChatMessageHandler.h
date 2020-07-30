//
//  CinChatMessageHandler.h
//  CFSocket_Demo
//
//  Created by edz on 2020/7/30.
//  Copyright © 2020 EDZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CinChatMode.h"


@interface CinChatMessageHandler : NSObject



#pragma mark- 网路 通信操作相关方法

// 增 删 查 改

#pragma mark- 本地数据库操作相关方法
// 增 删 查 改

-(BOOL)dropChatMessageTableOfChatID:(long long)chatID;

-(CinChatMode *)createTextMessageToDBOfChatID:(long long)toChatID
                                         text:(NSString *)text
                                groupSendUids:(NSMutableArray *)groupSendUids;
@end
 
