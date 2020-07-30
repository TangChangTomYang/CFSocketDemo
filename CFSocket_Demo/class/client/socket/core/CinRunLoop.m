//
//  CinRunLoop.m
//  CFSocket_Demo
//
//  Created by edz on 2020/7/27.
//  Copyright © 2020 EDZ. All rights reserved.
//

#import "CinRunLoop.h"

@interface CinRunLoop (){
    BOOL _isRunning;
    NSThread *_thread;
    NSRunLoop *_runLoop;
    dispatch_semaphore_t _semaphore;
}
@end

@implementation CinRunLoop

- (id)init {
    self = [super init];
    if (self) {
        _semaphore = dispatch_semaphore_create(0);
        _isRunning = YES;
        _thread = [[NSThread alloc] initWithTarget:self selector:@selector(runLoopThreadAction) object:nil];
        [_thread start];
        if (_runLoop == nil){
            dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
        }
            
    }
    return self;
}

- (void)dealloc {
    _isRunning = NO;
}


// 线程保活
-(void)runLoopThreadAction{
    
    _runLoop = [NSRunLoop currentRunLoop];
    //没有源的时候runloop会疯狂的执行，目前没有找到好的方法，先放一个空timer进去
    [NSTimer scheduledTimerWithTimeInterval:60 * 60 target:nil selector:nil userInfo:nil repeats:YES];
    dispatch_semaphore_signal(_semaphore);
    do {
        @autoreleasepool {
            [_runLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:5]];
        }
    } while (_isRunning);
    
}


- (NSRunLoop *)getNSRunLoop {
    return _runLoop;
}

- (CFRunLoopRef)getCFRunLoop {
    return [_runLoop getCFRunLoop];
}

- (NSThread *)getThread {
    return _thread;
}

- (void)closeRunLoop {
    _isRunning = NO;
}


@end
