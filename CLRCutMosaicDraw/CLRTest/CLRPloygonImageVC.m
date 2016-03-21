//
//  CLRPloygonImageVC.m
//  CLRCutMosaicDraw
//
//  Created by vk on 16/2/2.
//  Copyright © 2016年 clover. All rights reserved.
//

#import "CLRPloygonImageVC.h"
#import "CLRPloygonImageView.h"
#import "CLRPloygonImageViewNew.h"
#import "CLRiOSPlug.h"
#import "CLRDrawImageColorView.h"
#import "CLRDrawInRectTest.h"

@implementation CLRPloygonImageVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    //CLRPloygonImageViewNew *gIV = [[CLRPloygonImageViewNew alloc]initWithFrame:self.view.bounds];
    //[self.view addSubview:gIV];
    //CLRDrawImageColorView *mView = [[CLRDrawImageColorView alloc]initWithFrame:self.view.bounds];
    
    
    
    CGRect rect = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), ceil(CGRectGetWidth(self.view.bounds)*4/3));
    
    CLRDrawInRectTest *mView = [[CLRDrawInRectTest alloc]initWithFrame:rect];
    mView.center = self.view.center;
    mView.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:mView];
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
