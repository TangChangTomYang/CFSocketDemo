//
//  CinEncrypt.h
//  CinCommon
//
//  Created by Melman on 15/05/15.
//  Copyright (c) 2015 p. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CinEncrypt : NSObject
//文本加密
+ (NSData *)encryptWithText:(NSString *)message andKey:(NSData *)key andToken:(NSData *)token;
//解码
+ (NSData *)decryptWithOrigin:(NSData *)data andKey:(NSData *)key andToken:(NSData *)token;


//数据加密
+ (NSData *)encryptWithData:(NSData *)msgData andKey:(NSData *)key andToken:(NSData *)token;

+ (NSData *)encryptWithData:(NSData *)msgData andKey:(NSData *)key;
+ (NSData *)decryptWithData:(NSData *)msgData andKey:(NSData *)key;

//国密算法加解密
+ (NSData *)SM4EncryptWithText:(NSString *)message key:(NSData *)skey token:(NSData *)token;
+ (NSData *)SM4EncryptWithData:(NSData *)text key:(NSData *)skey token:(NSData *)token;
+ (NSData *)SM4DecryptWithData:(NSData *)text key:(NSData *)skey token:(NSData *)token;@end
