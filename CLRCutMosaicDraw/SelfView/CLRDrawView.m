//
//  CLRDrawView.m
//  CLRCutMosaicDraw
//
//  Created by vk on 16/1/31.
//  Copyright © 2016年 clover. All rights reserved.
//

#import "CLRDrawView.h"

@interface CLRDrawView ()
{
    UIBezierPath *drawPath;
   
    UIImage *incrementalImage;
    
    CGMutablePathRef cgPath;
    CGPoint pts[5];
    uint ctr;
    
    CGPoint rectStart;
    CGPoint rectPass;
}

@end


@implementation CLRDrawView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setMultipleTouchEnabled:NO];
        drawPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 0, 0)];//[UIBezierPath bezierPath];
        [drawPath setLineWidth:10.0];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    //NSLog(@"drawRect");
    //CGContextRef context = UIGraphicsGetCurrentContext();
    //[self drawView:context];
    //[incrementalImage drawInRect:rect];
    [[UIColor blackColor]setFill];
    //NSLog(@"%@",drawPath);
    [drawPath stroke];
   
    [drawPath removeAllPoints];
    
    //UIBezierPath *rectMa = [UIBezierPath bezierPathWithRect:CGRectMake(rectStart.x, rectStart.y, rectPass.x - rectStart.x, rectPass.y - rectStart.y) ];
    
    //UIBezierPath *linePath = [UIBezierPath bezierPath];
    //[[UIColor redColor] setFill];
    //[rectMa fill];
    
    
//    CGRect drawRect =
}

- (void)drawView:(CGContextRef)context
{

}

- (void)drawBitmap
{
    NSLog(@"bitmap");
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0.0);
    
    if (!incrementalImage) // first time; paint background white
    {
        UIBezierPath *rectpath = [UIBezierPath bezierPathWithRect:self.bounds];
        [[UIColor whiteColor] setFill];
        [rectpath fill];
    }
    [incrementalImage drawAtPoint:CGPointZero];
    [[UIColor blackColor] setStroke];
    [drawPath stroke];
    incrementalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
   // [drawPath moveToPoint:location];
    ctr = 0;
    pts[0] = location;
    
    rectStart = location;

    [drawPath moveToPoint:rectStart];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    rectPass = p;
    [drawPath moveToPoint:rectStart];
    [drawPath addLineToPoint:rectPass];
        [self setNeedsDisplay];
    //[drawPath removeAllPoints];
    //drawPath add
    /*
    ctr++;
    pts[ctr] = p;
    if (ctr == 4)
    {
        //NSLog(@"in for loop");
        pts[3] = CGPointMake((pts[2].x + pts[4].x)/2.0, (pts[2].y + pts[4].y)/2.0); // move the endpoint to the middle of the line joining the second control point of the first Bezier segment and the first control point of the second Bezier segment
        
        [drawPath moveToPoint:pts[0]];
        [drawPath addCurveToPoint:pts[3] controlPoint1:pts[1] controlPoint2:pts[2]]; // add a cubic Bezier from pt[0] to pt[3], with control points pt[1] and pt[2]
        
        [self setNeedsDisplay];
        // replace points and get ready to handle the next segment
        pts[0] = pts[3];
        pts[1] = pts[4];
        ctr = 1;
    }
     */

}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //[self drawBitmap];
    [self setNeedsDisplay];
    [drawPath removeAllPoints];
    ctr = 0;

}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

}

@end
