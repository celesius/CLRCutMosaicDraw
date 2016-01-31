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
    TpyeShiXinCircle,
    TypeShiXinRectangle,
    TypeCircle,
    TyperRectangle,
    TypeArrow,
    AllTypeNum
} CLRElementType;

@interface SubParameter: NSObject
/**
 *  马赛克块大小
 */
@property (nonatomic) CGSize mMosaicInputTileSize;
/**
 *  模糊程度
 */
@property (nonatomic) CGFloat mBlurIntensity;
/**
 *  文字大小
 */
@property (nonatomic) CGFloat mTextSize;
/**
 *  带Rect的元素的rect
 */
@property (nonatomic) CGRect mElementRect;
/**
 *  线宽度
 */
@property (nonatomic) CGFloat mLineWidth;
/**
 *  Line和userLine的path
 */
@property (nonatomic) UIBezierPath *mPath;
/**
 *  各元素的颜色
 */
@property (nonatomic) UIColor *mElementColor;
@end

@interface DrawElementsModel : NSObject
@property (nonatomic) CLRElementType mElementType;
@property (nonatomic,copy) SubParameter *mSubParameter;
@end
