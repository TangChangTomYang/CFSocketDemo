//
//  CinMessageParser.h
//  CFSocket_Demo
//
//  Created by edz on 2020/7/28.
//  Copyright © 2020 EDZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CinMessageProtocal.h"


@interface CinMessageParser : NSObject

-(NSArray<id<CinMessageProtocal>> *)parseData:(NSData *)data;
@end
 
