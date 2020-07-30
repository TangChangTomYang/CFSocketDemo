//
//  CinChatModeDAO.m
//  CFSocket_Demo
//
//  Created by edz on 2020/7/29.
//  Copyright © 2020 EDZ. All rights reserved.
//

#import "CinChatModeDAO.h"
#import "CinChatMode.h"
#import "FMDB.h"
#import "CinClient.h"


@implementation CinChatModeDAO

static CinChatModeDAO *_cinChatModeDAO = nil;
+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _cinChatModeDAO = [[self alloc] init];
    });
    return _cinChatModeDAO;
}


- (BOOL)createTable:(long long)chatID{
    __block BOOL ret = NO;
    NSString *createTable_sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS CinChatMode_%lld(\
                     messageID         Blob PRIMARY KEY,\
                     fromUid           Integer,\
                     toUid             Integer,\
                     createTime        Integer,\
                     expireTime        Integer,\
                     text              Text,\
                     status            Integer,\
                     isFavorite        Integer,\
                     orderID           Integer,\
                     readStatus        Integer,\
                     oneMinute         Integer,\
                     remindPersons     Text\
                     );",chatID];
    
    [[CinClient sharedClient].dbQueue inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:createTable_sql];
        if (ret == NO) {
            NSLog(@"创建 CinChatMode表: CinChatMode_%lld 失败.", chatID);
        }
         
        if (ret == YES) {
            // 创建 CreateTime索引 MessageID索引
            NSString *createTimeIndex_sql = [NSString stringWithFormat:@"CREATE INDEX IF NOT EXISTS CinChatMode_%lld_createTime ON CinChatMode_%lld(createTime);",chatID,chatID];
            ret = [db executeUpdate:createTimeIndex_sql];
            if (ret == NO) {
                NSLog(@"创建 CinChatMode表createTime索引: CinChatMode_%lld_createTime 失败.", chatID);
            }
        }
        
        if(ret == YES){
            NSString *messageIDInde_sql=[NSString stringWithFormat:@"CREATE INDEX IF NOT EXISTS CinChatMode_%lld_MessageID ON CinChatMode_%lld(orderID)",chatID,chatID];
            ret = [db executeUpdate:messageIDInde_sql];
            if (ret == NO) {
                NSLog(@"创建 CinChatMode表MessageID索引: CinChatMode_%lld_MessageID 失败.", chatID);
            }
        }
    }];
    
    if (ret == YES) {
        //新添字段，判断音频是否播放
        __block BOOL isExist = NO;
        NSString *selectSql = [NSString stringWithFormat:@"select count(MediaStatus) from CinChatMode_%lld",chatID];
        [[CinClient sharedClient].dbQueue inDatabase:^(FMDatabase *db) {
            FMResultSet *set = [db executeQuery:selectSql];
            if (set) {
                isExist = YES;
            }
            [set close];
        }];
        
        if (!isExist) {
            NSString *alterSql = [NSString stringWithFormat:@"alter table CinChatMode_%lld add MediaStatus Integer",chatID];
            [[CinClient sharedClient].dbQueue inDatabase:^(FMDatabase *db) {
                [db executeUpdate:alterSql];
            }];
        }
    }
    
    return ret;
}


// 向下取新的消息
-(NSMutableArray *)getNewMsgArrFromIndex:(int64_t)index count:(NSInteger)count chatID:(long long)chatID{
    
    return [self getMsgArrFromIndex:index count:count chatID:chatID isNew:YES];
}


-(NSMutableArray *)getMsgArrFromIndex:(int64_t)index count:(NSInteger)count chatID:(long long)chatID isNew:(BOOL)isNew{
    
    NSMutableArray *chatModeArray = [NSMutableArray array];
    
    [[CinClient sharedClient].dbQueue inDatabase:^(FMDatabase *db) {
        
        NSString * selectSQl = nil;
        if (isNew) {
            
            if(count != -1){
                selectSQl =[NSString stringWithFormat:
                            @"select \
                            *  \
                            FROM  \
                                (select \
                                *  \
                                FROM  CinChatMode_%lld \
                                where status!=%d and  orderID>%lld \
                                order by orderID \
                                asc limit 0,%ld ) \
                            order by orderID desc;",
                            chatID,CinMsgStatus_Delete,(long long)index,count];
            }
            else{
                selectSQl =[NSString stringWithFormat:
                            @"select \
                            *  \
                            FROM  \
                                (select \
                                *  \
                                FROM CinChatMode_%lld \
                                where \
                                status!=%d and  orderID>%lld \
                                order by orderID asc   )  \
                            order by orderID desc;",
                            chatID,CinMsgStatus_Delete,(long long)index];
            }
        }
        else{
            if(count != -1){
                selectSQl =[NSString stringWithFormat:
                            @"select \
                            *  \
                            FROM CinChatMode_%lld \
                            where \
                            Status!=%d and  orderID<%lld \
                            order by orderID desc limit 0,%ld ;",
                            chatID,CinMsgStatus_Delete,(long long)index,count];
            }
            else{
                selectSQl =[NSString stringWithFormat:
                            @"select \
                            * \
                            FROM \
                            CinChatMode_%lld \
                            where \
                            Status!=%d and  orderID<%lld \
                            order by orderID desc;",
                            chatID,CinMsgStatus_Delete,(long long)index];
            }
        }
        
        
        FMResultSet *set = [db executeQuery:selectSQl];
        if (set) {
            while ([set next]) {
                @autoreleasepool {
                    CinChatMode *model = [self chatModeWithResultSet:set];
                    [chatModeArray insertObject:model atIndex:0];
                }
            }
        }
        [set close];
    }];
    
    for (int i = 0; i<chatModeArray.count; i++) {
        CinChatMode *model = chatModeArray[i];
        [self updateAttachMode:model];
    }
    
    
    return chatModeArray;
    
}


/**
 从数据中, 读取ChatModel
 */
- (CinChatMode *)chatModeWithResultSet:(FMResultSet *)set{
    
    
    CinChatMode *model  = [[CinChatMode alloc]init];
    model.messageID     = [set dataForColumn:@"messageID"];
    model.fromUid       = [set longLongIntForColumn:@"fromUid"];
    model.toUid         = [set longLongIntForColumn:@"toUid"];
    model.createTime    = [set longLongIntForColumn:@"createTime"];
    model.expireTime    = [set longLongIntForColumn:@"expireTime"];
    model.text          = [set stringForColumn:@"text"];
    model.status        = [set intForColumn:@"status"];
    model.isFavorite    = [set intForColumn:@"isFavorite"];
    model.orderID       = [set intForColumn:@"orderID"];
    model.readStatus    = [set intForColumn:@"readStatus"];
    model.oneMinute     = [set intForColumn:@"oneMinute"];
    model.remindPersons = [set stringForColumn:@"remindPersons"];
    
    return  model;
}

// 更新CinChatMode 的附件模型
- (void)updateAttachMode:(CinChatMode *)mode{
    
}




@end
