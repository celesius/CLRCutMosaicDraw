//
//  CLRDrawElementModelStore.h
//  CLRCutMosaicDraw
//
//  Created by vk on 16/1/31.
//  Copyright © 2016年 clover. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DrawElementsModel.h"

@interface CLRDrawElementModelStore : NSObject

@property (nonatomic) CLRElementType currentElmentType;

+ (instancetype) sharedStore;
+ (NSString *) getElementName:(CLRElementType) type;

@end
