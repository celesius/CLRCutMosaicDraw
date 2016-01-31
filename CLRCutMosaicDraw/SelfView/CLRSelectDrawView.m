//
//  CLRSelectDrawView.m
//  CLRCutMosaicDraw
//
//  Created by vk on 16/1/31.
//  Copyright © 2016年 clover. All rights reserved.
//

#import "CLRSelectDrawView.h"

@interface CLRSelectDrawView ()

@end

@implementation CLRSelectDrawView

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        UIToolbar *mt = [[UIToolbar alloc]initWithFrame:frame];
        [self addSubview:mt];
        
    }
    return self;
}

@end
