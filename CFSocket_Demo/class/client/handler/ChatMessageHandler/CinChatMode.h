//
//  CinChatMode.h
//  CFSocket_Demo
//
//  Created by edz on 2020/7/29.
//  Copyright © 2020 EDZ. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    CinMsgStatus_SendSuccess,
    CinMsgStatus_SendFailed,
    CinMsgStatus_Sending,
    CinMsgStatus_Arrived,
    CinMsgStatus_None,
    CinMsgStatus_Delete,
    CinMsgStatus_SendCancel,
    CinMsgStatus_Revoked   //消息被回撤
}CinMsgStatus;


@interface CinChatMode : NSObject

@property (nonatomic, strong) NSData *messageID;

@property (nonatomic, assign) long long fromUid;
@property (nonatomic, assign) long long toUid;
@property (nonatomic, assign) long long createTime;
@property (nonatomic, assign) long long expireTime;                     /**< 过期时间 */
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) CinMsgStatus status;
@property (nonatomic, assign) BOOL isFavorite;
@property (nonatomic, assign) long long orderID;
@property (nonatomic, assign) NSInteger readStatus;
@property (nonatomic, assign) NSInteger oneMinute;                      /**< 判断时间是否在一分钟内 */
@property (nonatomic, copy) NSString *remindPersons;                    /**< @提醒的人 */



@end
 
