//
//  CLRDrawInRectTest.m
//  CLRCutMosaicDraw
//
//  Created by vk on 16/2/19.
//  Copyright © 2016年 clover. All rights reserved.
//

#import "CLRDrawInRectTest.h"

@interface CLRDrawInRectTest ()
{
    UIImage *backImg;
}

@end


@implementation CLRDrawInRectTest
- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        backImg = [UIImage imageNamed:@"test2.jpg"];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    NSLog(@"drawInRect");
    [backImg drawInRect:rect];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    backImg = [self capture];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self setNeedsDisplay];
}

- (UIImage *)capture
{
    UIImage *getImage;
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0);
    
    
    [self drawViewHierarchyInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) afterScreenUpdates:YES];
    
    getImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return getImage;

}

@end
