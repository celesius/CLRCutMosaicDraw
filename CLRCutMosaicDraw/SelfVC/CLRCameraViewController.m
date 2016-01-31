//
//  CLRCameraViewController.m
//  CLRCutMosaicDraw
//
//  Created by vk on 16/1/28.
//  Copyright © 2016年 clover. All rights reserved.
//

#import "CLRCameraViewController.h"
#import <GPUImage.h>
#import "CLRiOSPlug.h"

@interface CLRCameraViewController ()

@property (nonatomic) GPUImageStillCamera *gpuCamera;
@property (nonatomic) GPUImageFilter *filter;

@end

@implementation CLRCameraViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect screenRect = [CLRiOSPlug screenRect];
    CGRect viewRect = CGRectMake(0, 0, CGRectGetWidth([CLRiOSPlug screenRect]), CGRectGetHeight([CLRiOSPlug screenRect]));
    
    self.gpuCamera = [[GPUImageStillCamera alloc]initWithSessionPreset:AVCaptureSessionPresetPhoto cameraPosition:AVCaptureDevicePositionBack];
    self.gpuCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    GPUImageView *gpuImageView = [[GPUImageView alloc]initWithFrame:viewRect];
    gpuImageView.center = self.view.center;
    [self.view addSubview:gpuImageView];
    
    self.filter = [[GPUImageFilter alloc]init];
    [self.gpuCamera addTarget:self.filter];
    [self.filter addTarget:gpuImageView];
    
    UIButton *captureButton = [UIButton buttonWithType:UIButtonTypeSystem];
    captureButton.frame = CGRectMake( (CGRectGetWidth(screenRect) - 100.0)/2.0, CGRectGetHeight(screenRect) - 100.0 , 100, 60);
    [captureButton setTitle:@"拍照" forState:UIControlStateNormal];
    [captureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [captureButton addTarget:self action:@selector(captureButtonFoo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:captureButton];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.gpuCamera startCameraCapture];
}


- (void)captureButtonFoo:(id)sender
{
    [self.gpuCamera capturePhotoAsImageProcessedUpToFilter:self.filter withCompletionHandler:^(UIImage *processedImage, NSError *error) {
        NSData *dataForJPEGFile = UIImageJPEGRepresentation(processedImage, 0.8);
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSError *error2 = nil;
        if (![dataForJPEGFile writeToFile:[documentsDirectory stringByAppendingPathComponent:@"FilteredPhoto.jpg"] options:NSAtomicWrite error:&error2])
        {
            return;
        }
    }];
    
    /*
     [self.gpuCamera capturePhotoProcessedUpToFilter:filter withCompletionHandler:^(UIImage *processedImage, NSError *error){
     
     }];
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"CLRCameraViewController dealloc");
}

@end
