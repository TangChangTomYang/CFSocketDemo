//
//  HanZiPinYin.m
//  CinCommon
//
//  Created by YuGuangzhen on 13-10-16.
//  Copyright (c) 2013年 p. All rights reserved.
//

#import "HanZiPinYin.h"

@implementation HanZiPinYin

static NSMutableDictionary *gPinyinDic = nil;

// pinyin library dictionary
+ (NSDictionary *)getPinyinDic {
    @synchronized (self) {
        if (gPinyinDic == nil) {
            gPinyinDic = [[NSMutableDictionary alloc] initWithCapacity:1000];
            
            NSString *filename = [[NSBundle mainBundle] pathForResource:@"pinyin_db.bin" ofType:nil];
            NSData *readData = [NSData dataWithContentsOfFile:filename];
            unsigned short read_ID;
            int offset = 0;
            //读取ID
            while (offset < [readData length])
            {
                [readData getBytes:&read_ID range:NSMakeRange(offset,sizeof(read_ID))];
                offset += sizeof(read_ID);
                unsigned char valueLen = 0;
                [readData getBytes:&valueLen range:NSMakeRange(offset, 1)];
                offset += 1;
                NSData *value = [readData subdataWithRange:NSMakeRange(offset, valueLen)];
                offset += valueLen;
                NSString *strValue = [[NSString alloc]initWithData:value encoding:NSASCIIStringEncoding];
                NSNumber *keyNumber = [NSNumber numberWithUnsignedShort:read_ID];
                NSArray * valueArray = [strValue componentsSeparatedByString:@","];
                [gPinyinDic setObject:valueArray forKey:keyNumber];
                
            }
        }
        return gPinyinDic;
    }
}

// from pinyin.c
char pinyinFirstLetter(unsigned short hanzi);

+ (NSString *)getFirstLetter:(NSString *)tempStr {
    if (tempStr == nil) {
        return @"~";
    }
    NSString *string = [NSString stringWithString:tempStr];
    NSString *defaultChar = @"~";
    if (string.length <= 0) {
        return defaultChar;
    }
    NSString* firstLetter = nil;
	if (NSOrderedSame == [string compare:@"曾" options:NSCaseInsensitiveSearch range:NSMakeRange(0, @"曾".length)])
        firstLetter = @"Z";
    else if(NSOrderedSame == [string compare:@"解" options:NSCaseInsensitiveSearch range:NSMakeRange(0, @"解".length)])
        firstLetter = @"X";
    else if(NSOrderedSame == [string compare:@"翟" options:NSCaseInsensitiveSearch range:NSMakeRange(0, @"翟".length)])
        firstLetter = @"Z";
    else if(NSOrderedSame == [string compare:@"褚" options:NSCaseInsensitiveSearch range:NSMakeRange(0, @"褚".length)])
        firstLetter = @"C";
    else if(NSOrderedSame == [string compare:@"区" options:NSCaseInsensitiveSearch range:NSMakeRange(0, @"区".length)])
        firstLetter = @"O";
    else if(NSOrderedSame == [string compare:@"卜" options:NSCaseInsensitiveSearch range:NSMakeRange(0, @"卜".length)])
        firstLetter = @"B";
    else if(NSOrderedSame == [string compare:@"折" options:NSCaseInsensitiveSearch range:NSMakeRange(0, @"折".length)])
        firstLetter = @"Z";
    else if(NSOrderedSame == [string compare:@"适" options:NSCaseInsensitiveSearch range:NSMakeRange(0, @"适".length)])
        firstLetter = @"K";
    else if(NSOrderedSame == [string compare:@"句" options:NSCaseInsensitiveSearch range:NSMakeRange(0, @"句".length)])
        firstLetter = @"G";
    else if(NSOrderedSame == [string compare:@"乜" options:NSCaseInsensitiveSearch range:NSMakeRange(0, @"乜".length)])
        firstLetter = @"N";
    else if(NSOrderedSame == [string compare:@"眭" options:NSCaseInsensitiveSearch range:NSMakeRange(0, @"眭".length)])
        firstLetter = @"S";
    else if(NSOrderedSame == [string compare:@"祭" options:NSCaseInsensitiveSearch range:NSMakeRange(0, @"祭".length)])
        firstLetter = @"Z";
    else if(NSOrderedSame == [string compare:@"厘" options:NSCaseInsensitiveSearch range:NSMakeRange(0, @"厘".length)])
        firstLetter = @"X";
    else if(string.length >= 2 && NSOrderedSame == [string compare:@"长孙" options:NSCaseInsensitiveSearch range:NSMakeRange(0, @"长孙".length)])
        firstLetter = @"Z";
    else if(string.length >= 2 && NSOrderedSame == [string compare:@"尉迟" options:NSCaseInsensitiveSearch range:NSMakeRange(0, @"尉迟".length)])
        firstLetter = @"Y";
    else if(string.length >= 2 && NSOrderedSame == [string compare:@"单于" options:NSCaseInsensitiveSearch range:NSMakeRange(0, @"单于".length)])
        firstLetter = @"C";
    else if(NSOrderedSame == [string compare:@"缪" options:NSCaseInsensitiveSearch range:NSMakeRange(0, @"缪".length)])
        firstLetter = @"M";
    else if(NSOrderedSame == [string compare:@"查" options:NSCaseInsensitiveSearch range:NSMakeRange(0, @"查".length)])
        firstLetter = @"Z";
    else if(NSOrderedSame == [string compare:@"繁" options:NSCaseInsensitiveSearch range:NSMakeRange(0, @"繁".length)])
        firstLetter = @"P";
    else if(NSOrderedSame == [string compare:@"仇" options:NSCaseInsensitiveSearch range:NSMakeRange(0, @"仇".length)])
        firstLetter = @"Q";
    else if(NSOrderedSame == [string compare:@"朴" options:NSCaseInsensitiveSearch range:NSMakeRange(0, @"朴".length)])
        firstLetter = @"P";
    else if(NSOrderedSame == [string compare:@"查" options:NSCaseInsensitiveSearch range:NSMakeRange(0, @"查".length)])
        firstLetter = @"Z";
    else if(NSOrderedSame == [string compare:@"能" options:NSCaseInsensitiveSearch range:NSMakeRange(0, @"能".length)])
        firstLetter = @"N";
    else if(NSOrderedSame == [string compare:@"乐" options:NSCaseInsensitiveSearch range:NSMakeRange(0, @"乐".length)])
        firstLetter = @"Y";
    else if(NSOrderedSame == [string compare:@"单" options:NSCaseInsensitiveSearch range:NSMakeRange(0, @"单".length)])
        firstLetter = @"S";
    else
        firstLetter = [[NSString stringWithFormat:@"%c", pinyinFirstLetter([string characterAtIndex:0])] uppercaseString];
    
    if (([firstLetter compare:@"A"] == NSOrderedAscending) || ([firstLetter compare:@"Z"] == NSOrderedDescending)) {
        firstLetter = defaultChar;
    }
    return firstLetter;
}

+ (NSArray *)getFirstCharacterPinyin:(NSString *)string {
    if (string.length <= 0) {
        return nil;
    }
    NSMutableArray *pinyinArray = [NSMutableArray array];
    NSString *firstCharacter = [string substringWithRange:NSMakeRange(0, 1)];
//    unsigned char aa[10]={0};
//    [firstCharacter getCString:(char*)aa maxLength:10 encoding:NSUnicodeStringEncoding];
//    unsigned short key = ((aa[1]<<8) + aa[0]);
//    NSNumber *numKey = [NSNumber numberWithUnsignedShort:key];
    unichar c = [firstCharacter characterAtIndex:0];
    NSNumber *numKey = [NSNumber numberWithUnsignedShort:c];
    NSArray *tmp =[[self getPinyinDic] objectForKey:numKey];
    NSString *pinyin = firstCharacter;
    if ([tmp count] > 0) {
        for (NSString *name in tmp) {
            pinyin = [name substringToIndex:[name length] - 1];
            if (![pinyinArray containsObject:pinyin])
                [pinyinArray addObject:pinyin];
        }
    } else {
        [pinyinArray addObject:pinyin];
    }
    return pinyinArray;
}

+ (NSArray *)getAllCharactersPinyin:(NSString *)string
{
    if (string.length <= 0) {
        return nil;
    }
    NSMutableArray *pinyinArray = [NSMutableArray array];
    NSMutableString *nonChineseWord = [NSMutableString stringWithCapacity:5];
    for (int i = 0; i < [string length]; i++) {
        int character = [string characterAtIndex:i];
        NSString *currentStr = [string substringWithRange:NSMakeRange(i, 1)];
        if (character > 0x4e00 && character < 0x9fff) {
            if (nonChineseWord.length > 0) {
                [pinyinArray addObject:[NSArray arrayWithObject:nonChineseWord]];
                nonChineseWord = [NSMutableString stringWithCapacity:5];
            } 
            NSArray *array = [self getFirstCharacterPinyin:currentStr];
            [pinyinArray addObject:array];
        } else {
            if ([currentStr isEqualToString:@" "]) {
                if (nonChineseWord.length > 0) {
                    [pinyinArray addObject:[NSArray arrayWithObject:nonChineseWord]];
                    nonChineseWord = [NSMutableString stringWithCapacity:5];
                }
            } else {
                [nonChineseWord appendString:currentStr];
            }
        }
    }
    if (nonChineseWord.length > 0) {
        [pinyinArray addObject:[NSArray arrayWithObject:nonChineseWord]];
    }
    return pinyinArray;
}

+ (NSArray *)getWordsPinyinAndRangesInfo:(NSString *)string
{
    if (string.length <= 0) {
        return nil;
    }
    NSMutableArray *result = [NSMutableArray array];
    NSMutableArray *wordsRangeInfo = [NSMutableArray array];
    NSMutableArray *wordsPinyinArray = [NSMutableArray array];
    NSMutableString *nonChineseWord = [NSMutableString stringWithCapacity:5];
    NSInteger location = 0;
    for (int i = 0; i < [string length]; i++) {
        int character = [string characterAtIndex:i];
        NSString *currentStr = [string substringWithRange:NSMakeRange(i, 1)];
        if (character > 0x4e00 && character < 0x9fff) {
            if (nonChineseWord.length > 0) {
                [wordsPinyinArray addObject:[NSArray arrayWithObject:nonChineseWord]];
                [wordsRangeInfo addObject:[NSValue valueWithRange:NSMakeRange(location, nonChineseWord.length)]];
                nonChineseWord = [NSMutableString stringWithCapacity:5];
            }
            NSArray *array = [self getFirstCharacterPinyin:currentStr];
            [wordsPinyinArray addObject:array];
            [wordsRangeInfo addObject:[NSValue valueWithRange:NSMakeRange(i, 1)]];
            location = i+1;
        } else {
            if ([currentStr isEqualToString:@" "]) {
                if (nonChineseWord.length > 0) {
                    [wordsPinyinArray addObject:[NSArray arrayWithObject:nonChineseWord]];
                    [wordsRangeInfo addObject:[NSValue valueWithRange:NSMakeRange(location, nonChineseWord.length)]];
                    nonChineseWord = [NSMutableString stringWithCapacity:5];
                }
                location = i+1;
            } else {
                [nonChineseWord appendString:currentStr];
            }
        }
    }
    if (nonChineseWord.length > 0) {
        [wordsPinyinArray addObject:[NSArray arrayWithObject:nonChineseWord]];
        [wordsRangeInfo addObject:[NSValue valueWithRange:NSMakeRange(location, nonChineseWord.length)]];
    }
    [result addObject:wordsPinyinArray];
    [result addObject:wordsRangeInfo];
    return result;
}

+ (NSString *)getOnePinyinCombination:(NSString *)string
{
    if (string.length <= 0) {
        return nil;
    }
    NSMutableString *result = [NSMutableString stringWithCapacity:1];
    for (int i = 0 ; i < [string length]; i++) {
        int character = [string characterAtIndex:i];
        NSString *str = [string substringWithRange:NSMakeRange(i, 1)];
        if (character > 0x4e00 && character < 0x9fff) {
            NSString *pinyin = [[self getFirstCharacterPinyin:str] objectAtIndex:0];
            [result appendString:pinyin];
        } else {
            [result appendString:str];
        }
    }
    return result;
}

@end
