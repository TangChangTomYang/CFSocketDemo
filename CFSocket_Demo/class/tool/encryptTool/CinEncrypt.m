//
//  CinEncrypt.m
//  CinCommon
//
//  Created by Melman on 15/05/15.
//  Copyright (c) 2015 p. All rights reserved.
//
#import "CinConvertUtil.h"
#import "CinEncrypt.h"
#import "sm4.h"

#define SM4_BLOCK_SIZE          16
#define SM4_KEY_SIZE            16

@implementation CinEncrypt

+ (NSData *)encryptWithText:(NSString *)message andKey:(NSData *)key andToken:(NSData *)token{
    NSData *msgData = [message dataUsingEncoding:NSUTF8StringEncoding];
    
    return [CinEncrypt encryptWithData:msgData andKey:key andToken:token];
}

// msgData  待加密数据
// key      uuid
// token    acp token
// acpToken + uuid 就是 AES 的 key
+ (NSData *)encryptWithData:(NSData *)msgData andKey:(NSData *)key andToken:(NSData *)token{
    NSData *encryptKey = [CinEncrypt bindToken:token andKey:key];
    //    NSData* ret = [CinEncrypt encryptWithValue:msgData andKey:encryptKey];
    NSData *ret = [CinEncrypt EncryptAES128WithValue:msgData andKey:[CinConvertUtil getMD5:encryptKey]];
    return ret;
    
}

+ (NSData *)encryptWithData:(NSData *)msgData andKey:(NSData *)key{
    NSData *ret = [CinEncrypt EncryptAES128WithValue:msgData andKey:key];
    return ret;
}

+ (NSData *)decryptWithData:(NSData *)msgData andKey:(NSData *)key{
    NSData *ret = [CinEncrypt DecryptAES128WithValue:msgData andKey:key];
    return ret;
}

+ (NSData *)decryptWithOrigin:(NSData *)data andKey:(NSData *)key andToken:(NSData *)token{
    NSData *encryptKey = [CinEncrypt bindToken:token andKey:key];
    //    NSData *ret = [CinEncrypt encryptWithValue:data andKey:encryptKey];
    NSData *ret = [CinEncrypt DecryptAES128WithValue:data andKey:[CinConvertUtil getMD5:encryptKey]];
    return ret;
}

+(NSData *)encryptWithValue:(NSData *)msg andKey:(NSData *)key{
    unsigned char* msgPointer = (unsigned char*)[msg bytes];
    unsigned char* keyPointer = (unsigned char*)[key bytes];
    for (int i = 0; i < msg.length; i++)
    {
        msgPointer[i] = msgPointer[i] ^ keyPointer[i%key.length];
    }
    return [[NSData alloc]initWithBytes:msgPointer length:msg.length];
}

+(NSMutableData *)bindToken:(NSData *)token andKey:(NSData *)key{
    NSMutableData *ret = [[NSMutableData alloc]init];
    [ret appendData:token];
    [ret appendData:key];
    return ret;
}


+(NSData *)EncryptAES128WithValue:(NSData *)msg andKey:(NSData *)key{
    char keyPtr[kCCKeySizeAES128+1];
    bzero(keyPtr, sizeof(keyPtr));
    memcpy(keyPtr, [key bytes], key.length);
    NSUInteger dataLength = [msg length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [msg bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}
+(NSData *)DecryptAES128WithValue:(NSData *)msg andKey:(NSData *)key{
    char keyPtr[kCCKeySizeAES128+1];
    bzero(keyPtr, sizeof(keyPtr));
    //    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    memcpy(keyPtr, [key bytes], key.length);
    NSUInteger dataLength = [msg length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [msg bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer);
    return nil;
}

#pragma mark - SM4加解密

#pragma mark - SM4加密
+ (NSData *)SM4EncryptWithText:(NSString *)message key:(NSData *)skey token:(NSData *)token {
    NSData *text = [message dataUsingEncoding:NSUTF8StringEncoding];
    return [[self class] SM4EncryptWithData:text key:skey token:token];
}

#pragma mark - SM4加密
+ (NSData *)SM4EncryptWithData:(NSData *)text key:(NSData *)skey token:(NSData *)token {
    NSData *encryptKey = [CinEncrypt bindToken:token andKey:skey];
    NSData *md5Key = [CinConvertUtil getMD5:encryptKey];
    
    if(md5Key.length != SM4_KEY_SIZE){
        return nil;
    }
    
    //format input
    int len = (int)text.length + 4;
    int size = [[self class] calculateTimesWithValue:len times:SM4_BLOCK_SIZE];
    NSData *input_len = [[self class] getTimesDataWithIntValue:(int)text.length];
    unsigned char input[size];
    memset(input, 0, size);
    memcpy(input, input_len.bytes, 4);
    memcpy(input + 4, text.bytes, text.length);
    //output
    unsigned char output[size];
    memset(output, 0, size);
    //key
    unsigned char key[SM4_KEY_SIZE] = {0};
    memcpy(key, md5Key.bytes, SM4_KEY_SIZE);
    //encrypt.
    sm4_context ctx;
    sm4_setkey_enc(&ctx,key);
    sm4_crypt_ecb(&ctx,1,size,input,output);
    //
    NSMutableData *resultData = [[NSMutableData alloc] init];
    [resultData appendBytes:output length:size];
    
    return resultData;
}

#pragma mark - SM4解密
+ (NSData *)SM4DecryptWithData:(NSData *)text key:(NSData *)skey token:(NSData *)token {
    NSData *encryptKey = [CinEncrypt bindToken:token andKey:skey];
    NSData *md5Key = [CinConvertUtil getMD5:encryptKey];
    
    if (md5Key.length != SM4_KEY_SIZE) {
        return nil;
    }
    if(text.length % SM4_BLOCK_SIZE != 0) {
        return nil;
    }
    int size = (int)text.length;
    unsigned char input[size];
    memset(input, 0, size);
    memcpy(input, text.bytes, text.length);
    
    unsigned char output[size];
    memset(output, 0, size);
    
    unsigned char key[SM4_KEY_SIZE] = {0};
    memcpy(key, md5Key.bytes, md5Key.length);
    
    sm4_context ctx;
    sm4_setkey_dec(&ctx,key);
    sm4_crypt_ecb(&ctx,0,size,input,output);
    
    //remove the zero paddings.
    NSMutableData *output_len = [[NSMutableData alloc] init];
    [output_len appendBytes:output length:4];
    int len = [[self class] getTimesIntWithDataValue:output_len];
    int len2 = MIN((int)len, size - 4);
    len2 = MAX(0, len2);
    NSMutableData *result = [[NSMutableData alloc] init];
    [result appendBytes:output + 4 length:MIN(len2, size - 4)];
    return result;
}

+ (int)calculateTimesWithValue:(int)value times:(int)times {
    if(times > 0) {
        int r = (value%times)?((value/times + 1)*times): value;
        return r;
    } else {
        return value;
    }
}

+ (NSData *)getTimesDataWithIntValue:(int)value {
    char buff[4] = {0};
    buff[0] = (value>>(3*8))&0xff;
    buff[1] = (value>>(2*8))&0xff;
    buff[2] = (value>>(1*8))&0xff;
    buff[3] = (value>>(0*8))&0xff;
    
    NSMutableData *result = [[NSMutableData alloc] init];
    [result appendBytes:buff length:4];
    return result;
}

+ (int)getTimesIntWithDataValue:(NSData *)value {
    if (value.length >= 4) {
        int d = 0;
        const char *p = [value bytes];
        d += (p[0]<<(3*8));
        d += (p[1]<<(2*8));
        d += (p[2]<<(1*8));
        d += (p[3]<<(0*8));
        return d;
    } else {
        return 0;
    }
}

@end
