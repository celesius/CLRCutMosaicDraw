//
//  BrightnessAndSaturationView.h
//  cutImageIOS
//
//  Created by vk on 15/10/26.
//  Copyright © 2015年 Clover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSColorPickerView.h"

@interface BrightnessAndSaturationView : UIView

- (void) updateColor;

@property (nonatomic) RSColorPickerView *colorPicker;

//@property (nonatomic) CGFloat hue;

@end
