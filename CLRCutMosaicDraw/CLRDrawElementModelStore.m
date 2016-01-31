//
//  CLRDrawElementModelStore.m
//  CLRCutMosaicDraw
//
//  Created by vk on 16/1/31.
//  Copyright © 2016年 clover. All rights reserved.
//

#import "CLRDrawElementModelStore.h"

@interface CLRDrawElementModelStore ()

@property (nonatomic) NSMutableArray *modelStoreArray;

@end

@implementation CLRDrawElementModelStore

+ (instancetype) sharedStore
{
    static CLRDrawElementModelStore *sharerStore = nil;
    if(!sharerStore ){
        sharerStore = [[self alloc]initPrivate];
    }
    
    return sharerStore;
}

- (id)init
{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use + [ CLRDrawElementModelStore sharedStore]" userInfo:nil];
    return nil;
}

- (id)initPrivate
{
    self = [super init];
    self.modelStoreArray = [[NSMutableArray alloc]init];
    self.currentElmentType = 0;
    return self;
}

+ (NSString *) getElementName:(CLRElementType) type
{
    NSString *stringWillrReturn;
    switch (type) {
        case TypeLine:
            stringWillrReturn = @"直线";
            break;
        case TypeUserLine:
            stringWillrReturn = @"跟随手指";
            break;
        case TypeArrow:
            stringWillrReturn = @"箭头";
            break;
            case TypeCircle:
            stringWillrReturn = @"圆形";
            break;
        case TyperRectangle:
            stringWillrReturn = @"矩形";
            break;
        case TypeBlur:
            stringWillrReturn = @"模糊";
            break;
        case TypeMosaic:
            stringWillrReturn = @"马赛克";
            break;
        case TypeShiXinRectangle:
            stringWillrReturn = @"实心矩形";
            break;
        case TpyeShiXinCircle:
            stringWillrReturn = @"实心圆形";
            break;
        case TypeText:
            stringWillrReturn = @"文字";
            break;
        default:
            stringWillrReturn = @"未知";
            break;
    }
    return stringWillrReturn;
}

@end
