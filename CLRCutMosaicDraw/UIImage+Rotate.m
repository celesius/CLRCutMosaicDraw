//
//  UIImage+Rotate.m
//  ShowNailCamera
//
//  Created by vk on 15/5/5.
//  Copyright (c) 2015年 jiangbo. All rights reserved.
//

#import "UIImage+Rotate.h"

@interface  UIImage(Rotate)

@end

@implementation UIImage(Rotate)

//static inline double radians (double degrees) {return degrees * M_PI/180;}

- (UIImage*)rotateInRadians:(CGFloat)radians
{
    CGImageRef cgImage = self.CGImage;
    const CGFloat originalWidth = CGImageGetWidth(cgImage);
    const CGFloat originalHeight = CGImageGetHeight(cgImage);
    
    const CGRect imgRect = (CGRect){.origin.x = 0.0f, .origin.y = 0.0f,
        .size.width = originalWidth, .size.height = originalHeight};
    const CGRect rotatedRect = CGRectApplyAffineTransform(imgRect, CGAffineTransformMakeRotation(radians));
    
//    CGContextRef bmContext = NYXImageCreateARGBBitmapContext(rotatedRect.size.width, rotatedRect.size.height, 0);
    
    CGContextRef bmContext  = [self NYXImageCreateARGBBitmapContext:rotatedRect.size.width height:rotatedRect.size.height bytesPerRow:0];
    
    if (!bmContext)
        return nil;
    
    CGContextSetShouldAntialias(bmContext, true);
    CGContextSetAllowsAntialiasing(bmContext, true);
    CGContextSetInterpolationQuality(bmContext, kCGInterpolationHigh);
    
    CGContextTranslateCTM(bmContext, +(rotatedRect.size.width * 0.5f), +(rotatedRect.size.height * 0.5f));
    CGContextRotateCTM(bmContext, radians);
    
    CGContextDrawImage(bmContext, (CGRect){.origin.x = -originalWidth * 0.5f,  .origin.y = -originalHeight * 0.5f,
        .size.width = originalWidth, .size.height = originalHeight}, cgImage);
    
    CGImageRef rotatedImageRef = CGBitmapContextCreateImage(bmContext);
    UIImage *__autoreleasing rotated = [UIImage imageWithCGImage:rotatedImageRef];
    
    CGImageRelease(rotatedImageRef);
    CGContextRelease(bmContext);
    
    return rotated;
}

-(CGContextRef) NYXImageCreateARGBBitmapContext:(const size_t) width  height:(const size_t) height  bytesPerRow:(const size_t) bytesPerRow
{
    /// Use the generic RGB color space
    /// We avoid the NULL check because CGColorSpaceRelease() NULL check the value anyway, and worst case scenario = fail to create context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    /// Create the bitmap context, we want pre-multiplied ARGB, 8-bits per component
    CGContextRef bmContext = CGBitmapContextCreate(NULL, width, height, 8/*Bits per component*/, bytesPerRow, colorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    
    CGColorSpaceRelease(colorSpace);
    
    return bmContext;
}

-(UIImage *) scalarImageToSize:(CGSize) toSize
{
    
    // CGRect rect = CGRectMake(0,0,864,640);
    //@autoreleasepool {
    CGRect rect = CGRectMake(0, 0, toSize.width, toSize.height);
    UIGraphicsBeginImageContext( rect.size );
    [self drawInRect:rect];
    UIImage *__autoreleasing  picture1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *__autoreleasing imageData = UIImagePNGRepresentation(picture1);
    UIImage *__autoreleasing img=[UIImage imageWithData:imageData];
    return img;
  //  }
}

@end
