//
//  ColorPreview.h
//  HSVColorPicker
//
//  Created by vk on 15/10/8.
//  Copyright © 2015年 Clover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSColorPickerView.h"

@interface ColorPreview : UIView 

-(id)initWithFrame:(CGRect)frame;

@property (nonatomic, strong) UIColor *bgColor;  //要注意uicolor的定义类型

@end
