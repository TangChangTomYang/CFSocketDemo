//
//  CinQueue.m
//  CinCommonLibraryV2
//
//  Created by ProbeStar on 13-1-9.
//
//

#import "CinQueue.h"

@implementation CinQueue

-(id)init {
    self = [super init];
    if (self) {
        _array = [[NSMutableArray alloc] init];
    }
    return self;
}
 

-(void)enqueue:(id)obj {
    @synchronized(self) {
        [_array addObject:obj];
    }
}

-(id)dequeue {
    id ret = nil;
    @synchronized(self) {
        if ([_array count] > 0) {
            ret = [_array objectAtIndex:0];
            [_array removeObjectAtIndex:0];
        }
    }
    return ret;
}

-(id)pick{
    id ret = nil;
    @synchronized(self) {
        if ([_array count] > 0) {
            ret = [_array objectAtIndex:0];
        }
    }
    return ret;
}
-(void)remove:(id)obj {
    @synchronized(self) {
        [_array removeObject:obj];
    }
}

-(BOOL)contain:(id)obj {
    @synchronized(self) {
        return [_array containsObject:obj];
    }
}

-(void)clear {
    @synchronized(self) {
        [_array removeAllObjects];
    }
}

-(int)size {
    @synchronized(self) {
        return [_array count];
    }
}

-(void)queueJumper:(id)obj {
    @synchronized(self) {
        [_array insertObject:obj atIndex:0];
    }
}
@end
