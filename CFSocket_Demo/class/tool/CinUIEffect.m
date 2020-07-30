//
//  CinUIEffect.m
//  CinCommon
//
//  Created by WangYanwei on 13-12-24.
//  Copyright (c) 2013年 p. All rights reserved.
//

#import "CinUIEffect.h"
#import <AudioToolbox/AudioToolbox.h>
#import <UIKit/UILocalNotification.h>
#import <UIKit/UIApplication.h>

static void systemAudioCallback(SystemSoundID mySSID, void *clientData){
    AudioServicesDisposeSystemSoundID(mySSID);
}
static CinUIEffect *_uiEffect = nil;

@implementation CinUIEffect


+ (instancetype)sharedClient {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _uiEffect = [[self alloc] init];
    });
    return _uiEffect;
}

- (void)playSound:(NSString *)path {
    if (path == nil)
        return;
    NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
    if (filePath) {
        SystemSoundID soundId;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundId);
        AudioServicesAddSystemSoundCompletion(soundId, nil, nil, systemAudioCallback, nil);
        AudioServicesPlaySystemSound(soundId);
    }
}

- (void)playSystemSound {
    AudioServicesPlaySystemSound(1007);
}

- (void)vibrate {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}


@end
