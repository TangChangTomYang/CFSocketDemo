//
//  CinConvertUtil.h
//  CinCommon
//
//  Created by 曹 立冬 on 13-7-31.
//  Copyright (c) 2013年 p. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@interface CinConvertUtil : NSObject

+ (NSData *)getHashBytes:(NSData *)data;

+ (NSString *)bytes2HexString:(NSData *)data;

+ (NSData *)hexString2Bytes:(NSString*)hexString;

+ (NSData *)longlong2Bytes:(long long)value;

+ (NSString *)getCinBase64StringFromData:(NSData *)data;

+ (NSString *)getCinBase64StringFromString:(NSString *)data;  // X -> 64

+ (NSString *)getCinBase64StringFromLong:(long long)data;

+ (NSData *)dataWithBase64EncodedString:(NSString*)string;

+ (NSString *)getStringWithBase64EncodedString:(NSString *)encodedString; // 64 - > X

//MD5
+ (NSString *)getMD5StringOfString:(NSString *)string;

+ (NSString *)getMD5StringOfData:(NSData *)data;

+ (NSData *)getMD5:(NSData *)signKey;
@end
