//
//  CinTransaction.m
//  CFSocket_Demo
//
//  Created by edz on 2020/7/28.
//  Copyright © 2020 EDZ. All rights reserved.
//

#import "CinTransaction.h"
#import "CinConnectionAgent.h"


@interface CinTransaction(){
    CinConnectionAgent *_connectionAgent;
    NSDate *_expireDate;
}

@end


@implementation CinTransaction


-(instancetype)init:(CinRequest *)request
    connectionAgent:(CinConnectionAgent *)connectionAgent{
    self = [super init];
    if(self){
        _expireDate = nil;
        _connectionAgent = connectionAgent;
        self.request = request;
    }
    return self;
}

- (BOOL)sendRequest{
    if (self.request == nil) {
        return NO;
    }
    return  [_connectionAgent sendRequestTransaction:self];
}

- (BOOL)sendResponse:(CinResponse *)response{
    self.response = response;
    return  [_connectionAgent sendResponseTransaction:self];
}


- (BOOL)isExpired:(NSDate *)now {
    if (_expireDate == nil){
        return NO;
    }
    return [_expireDate compare:now] == NSOrderedAscending;
}


- (void)doTimeOut {
    if (self.timeOutCallBack) {
        self.receivedResponseCallBack = nil;
        self.timeOutCallBack();
        self.timeOutCallBack = nil;
    }
}
 
- (void)doReceivedResponse:(CinResponse *)response{
    if (self.receivedResponseCallBack) {
        self.timeOutCallBack = nil;
        self.receivedResponseCallBack(response);
        self.receivedResponseCallBack = nil;
    }
}

#pragma mark- getter
-(NSString *)requestkey{
    if (self.request) {
        return self.request.key;
    }
    return @"";
}
@end
