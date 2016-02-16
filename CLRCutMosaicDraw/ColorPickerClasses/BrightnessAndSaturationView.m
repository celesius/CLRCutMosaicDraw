//
//  BrightnessAndSaturationView.m
//  cutImageIOS
//
//  Created by vk on 15/10/26.
//  Copyright © 2015年 Clover. All rights reserved.
//

#import "BrightnessAndSaturationView.h"
#import "RSSelectionLayer.h"
#import "BSColorLayer.h"

#define kSelectionViewSize 30

@interface BrightnessAndSaturationView()

@property (nonatomic) CGFloat scale;
@property (strong, nonatomic) RSSelectionLayer *selectionLayer;
@property (strong, nonatomic) CALayer *contentsLayer;
@property (strong, nonatomic) BSColorLayer *bsColorLayer;
@property (strong, nonatomic) UIImage *bufferImg;
@property (nonatomic) CGFloat hueBuffer;

@end

@implementation BrightnessAndSaturationView

- (id) initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]) {
        [self initRoutine];
    }
    return self;
}

- (void)didMoveToWindow{
    [self resizeOrRescale];
}

- (void)initRoutine {
    
    self.bufferImg = [self getImage];
    
    self.contentsLayer = [CALayer layer];
    self.contentsLayer.frame = self.bounds;
    
    self.selectionLayer = [RSSelectionLayer layer];
    self.selectionLayer.frame = CGRectMake(0.0, 0.0, kSelectionViewSize, kSelectionViewSize);
    [self.selectionLayer setNeedsDisplay];
    
    self.bsColorLayer = [BSColorLayer layer];
    self.bsColorLayer.frame = self.bounds;
    self.bsColorLayer.img = self.bufferImg;
    //[self.bsColorLayer setNeedsDisplay];

    [self.contentsLayer addSublayer:self.bsColorLayer];
    [self.contentsLayer addSublayer:self.selectionLayer];
    [self.layer addSublayer:self.contentsLayer];
    self.contentsLayer.masksToBounds = YES;
    self.bsColorLayer.masksToBounds = YES;
    
    self.hueBuffer = 0;
}

- (void)resizeOrRescale {
    if (!self.window || self.frame.size.width == 0 || self.frame.size.height == 0) {
        self.scale = 0;
        //[self.loupeLayer disappearAnimated:NO];
        return;
    }

    self.scale = self.window.screen.scale;

    [CATransaction begin];
    [CATransaction setDisableActions:YES];

    self.layer.contentsScale = self.scale;
    self.contentsLayer.contentsScale = self.scale;
    self.selectionLayer.contentsScale = self.scale;
    self.bsColorLayer.contentsScale = self.scale;
    
    [CATransaction commit];
}

- (void) updateColor {
    self.bsColorLayer.getHue = self.colorPicker.hue;
    [self.bsColorLayer setNeedsDisplay];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];
   // NSLog(@"touchesBegan ");
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //NSLog(@"touchesMoved ");
    CGPoint point = [[touches anyObject] locationInView:self];
    [self changePoint:point];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];
    [self changePoint:point];
    //NSLog(@"touchesEnded ");
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesCancelled ");

}
- (UIImage *)getImage {
    
    CGSize imageSize =  CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - 1); //CGSizeMake(btn.frame.size.width, btn.frame.size.height);
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    //[[UIColor colorwithTSDefine:color_bg_11] set];
    [[UIColor clearColor] set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
    return pressedColorImg;
}

- (CGPoint) getPoint:(CGPoint) point {
    float maxX = CGRectGetWidth(self.bounds);
    float maxY = CGRectGetHeight(self.bounds);
    float newX = 0;
    float newY = 0;
    
    if(point.x<0) {
        newX = 0;
    } else if(point.x > maxX) {
        newX = maxX;
    } else {
        newX = point.x;
    }
    
    if(point.y < 0) {
        newY = 0;
    } else if (point.y > maxY) {
        newY = maxY;
    } else {
        newY = point.y;
    }
    
    return CGPointMake(newX, newY);
}

- (void) setBrightnessAndSaturationByPoint:(CGPoint)touchPoint {
    float brightness, saturation;
    brightness = touchPoint.x/CGRectGetWidth(self.bounds);
    saturation = touchPoint.y/CGRectGetHeight(self.bounds);
    [self.colorPicker setBrightness:brightness];
    [self.colorPicker setSaturation:saturation];
}

- (CGPoint) calculatePointByBrightness:(float) brightness andSaturation:(float) saturation {
    float px,py;
    px = brightness*CGRectGetWidth(self.bounds);
    py = saturation*CGRectGetHeight(self.bounds);
    return CGPointMake(px, py);
}

- (void) changePoint:(CGPoint) touchPoint {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    [self setBrightnessAndSaturationByPoint:[self getPoint:touchPoint]];
    CGPoint setPoint = [self calculatePointByBrightness:self.colorPicker.brightness andSaturation:self.colorPicker.saturation];
    self.selectionLayer.position = setPoint;
    [CATransaction commit];

}




@end
