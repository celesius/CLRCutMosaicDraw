//
//  CLRSelectLineWidthView.m
//  CLRCutMosaicDraw
//
//  Created by vk on 16/2/1.
//  Copyright © 2016年 clover. All rights reserved.
//

#import "CLRSelectLineWidthView.h"
#import "CLRDrawElementModelStore.h"
#import "ColorPickerView.h"


static float kLabelHeight = 32.0;
static float kButtonWidth = 32.0;
static float kButtonHeight = 32.0;



@interface CLRSelectLineWidthView () <ColorPickerViewDelegate>
{
    CLRDrawElementModelStore *drawElementModelStore;
    CLRElementType mCurrentELementType;
    UIView *editView;
    UISlider *userSlider;
    UISegmentedControl *userSegmentedControlRectangleOrCircle;
    UISegmentedControl *userSegmentedControlColor1;
    UISegmentedControl *userSegmentedControlColor2;
    UIButton *customizeColorButton;
    UILabel *colorText;
    UILabel *customizeColorText;
    UILabel *widthText;
    ColorPickerView *mColorPickerView;
    BOOL isColorPickerView;
}
@end


@implementation CLRSelectLineWidthView
- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        drawElementModelStore = [CLRDrawElementModelStore sharedStore];
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        
        float editViewW = CGRectGetWidth(self.bounds) * 3.0 / 4.0;
        float editViewH = editViewW * 10.0/21.0;
        
        editView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, editViewW, editViewH)];
        editView.center = self.center;
        editView.backgroundColor = [UIColor lightGrayColor];
        editView.layer.cornerRadius = 5.0;
        [self addSubview:editView];
        colorText = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(editView.bounds), kLabelHeight)];
        colorText.text = @"  颜色";
        colorText.font = [UIFont systemFontOfSize:16];
        colorText.backgroundColor = [UIColor greenColor];
        //[editView addSubview:colorText];
        customizeColorText = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(colorText.frame), CGRectGetWidth(colorText.frame), kLabelHeight)];
        customizeColorText.text = @"  自定义";
        customizeColorText.font = [UIFont systemFontOfSize:16];
        customizeColorText.backgroundColor = [UIColor greenColor];
        //[editView addSubview:customizeColorText];
        
        widthText = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(customizeColorText.frame), CGRectGetWidth(colorText.frame), kLabelHeight)];
        widthText.text = @"  线宽";
        widthText.font = [UIFont systemFontOfSize:16];
        widthText.backgroundColor = [UIColor greenColor];
        
        customizeColorButton = [UIButton buttonWithType:UIButtonTypeSystem];
        customizeColorButton.titleLabel.font = [UIFont systemFontOfSize:16];
        customizeColorButton.backgroundColor = [UIColor lightGrayColor];
        [customizeColorButton setTitle:@"颜色" forState:UIControlStateNormal];
        [customizeColorButton addTarget:self action:@selector(customizeColorButtonFoo:) forControlEvents:UIControlEventTouchUpInside];
       
        userSlider = [[UISlider alloc]init];
        [userSlider addTarget:self action:@selector(userSliderFoo:) forControlEvents:UIControlEventValueChanged];
        
        NSArray *colorArray1 = @[@"黑色",@"浅灰",@"红色",@"黄色"];
        userSegmentedControlColor1 = [[UISegmentedControl alloc]initWithItems:colorArray1];
        [userSegmentedControlColor1 addTarget:self action:@selector(userSegmentedControlColor1Foo:) forControlEvents:UIControlEventValueChanged];
        
        NSArray *colorArray2 = @[@"紫色",@"深蓝",@"青色",@"绿色"];
        userSegmentedControlColor2 = [[UISegmentedControl alloc]initWithItems:colorArray2];
        [userSegmentedControlColor2 addTarget:self action:@selector(userSegmentedControlColor2Foo:) forControlEvents:UIControlEventValueChanged];
      
        float cpViewW = CGRectGetWidth(self.bounds);
        float cpViewH = cpViewW*4.0/3.0;
        
        NSLog(@"%@",NSStringFromCGRect(self.bounds));
        mColorPickerView = [[ColorPickerView alloc]initWithFrame:CGRectMake(0, (CGRectGetHeight(self.bounds) - cpViewH)/2.0, cpViewW, cpViewH)];
        [self addSubview:mColorPickerView];
        mColorPickerView.hidden = YES;
        mColorPickerView.backgroundColor = [UIColor colorWithWhite:0.667 alpha:1.0];
        [mColorPickerView.layer setCornerRadius:10.0];
       
        mColorPickerView.delegate = self;
        
        [self refreshElementType];
        isColorPickerView = NO;
        //[editView addSubview:widthText];
    }
    return self;
}

- (void)refreshElementType
{
    mCurrentELementType = drawElementModelStore.currentElmentType;
    [self refreshEidtViewByElementType:mCurrentELementType];
}

- (void)refreshEidtViewByElementType:(CLRElementType) type
{
    switch (type) {
            
        case TypeUserLine:
        case TypeLine:
        case TyperRectangle:
        case TypeCircle:
        {
            [self removeALLView];
            editView.frame = CGRectMake(0, 0, CGRectGetWidth(editView.bounds), 7.0*kLabelHeight); //CGRectGetWidth(editView.bounds)*3.0/4.0);
            editView.center = self.center;
            [editView addSubview:colorText];

            userSegmentedControlColor1.frame = CGRectMake(0, CGRectGetMaxY(colorText.frame), CGRectGetWidth(colorText.bounds), kLabelHeight);
            [editView addSubview:userSegmentedControlColor1];
            
            userSegmentedControlColor2.frame = CGRectMake(0, CGRectGetMaxY(userSegmentedControlColor1.frame), CGRectGetWidth(colorText.bounds), kLabelHeight);
            [editView addSubview:userSegmentedControlColor2];
           
            customizeColorText.frame = CGRectMake(0, CGRectGetMaxY(userSegmentedControlColor2.frame), CGRectGetWidth(colorText.bounds), kLabelHeight);
            [editView addSubview:customizeColorText];
            customizeColorButton.frame = CGRectMake(0, CGRectGetMaxY(customizeColorText.frame), kButtonWidth, kButtonHeight);
            [editView addSubview:customizeColorButton];
            
            widthText.text = @"  线宽";
            widthText.frame = CGRectMake(0, CGRectGetMaxY(customizeColorButton.frame), CGRectGetWidth(colorText.bounds), kLabelHeight);
            [editView addSubview:widthText];
            
            userSlider.frame = CGRectMake(CGRectGetWidth(colorText.bounds)/18.0, CGRectGetMaxY(widthText.frame), CGRectGetWidth(colorText.bounds)*8.0/9.0, kLabelHeight);
            userSlider.maximumValue = 50.0;
            userSlider.minimumValue = 5.0;
            userSlider.value = drawElementModelStore.currentSubParamenter.mLineWidth;
            [editView addSubview:userSlider];
            
            
            editView.backgroundColor = [UIColor redColor];
            editView.alpha = 0.5;
            [self addSubview:editView];
        }
            break;
            
        case TypeBlur:{
            [self removeALLView];
            editView.frame = CGRectMake(0, 0, CGRectGetWidth(editView.bounds), 2.0*kLabelHeight);
            editView.center = self.center;
            widthText.text = @"  模糊程度";
            widthText.frame = CGRectMake(0, 0, CGRectGetWidth(editView.bounds), kLabelHeight);
            [editView addSubview:widthText];
            
            userSlider.frame = CGRectMake(CGRectGetWidth(colorText.bounds)/18.0, CGRectGetMaxY(widthText.frame), CGRectGetWidth(colorText.bounds)*8.0/9.0, kLabelHeight);
            userSlider.maximumValue = 0.7;
            userSlider.minimumValue = 0.0;
            userSlider.value = drawElementModelStore.currentSubParamenter.mBlurIntensity;
            [editView addSubview:userSlider];

            editView.backgroundColor = [UIColor redColor];
            editView.alpha = 0.5;
            [self addSubview:editView];
        }
            break;
        case TypeMosaic:{
            [self removeALLView];
            editView.frame = CGRectMake(0, 0, CGRectGetWidth(editView.bounds), 2.0*kLabelHeight);
            editView.center = self.center;
            widthText.text = @"  马赛克格子大小";
            widthText.frame = CGRectMake(0, 0, CGRectGetWidth(editView.bounds), kLabelHeight);
            [editView addSubview:widthText];
            
            userSlider.frame = CGRectMake(CGRectGetWidth(colorText.bounds)/18.0, CGRectGetMaxY(widthText.frame), CGRectGetWidth(colorText.bounds)*8.0/9.0, kLabelHeight);
            userSlider.maximumValue = 0.2;
            userSlider.minimumValue = 0.01;
            userSlider.value = drawElementModelStore.currentSubParamenter.mMosaicInputTileSize;
            [editView addSubview:userSlider];
            editView.backgroundColor = [UIColor redColor];
            editView.alpha = 0.5;
            [self addSubview:editView];
        }
            break;
        case TypeShiXinRectangle:
        case TypeShiXinCircle:
        case TypeArrow:
        {
            [self removeALLView];
            editView.frame = CGRectMake(0, 0, CGRectGetWidth(editView.bounds), 5.0*kLabelHeight);
            editView.center = self.center;
            [editView addSubview:colorText];
            
            userSegmentedControlColor1.frame = CGRectMake(0, CGRectGetMaxY(colorText.frame), CGRectGetWidth(colorText.bounds), kLabelHeight);
            [editView addSubview:userSegmentedControlColor1];
            
            userSegmentedControlColor2.frame = CGRectMake(0, CGRectGetMaxY(userSegmentedControlColor1.frame), CGRectGetWidth(colorText.bounds), kLabelHeight);
            [editView addSubview:userSegmentedControlColor2];
            
            customizeColorText.frame = CGRectMake(0, CGRectGetMaxY(userSegmentedControlColor2.frame), CGRectGetWidth(colorText.bounds), kLabelHeight);
            [editView addSubview:customizeColorText];
            customizeColorButton.frame = CGRectMake(0, CGRectGetMaxY(customizeColorText.frame), kButtonWidth, kButtonHeight);
            [editView addSubview:customizeColorButton];
            
            editView.backgroundColor = [UIColor redColor];
            editView.alpha = 0.5;
            [self addSubview:editView];
        }
            
            break;
        case TypeText:
            {
            [self removeALLView];
            editView.frame = CGRectMake(0, 0, CGRectGetWidth(editView.bounds), 7.0*kLabelHeight); //CGRectGetWidth(editView.bounds)*3.0/4.0);
            editView.center = self.center;
            [editView addSubview:colorText];

            userSegmentedControlColor1.frame = CGRectMake(0, CGRectGetMaxY(colorText.frame), CGRectGetWidth(colorText.bounds), kLabelHeight);
            [editView addSubview:userSegmentedControlColor1];
            
            userSegmentedControlColor2.frame = CGRectMake(0, CGRectGetMaxY(userSegmentedControlColor1.frame), CGRectGetWidth(colorText.bounds), kLabelHeight);
            [editView addSubview:userSegmentedControlColor2];
           
            customizeColorText.frame = CGRectMake(0, CGRectGetMaxY(userSegmentedControlColor2.frame), CGRectGetWidth(colorText.bounds), kLabelHeight);
            [editView addSubview:customizeColorText];
            customizeColorButton.frame = CGRectMake(0, CGRectGetMaxY(customizeColorText.frame), kButtonWidth, kButtonHeight);
            [editView addSubview:customizeColorButton];
            
            widthText.text = @"  字体大小";
            widthText.frame = CGRectMake(0, CGRectGetMaxY(customizeColorButton.frame), CGRectGetWidth(colorText.bounds), kLabelHeight);
            [editView addSubview:widthText];
            
            userSlider.frame = CGRectMake(CGRectGetWidth(colorText.bounds)/18.0, CGRectGetMaxY(widthText.frame), CGRectGetWidth(colorText.bounds)*8.0/9.0, kLabelHeight);
            userSlider.maximumValue = 50.0;
            userSlider.minimumValue = 5.0;
            userSlider.value = drawElementModelStore.currentSubParamenter.mTextSize;
            [editView addSubview:userSlider];
            
            editView.backgroundColor = [UIColor redColor];
            editView.alpha = 0.5;
            [self addSubview:editView];
        }
            break;
        default:
            break;
    }

}


- (void)userSegmentedControlColor1Foo:(id)sender
{
    userSegmentedControlColor2.selectedSegmentIndex = -1;
    switch (userSegmentedControlColor1.selectedSegmentIndex) {
        case 0:
            drawElementModelStore.currentSubParamenter.mElementColor = [UIColor blackColor];
            break;
        case 1:
            drawElementModelStore.currentSubParamenter.mElementColor = [UIColor lightGrayColor];
            break;
        case 2:
            drawElementModelStore.currentSubParamenter.mElementColor = [UIColor redColor];
            break;
        case 3:
            drawElementModelStore.currentSubParamenter.mElementColor = [UIColor yellowColor];
            break;
        default:
            break;
    }
}

- (void)userSegmentedControlColor2Foo:(id)sender
{
    userSegmentedControlColor1.selectedSegmentIndex = -1;
    switch (userSegmentedControlColor2.selectedSegmentIndex) {
        case 0:
            drawElementModelStore.currentSubParamenter.mElementColor = [UIColor purpleColor];
            break;
        case 1:
            drawElementModelStore.currentSubParamenter.mElementColor = [UIColor blueColor];
            break;
        case 2:
            drawElementModelStore.currentSubParamenter.mElementColor = [UIColor cyanColor];
            break;
        case 3:
            drawElementModelStore.currentSubParamenter.mElementColor = [UIColor greenColor];
            break;
        default:
            break;
    }
}

- (void)customizeColorButtonFoo:(id)sender
{
    //NSLog(@"myColor");
    mColorPickerView.alpha = 0.0;
    mColorPickerView.hidden = NO;
    isColorPickerView = YES;
    [self insertSubview:mColorPickerView aboveSubview:editView];
    //[self addSubview:mColorPickerView];
    
    [UIView animateWithDuration:0.4
                     animations:^{
                         mColorPickerView.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         //mColorPickerView.currentColor = [UIColor greenColor];
                         //[mColorPickerView updateLastColor];
                     }];
    
}

- (void)userSliderFoo:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    
    switch (drawElementModelStore.currentElmentType) {
        case TypeUserLine:
        case TypeLine:
        case TypeCircle:
        case TyperRectangle:
            drawElementModelStore.currentSubParamenter.mLineWidth = slider.value;
            break;
        case TypeText:
            drawElementModelStore.currentSubParamenter.mTextSize = slider.value;
            break;
        case TypeBlur:
            drawElementModelStore.currentSubParamenter.mBlurIntensity = slider.value;
            break;
        case TypeMosaic:
            drawElementModelStore.currentSubParamenter.mMosaicInputTileSize = slider.value;
        default:
            break;
    }

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    
    if(isColorPickerView){
        if(!CGRectContainsPoint(mColorPickerView.frame, location)){
            [UIView animateWithDuration:0.4
                             animations:^{
                                 mColorPickerView.alpha = 0.0;
                             }
                             completion:^(BOOL finished) {
                                 mColorPickerView.hidden = YES;
                                 isColorPickerView = NO;
                             }];
        }
        
    } else {
        if(!CGRectContainsPoint(editView.frame, location))
        {
            [self hiddenSelf];
        }
    }
}

/**
 *
 */
- (void)configureColor
{
    NSLog(@"确认颜色");
    isColorPickerView = NO;
    drawElementModelStore.currentSubParamenter.mElementColor = mColorPickerView.currentColor;//[UIColor cyanColor];
}

- (void)hiddenSelf
{
    [UIView animateWithDuration:0.4
                     animations:^{
                         self.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         self.hidden = YES;
                     }];
}

- (void)removeALLView
{
    [editView removeFromSuperview];
    
    if(userSlider){
        [userSlider removeFromSuperview];
    }
    
    if(userSegmentedControlRectangleOrCircle){
        [userSegmentedControlRectangleOrCircle removeFromSuperview];
    }
    
    if(userSegmentedControlColor1){
        [userSegmentedControlColor1 removeFromSuperview];
    }
    
    if(userSegmentedControlColor2){
        [userSegmentedControlColor2 removeFromSuperview];
    }
    
    if(customizeColorButton){
        [customizeColorButton removeFromSuperview];
    }
    
    if(colorText){
        [colorText removeFromSuperview];
    }
    
    if( customizeColorText ){
        [customizeColorText removeFromSuperview];
    }
    
    if(widthText){
        [widthText removeFromSuperview];
    }
}

@end
