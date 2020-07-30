//
//  CinUIEffect.h
//  CinCommon
//
//  Created by WangYanwei on 13-12-24.
//  Copyright (c) 2013年 p. All rights reserved.
//

#import <Foundation/Foundation.h> 

@interface CinUIEffect : NSObject

+ (instancetype)sharedClient;

//播放声音
- (void)playSound:(NSString *)file;

//播放系统声音
- (void)playSystemSound;

//振动
- (void)vibrate;


@end
