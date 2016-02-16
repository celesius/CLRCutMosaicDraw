//
//  CloverColorLayer.h
//  cutImageIOS
//
//  Created by vk on 15/10/25.
//  Copyright © 2015年 Clover. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CloverColorLayer : CALayer

- (void) upDateWithColor:(UIColor *)color;

@property (strong, nonatomic) UIColor *color;

@property (nonatomic) BOOL  enableInnerShadow;
@property (nonatomic) CGSize        innerShadowOffset;
@property (nonatomic) float         innerShadowBlur;
@property (nonatomic) CGColorRef    innerShadowColor;

@end
