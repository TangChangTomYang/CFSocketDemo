//
//  UIImage+ScaleAndCompress.h
//  CinCommon
//
//  Created by peng donghua on 13-6-25.
//  Copyright (c) 2013年 peng donghua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ScaleAndCompress)
- (UIImage *)scaledImageWithWidth:(CGFloat)aWidth andHeight:(CGFloat)aHeight;
- (UIImage *)getThumbImage;
- (UIImage *)scaledImageBasedIPhoneSizeWithWidth:(CGFloat)aWidth andHeight:(CGFloat)aHeight;
- (CGRect)scaledHeadImageWithWidth:(CGFloat)aWidth andHeight:(CGFloat)aHeight;
- (UIImage *)scaledFillImageWidth:(CGFloat)aWidth andHeight:(CGFloat)aHeight;
- (UIImage *)scaledImageToFullScreen;
- (UIImage *)scaledImageToFullScreenWidth:(CGFloat)aWidth andHeight:(CGFloat)aHeight;
- (NSData *)compressImage:(CGFloat)aQuality;

// 拉伸
- (UIImage *)scaledImageStretchableImageWithLeftCapWidth:(NSInteger)leftCapWidth topCapHeight:(NSInteger)topCapHeight;

//截取图片的某一部分
- (UIImage *)clipImageInRect:(CGRect)rect;

@end
