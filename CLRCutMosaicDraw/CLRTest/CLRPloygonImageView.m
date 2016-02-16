//
//  CLRPloygonImageView.m
//  CLRCutMosaicDraw
//
//  Created by vk on 16/2/2.
//  Copyright © 2016年 clover. All rights reserved.
//

#import "CLRPloygonImageView.h"

@interface CLRPloygonImageView ()
{
    CALayer	  *_contentLayer;
    CAShapeLayer *_maskLayer;
    UIImage *src;
}
@end


@implementation CLRPloygonImageView

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        //[self setup];
        
        src = [UIImage imageNamed:@"viewtest.jpg"];
        UIImage *mask = [UIImage imageNamed:@"mask.png"];
        [self createMask];
        UIImage *rr = [self createMaskByMerge:src maskImage:[self createMask]];
        NSLog(@"%@",rr);
        //-(UIImage*) createMaskByMerge:(UIImage*)source maskImage:(UIImage*)maskImage{
        //self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)setup
{
    _maskLayer = [CAShapeLayer layer];
    _maskLayer.path = [UIBezierPath bezierPathWithOvalInRect:self.bounds].CGPath;
    _maskLayer.fillColor = [UIColor blackColor].CGColor;
    _maskLayer.fillRule = kCAFillRuleEvenOdd;
    _maskLayer.strokeColor = [UIColor redColor].CGColor;
    _maskLayer.frame = self.bounds;
    _maskLayer.contentsCenter = CGRectMake(0.5, 0.5, 0.1, 0.1);
    _maskLayer.contentsScale = [UIScreen mainScreen].scale;
   
    UIImage *img =[UIImage imageNamed:@"viewtest.jpg"];
    _contentLayer = [CALayer layer];
    _contentLayer.contents = (id)img.CGImage;
    _contentLayer.mask = _maskLayer;
    _contentLayer.geometryFlipped = YES;
    NSLog(@"%d",_contentLayer.masksToBounds);
    _contentLayer.masksToBounds = YES;
    _contentLayer.frame = self.bounds;
    [self.layer addSublayer:_contentLayer];

}

- (UIImage *)createMask
{
   // UIImage *maskOriginal = [UIImage imageNamed:@"brows-test-sample-L-1.jpg"];
    UIImage *maskOriginal = [UIImage imageNamed:@"viewtest.jpg"];
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    UIGraphicsBeginImageContext(src.size);
    CGContextRef oldContext = UIGraphicsGetCurrentContext();
    // save context
    CGContextSaveGState(oldContext);
    [[UIColor colorWithWhite:1.0f alpha:1.0f] setFill];
    //[[UIColor redColor]setFill];
    UIRectFill((CGRect){{0,0}, src.size});
    [maskOriginal drawInRect:CGRectMake(0, 0, src.size.width, src.size.height)];
    // remove the polygon of eye
    [path fill];
    // recovery environment and save new Image
    CGContextRestoreGState(oldContext);
    UIImage *maskImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return maskImage;
}

- (void)drawRect:(CGRect)rect
{
   /*
    CGMutablePathRef path = CGPathCreateMutable();
    CGPoint origin = self.bounds.origin;
    CGFloat radius = CGRectGetWidth(self.bounds) / 2;
    CGPathMoveToPoint(path, NULL, origin.x, origin.y + 2 *radius);
    CGPathMoveToPoint(path, NULL, origin.x, origin.y + radius);
    
    CGPathAddArcToPoint(path, NULL, origin.x, origin.y, origin.x + radius, origin.y, radius);
    CGPathAddArcToPoint(path, NULL, origin.x + 2 * radius, origin.y, origin.x + 2 * radius, origin.y + radius, radius);
    CGPathAddArcToPoint(path, NULL, origin.x + 2 * radius, origin.y + 2 * radius, origin.x + radius, origin.y + 2  * radius, radius);
    CGPathAddLineToPoint(path, NULL, origin.x, origin.y + 2 * radius);
    
    _maskLayer = [CAShapeLayer layer];
    _maskLayer.path = path;
    _maskLayer.fillColor = [UIColor blackColor].CGColor;
    _maskLayer.strokeColor = [UIColor clearColor].CGColor;
    _maskLayer.frame = self.bounds;
    _maskLayer.contentsCenter = CGRectMake(0.5, 0.5, 0.1, 0.1);
    _maskLayer.contentsScale = [UIScreen mainScreen].scale;				 //非常关键设置自动拉伸的效果且不变形
   
    _contentLayer.contents = (id)[UIImage imageNamed:@"viewtext.jpg"].CGImage;
    _contentLayer = [CALayer layer];
    _contentLayer.mask = _maskLayer;
    _contentLayer.frame = self.bounds;
    [self.layer addSublayer:_contentLayer];
    */

}


-(UIImage*) createMaskByMerge:(UIImage*)source maskImage:(UIImage*)maskImage{
    CGImageRef maskRef = maskImage.CGImage;
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef sourceImage = [source CGImage];
    CGImageRef imageWithAlpha = sourceImage;
    if ((CGImageGetAlphaInfo(sourceImage) == kCGImageAlphaNone)
        || (CGImageGetAlphaInfo(sourceImage) == kCGImageAlphaNoneSkipFirst)
        || (CGImageGetAlphaInfo(sourceImage) == kCGImageAlphaNoneSkipLast)){
        imageWithAlpha = CopyImageAndAddAlphaChannel(sourceImage);
    }
    
    CGImageRef masked = CGImageCreateWithMask(imageWithAlpha, mask);
    CGImageRelease(mask);
    
    if (sourceImage != imageWithAlpha) {
        CGImageRelease(imageWithAlpha);
    }
    
    //Added extra render step to force it to save correct alpha values (not the mask)
    UIImage* retImage = [UIImage imageWithCGImage:masked];
    CGImageRelease(masked);
    
    UIGraphicsBeginImageContext(retImage.size);
    [retImage drawAtPoint:CGPointZero];
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    retImage = nil;
    
    return newImg;
}

CGImageRef CopyImageAndAddAlphaChannel(CGImageRef sourceImage)
{
    
    CGImageRef retVal = NULL;
    
    size_t width = CGImageGetWidth(sourceImage);
    
    size_t height = CGImageGetHeight(sourceImage);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef offscreenContext = CGBitmapContextCreate(NULL, width, height,
                                                          8, 0, colorSpace,   kCGImageAlphaPremultipliedLast );
    
    
    if (offscreenContext != NULL) {
        
        CGContextDrawImage(offscreenContext, CGRectMake(0, 0, width, height), sourceImage);
        
        retVal = CGBitmapContextCreateImage(offscreenContext);
        
        CGContextRelease(offscreenContext);
        
    }
    
    CGColorSpaceRelease(colorSpace);
    
    return retVal;
    
}


@end
