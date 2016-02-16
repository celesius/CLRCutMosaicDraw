//
//  CLRDrawViewAndBackgroundView.h
//  CLRCutMosaicDraw
//
//  Created by vk on 16/2/9.
//  Copyright © 2016年 clover. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLRDrawViewAndBackgroundView : UIView
@property (nonatomic,weak) UIImage *backgroundImage;

- (void)updateBackgroundImage:(UIImage *)image;
- (void)redo;
- (void)undo;
- (UIImage *)getDrawImage;

@end
