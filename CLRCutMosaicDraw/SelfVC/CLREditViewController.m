//
//  CLREditViewController.m
//  CLRCutMosaicDraw
//
//  Created by vk on 16/1/23.
//  Copyright © 2016年 clover. All rights reserved.
//

#import "CLREditViewController.h"
#import "CLRiOSPlug.h"
//#import "DrawView.h"
#import "CLRSmoothedBIView.h"
//#import "CLRDrawView.h"
#import "CLRDrawViewAndBackgroundView.h"
#import "CLRSelectDrawView.h"
#import "CLRDrawElementModelStore.h"
#import "CLRSelectLineWidthView.h"


@interface CLREditViewController ()
{
    CLRSelectDrawView *_mSelectDrawView;
    CLRSelectLineWidthView *_mSelectLineWidthView;
    CLRDrawElementModelStore *_mDrawElementModelStore;
    //CLRDrawView *_mDrawView;
    CLRDrawViewAndBackgroundView *_mDrawView;
}

//@property (nonatomic) DrawView *drawView;
//@property (nonatomic) CLRSmoothedBIView *drawView;
@property (nonatomic) UIToolbar *mToolbar;

@end

@implementation CLREditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    float toolBarHight = 50;
    [self.view setBackgroundColor:[UIColor greenColor]];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    backButton.frame = CGRectMake(0, 0, 50, 50);
    backButton.backgroundColor = [UIColor grayColor];
    backButton.titleLabel.font = [backButton.titleLabel.font fontWithSize:20.0]; //= [[UIFont alloc]init];
    
    [backButton setTitle:@"<" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonFoo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    //    CGRect  viewRect = CGRectMake(0, CGRectGetMaxY(backButton.frame), CGRectGetWidth([CLRiOSPlug screenRect]),  CGRectGetHeight([CLRiOSPlug screenRect]) - CGRectGetHeight(backButton.frame));
    float drawViewWH =  CGRectGetWidth([CLRiOSPlug screenRect])/CGRectGetHeight([CLRiOSPlug screenRect]);
    float drawViewH = CGRectGetHeight(self.view.bounds) - toolBarHight - CGRectGetHeight(backButton.bounds);
    float drawViewW = drawViewH*drawViewWH;
    
    CGRect  viewRect = CGRectMake( (CGRectGetWidth(self.view.bounds) - drawViewW)/2.0, CGRectGetMaxY(backButton.frame), drawViewW, drawViewH);
    
    if(_mDrawView == nil){
        _mDrawView = [[CLRDrawViewAndBackgroundView alloc]initWithFrame:viewRect];
        
        _mDrawView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_mDrawView];
    }
    
    
    self.mToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - toolBarHight, CGRectGetWidth(self.view.bounds), toolBarHight)];
    [self.view addSubview:self.mToolbar];
    
    NSMutableArray *barButtonItemArray = [[NSMutableArray alloc]initWithCapacity:0];
    UIBarButtonItem *b1 = [[UIBarButtonItem alloc]initWithTitle:@"线宽" style:UIBarButtonItemStylePlain target:self action:@selector(b1ButtonFoo:)];
    UIBarButtonItem *b2 = [[UIBarButtonItem alloc]initWithTitle:@"绘制类型" style:UIBarButtonItemStylePlain target:self action:@selector(b2ButtonFoo:)];
    UIBarButtonItem *cutImage = [[UIBarButtonItem alloc]initWithTitle:@"剪切" style:UIBarButtonItemStylePlain target:self action:@selector(cutImageButtonFoo:)];
    UIBarButtonItem *redoButton = [[UIBarButtonItem alloc]initWithTitle:@"redo" style:UIBarButtonItemStylePlain target:self action:@selector(redoButtonFoo:)];
    UIBarButtonItem *undoButton = [[UIBarButtonItem alloc]initWithTitle:@"undo" style:UIBarButtonItemStylePlain target:self action:@selector(undoButtonFoo:)];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barButtonItemArray addObject:b1];
    [barButtonItemArray addObject:space];
    [barButtonItemArray addObject:b2];
    [barButtonItemArray addObject:space];
    [barButtonItemArray addObject:cutImage];
    [barButtonItemArray addObject:space];
    [barButtonItemArray addObject:redoButton];
    [barButtonItemArray addObject:space];
    [barButtonItemArray addObject:undoButton];
    
    //self.mToolbar.items = barButtonItemArray;
    [self.mToolbar setItems:barButtonItemArray animated:YES];
    
    _mSelectDrawView = [[CLRSelectDrawView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_mSelectDrawView];
    _mSelectDrawView.hidden = YES;
    _mSelectDrawView.alpha = 0.0;
    _mDrawElementModelStore = [CLRDrawElementModelStore sharedStore];
    
    _mSelectLineWidthView = [[CLRSelectLineWidthView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_mSelectLineWidthView];
    _mSelectLineWidthView.hidden = YES;
    _mSelectLineWidthView.alpha = 0.0;
    
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    if(self.srcImage)
    {
        //self.drawView.
        //UIImageView *tt = [[UIImageView alloc]initWithImage:self.srcImage];
        //tt.frame = self.drawView.bounds;
        //[self.drawView addSubview:tt];
    }
}


- (void)setSrcImage:(UIImage *)srcImage
{
    _srcImage = srcImage;
    float viewWH = _srcImage.size.width / _srcImage.size.height;
    float viewW = CGRectGetWidth(self.view.bounds)*9.0/10.0;
    float viewH = viewW/viewWH;
    
    //CGPoint pointBuffer = self.
    //self.drawView
    if(_mDrawView != nil){
        
        _mDrawView.frame = CGRectMake(0, 0, viewW, viewH);
    }else
    {
        _mDrawView = [[CLRDrawViewAndBackgroundView alloc]initWithFrame:CGRectMake(0, 0, viewW, viewH)];
        [self.view addSubview:_mDrawView];
    }
    
    _mDrawView.center = CGPointMake(self.view.center.x, (CGRectGetHeight(self.view.bounds) - 50.0 - 50)/2.0 + 50 );
    [_mDrawView updateBackgroundImage:_srcImage];
    //_mDrawView.frame = CGRectMake(, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
    //UIImageView *imageEditView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, viewW, viewH)];
    //imageEditView.image = _srcImage;
    //imageEditView.center = self.drawView.center;
    //[self.view addSubview:imageEditView];
    
}

- (void)backButtonFoo:(id)sender
{
    CLREditViewController *__weak weakSelf = self;
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 NSLog(@" CLREditViewController dismissViewController");
                             }];
}

- (void)b1ButtonFoo:(id)sender
{
    _mSelectLineWidthView.hidden = NO;
    [_mSelectLineWidthView refreshElementType];
    [UIView animateWithDuration:0.3
                     animations:^{
                         _mSelectLineWidthView.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

- (void)b2ButtonFoo:(id)sender
{
    _mSelectDrawView.hidden = NO;
    [UIView animateWithDuration:0.3
                     animations:^{
                         _mSelectDrawView.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

- (void)cutImageButtonFoo:(id)sender
{
    
}

- (void)redoButtonFoo:(id)sender
{
    [_mDrawView redo];
}

- (void)undoButtonFoo:(id)sender
{
    [_mDrawView undo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --CLR Debug foo
- (void)dealloc
{
    NSLog(@"CLREditViewController dealloc");
}
@end
