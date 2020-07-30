//
//  CinSocket.h
//  CFSocket_Demo
//
//  Created by edz on 2020/7/27.
//  Copyright © 2020 EDZ. All rights reserved.
// -fno-objc-arc

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#include <netinet/in.h>
#import "CinRunLoop.h"

@class CinSocket;

@protocol CinSocketDelegate <NSObject>

- (void)socketDidConnected:(CinSocket *)socket ;

- (void)socketDidDisconnected:(CinSocket *)socket ;

- (void)socket:(CinSocket *)socket didRecieveData:(NSData*)data;

@end

 

@interface CinSocket : NSObject

@property (nonatomic, assign) BOOL enableLog;
@property (nonatomic, assign, readonly) BOOL isAddress;
@property (nonatomic, assign, readonly, getter=isConnected) BOOL  connected;
@property (nonatomic, copy, readonly) NSString *socketAddress;
@property (nonatomic, strong, readonly) CinRunLoop *runLoop;

@property (nonatomic, weak) id<CinSocketDelegate> delegate;


- (id)initAddress:(NSString*)address withRunLoop:(CinRunLoop *)runLoop;
- (id)initIP:(NSString *)ip withPort:(int)port withRunLoop:(CinRunLoop *)runLoop;


- (void)connect;

- (void)disconnect;

- (BOOL)sendData:(NSData*)data;
@end

 
