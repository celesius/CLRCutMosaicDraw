//
//  CLRDynamicView.m
//  CLRCutMosaicDraw
//
//  Created by vk on 16/2/17.
//  Copyright © 2016年 clover. All rights reserved.
//

#import "CLRDynamicView.h"

@interface CLRDynamicView ()
{
    UIImage *mImg;
}

@end

@implementation CLRDynamicView

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        mImg = [UIImage imageNamed:@"箭头.png"];
        [self setNeedsDisplay];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [mImg drawInRect:rect];

}

@end
