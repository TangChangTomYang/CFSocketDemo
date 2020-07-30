//
//  CinQueue.h
//  CinCommonLibraryV2
//
//  Created by ProbeStar on 13-1-9.
//
//

#import <Foundation/Foundation.h>

@interface CinQueue : NSObject {
    NSMutableArray *_array;
}

//放队尾
-(void)enqueue:(id)obj;
//移除队列
-(id)dequeue;

-(void)clear;

-(void)remove:(id)obj;
-(BOOL)contain:(id)obj;

-(int)size;
//放队首
-(void)queueJumper:(id)obj;

-(id)pick;
@end
