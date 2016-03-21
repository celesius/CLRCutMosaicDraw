//
//  CLRDrawElementModelStore.m
//  CLRCutMosaicDraw
//
//  Created by vk on 16/1/31.
//  Copyright © 2016年 clover. All rights reserved.
//

#import "CLRDrawElementModelStore.h"

@interface CLRDrawElementModelStore ()
{
}

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
    self.currentSubParamenter = [[SubParameter alloc]init];
    return self;
}

- (void)storeCurrentOperateAt:(NSInteger)setIndex
{
    NSInteger arrayCnt = [self getElementModelStoreQuantity];
    if(arrayCnt == setIndex)
    {
        [self storeCurrentOperate];
    } else {
        NSInteger indexBuffer = setIndex;
        
        if(indexBuffer == 0)
        {
            [self.modelStoreArray removeAllObjects];
        }else{
            for ( ; arrayCnt >= indexBuffer + 1; ) {
                [self.modelStoreArray removeLastObject];
                arrayCnt = [self getElementModelStoreQuantity];
            }
        }
        [self storeCurrentOperate];
    }
}

- (void)storeCurrentOperate
{
    SubParameter *newParameter = [self.currentSubParamenter mutableCopy];//[self copyParameter];//[[SubParameter alloc]init];
    DrawElementsModel *newModel = [DrawElementsModel creatDrawElementWith:self.currentElmentType andSubParameter:newParameter];
    [self.modelStoreArray addObject:newModel];
}

- (SubParameter *)copyParameter
{
    SubParameter *newParameter = [[SubParameter alloc]init];
    newParameter.mPath = [UIBezierPath bezierPathWithCGPath:self.currentSubParamenter.mPath.CGPath]; //[self.currentSubParamenter.mPath mutableCopy];
    newParameter.mElementColor =  [UIColor colorWithCGColor:self.currentSubParamenter.mElementColor.CGColor];
    return newParameter;
}

- (NSInteger) getElementModelStoreQuantity
{
    return [self.modelStoreArray count];
}

- (DrawElementsModel *) getModelByNum:(NSInteger)num
{
    NSLog(@"%ld",(long)num);
    return [self.modelStoreArray objectAtIndex:num];
}

- (void)initStoreArray
{
    self.modelStoreArray = nil;
    self.modelStoreArray = [[NSMutableArray alloc]init];
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
        case TypeShiXinCircle:
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
