//
//  CLRDrawViewAndBackgroundView.m
//  CLRCutMosaicDraw
//
//  Created by vk on 16/2/9.
//  Copyright © 2016年 clover. All rights reserved.
//

#import "CLRDrawViewAndBackgroundView.h"
#import "CLRDrawView.h"
#import "CLRDrawBackgroundView.h"
#import "CLRSmoothedBIView.h"

@interface CLRDrawViewAndBackgroundView()
{
    //CLRSmoothedBIView *_mDrawView;
    CLRDrawView *_mDrawView;
    CLRDrawBackgroundView *_mBackgroundView;
    
}

@end

@implementation CLRDrawViewAndBackgroundView

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        _mDrawView = [[CLRDrawView alloc]initWithFrame:self.bounds];
        _mDrawView.backgroundColor = [UIColor clearColor];
        //_mBackgroundView = [[CLRDrawBackgroundView alloc]initWithFrame:self.bounds];
        //[self addSubview:_mBackgroundView];
        [self addSubview:_mDrawView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _mDrawView.frame = self.bounds;
    //_mBackgroundView.frame = self.bounds;
}

- (void)updateBackgroundImage:(UIImage *)image
{
    //_mBackgroundView.image = image;
    //_mDrawView.incrementalImage = image;
    [_mDrawView updateBackgroundImage:image];
}

- (void)redo
{
    [_mDrawView redo];
}

- (void)undo
{
    [_mDrawView undo];
}

@end
