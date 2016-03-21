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

struct ArrowParameter{
    CGPoint origin;
    CGFloat heightScale;
    CGFloat weidth;
    CGFloat angle;
};

typedef struct ArrowParameter ArrowParameter;
/**
 *  Arrow存储参数生成
 *
 *  @param origin      旋转点
 *  @param heightScale 最终箭头长度scale
 *  @param weidth      箭头宽度
 *  @param angle       箭头角度
 *
 *  @return 箭头参数
 */
inline ArrowParameter CLRArrowMake(CGPoint origin, CGFloat heightScale, CGFloat weidth, CGFloat angle)
{
    ArrowParameter ap;
    ap.origin = origin;
    ap.heightScale = heightScale;
    ap.weidth = weidth;
    ap.angle = angle;
    return ap;
}

/*
@interface TextViewParameter : NSObject
@property (nonatomic) NSString *textString;
@property (nonatomic) UIColor *textColor;
@property (nonatomic) CGRect textViewRect;
@end
*/

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
 *  文字内容
 */
@property (nonatomic) NSString *mTextString;
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
/**
 *  箭头元素的相关属性
 */
@property (nonatomic) ArrowParameter mArrow;

@end

@interface DrawElementsModel : NSObject
+ (id)creatDrawElementWith:(CLRElementType)tpye andSubParameter:(SubParameter*)subParameter;
- (CLRElementType)getType;
- (SubParameter *)getParameter;
@end
