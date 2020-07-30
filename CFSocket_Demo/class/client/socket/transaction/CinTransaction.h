//
//  CinTransaction.h
//  CFSocket_Demo
//
//  Created by edz on 2020/7/28.
//  Copyright © 2020 EDZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CinResponse.h"
#import "CinRequest.h"

@class CinConnectionAgent;
 
@interface CinTransaction : NSObject

@property (nonatomic, strong) CinRequest *request;
@property (nonatomic, copy) void(^timeOutCallBack)(void);
@property (nonatomic, copy) void(^receivedResponseCallBack)(CinResponse *response);


@property (nonatomic, strong) CinResponse *response;

@property (nonatomic, copy, readonly) NSString *requestkey;
-(instancetype)init:(CinRequest *)request connectionAgent:(CinConnectionAgent *)connectionAgent;

// 给服务端发送 请求
- (BOOL)sendRequest;
// 给服务端 响应请求
- (BOOL)sendResponse:(CinResponse *)response;

- (BOOL)isExpired:(NSDate *)now;

- (void)doTimeOut;
- (void)doReceivedResponse:(CinResponse *)response;
@end
 
