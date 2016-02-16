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
@property (nonatomic) SubParameter *currentSubParamenter;

+ (instancetype) sharedStore;
+ (NSString *) getElementName:(CLRElementType) type;
- (void)storeCurrentOperateAt:(NSInteger)setIndex;

- (NSInteger) getElementModelStoreQuantity;
- (DrawElementsModel *) getModelByNum:(NSInteger)num;
/**
 *  因为这个类是个单例，一直存在于本程序的生命周期，所以每次进入编辑时，要重新初始化一下存储的array
 */
- (void)initStoreArray;

@end
