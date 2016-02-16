//
//  maskLayer.m
//  cutImageIOS
//
//  Created by vk on 15/10/26.
//  Copyright © 2015年 Clover. All rights reserved.
//

#import "MaskLayer.h"
#import "CloverScreen.h"

@implementation MaskLayer


- (void)drawInContext:(CGContextRef)ctx
{
    CGContextSetLineWidth(ctx, (CGRectGetWidth(self.bounds) - CGRectGetWidth(self.transparentRect))/2.0 );
//    CGContextSetStrokeColorWithColor(ctx, self.maskColor);
    CGContextSetStrokeColorWithColor(ctx, [CloverScreen stringTOColor:@"292829"].CGColor);
    NSLog(@"%@",NSStringFromCGRect(self.bounds));
    CGContextStrokeEllipseInRect(ctx,  CGRectInset(self.bounds, (CGRectGetWidth(self.bounds) - CGRectGetWidth(self.transparentRect))/4.0, (CGRectGetWidth(self.bounds) - CGRectGetWidth(self.transparentRect))/4.0) );  //self.transparentRect);
    
}

/*
- (void)drawInContext:(CGContextRef)ctx
{
    CGContextSetLineWidth(ctx, (CGRectGetWidth(self.bounds) - 5.0)/2.0 );
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    NSLog(@"%@",NSStringFromCGRect(self.bounds));
    CGContextStrokeEllipseInRect(ctx,  CGRectInset(self.bounds, (CGRectGetWidth(self.bounds) - 5.0)/4.0, (CGRectGetWidth(self.bounds) -5.0)/4.0) );  //self.transparentRect);
    
}
 */




@end
