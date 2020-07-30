//
//  GCDManager.m
//  CinCommonLibraryV2
//
//  Created by zhang yinglong on 12-12-24.
//
//

#import "GCDManager.h"
#import <UIKit/UIKit.h>

__strong NSMutableDictionary *_serialQueuesDic = nil;

@interface QueueObject : NSObject {
    dispatch_queue_t _t;
}

- (id)initWithQueue:(dispatch_queue_t)t;

- (dispatch_queue_t)getQueue;

@end

@implementation QueueObject

- (id)initWithQueue:(dispatch_queue_t)t {
    self = [super init];
    if (self){
        _t = t;
    }
    return self;
}
 

- (dispatch_queue_t)getQueue {
    return _t;
}

@end

@interface GCDManager (private)

- (void)doAsyncWork:(dispatch_queue_t)t andTask:(dispatch_block_t)task withCompleteQueue:(dispatch_queue_t)c withComplete:(dispatch_block_t)complete;

- (void)doSyncWork:(dispatch_queue_t)t andTask:(dispatch_block_t)task;

@end

@implementation GCDManager (private)

- (void)doAsyncWork:(dispatch_queue_t)t andTask:(dispatch_block_t)task withCompleteQueue:(dispatch_queue_t)c withComplete:(dispatch_block_t)complete {
    NSAssert(t != nil, @"doSerialQueueAsyncWork t can not be nil");
    NSAssert(task != nil, @"doSerialQueueAsyncWork task can not be nil");
    dispatch_async(t, ^{
        // 执行任务
        task();
        
        // 结束任务,向指定队列报告结果
        if ( complete != nil)
        {
            dispatch_queue_t tmp = c;
            if (tmp == nil)
            {
                tmp = dispatch_get_main_queue();
            }
            dispatch_async(tmp, ^{
                complete();
            });
        }
    });
}

- (void)doSyncWork:(dispatch_queue_t)t andTask:(dispatch_block_t)task {
    NSAssert(t != nil, @"doSerialQueueAsyncWork t can not be nil");
    NSAssert(task != nil, @"doSerialQueueAsyncWork task can not be nil");
    dispatch_sync(t, ^{
        // 执行任务
        task();
    });
}

- (dispatch_queue_t) getMainUIQueue {
    return dispatch_get_main_queue();
}

- (dispatch_queue_t) getCurrentQueue {
    return dispatch_get_current_queue();
}

- (dispatch_queue_t) getSerialQueueWithName:(NSString *)name {
    @synchronized(self) {
        dispatch_queue_t ret = nil;
        if ( [_serialQueuesDic objectForKey:name] != nil ) {
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
                ret = (dispatch_queue_t)[_serialQueuesDic objectForKey:name];
            } else {
                QueueObject *tmp = (QueueObject *)[_serialQueuesDic objectForKey:name];
                ret = [tmp getQueue];
            }
        } else {
            ret = dispatch_queue_create([name cStringUsingEncoding:NSUTF8StringEncoding], nil);
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
                [_serialQueuesDic setObject:(id)ret forKey:name];
            
            }
            else {
                QueueObject *tmp = [[QueueObject alloc] initWithQueue:ret];
                
                [_serialQueuesDic setObject:tmp forKey:name];
                
            }
        }
        return ret;
    }
}

- (dispatch_queue_t) getParallelQueueWithPriority:(QueuePriorityType)Priority {
    return dispatch_get_global_queue(Priority, 0);
}

@end

@implementation GCDManager

SYNTHESIZE_SINGLETON_FOR_CLASS(GCDManager);

+ (void)initialize {
    _serialQueuesDic = [[NSMutableDictionary alloc] initWithCapacity:3];
}
 
- (void)doWorkInMainQueue:(dispatch_block_t)task {
    dispatch_async(dispatch_get_main_queue(), task);
}

- (void)doSyncWorkInMainQueue:(dispatch_block_t)task {
    if ([NSThread isMainThread])
        task();
    else
        dispatch_sync(dispatch_get_main_queue(), task);
}

- (void)doFastCycleWork:(size_t)cycleCount withTask:(void (^)(size_t i))task {
    dispatch_apply(cycleCount, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), task);
}

- (void)doParallelQueueAsyncWork:(dispatch_block_t)task {
    [self doParallelQueueAsyncWork:task withCompleteQueue:nil withComplete:nil];
}

- (void)doParallelQueueAsyncWork:(dispatch_block_t)task withComplete:(dispatch_block_t)complete {
    [self doParallelQueueAsyncWork:task withCompleteQueue:nil withComplete:complete];
}

- (void)doParallelQueueAsyncWork:(dispatch_block_t)task withInQueue:(dispatch_queue_t)queue withComplete:(dispatch_block_t)complete {
    [self doParallelQueueAsyncWork:task
                       withInQueue:queue
                 withCompleteQueue:nil
                      withComplete:complete];
}

- (void)doParallelQueueAsyncWork:(dispatch_block_t)task
                     withInQueue:(dispatch_queue_t)queue
               withCompleteQueue:(NSString *)completeQueue
                    withComplete:(dispatch_block_t)complete
{
    [self doAsyncWork:queue
              andTask:task
    withCompleteQueue:(completeQueue ? [self getSerialQueueWithName:completeQueue] : nil)
         withComplete:complete];
}

- (void)doParallelQueueAsyncWork:(dispatch_block_t)task withCompleteQueue:(NSString *)completeQueue withComplete:(dispatch_block_t)complete {
    [self doAsyncWork:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
              andTask:task
    withCompleteQueue:(completeQueue ? [self getSerialQueueWithName:completeQueue] : nil)
         withComplete:complete];
}

- (void)doParallelQueueSyncWork:(dispatch_block_t)task {
    [self doSyncWork:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) andTask:task];
}

- (void)doSerialQueueAsyncWork:(NSString *)taskQueue andTask:(dispatch_block_t)task {
    [self doSerialQueueAsyncWork:taskQueue andTask:task withCompleteQueue:nil withComplete:nil];
}

- (void)doSerialQueueAsyncWork:(NSString *)taskQueue andTask:(dispatch_block_t)task withComplete:(dispatch_block_t)complete {
    [self doSerialQueueAsyncWork:taskQueue andTask:task withCompleteQueue:nil withComplete:complete];
}

- (void)doSerialQueueAsyncWork:(NSString *)taskQueue andTask:(dispatch_block_t)task withCompleteQueue:(NSString *)completeQueue withComplete:(dispatch_block_t)complete {
    [self doAsyncWork:[self getSerialQueueWithName:taskQueue]
              andTask:task
    withCompleteQueue:(completeQueue ? [self getSerialQueueWithName:completeQueue] : nil)
         withComplete:complete];
}

- (void)doSerialQueueSyncWork:(NSString *)taskQueue andTask:(dispatch_block_t)task {
    [self doSyncWork:[self getSerialQueueWithName:taskQueue] andTask:task];
}

- (void)doParallelQueueAsyncGroupWork:(NSArray *)works withComplete:(dispatch_block_t)complete {
    NSAssert(works != nil, @"doParallelQueueAsyncGroupWork works can not be nil");

    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 创建多任务序列
    [works enumerateObjectsUsingBlock:^(dispatch_block_t t, NSUInteger idx, BOOL *stop) {
        if ( t ) {
            dispatch_group_async(group, queue, t);
        }
    }];
    if (complete) {
        dispatch_group_notify(group, dispatch_get_main_queue(), complete);
    }
  
}

@end
