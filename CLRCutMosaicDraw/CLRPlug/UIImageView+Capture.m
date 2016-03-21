//
//  UIImageView+Capture.m
//  CLRCutMosaicDraw
//
//  Created by vk on 16/3/18.
//  Copyright © 2016年 clover. All rights reserved.
//

#import "UIImageView+Capture.h"

@implementation UIImageView(Capture)

/**
 *  截取当前view内容
 *
 *  @return 返回图片
 */
- (UIImage *)capture {
//    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, [UIScreen mainScreen].scale);
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0);
    //[self drawViewHierarchyInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) afterScreenUpdates:NO];
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
