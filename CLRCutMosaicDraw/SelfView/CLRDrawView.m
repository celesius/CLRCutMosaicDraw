//
//  CLRDrawView.m
//  CLRCutMosaicDraw
//
//  Created by vk on 16/1/31.
//  Copyright © 2016年 clover. All rights reserved.
//

#import "CLRDrawView.h"
#import <GPUImage.h>

typedef enum mProcessingType {
    TypeRedo,
    TypeUndo,
    TypeCount
} ProcessingType;

@interface CLRDrawView ()
{
    UIBezierPath *drawPath;
   
    UIImage *incrementalImage;
    
    CGMutablePathRef cgPath;
    CGPoint pts[5];
    uint ctr;
    
    CGPoint rectStart;
    CGPoint rectPass;
    CGPoint topRight;
    CGPoint bottomLift;
    
    UIImage *backgroundImage;
    BOOL isDrawBack;
    
    NSInteger currentStoreIndex;
    UIImage *rectImage;
    CGRect tmpRect;
    BOOL isMove;
}

@property (nonatomic, readwrite) CLRDrawElementModelStore *currentDrawModel;

@end


@implementation CLRDrawView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setMultipleTouchEnabled:NO];
        isDrawBack = NO;
        drawPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 0, 0)];//[UIBezierPath bezierPath];
        //[drawPath setLineWidth:10.0];
        
        self.currentDrawModel = [CLRDrawElementModelStore sharedStore];
        currentStoreIndex = 0;
        [self.currentDrawModel initStoreArray];
    }
    return self;
}

- (void)updateBackgroundImage:(UIImage *)image
{
    incrementalImage = image;
    backgroundImage = image;//[self getCopyImage:image];
    [self initBackgroundImage];
    [self setNeedsDisplay];
}

- (void)initBackgroundImage
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);//[UIScreen mainScreen].scale);
    [incrementalImage drawInRect:self.bounds];
    incrementalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

#pragma mark -redo逻辑
/**
 *  redo操作逻辑
 *  首先要看当前index是否为0，不为0则进行redo操作，否则显示原图后返回
 */
- (void)redo
{
    incrementalImage = backgroundImage;
    [self initBackgroundImage];
    //[self setNeedsDisplay];
    if(currentStoreIndex != 0){
        currentStoreIndex--;
        [self processingDrawByIndex:currentStoreIndex andType:TypeRedo];
    }
}

- (void)undo
{
    //incrementalImage = backgroundImage;
    //[self initBackgroundImage];
    NSInteger modelStoreCount = [self.currentDrawModel getElementModelStoreQuantity];
    if(currentStoreIndex < modelStoreCount){
        currentStoreIndex ++;
        [self processingDrawByIndex:currentStoreIndex andType:TypeUndo];
    }
}

- (void)processingDrawByIndex:(NSInteger) index andType:(ProcessingType) pType
{
    NSInteger currentModelStoreQuantity = [self.currentDrawModel getElementModelStoreQuantity];
   
    NSInteger indexBuffer = index;
    DrawElementsModel *model;
    CLRElementType modelType;
    SubParameter *modelParamter;

    switch (pType) {
        case TypeRedo:
            /*
            while (indexBuffer > 0) {
                indexBuffer --;
                model = [self.currentDrawModel getModelByNum:indexBuffer];
                modelType = [model getType];
                modelParamter = [model getParameter];
                [self drawImageByType:modelType andParamter:modelParamter];
            }*/
             //while (indexBuffer > 0) {
                //indexBuffer --;
            for (NSInteger i = 0; i< indexBuffer; i++) {
                model = [self.currentDrawModel getModelByNum:i];
                modelType = [model getType];
                modelParamter = [model getParameter];
                [self drawImageByType:modelType andParamter:modelParamter];
            }
            break;
        case TypeUndo:
            //while (!(indexBuffer > currentStoreIndex)) {
                model = [self.currentDrawModel getModelByNum:indexBuffer - 1];
                modelType = [model getType];
                modelParamter = [model getParameter];
                [self drawImageByType:modelType andParamter:modelParamter];
            //    indexBuffer ++;
            //}
            break;
        default:
            break;
    }
    
    [self setNeedsDisplay];
    /*
    for (NSInteger indexBuffer = index; indexBuffer > 0; indexBuffer --) {
    }
     */
}

- (void)drawImageByType:(CLRElementType) modelType andParamter:(SubParameter *) modelParamter
{
    CGRect processingRect;
    switch (modelType) {
        case TypeUserLine:
        case TypeLine:
        case TyperRectangle:
        case TypeCircle:
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
            [incrementalImage drawInRect:self.bounds];
            //[[UIColor blackColor] setStroke];
            [modelParamter.mElementColor setStroke];
            [modelParamter.mPath stroke];
            incrementalImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            break;
        case TypeShiXinRectangle:
        case TypeShiXinCircle:
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
            [incrementalImage drawInRect:self.bounds];
            //[[UIColor blackColor] setStroke];
            [modelParamter.mElementColor setFill];
            [modelParamter.mPath fill];
            incrementalImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            break;
        case TypeMosaic:
            processingRect = modelParamter.mElementRect;
            rectImage = [self getMosaicByRect:processingRect];
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
            [incrementalImage drawInRect:self.bounds];
            [rectImage drawInRect: processingRect];
            incrementalImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            break;
        case TypeBlur:
            processingRect = modelParamter.mElementRect;
            rectImage = [self getBlurByRect:processingRect];
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
            [incrementalImage drawInRect:self.bounds];
            [rectImage drawInRect: processingRect];
            incrementalImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            break;
        default:
            break;
    }
}

- (void)drawRect:(CGRect)rect
{
    //NSLog(@"drawRect");
    [incrementalImage drawInRect:rect];
    
    switch (self.currentDrawModel.currentElmentType) {
        case TypeLine:
        case TyperRectangle:
        case TypeCircle:
            [self.currentDrawModel.currentSubParamenter.mElementColor setStroke];
            [drawPath stroke];
            [drawPath removeAllPoints];
            break;
        case TypeUserLine:
            [self.currentDrawModel.currentSubParamenter.mElementColor setStroke];
            [drawPath stroke];
            break;
        case TypeBlur:
        case TypeMosaic:
            [[UIColor colorWithWhite:0.5 alpha:0.5] setFill];
            [drawPath fill];
            [drawPath removeAllPoints];
            break;
        case TypeShiXinRectangle:
        case TypeShiXinCircle:
            [self.currentDrawModel.currentSubParamenter.mElementColor setFill];
            [drawPath fill];
            [drawPath removeAllPoints];
            break;
        case TypeArrow:
            break;
        case TypeText:
            break;
        default:
            [drawPath stroke];
            [drawPath removeAllPoints];
            break;
    }
    
    //UIBezierPath *rectMa = [UIBezierPath bezierPathWithRect:CGRectMake(rectStart.x, rectStart.y, rectPass.x - rectStart.x, rectPass.y - rectStart.y) ];
    
    //UIBezierPath *linePath = [UIBezierPath bezierPath];
    //[[UIColor redColor] setFill];
    //[rectMa fill];
    
//    CGRect drawRect =
}


- (void)drawBitmap
{
    NSLog(@"bitmap");
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);//[UIScreen mainScreen].scale);
    if (!incrementalImage) // first time; paint background white
    {
        UIBezierPath *rectpath = [UIBezierPath bezierPathWithRect:self.bounds];
        [[UIColor clearColor] setFill];
        //[rectpath  fillWithBlendMode:kCGBlendModeNormal alpha:0.5];//fillWithBlendMode:kCGBlendModeClear alpha:0.1];
        [rectpath fill];
    }
    [incrementalImage drawInRect:self.bounds];
    
    switch (self.currentDrawModel.currentElmentType) {
        case TypeMosaic:
        case TypeBlur:
            [rectImage drawInRect: self.currentDrawModel.currentSubParamenter.mElementRect];
            break;
        case TypeCircle:
        case TyperRectangle:
        case TypeLine:
        case TypeUserLine:
            [self.currentDrawModel.currentSubParamenter.mElementColor setStroke];
            [drawPath stroke];
            break;
        case TypeShiXinRectangle:
        case TypeShiXinCircle:
            [self.currentDrawModel.currentSubParamenter.mElementColor setFill];
            [drawPath fill];
            break;
        default:
            break;
    }
    
    incrementalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    isMove = NO;
   // [drawPath moveToPoint:location];
    ctr = 0;
    pts[0] = location;
    rectStart = location;
    switch (self.currentDrawModel.currentElmentType) {
        case TypeCircle:
        case TypeShiXinCircle:
            drawPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0,0,0,0)];
            break;
        //case TypeUserLine:
        //    drawPath = [UIBezierPath bezierPath];
        //    break;
        default:
            drawPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 0, 0)];
            break;
    }
    [drawPath moveToPoint:rectStart];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    topRight = CGPointMake(p.x, rectStart.y);
    bottomLift = CGPointMake(rectStart.x, p.y);
    
    rectPass = p;
    [drawPath setLineWidth:self.currentDrawModel.currentSubParamenter.mLineWidth];
    switch (self.currentDrawModel.currentElmentType) {
        case TypeLine:
            [drawPath moveToPoint:rectStart];
            [drawPath addLineToPoint:rectPass];
            [self setNeedsDisplay];
            break;
        case TypeUserLine:
            ctr++;
            pts[ctr] = p;
            if (ctr == 4)
            {
                //NSLog(@"in for loop");
                pts[3] = CGPointMake((pts[2].x + pts[4].x)/2.0, (pts[2].y + pts[4].y)/2.0); // move the endpoint to the middle of the line joining the second control point of the first Bezier segment and the first control point of the second Bezier segment
                
                [drawPath moveToPoint:pts[0]];
                [drawPath addCurveToPoint:pts[3] controlPoint1:pts[1] controlPoint2:pts[2]]; // add a cubic Bezier from pt[0] to pt[3], with control points pt[1] and pt[2]
                
                [self setNeedsDisplay];
                // replace points and get ready to handle the next segment
                pts[0] = pts[3];
                pts[1] = pts[4];
                ctr = 1;
            }
            break;
        case TypeBlur:
        case TypeMosaic:
        case TypeShiXinRectangle:
        case TyperRectangle:
            [drawPath moveToPoint:rectStart];
            [drawPath addLineToPoint:topRight];
            [drawPath addLineToPoint:rectPass];
            [drawPath addLineToPoint:bottomLift];
            [drawPath closePath];
            [self setNeedsDisplay];
            break;
        case TypeShiXinCircle:
            drawPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(rectStart.x,rectStart.y, rectPass.x - rectStart.x, rectPass.y - rectStart.y)];
            [self setNeedsDisplay];
            break;
        case TypeCircle:
            //drawPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(rectStart.x,rectStart.y, rectPass.x - rectStart.x, rectPass.y - rectStart.y)];
            drawPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(rectStart.x,rectStart.y, rectPass.x - rectStart.x, rectPass.y - rectStart.y)];
            [drawPath setLineWidth:self.currentDrawModel.currentSubParamenter.mLineWidth];
            [self setNeedsDisplay];
            
            break;
        default:
            break;
    }
    isMove = YES;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //CGRect pickerRect;
    switch (self.currentDrawModel.currentElmentType) {
        case TypeLine:
            [drawPath moveToPoint:rectStart];
            [drawPath addLineToPoint:rectPass];
            self.currentDrawModel.currentSubParamenter.mPath = drawPath;
            break;
        case TypeUserLine:
            self.currentDrawModel.currentSubParamenter.mPath = drawPath;
            break;
        case TypeShiXinRectangle:
        case TyperRectangle:
            [drawPath moveToPoint:rectStart];
            [drawPath addLineToPoint:topRight];
            [drawPath addLineToPoint:rectPass];
            [drawPath addLineToPoint:bottomLift];
            [drawPath closePath];
            self.currentDrawModel.currentSubParamenter.mPath = drawPath;
            break;
        case TypeCircle:
            drawPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(rectStart.x,rectStart.y, rectPass.x - rectStart.x, rectPass.y - rectStart.y)];
            [drawPath setLineWidth:self.currentDrawModel.currentSubParamenter.mLineWidth];
            self.currentDrawModel.currentSubParamenter.mPath = drawPath;
            break;
        case TypeShiXinCircle:
            drawPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(rectStart.x,rectStart.y, rectPass.x - rectStart.x, rectPass.y - rectStart.y)];
            self.currentDrawModel.currentSubParamenter.mPath = drawPath;
            break;
        case TypeMosaic:
            self.currentDrawModel.currentSubParamenter.mElementRect = [self rectMakeByPoint1:rectStart andPoint2:rectPass];
            rectImage = [self getMosaicByRect:self.currentDrawModel.currentSubParamenter.mElementRect];
            break;
        case TypeBlur:
            self.currentDrawModel.currentSubParamenter.mElementRect = [self rectMakeByPoint1:rectStart andPoint2:rectPass];
            rectImage = [self getBlurByRect:self.currentDrawModel.currentSubParamenter.mElementRect];
            break;
        default:
            break;
    }
    [self.currentDrawModel storeCurrentOperateAt:currentStoreIndex];
    currentStoreIndex++;
    if(isMove){
        [self drawBitmap];
        [self setNeedsDisplay];
    }
    [drawPath removeAllPoints];
    ctr = 0;
}

- (CGRect) rectMakeByPoint1:(CGPoint) point1 andPoint2:(CGPoint) point2
{
    double width = fabs( (double)point1.x - (double)point2.x );
    double height = fabs( (double)point1.y - (double)point2.y );
    CGRect rRect = CGRectMake( (point1.x < point2.x)?point1.x:point2.x , (point1.y < point2.y)?point1.y:point2.y , width, height);
    return rRect;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesCancelled");
    
}

-(UIImage *) getCopyImage:(UIImage *)image
{
    CGSize toSize = image.size;
    
    CGRect rect = CGRectMake(0, 0, toSize.width, toSize.height);
    UIGraphicsBeginImageContext( rect.size );
    [image drawInRect:rect];
    UIImage *__autoreleasing  picture1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *__autoreleasing imageData = UIImagePNGRepresentation(picture1);
    UIImage *__autoreleasing img=[UIImage imageWithData:imageData];
    return img;
}

- (UIImage *)getMosaicByRect:(CGRect) setRect
{
    CGFloat processFloat = [UIScreen mainScreen].scale;
    CGImageRef imgRef = CGImageCreateWithImageInRect(incrementalImage.CGImage, CGRectMake(setRect.origin.x*processFloat, setRect.origin.y*processFloat, setRect.size.width*processFloat, setRect.size.height*processFloat));
    UIImage *processingImage = [UIImage imageWithCGImage:imgRef];
    CGImageRelease(imgRef);
    GPUImagePixellateFilter *mMFilter = [[GPUImagePixellateFilter alloc]init];
    mMFilter.fractionalWidthOfAPixel = self.currentDrawModel.currentSubParamenter.mMosaicInputTileSize;
    //GPUImageGrayscaleFilter *mMFilter = [[GPUImageGrayscaleFilter alloc]init];
    GPUImagePicture *pic = [[GPUImagePicture alloc]initWithImage:processingImage];
    [mMFilter useNextFrameForImageCapture];
    [pic addTarget:mMFilter];
    [pic processImage];
    processingImage  = [mMFilter imageFromCurrentFramebuffer];
    return processingImage;
}

- (UIImage *)getBlurByRect:(CGRect) setRect
{
    CGFloat processFloat = [UIScreen mainScreen].scale;
    CGImageRef imgRef = CGImageCreateWithImageInRect(incrementalImage.CGImage, CGRectMake(setRect.origin.x*processFloat, setRect.origin.y*processFloat, setRect.size.width*processFloat, setRect.size.height*processFloat));
    UIImage *processingImage = [UIImage imageWithCGImage:imgRef];
    CGImageRelease(imgRef);
//    GPUImagePixellateFilter *mMFilter = [[GPUImagePixellateFilter alloc]init];
    GPUImageiOSBlurFilter *mMFilter = [[GPUImageiOSBlurFilter alloc]init];

    mMFilter.blurRadiusInPixels = 3.0;
    mMFilter.saturation = 0.6;
    mMFilter.rangeReductionFactor = self.currentDrawModel.currentSubParamenter.mBlurIntensity ;
    //GPUImageGrayscaleFilter *mMFilter = [[GPUImageGrayscaleFilter alloc]init];
    GPUImagePicture *pic = [[GPUImagePicture alloc]initWithImage:processingImage];
    [mMFilter useNextFrameForImageCapture];
    [pic addTarget:mMFilter];
    [pic processImage];
    processingImage  = [mMFilter imageFromCurrentFramebuffer];
    return processingImage;
    
    
}

- (void) drawImageByRedo
{
    NSInteger modelNum = [self.currentDrawModel getElementModelStoreQuantity];
}

- (void)drawView:(CGContextRef)context
{
    if(backgroundImage && !isDrawBack){
        UIImage *drawImage = [UIImage imageWithCGImage:backgroundImage.CGImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationDown];
        isDrawBack = YES;
        CGRect rect = self.bounds;
        
        CGContextSaveGState(context);
        
        CGContextTranslateCTM(context, rect.origin.x, rect.origin.y);
        CGContextTranslateCTM(context, 0, rect.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextTranslateCTM(context, -rect.origin.x, -rect.origin.y);
        CGContextDrawImage(context, rect, drawImage.CGImage);
        CGContextRestoreGState(context);
    }
}

@end