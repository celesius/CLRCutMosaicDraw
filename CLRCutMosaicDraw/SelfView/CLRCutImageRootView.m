//
//  CLRCutImageRootView.m
//  CLRCutMosaicDraw
//
//  Created by vk on 16/3/21.
//  Copyright © 2016年 clover. All rights reserved.
//

#import "CLRCutImageRootView.h"
#import "CLRCutImageScrollView.h"

@interface CLRCutImageRootView () <UIScrollViewDelegate>
{
    CLRCutImageScrollView *m_ScrollView;
    UIImageView *m_MaskImageView;

}

@end

@implementation CLRCutImageRootView

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        m_ScrollView = [[CLRCutImageScrollView alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
        m_ScrollView.delegate = self;
        [self addSubview:m_ScrollView];
    }
    return self;
}

- (void)setReceiveImage:(UIImage *)receiveImage
{
    _receiveImage = receiveImage;
    m_ScrollView.inputImage = receiveImage;
}

@end
