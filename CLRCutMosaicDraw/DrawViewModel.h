//
//  DrawViewModel.h
//  cutImageIOS
//
//  Created by vk on 15/8/31.
//  Copyright (c) 2015年 quxiu8. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DrawViewModel : NSObject

//+ (id)viewModelWithColor:(UIColor *)color Path:(UIBezierPath *)path Width:(CGFloat)width  StartPoint:(CGPoint)startPoint  EndPoint:(CGPoint) endPoint IsDot:(BOOL)isDot;
+ (id)viewModelWithColor:(UIColor *)color Path:(UIBezierPath *)path Width:(CGFloat)width;

@property (copy, nonatomic) UIColor *color;
@property (copy, nonatomic) UIBezierPath *path;

@property (nonatomic) CGFloat width;
@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGPoint endPoint;
@property (nonatomic) BOOL isDot;
@property (nonatomic) BOOL isLineWith2Dot;

@end

