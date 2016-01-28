//
//  CLREditViewController.m
//  CLRCutMosaicDraw
//
//  Created by vk on 16/1/23.
//  Copyright © 2016年 clover. All rights reserved.
//

#import "CLREditViewController.h"
#import "CLRiOSPlug.h"
#import "DrawView.h"
#import "CLRSmoothedBIView.h"

@interface CLREditViewController ()

//@property (nonatomic) DrawView *drawView;
@property (nonatomic) CLRSmoothedBIView *drawView;

@end

@implementation CLREditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor greenColor]];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    backButton.frame = CGRectMake(0, 0, 50, 50);
    backButton.backgroundColor = [UIColor grayColor];
    backButton.titleLabel.font = [backButton.titleLabel.font fontWithSize:20.0]; //= [[UIFont alloc]init];
    
    [backButton setTitle:@"<" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonFoo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
   
    CGRect  viewRect = CGRectMake(0, CGRectGetMaxY(backButton.frame), CGRectGetWidth([CLRiOSPlug screenRect]),  CGRectGetHeight([CLRiOSPlug screenRect]) - CGRectGetHeight(backButton.frame));
    
   // self.drawView = [[DrawView alloc]initWithFrame:viewRect];
    self.drawView = [[CLRSmoothedBIView alloc]initWithFrame:viewRect];
    self.drawView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.drawView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)backButtonFoo:(id)sender
{
    CLREditViewController *__weak weakSelf = self;
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 NSLog(@" CLREditViewController dismissViewController");
                             }];
}

#pragma --CLR Debug foo
- (void)dealloc
{
    NSLog(@"CLREditViewController dealloc");
}
@end
