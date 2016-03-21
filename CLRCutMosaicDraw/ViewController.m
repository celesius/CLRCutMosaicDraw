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
#import "CLRPloygonImageVC.h"
#import "UIImage+Rotate.h"
static float offsetValue = 25.0;

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIImagePickerController *ipc;
    //float offsetValue;
}

@property (nonatomic) UIImage *galleryImage;

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
    
    
    UIButton *testButton = [UIButton buttonWithType:UIButtonTypeSystem];
    testButton.frame = CGRectMake(CGRectGetMinX(drawButton.frame), CGRectGetMaxY(drawButton.frame) + 20.0, buttonWidth, buttonHeight);
    testButton.backgroundColor = [UIColor grayColor];
    [testButton setTitle:@"测试" forState:UIControlStateNormal];
    [testButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [testButton addTarget:self action:@selector(testButtonFoo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testButton];
    
    
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
    UIImage *image = [self createImageByColor:[UIColor yellowColor]];
    clrEditVC.srcImage = image;
    
    [self presentViewController:clrEditVC animated:YES completion:nil];
}

- (UIImage *)createImageByColor:(UIColor *)color
{
    UIImage *createImage;
    CGRect imageRect = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), ceilf(CGRectGetWidth([UIScreen mainScreen].bounds)*4.0/3.0)  );
    UIGraphicsBeginImageContextWithOptions(imageRect.size, self.view.opaque, 0.0);//[UIScreen mainScreen].scale);
    UIBezierPath *rectpath = [UIBezierPath bezierPathWithRect:imageRect];
    [color setFill];
    //[rectpath  fillWithBlendMode:kCGBlendModeNormal alpha:0.5];//fillWithBlendMode:kCGBlendModeClear alpha:0.1];
    [rectpath fill];
    [createImage drawAsPatternInRect:imageRect];
    createImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return createImage;
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

- (void)cameraButtonFoo:(id)sender
{
    [self openCamera];
}

- (void)openCamera
{
    CLRCameraViewController *cameraVC = [[CLRCameraViewController alloc]init];
    [self presentViewController:cameraVC animated:YES completion:nil];
}

- (void)testButtonFoo:(id)sender
{
    CLRPloygonImageVC *pIVC = [[CLRPloygonImageVC alloc]init];
    [self presentViewController:pIVC animated:YES completion:nil];
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
    self.galleryImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    CLREditViewController *clrEditVC = [[CLREditViewController alloc]init];
    [self presentViewController:clrEditVC animated:YES completion:^{
        //weakself.galleryImage = [weakself.galleryImage rotateInRadians:10];
        
        clrEditVC.srcImage = weakself.galleryImage;
    }];
    //_getImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    //[self vcPush];
    //_clrGPUImageVC = [[CLRGPUImageVC alloc]init];
    //_clrGPUImageVC.getImage = _getImage;
    //NSLog(@"getImage");
}

- (void)vcPush
{

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
