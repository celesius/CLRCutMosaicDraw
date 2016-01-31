//
//  CLRDrawView.h
//  CLRCutMosaicDraw
//
//  Created by vk on 16/1/31.
//  Copyright © 2016年 clover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawElementsModel.h"

@interface CLRDrawView : UIView


@property (nonatomic) CLRElementType currentType;

@property (nonatomic, readonly) DrawElementsModel *currentDrawModel;

- (void)redo;
- (void)undo;

@end
