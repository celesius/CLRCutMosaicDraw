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
    return self;
}

@end
