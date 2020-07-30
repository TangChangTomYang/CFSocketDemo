//
//  CinDBCreaterProtocal.h
//  CFSocket_Demo
//
//  Created by edz on 2020/7/29.
//  Copyright © 2020 EDZ. All rights reserved.
//

#import <Foundation/Foundation.h>



@protocol CinDBCreaterProtocal <NSObject>

@required
// 创建数据库表
-(BOOL)createDatabase;
@end


