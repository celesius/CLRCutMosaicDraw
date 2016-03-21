//
//  CLRDrawView.h
//  CLRCutMosaicDraw
//
//  Created by vk on 16/1/31.
//  Copyright © 2016年 clover. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "DrawElementsModel.h"
#import "CLRDrawElementModelStore.h"

@interface CLRDrawView : UIView


@property (nonatomic) CLRElementType currentType;
//@property (nonatomic, weak) UIImage *incrementalImage;


@property (nonatomic, readonly) CLRDrawElementModelStore *currentDrawModel;

- (void)updateBackgroundImage:(UIImage *)image;
- (void)redo;
- (void)undo;

- (UIImage *)getResultImage;

@end
