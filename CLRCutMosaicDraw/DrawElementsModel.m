//
//  DrawElementsModel.m
//  CLRCutMosaicDraw
//
//  Created by vk on 16/1/30.
//  Copyright © 2016年 clover. All rights reserved.
//

#import "DrawElementsModel.h"

@implementation DrawElementsModel

+(id) creatDrawElementWith:(CLRElementType)tpye andSubParameter:(SubParameter*)subParameter
{
    DrawElementsModel *drawElementModel = [[DrawElementsModel alloc]init];
    [drawElementModel setMElementType:tpye];
    [drawElementModel setMSubParameter:subParameter];
    return drawElementModel;
}

- (void)dealloc
{
    NSLog(@"DrawElementsModel dealloc");
}

@end
