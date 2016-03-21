//
//  CLRDrawView.m
//  CLRCutMosaicDraw
//
//  Created by vk on 16/1/31.
//  Copyright © 2016年 clover. All rights reserved.
//

#import "CLRDrawView.h"
#import "CLRDynamicView.h"
#import <GPUImage.h>
#import "UIImageView+Capture.h"

typedef enum mProcessingType {
    TypeRedo,
    TypeUndo,
    TypeCount
} ProcessingType;

@interface CLRDrawView () <UITextViewDelegate>
{
    UIBezierPath *drawPath;
    
    UIImage *incrementalImage;
    UIImageView *backgroundImageView;
    
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
    CLRDynamicView *arrowView;
    CGRect arrowViewOrgRect;
    
    CGPoint arrowOrigin;
    CGFloat arrowHeightScale;
    CGFloat arrowWeidth;
    CGFloat arrowAngle;
    
    UIImageView *m_ArrowDrawView;
   // UIBarButtonItem *m_keyboardTopBarButtonItem;
    UIToolbar *m_KeyboardToolbar;
    UITextView *m_TextView;
    UITextView *m_WillCloseTextView;
    BOOL m_EnableLayoutTextView;
    
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
        arrowViewOrgRect = CGRectMake(0, 0, 20, 40);
        [self initKeyBoardTopBar];
        m_EnableLayoutTextView = YES;
        //backgroundImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        //[self addSubview:backgroundImageView];
    }
    return self;
}


- (void)initKeyBoardTopBar
{
    m_KeyboardToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0,  CGRectGetWidth([UIScreen mainScreen].bounds) , 30)];
    [ m_KeyboardToolbar setBarStyle:UIBarStyleDefault];
    /*
     UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"Hello" style:UIBarButtonItemStyleBordered target:self action:nil];
     UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
     */
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard:)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    //NSArray * buttonsArray = [NSArray arrayWithObjects:helloButton,btnSpace,doneButton,nil];
    NSArray *buttonsArray = [NSArray arrayWithObjects:flexibleSpace,doneButton,nil];
    
    [m_KeyboardToolbar setItems:buttonsArray];
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
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0);//[UIScreen mainScreen].scale);
    [incrementalImage drawInRect:self.bounds];
    incrementalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}
/**
 *  截取当前view内容
 *
 *  @return 返回图片
 */
- (UIImage *)capture {
    //    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, [UIScreen mainScreen].scale);
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0);
    //[self drawViewHierarchyInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) afterScreenUpdates:NO];
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
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
    [arrowView removeFromSuperview];
    
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

- (UIImage *)getResultImage
{
    return incrementalImage;
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
        case TypeArrow:
            NSLog(@"%@", NSStringFromCGPoint(modelParamter.mArrow.origin));
            NSLog(@"%f", modelParamter.mArrow.heightScale);
            NSLog(@"%f", modelParamter.mArrow.weidth);
            NSLog(@"%f", modelParamter.mArrow.angle);
            
            //UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
            //[incrementalImage drawInRect:self.bounds];
            //incrementalImage = UIGraphicsGetImageFromCurrentImageContext();
            //UIGraphicsEndImageContext();
            
            [self drawArrowByArrowParameter:modelParamter.mArrow];
            //incrementalImage = [self capture];
            //[arrowView removeFromSuperview];
            //[arrowView removeFromSuperview];
            break;
        case TypeText:
            [self drawTextViewByParameter:modelParamter];
            break;
        default:
            break;
    }
}

- (void)drawRect:(CGRect)rect
{
    //NSLog(@"drawRect");
    //CGContextRef context = UIGraphicsGetCurrentContext();
    //[self drawView:context];
    //UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0);
    /**
     *  这个会引起图像的退化，后续看看如何处理 这个可以用一个uiimageview替换
     */
    [incrementalImage drawAsPatternInRect:rect];
    //UIGraphicsEndImageContext();
    //backgroundImageView.image = incrementalImage;
    
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
        case TypeText:
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
        default:
            [drawPath stroke];
            [drawPath removeAllPoints];
            break;
    }
}

- (void)drawBitmap
{
    NSLog(@"bitmap");
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0);//[UIScreen mainScreen].scale);
    if (!incrementalImage) // first time; paint background white
    {
        UIBezierPath *rectpath = [UIBezierPath bezierPathWithRect:self.bounds];
        [[UIColor whiteColor] setFill];
        //[rectpath  fillWithBlendMode:kCGBlendModeNormal alpha:0.5];//fillWithBlendMode:kCGBlendModeClear alpha:0.1];
        [rectpath fill];
    }
    [incrementalImage drawAsPatternInRect:self.bounds];
    
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
        case TypeArrow:
            arrowView = [[CLRDynamicView alloc]initWithFrame:arrowViewOrgRect];
            arrowView.center = location;
            arrowView.layer.anchorPoint = CGPointMake(0.5, 0);
            [self addSubview:arrowView];
            break;
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
    CGPoint location = p;
    CGPoint center = rectStart;
    CGFloat height = sqrt( ((p.x - center.x) * (p.x - center.x) + (p.y - center.y) * (p.y - center.y)) );
    
    CGFloat oriH = arrowViewOrgRect.size.height;
    
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
        case TypeText:
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
        case TypeArrow:
            if(location.x < center.x){
                if(location.x != center.x){
                    arrowAngle = (90*(M_PI/180.0)) +  atan( (location.y - center.y)/(location.x - center.x) );
                    arrowView.transform = CGAffineTransformMakeRotation( arrowAngle );
                    arrowView.transform = CGAffineTransformScale( arrowView.transform, 1, height/oriH );
                }
            } else {
                if(location.x != center.x){
                    arrowAngle = atan((location.y - center.y)/(location.x - center.x)) - (90*(M_PI/180.0));
                    arrowView.transform = CGAffineTransformMakeRotation( arrowAngle );
                    arrowView.transform = CGAffineTransformScale( arrowView.transform, 1, height/oriH );
                }
            }
            arrowHeightScale = height/oriH;
            arrowWeidth = CGRectGetWidth(arrowView.bounds);
            arrowOrigin = center;
            //self.currentDrawModel.currentSubParamenter.mArrow.angle = 0.1;
            break;
        default:
            break;
    }
    isMove = YES;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //CGRect pickerRect;
    UITextView *a_Label;
    UIToolbar * topView;
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
        case TypeArrow:
            self.currentDrawModel.currentSubParamenter.mArrow = CLRArrowMake(arrowOrigin, arrowHeightScale, arrowWeidth, arrowAngle);
            [self drawArrowToImg:[self capture]];
            break;
        case TypeText:
            if(isMove && m_EnableLayoutTextView)
                [self layoutTextViewByFrame:CGRectMake(rectStart.x,rectStart.y, rectPass.x - rectStart.x, rectPass.y - rectStart.y)];
            self.currentDrawModel.currentSubParamenter.mElementRect =[self rectMakeByPoint1:rectStart andPoint2:rectPass];
            break;
        default:
            break;
    }
    if(self.currentDrawModel.currentElmentType != TypeText){
        [self storeDrawModelAndUpdateImage];
    }
}

- (void)storeDrawModelAndUpdateImage
{
    [self.currentDrawModel storeCurrentOperateAt:currentStoreIndex];
    currentStoreIndex++;
    if(isMove){
        [self drawBitmap];
        [self setNeedsDisplay];
    }
    [drawPath removeAllPoints];
    ctr = 0;
}

- (void)drawArrowToImg:(UIImage *)image
{
    NSLog(@"%@",image);
    NSLog(@"%@",incrementalImage);
    incrementalImage = image;
    [self initBackgroundImage];
    [arrowView removeFromSuperview];
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

- (void) drawArrowByArrowParameter:( ArrowParameter )arrowParameter
{
    m_ArrowDrawView = [[UIImageView alloc]initWithFrame:self.bounds];
    m_ArrowDrawView.image = incrementalImage;
    arrowView = [[CLRDynamicView alloc]initWithFrame:arrowViewOrgRect];
    arrowView.center = arrowParameter.origin;
    arrowView.layer.anchorPoint = CGPointMake(0.5, 0);
    [m_ArrowDrawView addSubview:arrowView];
    arrowView.transform = CGAffineTransformMakeRotation( arrowParameter.angle);
    arrowView.transform = CGAffineTransformScale( arrowView.transform, 1, arrowParameter.heightScale );
    incrementalImage = [m_ArrowDrawView capture];
    [arrowView removeFromSuperview];
    //[self drawArrowToImg:incrementalImage];
}

- (void) drawTextViewByParameter:(SubParameter *)parameter
{
    m_ArrowDrawView = [[UIImageView alloc]initWithFrame:self.bounds];
    m_ArrowDrawView.image = incrementalImage;

    m_TextView = [[UITextView alloc]initWithFrame:parameter.mElementRect];
    m_TextView.scrollEnabled = NO;
    m_TextView.scrollsToTop = YES;
    m_TextView.font = [UIFont systemFontOfSize:parameter.mTextSize];
    m_TextView.text = parameter.mTextString;
    m_TextView.textColor = parameter.mElementColor;
    m_TextView.backgroundColor = [UIColor clearColor];
    
    [m_ArrowDrawView addSubview:m_TextView];
    incrementalImage = [m_ArrowDrawView capture];
    [m_TextView removeFromSuperview];
}

- (void)drawView:(CGContextRef)context
{
    //if(backgroundImage && !isDrawBack){
    
    isDrawBack = YES;
    CGRect rect = self.bounds;
    
    CGContextSaveGState(context);
    
    CGContextTranslateCTM(context, rect.origin.x, rect.origin.y);
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, -rect.origin.x, -rect.origin.y);
    CGContextDrawImage(context, rect, incrementalImage.CGImage);
    CGContextRestoreGState(context);
    //}
}

- (void)layoutTextViewByFrame:(CGRect)layoutFrame
{
    m_TextView = [[UITextView alloc]initWithFrame:layoutFrame];
    m_TextView.scrollEnabled = NO;
    //m_TextView.scrollsToTop = YES;
    m_TextView.backgroundColor = [UIColor yellowColor];
    m_TextView.delegate = self;
    m_TextView.textAlignment = NSTextAlignmentLeft;
    m_TextView.font = [UIFont systemFontOfSize:self.currentDrawModel.currentSubParamenter.mTextSize];
    m_TextView.textColor = self.currentDrawModel.currentSubParamenter.mElementColor;
    m_TextView.layoutManager.allowsNonContiguousLayout = YES;
    [self addSubview:m_TextView];
    
    [m_TextView setInputAccessoryView:m_KeyboardToolbar];
    
    [m_TextView becomeFirstResponder];
}

- (void)dismissKeyBoard:(id)sender
{
    [m_WillCloseTextView resignFirstResponder];
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    //NSLog(@"textViewDidChangeSelection");
    //NSLog(@"%@",textView);
}

- (void)textViewDidChange:(UITextView *)textView
{
    //NSLog(@"textViewDidChange");
    //NSLog(@"%@",textView);
}

/**
 *  保证可关闭的是当前的textView
 *
 *  @param textView
 */
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    m_WillCloseTextView = textView;
    m_EnableLayoutTextView = NO;
    NSLog(@"textViewDidBeginEditing");
    
    NSLog(@"%d",self.userInteractionEnabled);
    //if (self.userInteractionEnabled) {
    //    self.userInteractionEnabled = NO;
    //}
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    m_EnableLayoutTextView = YES;
    self.currentDrawModel.currentSubParamenter.mTextString = textView.text;
    incrementalImage = [self capture];
    [self storeDrawModelAndUpdateImage];
    [textView removeFromSuperview];
    
    //self.userInteractionEnabled = YES;
    NSLog(@"textViewDidEndEditing");
}


//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//}
//
//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//}
//
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//    return YES;
//}

@end