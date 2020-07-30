//
//  CinConnectionAgent.m
//  CFSocket_Demo
//
//  Created by edz on 2020/7/28.
//  Copyright © 2020 EDZ. All rights reserved.
//

#import "CinConnectionAgent.h"


#define kAgentCallBackQueue       "kAgentCallBackQueue"


@interface CinConnectionAgent(){
    dispatch_queue_t _queue;
    NSString *_name; 
}

@property (nonatomic, strong) CinConnection *connection;
@property (nonatomic, strong) CinTransactionManager *transactionMgr;
@end


@implementation CinConnectionAgent

- (void)dealloc {
    self.transactionMgr = nil;
    self.connection = nil;
}

- (id)initWithName:(NSString *)name address:(NSString *)address runLoop:(CinRunLoop *)runLoop;{
    self = [super init];
    if (self) {
        _queue = dispatch_queue_create(kAgentCallBackQueue, nil);
        _name = name;
        
        CinConnection *connection = [[CinConnection alloc] initAddress:address withRunLoop:runLoop];
        connection.delegate = self;
        self.connection = connection;
        
        self.transactionMgr = [[CinTransactionManager  alloc] init:[runLoop getNSRunLoop]];
    }
    return self;
}

-(NSString *)description{
    return  [NSString stringWithFormat:@"CinConnectionAgent: %@", self.name];
}


#pragma mark- getter
-(BOOL)isAddress{
    return self.connection.isAddress;
}

-(NSString *)socketAddress{
    return self.connection.socketAddress;
}

-(BOOL)isConnected{
    return self.connection.isConnected;
}

-(CinRunLoop *)runLoop{
    return self.connection.runLoop;
}

-(NSString *)name{
    return _name;
}


#pragma mark- 动作
- (void)connect {
    [self.connection connect];
}

- (void)disconnect {
    [self.connection disconnect];
}

/**发送网络请求 给服务端*/
- (BOOL)sendRequestTransaction:(CinTransaction *)transaction{
    if ((self.connection == nil) || !self.connection.isConnected) {
        [transaction doTimeOut];
        return NO;
    }
    
    if (transaction.receivedResponseCallBack) {
        [self.transactionMgr addTransaction:transaction];;
    }
    BOOL result = [self.connection sendRequest:transaction.request];
    if(result == NO){
        [self.transactionMgr removeTransaction:transaction];
        [transaction doTimeOut];
    }
    return result;
}

/**响应服务端的 请求*/
- (BOOL)sendResponseTransaction:(CinTransaction *)transaction{
    if (self.connection == nil || !self.connection.isConnected) {
        [transaction doTimeOut];
        return NO;
    }
    
    return  [self.connection sendResponse:transaction.response];
}


#pragma mark- CinConnectionDelegate

- (void)connectionDidConnected:(CinConnection *)connection{
    dispatch_async(_queue, ^{
        if([self.delegate respondsToSelector:@selector(agentDidConnected:)]){
            [self.delegate agentDidConnected:self];
        }
    });
}

- (void)connectionDidDisconnected:(CinConnection *)connection{
    dispatch_async(_queue, ^{
        if ([self.delegate respondsToSelector:@selector(agentDidDisconnected:)]) {
            [self.delegate agentDidDisconnected:self];
        }
    });
}

- (void)connection:(CinConnection *)connection didRecieveData:(NSData*)data{
    dispatch_async(_queue, ^{
        if ([self.delegate respondsToSelector:@selector(agent:didRecieveData:)]) {
            [self.delegate agent:self didRecieveData:data];
        }
    });
}

// 接收到服务器端的推送消息
- (void)connection:(CinConnection *)connection didReciveRequest:(CinRequest*)request{
    if([self.delegate respondsToSelector:@selector(agent: didRecieveRequestTransaction:)]){
        dispatch_async(_queue, ^{
            CinTransaction *transaction = [[CinTransaction alloc] init:request connectionAgent:self];
            [self.delegate agent:self didRecieveRequestTransaction:transaction];
        });
    } 
}

// 接收到服务器端的 请求响应
- (void)connection:(CinConnection *)connection didRecieveResponse:(CinResponse*)response{
    NSString *requestKey = response.key;
    CinTransaction *transaction = [self.transactionMgr getTransactionForRequestkey:requestKey];
    if (transaction == nil) {
        NSLog(@"--- 警告!!! 在接收到服务器端 request 的 response 时, 没有找到对应的 transaction");
        return;
    }
    
    dispatch_async(_queue, ^{
        [transaction doReceivedResponse:response];
        [self.transactionMgr removeTransaction:transaction];
    });
    
}




@end
