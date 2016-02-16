//
//  DrawElementsModel.h
//  CLRCutMosaicDraw
//
//  Created by vk on 16/1/30.
//  Copyright © 2016年 clover. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum clrElementType {
    TypeUserLine,
    TypeLine,
    TypeText,
    TypeMosaic,
    TypeBlur,
    TypeShiXinCircle,
    TypeShiXinRectangle,
    TypeCircle,
    TyperRectangle,
    TypeArrow,
    AllTypeNum
} CLRElementType;

@interface SubParameter: NSObject <NSMutableCopying>
/**
 *  马赛克块大小 初始化为0.05
 */
@property (nonatomic) CGFloat mMosaicInputTileSize;
/**
 *  模糊程度 初始化0.1
 */
@property (nonatomic) CGFloat mBlurIntensity;
/**
 *  文字大小 初始化16
 */
@property (nonatomic) CGFloat mTextSize;
/**
 *  圆形，模糊，马赛克，矩形的rect 初始化为zero
 */
@property (nonatomic) CGRect mElementRect;
/**
 *  线宽度 初始化为10
 */
@property (nonatomic) CGFloat mLineWidth;
/**
 *  带Rect的元素的rect
 */
//@property (nonatomic) CGRect mRect;
/**
 *  Line和userLine的path 初始化为init
 */
@property (nonatomic, copy) UIBezierPath *mPath;
/**
 *  各元素的颜色 初始化为black
 */
@property (nonatomic) UIColor *mElementColor;
@end

@interface DrawElementsModel : NSObject
+ (id)creatDrawElementWith:(CLRElementType)tpye andSubParameter:(SubParameter*)subParameter;
- (CLRElementType)getType;
- (SubParameter *)getParameter;
@end
