//
//  FileUtil.h
//  AVVideoFramework
//
//  Created by 曹 立冬 on 13-7-30.
//  Copyright (c) 2013年 曹 立冬. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileUtil : NSObject

//提供获取document路径
+(NSString *)getDocumentPath;

//获取应用程序路径
+(NSString *)getApplicationPath;

//获取cache缓存路径
+(NSString *)getCachePath;

//获取temp路径
+(NSString *)getTempPath;

//判断文件是否存在
+(BOOL)isExist:(NSString *)filePath;

//判断文件是否存在并且数据完整
+(BOOL)isFull:(NSString *)filePath  fullSize:(long long )fullSize;

//删除文件
+(BOOL)removeFile:(NSString *)filePath;

+(BOOL)createAtDir:(NSString *)dirPath;
//创建文件夹 如果中间的文件夹没有生成  也可以默认生成
+(BOOL)createDir:(NSString *)dirPath;

//创建文件  如果中间的文件夹没有生成  也可以默认生成
+(BOOL)createFile:(NSString *)filePath;

//保存文件
+(BOOL)saveFile:(NSString *)filePath
        andData:(NSData *)data;

//追加写文件
+(void)saveFileWithAppendData:(NSData *)data withPath:(NSString *)path ;

//读取文件
+ (NSData *)getFileData:(NSString *)path ;

+ (NSData *)getFileData:(NSString *)path startIndex:(long long)startIndex length:(long long)length;

//移动文件
+(BOOL)moveFileFromPath:(NSString *)from toPath:(NSString *)to;

//拷贝文件
+(BOOL)copyFIleFromPath:(NSString *)from toPath:(NSString *)to;

//获取文件夹下文件列表
+(NSArray *)getFileListInDirPath:(NSString *)dirPath;

//获取文件属性
+(unsigned long long)getFileSize:(NSString *)filePath;      //获取文件大小
+(NSDate *)getFileCreateDate:(NSString *)filePath;          //获取文件创建日期
+(NSString *)getFileOwner:(NSString *)filePath;             //获取文件所有者
+(NSDate *)getFileChangeDate:(NSString *)filePath;          //获取文件更改日期



// 获取文件内容的MD5
+ (NSString *)getMD5WithPath:(NSString *)path ;

@end
