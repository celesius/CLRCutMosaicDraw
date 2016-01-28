//
//  ViewController.m
//  CLRCutMosaicDraw
//
//  Created by vk on 16/1/23.
//  Copyright © 2016年 clover. All rights reserved.
//

#import "ViewController.h"
#import "CLRiOSPlug.h"
#import "CLREditViewController.h"
#import "CLRCameraViewController.h"
static float offsetValue = 25.0;

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIImagePickerController *ipc;
    
    //float offsetValue;
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
   
    CGRect viewRect = CGRectMake(-offsetValue, -offsetValue, CGRectGetWidth([CLRiOSPlug screenRect]) + 2.0*offsetValue , CGRectGetHeight([CLRiOSPlug screenRect]) + 2.0*offsetValue);
    
    UIImageView *backgroundView = [[UIImageView alloc]initWithFrame:viewRect];
    backgroundView.backgroundColor = [UIColor grayColor];
    backgroundView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"backgroundDrakCloud" ofType:@"jpg"]];
    [self addMotionaEffect:backgroundView];
    [self.view addSubview:backgroundView];
    
    float buttonWidth = 50;
    float buttonHeight = buttonWidth;
    /**
     *  draw 在屏幕中间
     */
    UIButton *drawButton = [UIButton buttonWithType:UIButtonTypeSystem];
    drawButton.frame = CGRectMake((CGRectGetWidth([CLRiOSPlug screenRect]) - buttonWidth)/2.0, CGRectGetHeight([CLRiOSPlug screenRect])/2.0+100.0, buttonWidth, buttonHeight);
    drawButton.backgroundColor = [UIColor grayColor];
    [drawButton setTitle:@"绘制" forState:UIControlStateNormal];
    [drawButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [drawButton addTarget:self action:@selector(drawButtonFoo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:drawButton];
    
    UIButton *galleryButton = [UIButton buttonWithType:UIButtonTypeSystem];
    galleryButton.frame = CGRectMake(CGRectGetMinX(drawButton.frame) - 1.5*buttonWidth, CGRectGetMinY(drawButton.frame), buttonWidth, buttonHeight);
    galleryButton.backgroundColor = [UIColor grayColor];
    [galleryButton setTitle:@"编辑" forState:UIControlStateNormal];
    [galleryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [galleryButton addTarget:self action:@selector(galleryButtonFoo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:galleryButton];
    
    UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cameraButton.frame = CGRectMake(CGRectGetMaxX(drawButton.frame) + 0.5*buttonWidth, CGRectGetMinY(drawButton.frame), buttonWidth, buttonHeight);
    cameraButton.backgroundColor = [UIColor grayColor];
    [cameraButton setTitle:@"拍照" forState:UIControlStateNormal];
    [cameraButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cameraButton addTarget:self action:@selector(cameraButtonFoo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cameraButton];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addMotionaEffect:(UIView *)effectOnView
{
    UIInterpolatingMotionEffect *motionaEffect = [[UIInterpolatingMotionEffect alloc]initWithKeyPath:@"center.x"
                                                                                                type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    motionaEffect.minimumRelativeValue = @(-25);
    motionaEffect.maximumRelativeValue= @(25);
    [effectOnView addMotionEffect:motionaEffect];
    UIInterpolatingMotionEffect *motionbEffect = [[UIInterpolatingMotionEffect alloc]initWithKeyPath:@"center.y"
                                                                                                type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    motionbEffect.minimumRelativeValue = @(-25);
    motionbEffect.maximumRelativeValue= @(25);
    [effectOnView addMotionEffect:motionbEffect];
}

- (void)addMotionaEffect2:(UIView *)effectOnView
{
    UIInterpolatingMotionEffect *motionaEffect = [[UIInterpolatingMotionEffect alloc]initWithKeyPath:@"center.x"
                                                                                                type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    motionaEffect.minimumRelativeValue = @(12.5);
    motionaEffect.maximumRelativeValue= @(-12.5);
    [effectOnView addMotionEffect:motionaEffect];
    UIInterpolatingMotionEffect *motionbEffect = [[UIInterpolatingMotionEffect alloc]initWithKeyPath:@"center.y"
                                                                                                type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    motionbEffect.minimumRelativeValue = @(12.5);
    motionbEffect.maximumRelativeValue= @(-12.5);
    [effectOnView addMotionEffect:motionbEffect];
}

- (void)drawButtonFoo:(id)sender
{
    [self greatNewCanvas];
}

- (void)greatNewCanvas
{
    CLREditViewController *clrEditVC = [[CLREditViewController alloc]init];
    [self presentViewController:clrEditVC animated:YES completion:nil];
}

- (void)galleryButtonFoo:(id)sender
{
    [self openGallery];
}

- (void)openGallery
{
    ipc = [[UIImagePickerController alloc]init];
    ipc.delegate = self;
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        [self presentViewController:ipc animated:YES completion:nil];
    }
}

- (void)cameraButtonFoo:(id)sener
{
    [self openCamera];
}

- (void)openCamera
{
    CLRCameraViewController *cameraVC = [[CLRCameraViewController alloc]init];
    [self presentViewController:cameraVC animated:YES completion:nil];

}

#pragma make - ImagePickerController Delegate
//- (void)
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    ViewController * __weak weakself = self;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        //[picker dismissViewControllerAnimated:YES completion:^{[weakself vcPush];}];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
   
    
    //_getImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    //[self vcPush];
    //_clrGPUImageVC = [[CLRGPUImageVC alloc]init];
    //_clrGPUImageVC.getImage = _getImage;
    //NSLog(@"getImage");
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
