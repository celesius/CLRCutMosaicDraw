//
//  CLRDrawImageColorView.m
//  CLRCutMosaicDraw
//
//  Created by vk on 16/2/18.
//  Copyright © 2016年 clover. All rights reserved.
//

#import "CLRDrawImageColorView.h"

@interface CLRDrawImageColorView()
{
    UIBezierPath *path;
    UIImage *img;
}

@end

@implementation CLRDrawImageColorView

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        path = [UIBezierPath bezierPath];
        path.lineWidth = 50.0;
        img = [UIImage imageNamed:@"testImg.jpg"];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    //[[UIColor grayColor]setFill];
    
    UIColor *color = [UIColor colorWithPatternImage:img];
    [color set];

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *gradientColor = color;//[UIColor colorWithRed:0.51 green:0.0 blue:0.49 alpha:1.0];
    
    NSArray *gradientColors = [NSArray arrayWithObjects:
                               (id)[UIColor blueColor].CGColor,
                               (id)gradientColor.CGColor,
                               (id)[UIColor redColor].CGColor, nil];
    CGFloat gradientLocations[] = {0, 0.5, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)gradientColors, gradientLocations);
    
    UIBezierPath *roundedRectanglePath = path;//[UIBezierPath bezierPathWithRoundedRect:CGRectMake(10, 10, 200, 200) cornerRadius:6];
    CGContextSaveGState(context);
    [roundedRectanglePath fill];
    //[roundedRectanglePath addClip];
    CGContextSetFillColorWithColor(context, color.CGColor);
//    CGContextDrawLinearGradient(context, gradient, CGPointMake(10, 10), CGPointMake(210, 10), 0);
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
    
    
    /*
   
    CGPoint point1 = CGPointMake(0, 0);
    CGPoint point2 = CGPointMake(100, 0);
    CGPoint point3 = CGPointMake(100, 100);
    CGPoint point4 = CGPointMake(0, 100);
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    
    CGMutablePathRef a_path = CGPathCreateMutable();
    CGContextBeginPath(context);
    
    //Add a polygon to the path
    CGContextMoveToPoint(context, point1.x, point1.y);
    CGContextAddLineToPoint(context, point2.x, point2.y);
    CGContextAddLineToPoint(context, point3.x, point3.y);
    CGContextAddLineToPoint(context, point4.x, point4.y);
    CGContextAddLineToPoint(context, point1.x, point1.y);
    CGContextClosePath(context);
   
    //CGContextAddPath(context, a_path);
    CGContextClip(context);
    
    // Fill the path
    CGContextSetFillColorWithColor(context, [[UIColor grayColor] CGColor]);
    CGContextFillPath(context);
    //CGPathRelease(a_path);
    
    [path removeAllPoints];
    
    [path stroke];
    [path removeAllPoints];
     */
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location =[touch locationInView:self];
    [path moveToPoint:location];

}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location =[touch locationInView:self];
    [path addLineToPoint:location];

}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    UITouch *touch = [touches anyObject];
    CGPoint location =[touch locationInView:self];
    [path addLineToPoint:location];
    [path closePath];
    [self setNeedsDisplay];

}

@end
