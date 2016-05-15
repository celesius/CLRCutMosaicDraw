//
//  CLRCutImageScrollView.m
//  CLRCutMosaicDraw
//
//  Created by vk on 16/3/21.
//  Copyright © 2016年 clover. All rights reserved.
//

#import "CLRCutImageScrollView.h"

@interface CLRCutImageScrollView()
{
    UIImageView *m_SrcImageView;
}

@end

@implementation CLRCutImageScrollView

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        
        self.accessibilityActivationPoint = CGPointMake(100, 100);
        //imgView = [[UIImageView alloc]initWithImage:
        //           [UIImage imageNamed:@"AppleUSA.jpg"]];
        //[myScrollView addSubview:imgView];
        self.minimumZoomScale = 0.5;
        self.maximumZoomScale = 3.0;
        //myScrollView.contentSize = CGSizeMake(imgView.frame.size.width,
        //                                      imgView.frame.size.height);
    }
    return self;
}

- (void)setInputImage:(UIImage *)inputImage
{
    _inputImage = inputImage;
    m_SrcImageView = [[UIImageView alloc]initWithImage:inputImage];
    [self addSubview:m_SrcImageView];
    self.contentSize = CGSizeMake(m_SrcImageView.frame.size.width,
                                  m_SrcImageView.frame.size.height);
}


@end
