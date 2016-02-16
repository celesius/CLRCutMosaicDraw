//
//  DrawViewModel.m
//  cutImageIOS
//
//  Created by vk on 15/8/31.
//  Copyright (c) 2015年 Clover. All rights reserved.
//
#import "DrawViewModel.h"
@implementation DrawViewModel


//+ (id)viewModelWithColor:(UIColor *)color Path:(UIBezierPath *)path Width:(CGFloat)width  StartPoint:(CGPoint)startPoint  EndPoint:(CGPoint) endPoint IsDot:(BOOL)isDot;
+ (id)viewModelWithColor:(UIColor *)color Path:(UIBezierPath *)path Width:(CGFloat)width;
{
    DrawViewModel *drawViewModel = [[DrawViewModel alloc] init];
   
    drawViewModel.color = color;
    drawViewModel.path = path;
    drawViewModel.width = width;
    //drawViewModel.startPoint = startPoint;
    //drawViewModel.endPoint = endPoint;
    //drawViewModel.isDot = isDot;
    
    return drawViewModel;
}

-(BOOL)isIsLineWith2Dot
{
    if(self.isDot){
        if(CGPointEqualToPoint(self.startPoint, self.endPoint))
            return NO;
        else
            return YES;
    }
    else
        return NO;
}

#pragma --CLR Debug Code

- (void)dealloc
{
    NSLog(@"Dealloc DrawViewModel");
}
@end