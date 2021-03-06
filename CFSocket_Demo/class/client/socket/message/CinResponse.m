//
//  CinResponse.m
//  CFSocket_Demo
//
//  Created by edz on 2020/7/28.
//  Copyright © 2020 EDZ. All rights reserved.
//

#import "CinResponse.h"

 
@interface CinResponse (){
    int  _type;
    NSData *_data;
    NSString *_key;
}
 
@end

@implementation CinResponse

-(int)type{
    return _type;
}

-(void)setType:(int)type{
    _type = type;
}

-(NSData *)data{
    return _data;
}

-(void)setData:(NSData *)data{
    _data = data;
}

-(NSString *)key{
    return _key;
}

-(void)setKey:(NSString *)key{
    _key = key;
}
@end
