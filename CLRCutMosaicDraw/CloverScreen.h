//
//  CloverScreen.h
//  cutImageIOS
//
//  Created by vk on 15/10/21.
//  Copyright © 2015年 Clover. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CloverScreen : NSObject


+ (float) getHorizontal:(float)inv;
+ (float) getVertical:(float)inv;
+ (UIColor *) stringTOColor:(NSString *)hexColor;

@end
