//
//  CinConnection.m
//  CFSocket_Demo
//
//  Created by edz on 2020/7/28.
//  Copyright © 2020 EDZ. All rights reserved.
//

#import "CinConnection.h"
#import "CinRequest.h"
#import "CinResponse.h"
#import "CinMessageParser.h"

@interface CinConnection (){
    CinSocket *_socket;
    BOOL _isAddress;
}

@property (nonatomic, strong) CinMessageParser *parser;
@end

@implementation CinConnection

- (void)dealloc {
    _socket.delegate = nil;
}

- (id)initAddress:(NSString *)address withRunLoop:(CinRunLoop *)runLoop {
    self = [super init];
    if (self) {
        _socket = [[CinSocket alloc] initAddress:address withRunLoop:runLoop];
        _socket.delegate = self;
        _socket.enableLog = NO;
        self.parser = [[CinMessageParser alloc] init];
    }
    return self;
}

#pragma mark- getter
-(BOOL)isAddress{
    return _socket.isAddress;
}

-(BOOL)isConnected{
    return _socket.isConnected;
}

-(CinRunLoop *)runLoop{
    return _socket.runLoop;
}

-(NSString *)socketAddress{
    return _socket.socketAddress;
}


#pragma mark- socket 操作
- (void)connect; {
    [_socket connect];
}

- (void)disconnect {
    [_socket disconnect];
}

- (BOOL)sendRequest:(CinRequest *)req {
    return  [self connectionSendData: req.data];
}

- (BOOL)sendResponse:(CinResponse *)resp {
    return  [self connectionSendData:resp.data];
}


-(BOOL)connectionSendData:(NSData *)data{
    return [_socket sendData:data];
}


#pragma mark- CinSocketDelegate

- (void)socketDidConnected:(CinSocket *)socket {
    [self.delegate connectionDidConnected:self];
}

- (void)socketDidDisconnected:(CinSocket *)socket{
    [self.delegate connectionDidDisconnected:self];
}

- (void)socket:(CinSocket *)socket didRecieveData:(NSData*)data{
    [self.delegate connection:self didRecieveData:data];
    
    NSArray<id<CinMessageProtocal>> *messgeArrM = [self.parser parseData:data];
    for (id msg in messgeArrM) {
        if ([msg isKindOfClass:[CinRequest class]]) {
            [self.delegate connection:self didReciveRequest:(CinRequest *)msg];
        }
        else if([msg isKindOfClass:[CinResponse class]]){
            [self.delegate connection:self didRecieveResponse:(CinResponse *)msg];
        }
    }
}
@end
