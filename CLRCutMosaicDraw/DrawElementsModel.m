//
//  DrawElementsModel.m
//  CLRCutMosaicDraw
//
//  Created by vk on 16/1/30.
//  Copyright © 2016年 clover. All rights reserved.
//

#import "DrawElementsModel.h"


@implementation SubParameter

- (id)init
{
    if(self = [super init])
    {
        
        self.mMosaicInputTileSize = 0.05;
        /**
         *  模糊程度
         */
        self.mBlurIntensity = 0.35;
        /**
         *  文字大小
         */
        self.mTextSize = 16.0;
        /**
         *  圆形，模糊，马赛克，矩形的rect
         */
        self.mElementRect = CGRectZero;
        /**
         *  线宽度
         */
        self.mLineWidth = 10.0;
        /**
         *  Line和userLine的path
         */
        self.mPath = [[UIBezierPath alloc]init];
        /**
         *  各元素的颜色
         */
        self.mElementColor = [UIColor blackColor];
    }
    return self;
}

- (id)mutableCopy
{
    //[super mutableCopy];
    //return self;
    SubParameter *copy = [[[self class]alloc] init];
    copy.mMosaicInputTileSize = self.mMosaicInputTileSize;
    copy.mBlurIntensity = self.mBlurIntensity;
    copy.mTextSize = self.mTextSize;
    copy.mElementColor = self.mElementColor;
    copy.mLineWidth = self.mLineWidth;
    copy.mPath = self.mPath;
    copy.mElementColor = self.mElementColor;
    copy.mElementRect = self.mElementRect;
    return copy;
    
}
- (id)mutableCopyWithZone:(struct _NSZone *)zone
{
    //return self;
    NSLog(@"zone");
    id copy = [[[self class]allocWithZone:zone] init];
    return copy;
}

- (void)dealloc
{
    NSLog(@"SubParameter dealloc");
}

@end



@interface DrawElementsModel ()
@property (nonatomic) CLRElementType mElementType;
@property (nonatomic) SubParameter *mSubParameter;
@end

@implementation DrawElementsModel

+(id) creatDrawElementWith:(CLRElementType)tpye andSubParameter:(SubParameter*)subParameter
{
    DrawElementsModel *drawElementModel = [[DrawElementsModel alloc]init];
    [drawElementModel setMElementType:tpye];
    [drawElementModel setMSubParameter:subParameter];
    return drawElementModel;
}

- (CLRElementType)getType
{
    return _mElementType;
}
- (SubParameter *)getParameter
{
    return _mSubParameter;
}

- (void)dealloc
{
    NSLog(@"DrawElementsModel dealloc");
}

@end
