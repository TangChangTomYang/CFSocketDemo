//
//  HanZiPinYin.h
//  CinCommon
//
//  Created by YuGuangzhen on 13-10-16.
//  Copyright (c) 2013年 p. All rights reserved.
//
// 汉字 to 拼音

#import <Foundation/Foundation.h>

@interface HanZiPinYin : NSObject

/*
 * Get the uppercase first letter of the first character pinyin
 * if the first character is chinese characters, get the uppercase first letter of its pinyin
 * if the first character is alphabet, get the uppercase first letter of itself
 * other, return default character @"~"
 * e.g. string = @"a"/@"axxx" will return @"A"
 * e.g. string = @"#" will return default character @"~"
 * e.g. string = @"" will return default character @"~"
 * e.g. string = nil will return default character @"~"
 */
+ (NSString *)getFirstLetter:(NSString *)string;

/* 
 * Get the first character's pinyin array of the string
 * return all pinyin, if the first character of string is Chinese characters
 * return itself, if the first character of string is not Chinese characters
 * e.g. string = @"长"/@"长xxx" will return {zhang,change}
 * e.g. string = @"a"/@"axxx" will return {a}
 */
+ (NSArray *)getFirstCharacterPinyin:(NSString *)string;

/*
 * Get All characters pinyin array of string
 * return an two-dimensional array, each element contains each character's pinyin array of the string
 * e.g. string = @"one word张english长" will return {{one},{word},{zhang},{english},{zhang,change}}
 */
+ (NSArray *)getAllCharactersPinyin:(NSString *)string;

/*
 * Get All characters pinyin array of string, and original character range info
 * return an two-dimensional array, each element contains each character's pinyin array of the string
 * e.g. string = @" one word张english 长" will return {{{one},{word},{zhang},{english},{zhang,change}},{NSRange(1,3),NSRange(5,4),NSRange(9,1),NSRange(10,7),NSRange(18,1)}}
 */
+ (NSArray *)getWordsPinyinAndRangesInfo:(NSString *)string;

/*
 * return one pinyin combination of string
 * e.g. string = @"ab长弹" will return @"abchangdan"
 */
+ (NSString *)getOnePinyinCombination:(NSString *)string;

@end
