//
//  CinTransactionManager.m
//  CFSocket_Demo
//
//  Created by edz on 2020/7/28.
//  Copyright © 2020 EDZ. All rights reserved.
//

#import "CinTransactionManager.h"
#import "CinTransaction.h"


@interface CinTransactionManager (){
    NSRunLoop *_runLoop;
    NSTimer *_timer;
}

@property (nonatomic, strong) NSMutableDictionary<NSString *, CinTransaction *> *transactionDicM;
@property (nonatomic, strong) NSTimer *timeOutTimer;
@end


@implementation CinTransactionManager


-(id)init:(NSRunLoop *)runLoop {
    self = [super init];
    if (self) {
        _runLoop = runLoop;
        self.timeOutTimer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:3
                                            target:self
                                          selector:@selector(timeOutTimerAction) userInfo:nil repeats:YES];
        [_runLoop addTimer:_timer forMode:NSDefaultRunLoopMode];
        [_timer fire];
    }
    return self;
}

-(NSMutableDictionary<NSString *,CinTransaction *> *)transactionDicM{
    if(!_transactionDicM){
        _transactionDicM = [NSMutableDictionary dictionary];
    }
    return _transactionDicM;
}

-(void)timeOutTimerAction {
    
    NSDate *now = [NSDate date];
    @synchronized (self) {
        NSArray *keyArr = self.transactionDicM.allKeys;
        
        if (keyArr.count <= 0){
            return;
        }
            
        for (NSString *key in keyArr) {
            CinTransaction *trans = self.transactionDicM[key];
            
            if (trans && [trans isExpired:now]) {
                [self.transactionDicM removeObjectForKey:key];
                [trans doTimeOut];
            }
        }
    }
}

-(void)addTransaction:(CinTransaction*)transaction{
    @synchronized (self) {
        NSString *requestkey = transaction.requestkey;
        if (requestkey.length == 0) {
            NSLog(@"--- 警告!!! 添加 transaction时, transaction 的 key 长度为0");
        }
        self.transactionDicM[requestkey] = transaction;
    }
}

-(void)removeTransaction:(CinTransaction*)trans{
    @synchronized (self) {
        NSString *requestkey = trans.requestkey;
        if (requestkey.length == 0) {
            NSLog(@"--- 警告!!! 移除 transaction时, transaction 的 key 长度为0");
        }
        [self.transactionDicM removeObjectForKey:requestkey];
    }
}

-(CinTransaction *)getTransactionForRequestkey:(NSString *)requestkey{
    @synchronized (self) {
        if (requestkey.length == 0) {
            NSLog(@"--- 警告!!! 获取 transaction时, transaction 的 key 长度为0");
        }
        return self.transactionDicM[requestkey];
    }
}

@end
