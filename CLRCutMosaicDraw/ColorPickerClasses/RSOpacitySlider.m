//
//  RSOpacitySlider.m
//  RSColorPicker
//
//  Created by Jared Allen on 5/16/13.
//  Copyright (c) 2013 Red Cactus LLC. All rights reserved.
//

#import "RSOpacitySlider.h"

#import "RSColorFunctions.h"
#import "CloverOpacitySliderBackgroundLayer.h"
#import "CloverWhiteArc.h"

@interface RSOpacitySlider()

@property (nonatomic, strong) CloverOpacitySliderBackgroundLayer *backgroundLayer;
@property (nonatomic, strong) CloverWhiteArc *arcLayer;

@end

@implementation RSOpacitySlider

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initRoutine];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initRoutine];
    }
    return self;
}

- (void)initRoutine {
    self.minimumValue = 0.0;
    self.maximumValue = 1.0;
    self.continuous = YES;

    self.enabled = YES;
    self.userInteractionEnabled = YES;
    
    self.backgroundLayer  = [CloverOpacitySliderBackgroundLayer layer];
    //bagL.backgroundColor = [UIColor blackColor].CGColor;
    self.backgroundLayer.frame = self.bounds;
    [self.backgroundLayer setCornerRadius:CGRectGetHeight(self.bounds)/2.0];
    [self.backgroundLayer setNeedsDisplay];
    [self.layer addSublayer:self.backgroundLayer];
    
    self.arcLayer = [CloverWhiteArc layer];
    self.arcLayer.frame = self.bounds;
    [self.arcLayer setNeedsDisplay];
    [self.layer addSublayer:self.arcLayer];
    
    //[self.layer setCornerRadius:5];
    [self addTarget:self action:@selector(myValueChanged:) forControlEvents:UIControlEventValueChanged];
}

-  (void)didMoveToWindow {
    if (!self.window) return;

    UIImage *backgroundImage = RSOpacityBackgroundImage(5.f, self.window.screen.scale, [UIColor colorWithWhite:0.5 alpha:1.0]);
    self.backgroundLayer.backgroundColor = [UIColor colorWithPatternImage:backgroundImage].CGColor;
    
    self.arcLayer.contentsScale = self.layer.contentsScale;
    
    // self.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
   // self.backgroundColor = [UIColor whiteColor];
}

- (void)myValueChanged:(id)notif {
    _colorPicker.opacity = self.value;
}

- (void)drawRect:(CGRect)rect {
    
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//
//    CGColorSpaceRef space = CGColorSpaceCreateDeviceGray();
//    NSArray *colors = [[NSArray alloc] initWithObjects:
//                       (id)[UIColor colorWithWhite:0 alpha:0].CGColor,
//                       (id)[UIColor colorWithWhite:1 alpha:1].CGColor,nil];
//
//    CGGradientRef myGradient = CGGradientCreateWithColors(space, (__bridge CFArrayRef)colors, NULL);
//
//    CGContextDrawLinearGradient(ctx, myGradient, CGPointZero, CGPointMake(rect.size.width, 0), 0);
//    CGGradientRelease(myGradient);
//    CGColorSpaceRelease(space);
    
}

- (void)setColorPicker:(RSColorPickerView *)cp {
    _colorPicker = cp;
    if (!_colorPicker) { return; }
    self.value = [_colorPicker brightness];
}

@end
