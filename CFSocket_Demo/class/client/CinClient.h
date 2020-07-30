//
//  CinClient.h
//  CFSocket_Demo
//
//  Created by edz on 2020/7/29.
//  Copyright © 2020 EDZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CinConnectionAgent.h"
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"

#import "CinTransactionHandlerProtocal.h"
#import "CinDBCreaterProtocal.h"
#import "CinAppTerminateHandlerProtocal.h"

@class CinClient;
@protocol CinClientDelegate <NSObject>

- (void)clientDidConnected:(CinClient *)client;

- (void)clientDidDisConnected:(CinClient *)client;

- (void)client:(CinClient *)client didRecieveData:(NSData*)data;
@end
 


@interface CinClient : NSObject

@property (nonatomic, strong, readonly) CinConnectionAgent *connectionAgent;


@property(nonatomic,strong,readonly) FMDatabaseQueue *dbQueue;
@property (nonatomic, strong) NSMutableDictionary<NSString *, id<CinTransactionHandlerProtocal>> *transactionHandlerDicM;
@property (nonatomic, strong) NSMutableArray<id<CinDBCreaterProtocal>> *dbCreaterArrM;
@property (nonatomic, strong) NSMutableArray<id<CinAppTerminateHandlerProtocal>> *terminateHandlerArrM;

@property (nonatomic, weak) id<CinClientDelegate> delegate;

// 我们给每个 CinClient 去一个名字
@property (nonatomic, copy) NSString *name;


#pragma mark- socket 通信相关
- (void)connect:(NSString *)address;
- (void)disconnect;
- (CinTransaction *)createTransaction:(CinRequest *)request;


#pragma mark- CinTransactionHandler 相关
- (void)registerTransactionHandler:(id<CinTransactionHandlerProtocal>)transactionHandler;

#pragma mark- DBCreater 相关
- (void)registerDBCreater:(id<CinDBCreaterProtocal>)dbCreater;
- (void)initCreateTable;

- (void)openDatabase:(NSString *)userID;
- (void)closeDB;

#pragma mark- AppTerminateHandler
- (void)registerTerminateHandler:(id<CinAppTerminateHandlerProtocal>)handler;
- (void)doTerminateHandlerTask;
@end
























/**
 CinTransaction *trans = [[CinClient sharedCinClient] createTransaction:request];
    [trans setOnResponseReceived:^(CinResponse *resp) {
        switch ([resp getStatusCode]) {
            case CinResponseCodeOK:{
                // CLog(@"发送消息--chatMode--成功,handle 发送消息成功 response ");
                CinHeader *status = [request getHeader:CinHeaderTypeStatus]; // 0x13,
                BOOL isReSent = NO;
                if (status != nil && ([status getInt64]&32) != 0){
                    isReSent = YES;
                }
                
                long long serverOrderID = [[resp getHeader:CinHeaderTypeVersion]getInt64];
                messageItem.serverOrderID = serverOrderID;
                [self handleSendMessageSuccessedResponse:resp
                                                tochatID: chatID
                                               messageID:messageItem.messageID
                                                isReSent:isReSent];
            } break;
                
            default:  {
                //CLog(@"发送消息--chatMode--失败,handle 发送消息成功 response ");
                [self handleSendMessageFailed:chatID messageID:messageItem.messageID response:resp];
            }  break;
        }
    }];
    [trans setOnTimeout:^{
        CLog(@"发送消息----超时, handle 发送消息成功 response %lld  ",chatID);
        [self handleSendMessageFailed:chatID messageID:messageItem.messageID response:nil];
    }];
    [trans sendRequest];
 */
 

/**
 - (BOOL)handle:(CinTransaction *)trans {
     // TODO:
     CinRequest *req = trans.Request;
     switch ([req getMethod]) {
             
         case CinRequestMethodGroupMessage: {
             //CLog(@"-----handle 处理 讨论组 推送消息---");
             [self handleReceiveMessage:req];
             [trans sendResponseCode:CinResponseCodeOK];
         } break;
         
         
             
         case CinRequestMethodSDKNotifyInterface:{
             //CLog(@"-----handle 处理 CinRequestMethodSDKNotifyInterface 推送消息---");
             if ([req.Event getInt64] == 0x01) {
                 [self handleReceiveMailMessage:req];
                 [trans sendResponseCode:CinResponseCodeOK];
             }

             if ([req.Event getInt64] == 0x04) {
                 // 动账通知 MessageTypeBillNotify
                 [self handleReceiveBillNotifyMessage:req];
                 [trans sendResponseCode:CinResponseCodeOK];

             }
         }  break;
             
         default:
             return NO;
             break;
     }
     return YES;
 }
 */
