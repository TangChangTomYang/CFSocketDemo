//
//  CinConnection.h
//  CFSocket_Demo
//
//  Created by edz on 2020/7/28.
//  Copyright © 2020 EDZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CinSocket.h"
@class CinRequest;
@class CinResponse;
@class CinConnection;


@protocol CinConnectionDelegate <NSObject>

- (void)connectionDidConnected:(CinConnection *)connection;
- (void)connectionDidDisconnected:(CinConnection *)connection;

- (void)connection:(CinConnection *)connection didRecieveData:(NSData*)data;

- (void)connection:(CinConnection *)connection didReciveRequest:(CinRequest*)req;
- (void)connection:(CinConnection *)connection didRecieveResponse:(CinResponse*)resp;


@end

@interface CinConnection : NSObject<CinSocketDelegate>

@property (nonatomic, assign, readonly) BOOL isAddress;
@property (nonatomic, copy, readonly) NSString *socketAddress;
@property (nonatomic, assign, readonly, getter=isConnected) BOOL connected;
@property (nonatomic, strong, readonly) CinRunLoop *runLoop;

@property (nonatomic, weak) id<CinConnectionDelegate> delegate;

- (id)initAddress:(NSString *)address withRunLoop:(CinRunLoop *)runLoop;

- (void)connect;
- (void)disconnect;

- (BOOL)sendRequest:(CinRequest *)req;
- (BOOL)sendResponse:(CinResponse *)resp;

@end
 
