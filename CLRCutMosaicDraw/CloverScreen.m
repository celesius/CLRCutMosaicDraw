//
//  CloverScreen.m
//  cutImageIOS
//
//  Created by vk on 15/10/21.
//  Copyright © 2015年 Clover. All rights reserved.
//

#import "CloverScreen.h"


@interface CloverScreen()

@end

@implementation CloverScreen

+ (float) getHorizontal:(float)inv{
    CGRect mainScreen = [UIScreen mainScreen].bounds;
    NSLog(@"mainScreen = %@", NSStringFromCGRect(mainScreen));
    return ( CGRectGetWidth(mainScreen) *(inv/2.0))/375.0;
}

+ (float) getVertical:(float)inv{
    CGRect mainScreen = [UIScreen mainScreen].bounds;
    NSLog(@"mainScreen = %@", NSStringFromCGRect(mainScreen));
    return (CGRectGetHeight(mainScreen)*(inv/2.0))/667.0;
}

+ (UIColor *) stringTOColor:(NSString *)hexColor {
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];
    return [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green / 255.0f) blue:(float)(blue / 255.0f)alpha:1.0f];
}

@end
