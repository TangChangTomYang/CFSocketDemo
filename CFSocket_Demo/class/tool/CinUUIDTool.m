//
//  CinUUIDTool.m
//  CFSocket_Demo
//
//  Created by edz on 2020/7/28.
//  Copyright © 2020 EDZ. All rights reserved.
//

#import "CinUUIDTool.h"

@implementation CinUUIDTool

+ (NSString*) getUUID {
    CFUUIDRef UUID = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef UUIDString = CFUUIDCreateString(kCFAllocatorDefault, UUID);
    NSString *result = [[NSString alloc] initWithString:(NSString*)CFBridgingRelease(UUIDString)];
    CFRelease(UUID);
    CFRelease(UUIDString);
    return result;
}

+ (NSData *) getUUIDData {
    CFUUIDRef UUID = CFUUIDCreate(kCFAllocatorDefault);
    CFUUIDBytes bytes = CFUUIDGetUUIDBytes(UUID);
    NSData *result = [[NSData alloc] initWithBytes:&bytes length:sizeof(bytes)];
    CFRelease(UUID);
    return result;
}
@end
