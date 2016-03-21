//
//  CLRCutImageViewController.m
//  CLRCutMosaicDraw
//
//  Created by vk on 16/3/21.
//  Copyright © 2016年 clover. All rights reserved.
//

#import "CLRCutImageViewController.h"
#import "CLRCutImageRootView.h"

@interface CLRCutImageViewController()
{

    CLRCutImageRootView *m_CutImageView;
    UIToolbar *m_TopToolbar;
}

@end

@implementation CLRCutImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"< 返回"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(pullVCFoo:)];
    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成"
                                                                      style:UIBarButtonItemStyleDone
                                                                     target:self
                                                                     action:@selector(doneEditFoo:)];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    m_TopToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 50)];
    m_TopToolbar.backgroundColor = [UIColor cyanColor];
    NSArray *buttonArray = [NSArray arrayWithObjects:backButtonItem,flexibleSpace, doneButtonItem, nil];
    
    [m_TopToolbar setItems:buttonArray];
    [self.view addSubview:m_TopToolbar];
    
    m_CutImageView = [[CLRCutImageRootView alloc]initWithFrame: CGRectMake(0,
                                                                           CGRectGetMaxY(m_TopToolbar.frame),
                                                                           CGRectGetWidth([UIScreen mainScreen].bounds),
                                                                           CGRectGetHeight([UIScreen mainScreen].bounds) - CGRectGetHeight(m_TopToolbar.bounds)
                                                                           )];
    m_CutImageView.receiveImage = _inputImage;
    [self.view addSubview:m_CutImageView];
    
    //m_CutImageView = [[CLRCutImageRootView alloc]initWithFrame:self.view.bounds];
    //self.view = m_CutImageView;

}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)pullVCFoo:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"");
}



@end
