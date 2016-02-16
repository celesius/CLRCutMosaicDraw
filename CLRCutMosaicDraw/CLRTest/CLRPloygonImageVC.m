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

@implementation CLRPloygonImageVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    CLRPloygonImageViewNew *gIV = [[CLRPloygonImageViewNew alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:gIV];
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
