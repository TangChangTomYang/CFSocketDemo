//
//  CinRunLoop.h
//  CFSocket_Demo
//
//  Created by edz on 2020/7/27.
//  Copyright © 2020 EDZ. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CinRunLoop : NSObject

- (NSRunLoop *)getNSRunLoop;

- (CFRunLoopRef)getCFRunLoop;


- (NSThread *)getThread;
- (void)closeRunLoop;



@end


