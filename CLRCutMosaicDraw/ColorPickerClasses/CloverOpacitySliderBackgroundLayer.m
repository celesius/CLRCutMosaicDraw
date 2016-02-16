//
//  CloverOpacitySliderBackgroundLayer.m
//  cutImageIOS
//
//  Created by vk on 15/10/28.
//  Copyright © 2015年 Clover. All rights reserved.
//

#import "CloverOpacitySliderBackgroundLayer.h"
#import <UIKit/UIKit.h>

@implementation CloverOpacitySliderBackgroundLayer


- (void)drawInContext:(CGContextRef)ctx {
    
    //CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef space = CGColorSpaceCreateDeviceGray();
    NSArray *colors = [[NSArray alloc] initWithObjects:
                       (id)[UIColor colorWithWhite:0.0 alpha:0.0].CGColor,
                       (id)[UIColor colorWithWhite:1 alpha:1].CGColor,nil];
    
    CGGradientRef myGradient = CGGradientCreateWithColors(space, (__bridge CFArrayRef)colors, NULL);
    
    
    CGContextDrawLinearGradient(ctx, myGradient, CGPointMake((self.bounds.size.height)/2.0, 0), CGPointMake(self.bounds.size.width - (self.bounds.size.height/2.0), 0), 0);
    
    
    //CGContextSetLineCap(ctx, kCGLineCapRound);
    CGGradientRelease(myGradient);
    CGColorSpaceRelease(space);
    
    //[[UIColor yellowColor] set];
    //CGContextAddArc(ctx, self.bounds.size.width - (self.bounds.size.height/2.0), 0, (self.bounds.size.height/2.0), 0.0, M_PI_2, 1);
    
    //设置属性
    //[[UIColor colorWithWhite:1 alpha:1] set];
    //绘制
   // CGContextDrawPath(ctx, kCGPathFillStroke);
    
    
}


@end
