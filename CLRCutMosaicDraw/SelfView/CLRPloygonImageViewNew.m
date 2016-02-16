//
//  CLRPloygonImageViewNew.m
//  CLRCutMosaicDraw
//
//  Created by vk on 16/2/2.
//  Copyright © 2016年 clover. All rights reserved.
//

#import "CLRPloygonImageViewNew.h"

@interface CLRPloygonImageViewNew ()
{
    CGMutablePathRef _path;
    UIImage *testImage;
}

@end

@implementation CLRPloygonImageViewNew

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        testImage = [UIImage imageNamed:@"viewtest.jpg"];
        //[self drawImage];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location =[touch locationInView:self];
    _path = CGPathCreateMutable();
    
    CGPathMoveToPoint(_path, NULL, location.x, location.y);
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location =[touch locationInView:self];
    //CGPathMoveToPoint(_path, NULL, location.x, location.y);
    CGPathAddLineToPoint(_path, NULL, location.x, location.y);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
   
    UIBezierPath *bPath = [UIBezierPath bezierPathWithCGPath:_path];
    NSLog(@"%@",bPath);
    
    NSLog(@"%@",_path);
    [self drawImage];
}

- (void)drawImage
{
    size_t bmpWidth = testImage.size.width;
    size_t bmpHeight = testImage.size.height;
    
    //CGContextRef theContext = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    size_t bytesPerPixel = 1;
    size_t bytesPerRow = bmpWidth * bytesPerPixel;
    size_t bmpDataSize = ( bytesPerRow * bmpHeight);
    
    unsigned char *bmpData = malloc(bmpDataSize);
    memset(bmpData, 0, bmpDataSize);
    
    CGContextRef theContext = CGBitmapContextCreate(bmpData, bmpWidth, bmpHeight, 8, bytesPerRow, colorSpace, kCGImageAlphaNone | kCGBitmapByteOrderDefault);
    
    CGContextAddPath(theContext, _path);
    CGContextClip(theContext);
    
    // not sure you need the translate and scale...
    CGContextTranslateCTM(theContext, 0, bmpHeight);
    CGContextScaleCTM(theContext, 1, -1);
    
    CGContextDrawImage(theContext, self.bounds, testImage.CGImage);
    
      CGImageRef retVal = CGBitmapContextCreateImage(theContext);
    
    UIImage *img = [UIImage imageWithCGImage:retVal];
    NSLog(@"%@",img);
}

@end
