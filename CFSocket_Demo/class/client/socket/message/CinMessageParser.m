//
//  CinMessageParser.m
//  CFSocket_Demo
//
//  Created by edz on 2020/7/28.
//  Copyright © 2020 EDZ. All rights reserved.
//

#import "CinMessageParser.h"
#import "CinRequest.h"
#import "CinResponse.h"

// 协议格式
// methodType(1字节) + methodBodyLength(4字节) + methodBody + methodEnd(0x00)
#define kMaxMessageLength        67108864

@interface CinMessageParser()
 
@property (nonatomic, strong) NSMutableData *data;

@end
 

@implementation CinMessageParser

-(NSArray<id<CinMessageProtocal>> *)parseData:(NSData *)data{
    // 必须枷锁
    @synchronized ([self class]) {
        //
        [self.data appendData:data];
        unsigned char *pointer = (unsigned char *)(data.bytes);
        NSInteger point = 0;
        NSInteger bufferLength = self.data.length;
        NSMutableArray< id<CinMessageProtocal> > *messgeArrM = [NSMutableArray array];
        
        while (point < bufferLength) {// 在这里需要做 粘包 和 断包的处理
            // 解析数据
            pointer;
            // ...
            
            // 裁剪掉已经 解析的data, 将不足解析的剩余部分 存起来
            // 比如下面就是剩余的
            self.data = [[self.data subdataWithRange: NSMakeRange(100, 10)] mutableCopy];
            break;
        }
        return messgeArrM;
    }
}
@end
