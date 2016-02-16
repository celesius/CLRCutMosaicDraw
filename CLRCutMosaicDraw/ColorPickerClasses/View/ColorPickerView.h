//
//  ColorPickerView.h
//  cutImageIOS
//
//  Created by vk on 15/10/12.
//  Copyright © 2015年 Clover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSColorPickerView.h"

@protocol ColorPickerViewDelegate  <NSObject>

- (void)configureColor;

@end


@interface ColorPickerView : UIView <RSColorPickerViewDelegate>

- (id)initWithFrame:(CGRect)frame;
- (void) updateLastColor;

@property (nonatomic, strong) UIColor *currentColor;
@property (nonatomic, weak) id<ColorPickerViewDelegate>delegate;

@end
