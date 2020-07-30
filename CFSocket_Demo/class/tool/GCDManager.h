//
//  GCDManager.h
//  CinCommonLibraryV2
//
//  Created by zhang yinglong on 12-12-24.
//
//

#import <Foundation/Foundation.h>


#if __has_feature(objc_arc)

#define SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(classname) \
\
+ (classname *)shared##classname;

#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname) \
\
static classname *shared##classname = nil; \
\
+ (classname *)shared##classname \
{ \
    static dispatch_once_t pred; \
    dispatch_once(&pred, ^{ shared##classname = [[classname alloc] init]; }); \
    return shared##classname; \
}

#else

#define SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(classname) \
\
+ (classname *)shared##classname;

#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname) \
\
static classname *shared##classname = nil; \
\
+ (classname *)shared##classname \
{ \
    static dispatch_once_t pred; \
    dispatch_once(&pred, ^{ shared##classname = [[classname alloc] init]; }); \
    return shared##classname; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
    return self; \
} \
\
- (id)retain \
{ \
    return self; \
} \
\
- (NSUInteger)retainCount \
{ \
    return NSUIntegerMax; \
} \
\
- (oneway void)release \
{ \
} \
\
- (id)autorelease \
{ \
    return self; \
}

#endif



typedef enum {
    QueuePriorityTypeHigh = DISPATCH_QUEUE_PRIORITY_HIGH,
    QueuePriorityTypeDefault = DISPATCH_QUEUE_PRIORITY_DEFAULT,
    QueuePriorityTypeLow = DISPATCH_QUEUE_PRIORITY_LOW,
    QueuePriorityTypeBackGround = DISPATCH_QUEUE_PRIORITY_BACKGROUND
} QueuePriorityType;

@interface GCDManager : NSObject

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(GCDManager);

// 主线程
- (void)doWorkInMainQueue:(dispatch_block_t)task;

- (void)doSyncWorkInMainQueue:(dispatch_block_t)task;

// 并发快速遍历
- (void)doFastCycleWork:(size_t)cycleCount withTask:(void (^)(size_t))task;

// 并发队列的异步调用
- (void)doParallelQueueAsyncWork:(dispatch_block_t)task;

- (void)doParallelQueueAsyncWork:(dispatch_block_t)task withComplete:(dispatch_block_t)complete;

- (void)doParallelQueueAsyncWork:(dispatch_block_t)task withInQueue:(dispatch_queue_t)queue withComplete:(dispatch_block_t)complete;

- (void)doParallelQueueAsyncWork:(dispatch_block_t)task
                     withInQueue:(dispatch_queue_t)queue
               withCompleteQueue:(NSString *)completeQueue
                    withComplete:(dispatch_block_t)complete;

- (void)doParallelQueueAsyncWork:(dispatch_block_t)task withCompleteQueue:(NSString *)completeQueue withComplete:(dispatch_block_t)complete;

// 并发队列的同步调用
- (void)doParallelQueueSyncWork:(dispatch_block_t)task;

// 串行队列的异步调用
- (void)doSerialQueueAsyncWork:(NSString *)taskQueue andTask:(dispatch_block_t)task;

- (void)doSerialQueueAsyncWork:(NSString *)taskQueue andTask:(dispatch_block_t)task withComplete:(dispatch_block_t)complete;

- (void)doSerialQueueAsyncWork:(NSString *)taskQueue andTask:(dispatch_block_t)task withCompleteQueue:(NSString *)completeQueue withComplete:(dispatch_block_t)complete;

// 串行队列的同步调用
- (void)doSerialQueueSyncWork:(NSString *)taskQueue andTask:(dispatch_block_t)task;

// 多任务组异步调用
- (void)doParallelQueueAsyncGroupWork:(NSArray *)works withComplete:(dispatch_block_t)complete;

@end
