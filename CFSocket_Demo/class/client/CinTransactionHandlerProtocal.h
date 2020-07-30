//
//  CinTransactionHandleProtocal.h
//  CFSocket_Demo
//
//  Created by edz on 2020/7/29.
//  Copyright © 2020 EDZ. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CinTransaction;
 
@protocol CinTransactionHandlerProtocal <NSObject>

@required
// 处理服务端 的推送请求
- (BOOL)handleTransaction:(CinTransaction *)transaction;
@end
 
