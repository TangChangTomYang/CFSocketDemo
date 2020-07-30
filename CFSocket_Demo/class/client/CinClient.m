//
//  CinClient.m
//  CFSocket_Demo
//
//  Created by edz on 2020/7/29.
//  Copyright © 2020 EDZ. All rights reserved.
//

#import "CinClient.h"


@interface CinClient ()<CinConnectionAgentDelegate>{
    CinConnectionAgent *_connectionAgent;
    FMDatabaseQueue *_dbQueue;
}
@end


static int _CinClientIndex = 0;

@implementation CinClient
 

-(NSString *)description{
    return [NSString stringWithFormat:@"CinClient: %@", self.name];
}

-(NSString *)name{
    if (!_name) {
        _name = [NSString stringWithFormat:@"%d",_CinClientIndex++];
    }
    return _name;
}

-(NSMutableDictionary<NSString *,id<CinTransactionHandlerProtocal>> *)transactionHandlerDicM{
    if(!_transactionHandlerDicM){
        _transactionHandlerDicM = [NSMutableDictionary dictionary];
    }
    return _transactionHandlerDicM;
}

-(NSMutableArray<id<CinDBCreaterProtocal>> *)dbCreaterArrM{
    if(!_dbCreaterArrM){
        _dbCreaterArrM = [NSMutableArray array];
    }
    return _dbCreaterArrM;
}

-(NSMutableArray<id<CinAppTerminateHandlerProtocal>> *)terminateHandlerArrM{
    if(!_terminateHandlerArrM){
        _terminateHandlerArrM = [NSMutableArray array];
    }
    return _terminateHandlerArrM;
}

-(CinConnectionAgent *)connectionAgent{
    return _connectionAgent;
}

-(FMDatabaseQueue *)dbQueue{
    return _dbQueue;
}



#pragma mark- socket 通信相关
-(void)connect:(NSString *)address{
    if (_connectionAgent != nil) {
        _connectionAgent.delegate = nil;
        [_connectionAgent disconnect];
        _connectionAgent = nil;
    }
    
    CinRunLoop *runLoop = [[CinRunLoop alloc] init];
    _connectionAgent = [[CinConnectionAgent alloc] initWithName:self.name address:address runLoop:runLoop];
    _connectionAgent.delegate = self;
    [_connectionAgent connect];
}

-(void)disconnect{
    if(_connectionAgent){
        [_connectionAgent disconnect];
    }
}

- (CinTransaction *)createTransaction:(CinRequest *)request{
    if (_connectionAgent) {
        CinTransaction *transaction = [[CinTransaction alloc] init:request connectionAgent:_connectionAgent];
        return transaction;
    }
    NSLog(@"---警告!!! CinClient创建CinTransaction时, _connectionAgent 为 nil ");
    return nil;
    
}


#pragma mark- CinTransactionHandler 相关
// 注册 requestKey 对应的handler, 用于响应服务器端的推送 请求
- (void)registerTransactionHandler:(id<CinTransactionHandlerProtocal>)transactionHandler
                        requestKey:(NSString *)requestKey{
    
    self.transactionHandlerDicM[requestKey] = transactionHandler;
}

#pragma mark- DBCreater 相关
- (void)registerDBCreater:(id<CinDBCreaterProtocal>)dbCreater{
    if (![self.dbCreaterArrM containsObject:dbCreater]) {
        [self.dbCreaterArrM addObject:dbCreater];
    }
}

-(void)initCreateTable{
    for (id<CinDBCreaterProtocal> dbCreater in self.dbCreaterArrM) {
        [dbCreater createDatabase];
    }
}

- (void)openDatabase:(NSString *)userID{
    if (_dbQueue) {
        [self closeDB];
        return;
    }
    
    NSString *userDirectory = [self directoryOfUser:userID];
    NSString *dbPath = [userDirectory stringByAppendingPathComponent:@"im.db"];
    _dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
}

- (void)closeDB{
    [_dbQueue close];
    _dbQueue = nil;
}


-(NSString *)directoryOfUser:(NSString *)userId{
    
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSString *userDirectory = [cachePath stringByAppendingPathComponent:userId];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:userDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:userDirectory
                                  withIntermediateDirectories:NO
                                                   attributes:nil error:nil];
    }
    return userDirectory;
}

#pragma mark- AppTerminateHandler
- (void)registerTerminateHandler:(id<CinAppTerminateHandlerProtocal>)handler{
    if (![self.terminateHandlerArrM containsObject:handler]) {
        [self.terminateHandlerArrM addObject:handler];
    }
}

- (void)doTerminateHandlerTask{
    for (id<CinAppTerminateHandlerProtocal> handler in self.terminateHandlerArrM) {
        [handler applicationWillTerminateTask];
    }
}
 
#pragma mark- CinConnectionAgentDelegate
- (void)agentDidConnected:(CinConnectionAgent *)agent{
    if ([self.delegate respondsToSelector:@selector(clientDidConnected:)]) {
        [self.delegate clientDidConnected:self];
    }
}

- (void)agentDidDisconnected:(CinConnectionAgent *)agent{
    if ([self.delegate respondsToSelector:@selector(clientDidDisConnected:)]) {
        [self.delegate clientDidDisConnected:self];
    }
}

- (void)agent:(CinConnectionAgent *)agent didRecieveData:(NSData*)data{
    if ([self.delegate respondsToSelector:@selector(client: didRecieveData:)]) {
        [self.delegate client:self didRecieveData:data];
    }
}

- (void)agent:(CinConnectionAgent *)agent didRecieveRequestTransaction:(CinTransaction *)transaction{
    NSString *requestkey = transaction.requestkey;
    id<CinTransactionHandlerProtocal> handler = self.transactionHandlerDicM[requestkey];
    if (handler) {
        [handler handleTransaction:transaction];
        return;
    }
    
    if (!handler) { // 没有与之对应的 handler 来处理 服务端的推送信息
        NSLog(@"---警告!!! ---- 接收到服务端的非法 请求, not support request: %@", requestkey);
        // 客户端不支持的 请求响应
        CinResponse *notSupportResponse = [[CinResponse alloc] init];
        [transaction sendResponse:notSupportResponse];
    }
}

@end
