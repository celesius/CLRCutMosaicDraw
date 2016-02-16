//
//  CloverColorLayer.m
//  cutImageIOS
//
//  Created by vk on 15/10/25.
//  Copyright © 2015年 Clover. All rights reserved.
//

#import "CloverColorLayer.h"
#import "CloverScreen.h"
#import "RSColorFunctions.h"

@interface CloverColorLayer()


@end

@implementation CloverColorLayer

- (id) init {
    if(self = [super init]) {
        self.enableInnerShadow = NO;
        self.innerShadowOffset = CGSizeMake(0, 3);
        self.innerShadowBlur = 5.0;
        self.innerShadowColor =  [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.8].CGColor; //[UIColor grayColor].CGColor;
    }
    return self;
}

- (void)drawInContext:(CGContextRef)ctx {
    CGRect rect = self.bounds;
    NSLog(@" %@ ",NSStringFromCGRect(rect));
    //CGContextSetStrokeColorWithColor(ctx, self.color.CGColor);
//    CGContextStrokeEllipseInRect(ctx, rect);//CGRectInset(rect, 1.5, 1.5));
    CGContextSetFillColorWithColor(ctx, self.color.CGColor);
    //CGContextAddEllipseInRect(ctx, rect);
    //CGContextStrokePath(ctx);
    CGContextFillEllipseInRect(ctx, rect);//CGRectMake(0, 0, 50, 50));  //CGRectInset(rect, 5, 5));//CGRectInset(rect, 1.5, 1.5));
    if(self.enableInnerShadow){
        CGContextSetLineWidth(ctx, 6);
        CGContextSetStrokeColorWithColor(ctx, self.shadowColor);
        CGContextSaveGState(ctx);
        CGContextSetShadowWithColor(ctx, self.innerShadowOffset, self.innerShadowBlur, self.shadowColor);
        CGContextStrokeEllipseInRect(ctx, CGRectInset(rect, -3, -3));
    }
}

- (void) upDateWithColor:(UIColor *)color {
    self.color = color;
    [self setNeedsDisplay];
}

@end
