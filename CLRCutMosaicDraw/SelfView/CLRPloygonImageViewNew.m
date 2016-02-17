//
//  CLRPloygonImageViewNew.m
//  CLRCutMosaicDraw
//
//  Created by vk on 16/2/2.
//  Copyright © 2016年 clover. All rights reserved.
//

#import "CLRPloygonImageViewNew.h"
#import "CLRDynamicView.h"
@interface CLRPloygonImageViewNew ()
{
    CGMutablePathRef _path;
    UIImage *testImage;
    CLRDynamicView *mDView;
    CGFloat oriH;
    
}

@end

@implementation CLRPloygonImageViewNew

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        testImage = [UIImage imageNamed:@"viewtest.jpg"];
        mDView = [[CLRDynamicView alloc]initWithFrame:CGRectMake(0, 0, 100, 200)];
        mDView.center = self.center;
        [self addSubview:mDView];
        mDView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        mDView.transform = CGAffineTransformMakeRotation(-45.0* (M_PI / 180.0f));
        oriH = mDView.frame.size.height;
        
        UIButton *saveImg = [UIButton buttonWithType:UIButtonTypeSystem];
        [saveImg setTitle:@"save" forState:UIControlStateNormal];
        [saveImg setBackgroundColor:[UIColor lightGrayColor]];
        saveImg.frame = CGRectMake(0, 0, 50, 50);
        [saveImg addTarget:self action:@selector(saveImage:) forControlEvents:UIControlEventTouchUpInside];
        
        
        //NSLog(@"%f",atan(2) / (M_PI/180.0));
        //[self drawImage];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location =[touch locationInView:self];
    _path = CGPathCreateMutable();
    
    CGPathMoveToPoint(_path, NULL, location.x, location.y);
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location =[touch locationInView:self];
    CGPoint center = self.center;
    //CGPathMoveToPoint(_path, NULL, location.x, location.y);
    CGPathAddLineToPoint(_path, NULL, location.x, location.y);
    
    static NSInteger angle = 0;
    angle += 5;
    //    mDView.transform = CGAffineTransformMakeRotation(angle * (M_PI / 180.0f));
    
    CGFloat height = sqrt( ((location.x - center.x) * (location.x - center.x) + (location.y - center.y) * (location.y - center.y)) );
    mDView.layer.anchorPoint = CGPointMake(0.5, 0);
    
    if(location.x < center.x){
        if(location.x != center.x){
            mDView.transform = CGAffineTransformMakeRotation( (90*(M_PI/180.0)) +  atan( (location.y - center.y)/(location.x - center.x) )  );
            mDView.transform = CGAffineTransformScale(mDView.transform, 1, height/oriH);
        }
    } else {
        if(location.x != center.x){
            mDView.transform = CGAffineTransformMakeRotation(   atan( (location.y - center.y)/(location.x - center.x) ) - (90*(M_PI/180.0))  );
            mDView.transform = CGAffineTransformScale(mDView.transform, 1, height/oriH);
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    //    UIBezierPath *bPath = [UIBezierPath bezierPathWithCGPath:_path];
    //    NSLog(@"%@",bPath);
    
    //    NSLog(@"%@",_path);
    //    [self drawImage];
}



- (void)drawImage
{
    size_t bmpWidth = testImage.size.width;
    size_t bmpHeight = testImage.size.height;
    
    //CGContextRef theContext = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    size_t bytesPerPixel = 1;
    size_t bytesPerRow = bmpWidth * bytesPerPixel;
    size_t bmpDataSize = ( bytesPerRow * bmpHeight);
    
    unsigned char *bmpData = malloc(bmpDataSize);
    memset(bmpData, 0, bmpDataSize);
    
    CGContextRef theContext = CGBitmapContextCreate(bmpData, bmpWidth, bmpHeight, 8, bytesPerRow, colorSpace, kCGImageAlphaNone | kCGBitmapByteOrderDefault);
    
    CGContextAddPath(theContext, _path);
    CGContextClip(theContext);
    
    // not sure you need the translate and scale...
    CGContextTranslateCTM(theContext, 0, bmpHeight);
    CGContextScaleCTM(theContext, 1, -1);
    
    CGContextDrawImage(theContext, self.bounds, testImage.CGImage);
    
    CGImageRef retVal = CGBitmapContextCreateImage(theContext);
    
    UIImage *img = [UIImage imageWithCGImage:retVal];
    NSLog(@"%@",img);
}

@end
