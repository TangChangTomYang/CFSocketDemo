//
//  UIImage+ScaleAndCompress.m
//  CinCommon
//
//  Created by peng donghua on 13-6-25.
//  Copyright (c) 2013年 peng donghua. All rights reserved.
//

#import "UIImage+ScaleAndCompress.h"

@implementation UIImage (ScaleAndCompress)
//缩放图片
- (UIImage *)scaledImageWithWidth:(CGFloat)aWidth andHeight:(CGFloat)aHeight
{
//    CGRect rect = CGRectIntegral(CGRectMake(0,0,aWidth,aHeight));
//    UIGraphicsBeginImageContext(rect.size);
//    [self drawInRect:rect];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return image;
    
    //缩略图更清晰
    CGSize size  = CGSizeMake(aWidth, aHeight);
    if([[UIScreen mainScreen] scale] == 2.0){
        UIGraphicsBeginImageContextWithOptions(size, NO, 2.0);
    }else{
        UIGraphicsBeginImageContext(size);
    }
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}
//缩略图
- (UIImage *)getThumbImage
{
    CGSize size= self.size;
    //double max = size.width > size.height ? size.width : size.height;
    UIImage *thumbImage = self;
//    if (max > 100){
//        double scale = 100 / max;
//        thumbImage = [self scaledImageWithWidth:size.width * scale andHeight:size.height * scale];
//    }
    double minLen = (size.width < size.height ? size.width : size.height);
    if (minLen > 154) {
        double scale = 154/minLen;
        thumbImage = [self scaledImageWithWidth:size.width*scale andHeight:size.height*scale];
    }
    return thumbImage;
}
//图片分辨率限制在给定宽高内
- (UIImage *)scaledImageBasedIPhoneSizeWithWidth:(CGFloat)aWidth andHeight:(CGFloat)aHeight
{
    CGSize size = [self size];
    double scaleHeight = self.size.height > aHeight ? aHeight / self.size.height : 1;
    double scaleWidth = self.size.width> aWidth? aWidth/self.size.width:1;
    double scale=scaleHeight>scaleWidth?scaleHeight:scaleWidth;
    UIImage *image1 = self;
    if (scale < 1) {
        image1 = [self scaledImageWithWidth:size.width * scale andHeight:size.height * scale];
    }
    return image1;
}
//给定宽高内完整显示图片的frame坐标，不改变原图数据
- (CGRect)scaledHeadImageWithWidth:(CGFloat)aWidth andHeight:(CGFloat)aHeight
{
    CGFloat rate = aWidth / aHeight;
    //UIImage *image = nil;
    CGFloat w;
    CGFloat h;
    CGRect frame;
    if ((CGFloat)self.size.width / self.size.height >= rate){
        CGFloat scale = (CGFloat)self.size.width / aWidth;
        w = aWidth;
        h = (CGFloat)self.size.height / scale;
        frame = CGRectMake(0, (aHeight - h)/2, w, h);
    }
    else {
        CGFloat scale = (CGFloat)self.size.height / aHeight;
        w = (CGFloat)self.size.width / scale;
        h = aHeight;
        frame = CGRectMake((aWidth - w)/2, 0, w, h);
    }
    //self = [self scaledImageWithWidth:w andHeight:h];
    return frame;
}
//给定宽高内完整显示图片的frame坐标，可能会有黑色背景填充
- (UIImage *)scaledFillImageWidth:(CGFloat)aWidth andHeight:(CGFloat)aHeight
{
    CGFloat rate = aWidth / aHeight;
    CGFloat w;
    CGFloat h;
    CGRect frame;
    BOOL needBackground;
    CGRect backRect = CGRectMake(0, 0, aWidth, aHeight);
    if ((CGFloat)self.size.width / self.size.height > rate){
        CGFloat scale = (CGFloat)self.size.width / aWidth;
        w = aWidth;
        h = (CGFloat)self.size.height / scale;
        frame = CGRectMake(0, (aHeight - h)/2, w, h);
        needBackground = YES;
    }
    else if ((CGFloat)self.size.width / self.size.height < rate){
        CGFloat scale = (CGFloat)self.size.height / aHeight;
        w = (CGFloat)self.size.width / scale;
        h = aHeight;
        frame = CGRectMake((aWidth - w)/2, 0, w, h);
        needBackground = YES;
    }
    else{
        frame = backRect;
        needBackground = NO;
    }
    
    UIGraphicsBeginImageContext(backRect.size);
    if (needBackground){
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
        CGContextAddRect(context, backRect);
        CGContextDrawPath(context, kCGPathFill);
    }
    [self drawInRect:frame];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
//全屏下完整显示图片
- (UIImage *)scaledImageToFullScreen
{
    return [self scaledFillImageWidth:[UIScreen mainScreen].bounds.size.width*2 andHeight:[UIScreen  mainScreen].bounds.size.height*2];
}
- (UIImage *)scaledImageToFullScreenWidth:(CGFloat)aWidth andHeight:(CGFloat)aHeight
{
    return [self scaledFillImageWidth:aWidth*2 andHeight:aHeight*2];
}
// 给定图片质量压缩jpg图片
- (NSData *)compressImage:(CGFloat)aQuality
{
    NSData *rest = nil;
    if (aQuality > 1 || aQuality < 0.3)
    {
        aQuality = 0.65;
    }
    UIImage *image = self;
    NSData *data = UIImageJPEGRepresentation(image, 1);
    NSInteger i = 1;
    if ([data length] < 1024*100){
        rest = data;
    }
    else{
        CGFloat rate = 0.8;
        //CGSize screenSize = [UIScreen mainScreen].bounds.size;
        CGSize imageSize = image.size;
        //判断原图分辨率
        if (image.size.width > 640  || image.size.height > 640 ){
            CGRect frame = [image scaledHeadImageWithWidth:640  andHeight:640];
            imageSize = frame.size;
            image = [image scaledImageWithWidth:imageSize.width andHeight:imageSize.height];
        }
        //第一次只压缩质量
        NSData *data = UIImageJPEGRepresentation(image, aQuality);
        
        while([data length]> 1024*100){
            //第二次开始压缩分辨率和质量
            image = [image scaledImageWithWidth:imageSize.width * rate andHeight:imageSize.height * rate];
            data = UIImageJPEGRepresentation(image, aQuality);
            rate *= 0.8;
            i++;
            NSLog(@"<UIImage+ScaleAndCompress>第%d次压缩后的图片大小为:%dK",i,[data length]/1024);
            
        }
        rest = data;
    }
    return rest;
}

- (UIImage *)scaledImageStretchableImageWithLeftCapWidth:(NSInteger)leftCapWidth topCapHeight:(NSInteger)topCapHeight{
//    UIImage *scaledImage = [self scaledImage:0.5];
//    return [scaledImage stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
    return [self stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
}

- (UIImage *)clipImageInRect:(CGRect)rect{
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
}

@end
