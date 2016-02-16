//
//  CloverWhiteArc.m
//  cutImageIOS
//
//  Created by vk on 15/10/29.
//  Copyright © 2015年 Clover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CloverWhiteArc.h"

@implementation CloverWhiteArc

- (void)drawInContext:(CGContextRef)ctx {
    CGContextAddArc(ctx, self.bounds.size.width - (self.bounds.size.height/2.0), (self.bounds.size.height/2.0), (self.bounds.size.height/2.0), M_PI_2, M_PI + M_PI_2, 1);
   // CGContextSetStrokeColorWithColor(ctx, [UIColor yellowColor].CGColor);
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithWhite:1 alpha:1].CGColor);
    //设置属性
    //绘制
    
    CGContextFillPath(ctx);
    
    //CGContextDrawPath(ctx, kCGPathFillStroke);
    
    
    
    
    
}

@end
