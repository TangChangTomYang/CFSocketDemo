//
//  CinTransactionManager.h
//  CFSocket_Demo
//
//  Created by edz on 2020/7/28.
//  Copyright © 2020 EDZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CinTransaction.h"

@interface CinTransactionManager : NSObject


-(id)init:(NSRunLoop*)runLoop;

-(void)addTransaction:(CinTransaction*)trans;
-(void)removeTransaction:(CinTransaction*)trans;
-(CinTransaction *)getTransactionForRequestkey:(NSString *)key;

@end

