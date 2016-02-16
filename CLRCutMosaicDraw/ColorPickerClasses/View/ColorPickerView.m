//
//  ColorPickerView.m
//  cutImageIOS
//
//  Created by vk on 15/10/12.
//  Copyright © 2015年 Clover. All rights reserved.
//

#import "ColorPickerView.h"
#import "ColorPreview.h"
#import "RSOpacitySlider.h"
#import "RSBrightnessSlider.h"
#import "CloverScreen.h"
#import "BrightnessAndSaturationView.h"

@interface ColorPickerView()

@property (nonatomic, strong) RSColorPickerView *rscpView;

@property (nonatomic, strong) ColorPreview *colorPreview;
@property (nonatomic, strong) RSBrightnessSlider *brightnessSlider;
@property (nonatomic, strong) RSOpacitySlider *opacitySlider;
@property (nonatomic, strong) BrightnessAndSaturationView *bsView;

@end

@implementation ColorPickerView
- (id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        CGRect mainScreen = self.bounds;
        int rscpViewW = [CloverScreen getHorizontal:450];
        int  rscpViewH =   rscpViewW;
        self.rscpView = [[RSColorPickerView alloc] initWithFrame:CGRectMake( (CGRectGetWidth(mainScreen) - rscpViewW)/2.0 , [CloverScreen getVertical:50], rscpViewW, rscpViewH)];
        //self.rscpView.center = CGPointMake( CGRectGetMidX(mainScreen), self.rscpView.center.y );
        
        [self.rscpView.layer setShadowOffset:CGSizeMake(0, 2)];
        [self.rscpView.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.rscpView.layer setShadowOpacity:1.0];
        // Optionally set and force the picker to only draw a circle
        [self.rscpView setCropToCircle:YES]; // Defaults to NO (you can set BG color)
        
        self.rscpView.delegate = self;
        
        // UISwitch *circleSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(10, 340, 0, 0)];
        /**
         透明度调整
         */
        float opSliderW = [CloverScreen getHorizontal:500.0];
        float opSliderH = 30;//[CloverScreen getVertical:50.0];
        self.opacitySlider = [[RSOpacitySlider alloc] initWithFrame:CGRectMake(  (mainScreen.size.width - opSliderW)/2.0   , CGRectGetMaxY(self.rscpView.frame) + [CloverScreen getVertical:50.0], opSliderW, opSliderH)];
        //[self.opacitySlider.layer setCornerRadius: CGRectGetHeight(self.opacitySlider.bounds)/2.0];
        [self.opacitySlider setColorPicker:self.rscpView];
        /**
         透明度调整
         */
       // self.brightnessSlider = [[RSBrightnessSlider alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.opacitySlider.frame), CGRectGetMaxY(self.opacitySlider.frame) + 10, self.opacitySlider.frame.size.width, self.opacitySlider.frame.size.height)];
       // [self.brightnessSlider setColorPicker:self.rscpView];
        
        self.colorPreview = [[ColorPreview alloc]initWithFrame:CGRectMake( CGRectGetWidth(self.bounds) - 50 , 0, 50, 50)];
        
        self.bsView = [[BrightnessAndSaturationView alloc]initWithFrame:CGRectMake(  (CGRectGetWidth(self.bounds) - [CloverScreen getHorizontal:500])/2 , CGRectGetMaxY(self.opacitySlider.frame) + 10, [CloverScreen getHorizontal:500], [CloverScreen getVertical:150] )];
        [self.bsView setColorPicker:self.rscpView];
        //self.bsView.backgroundColor = [UIColor cyanColor];
        
        self.currentColor = [UIColor whiteColor];
        [self addSubview:self.opacitySlider];
        //[self addSubview:self.brightnessSlider];
        [self addSubview:self.rscpView];
        [self addSubview:self.colorPreview];
        [self addSubview:self.bsView];
        
        UIButton * configureColorButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [configureColorButton  setTitle:@"确定" forState:UIControlStateNormal];
        [configureColorButton  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [configureColorButton  addTarget:self action:@selector(configureColorButtonFoo:) forControlEvents:UIControlEventTouchUpInside];
        configureColorButton.frame = CGRectMake((CGRectGetWidth(self.bounds) - 50)/2.0, CGRectGetHeight(self.bounds) - 70.0, 50.0, 50.0);
        [self addSubview:configureColorButton];
        
    }
    return self;
}

-(void)colorPickerDidChangeSelection:(RSColorPickerView *)colorPicker{
    UIColor *color = [colorPicker selectionColor];
    self.currentColor = color;
    self.colorPreview.bgColor = color;
    //self.brightnessSlider.value = [colorPicker brightness];
    self.opacitySlider.value = [colorPicker opacity];
    //self.colorPreview.backgroundColor = color;
    [self.colorPreview setNeedsDisplay];
    [self.bsView updateColor];
}

- (void)updateLastColor {
    [self.rscpView updateLastColorLayer:self.currentColor];
}

- (void)configureColorButtonFoo:(id)sender
{
    [UIView animateWithDuration:0.4
                     animations:^{
                         self.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         if ([self.delegate respondsToSelector:@selector(configureColor)]) {
                             [self.delegate configureColor];
                         }
                         [self updateLastColor];
                         self.hidden = YES;
                     }];
}

@end
