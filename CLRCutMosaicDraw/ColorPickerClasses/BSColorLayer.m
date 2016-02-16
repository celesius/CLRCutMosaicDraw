//
//  BSColorLayer.m
//  cutImageIOS
//
//  Created by vk on 15/10/27.
//  Copyright © 2015年 Clover. All rights reserved.
//

#import "BSColorLayer.h"
#import "RSColorFunctions.h"

@interface BSColorLayer()

@property (nonatomic, strong) UIColor *layerHUE;

@end

@implementation BSColorLayer

- (id)init {
    if(self = [super init]) {
    
    }
    return self;
}

- (void)drawInContext:(CGContextRef)ctx{
    self.img = [self imageBlackToTransparent:self.img];
    [self drawImage:ctx andImg:self.img.CGImage andRect:self.bounds];
    CGContextSetLineWidth(ctx, 3);
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithWhite:0.5 alpha:0.5].CGColor);
    //CGContextSetShadowWithColor(ctx, CGSizeMake(0, 3), 5.0,  [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8].CGColor );
    CGContextStrokeRect(ctx, CGRectInset(self.bounds, 0, 0));
    
    
    //CGContextStrokeEllipseInRect(ctx, CGRectMake(0, 0, 10, 10) );
}
/**
 *  翻转图片
 *
 *  @param context
 *  @param image
 *  @param rect    
 */
- (void) drawImage:(CGContextRef) context   andImg:(CGImageRef) image  andRect:(CGRect) rect{
    CGContextSaveGState(context);
    
    CGContextTranslateCTM(context, rect.origin.x, rect.origin.y);
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, -rect.origin.x, -rect.origin.y);
    CGContextDrawImage(context, rect, image);
    
    CGContextRestoreGState(context);
}

//- (UIColor *) getLayCo



- (UIImage*) imageBlackToTransparent:(UIImage*) image
{
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    
    //   create context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    
    // traverse pixe
    //int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    
    //UIColor *newColor = self.sendColor;//[ UIColor yellowColor ]; //self.rs.selectionColor;
    //CGFloat rgba[4];
    //RSGetComponentsForColor(rgba, newColor);
    
    CGFloat hue, saturation, brightness, alpha ;
    //  [newColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
//    [self.sendColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    
    int maxRows = CGRectGetHeight(self.bounds);
    int maxCols = CGRectGetWidth(self.bounds);
    
    UIColor *cColor;
    
    for (int y = 0; y < maxRows; y++) {
        saturation = ((float) (y + 1))/((float)maxRows);
        //cColor =  [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];
        for (int x = 0; x < maxCols; x++) {
            brightness = ((float)(x + 1))/((float)maxCols);
            cColor =  [UIColor colorWithHue:self.getHue saturation:saturation brightness:brightness alpha:1];
            //cColor =  [UIColor colorWithHue:1 saturation:saturation brightness:brightness alpha:alpha];
            CGFloat rr,gg,bb,aa;
            [cColor getRed:&rr green:&gg blue:&bb alpha:&aa];
            uint32_t uintR = (uint32_t) (rr*255.0);
            uint32_t uintG = (uint32_t) (gg*255.0);
            uint32_t uintB = (uint32_t) (bb*255.0);
            uint32_t uintA = (uint32_t) (aa*255.0);
            *pCurPtr = uintR<<24 | uintG <<16| uintB << 8 | uintA;
            pCurPtr ++;
        }
    }
    

#if 0
    for (int i = 0; i < pixelNum; i++, pCurPtr++)
    {
        //        if ((*pCurPtr & 0xFFFFFF00) == 0xffffff00)    // make white to Transparent
        if ((*pCurPtr & 0xFFFFFF00) == 0x00000000)    // / make black to Transparent
        {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
        /*
         else
         {
         uint8_t* ptr = (uint8_t*)pCurPtr;
         ptr[3] = 0; //0~255
         ptr[2] = 0;
         ptr[1] = 0;
         
         }
         */
        
    }
#endif
    // context to image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    
    // release
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    return resultUIImage;
}

void ProviderReleaseData (void *info, const void *data, size_t size)
{
    free((void*)data);
}

@end
