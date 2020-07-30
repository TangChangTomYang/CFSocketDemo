//
//  CinConnectionAgent.h
//  CFSocket_Demo
//
//  Created by edz on 2020/7/28.
//  Copyright © 2020 EDZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CinConnection.h" 
#import "CinTransactionManager.h"

@class CinConnectionAgent;
 

@protocol CinConnectionAgentDelegate <NSObject>
 
- (void)agentDidConnected:(CinConnectionAgent *)agent;
- (void)agentDidDisconnected:(CinConnectionAgent *)agent;


- (void)agent:(CinConnectionAgent *)agent didRecieveData:(NSData*)data;
- (void)agent:(CinConnectionAgent *)agent didRecieveRequestTransaction:(CinTransaction *)transaction;
@end



@interface CinConnectionAgent : NSObject<CinConnectionDelegate>


@property (nonatomic, assign, readonly) BOOL isAddress;
@property (nonatomic, copy, readonly) NSString *socketAddress;
@property (nonatomic, assign, readonly, getter=isConnected) BOOL connected;
@property (nonatomic, strong, readonly) CinRunLoop *runLoop;

@property (nonatomic, copy, readonly) NSString *name;


@property (nonatomic, weak) id<CinConnectionAgentDelegate> delegate;


- (id)initWithName:(NSString *)name address:(NSString *)address runLoop:(CinRunLoop *)runLoop;

- (void)connect;
- (void)disconnect;


 
- (BOOL)sendRequestTransaction:(CinTransaction *)transaction;

- (BOOL)sendResponseTransaction:(CinTransaction *)transaction;
  

@end
 
