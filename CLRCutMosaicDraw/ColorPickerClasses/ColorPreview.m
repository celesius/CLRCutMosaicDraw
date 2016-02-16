//
//  ColorPreview.m
//  HSVColorPicker
//
//  Created by vk on 15/10/8.
//  Copyright © 2015年 Clover. All rights reserved.
//

#import "ColorPreview.h"

@interface ColorPreview()


@end

@implementation ColorPreview

-(id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.bgColor = [[UIColor alloc]initWithCGColor:[UIColor clearColor].CGColor ];//[UIColor clearColor];//[UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
//    NSLog(@"%f,%f,%f,%f",rect.origin.x,rect.origin.y,rect.size.height,rect.size.width);
    CGFloat r, g, b, a;
    [self.bgColor  getRed:&r green:&g blue:&b alpha:&a];
    NSString *colorDesc = [NSString stringWithFormat:@"rgba: %f, %f, %f, %f", r, g, b, a];
    NSLog(@"%@", colorDesc);
    //[self.bgColor set];  = CGContextSetFillColorWithColor(context, self.bgColor.CGColor);
    CGContextSetFillColorWithColor(context, self.bgColor.CGColor);
//    CGContextFillRect(context, CGRectMake(0, 0, rect.size.width/2, rect.size.height/2)); //  = CGContextAddRect(context, rect); + CGContextDrawPath(context, kCGPathFillStroke);
    CGContextFillRect(context, rect); //  = CGContextAddRect(context, rect); + CGContextDrawPath(context, kCGPathFillStroke);
   /*
    //外框绘制
    CGContextStrokeRect(context, rect);
    CGContextSetStrokeColorWithColor(context, self.bgColor.CGColor);
    CGContextSetLineWidth(context, 1.0);
    */
//    CGContextAddRect(context, rect);
   // CGContextAddRect(context, CGRectMake(0, 0, rect.size.width/2, rect.size.height/2)); //  = CGContextAddRect(context, rect); + CGContextDrawPath(context, kCGPathFillStroke);
   // CGContextDrawPath(context, kCGPathFillStroke);
}

@end
