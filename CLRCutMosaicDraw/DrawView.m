//
//  ImageShowView.m
//  cutImageIOS
//
//  Created by vk on 15/8/31.
//  Copyright (c) 2015年 quxiu8. All rights reserved.
//

#import "DrawView.h"
#import "DrawViewModel.h"
#import <CoreMotion/CoreMotion.h>

@interface DrawView()

@property (assign, nonatomic) CGMutablePathRef path;
@property (strong, nonatomic) NSMutableArray *pathArray;
@property (assign, nonatomic) BOOL isHavePath;
//@property (strong, nonatomic) UIImage * setImage;
@property (strong, nonatomic) UIImageView * setView;

@property (strong, nonatomic) NSMutableArray *removePathArray;
@property (strong, nonatomic) CMMotionManager *cmMotionManager;
//@property (nonatomic) float
@property (nonatomic, strong) NSMutableArray *pointArray;  //同时发送的只能有一组array, 删除，添加，选取都是这一个array
@property (nonatomic, assign) BOOL IsCutImage;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) BOOL cancelDraw;

@end

@implementation DrawView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
-(id)initWithFrame:(CGRect)frame
{
    if(self=[super initWithFrame:frame])
    {
        self.lineWidth = 10.0f;
        self.removePathArray = [NSMutableArray array];
        self.pointArray = [NSMutableArray array];
        self.cmMotionManager = [[CMMotionManager alloc]init];
        self.lineScale = 1.0;
        //self.IsCutImage = isCutImage;
        self.lineColor = [UIColor  colorWithRed:1.0 green: (204.0/255.0) blue:(204.0/255.0) alpha:0.5];  //[UIColor redColor];
        
        self.multipleTouchEnabled = YES;
        self.cancelDraw = NO;
        self.deleteLine = NO;
        
    }
    return self;
}

- (void) drawLineColorIS:(NSNotification *)nt {
    UIColor *c = [nt object];
    self.lineColor = c;
}

- (void) drawLineWidthIS:(NSNotification *)nt {
    NSValue *v = [nt object];
    float lw;
    [v getValue:&lw];
    self.lineWidth = lw;
}

-(void) resetDraw
{
    /*
     if(self.pathArray != nil){
     [self.pathArray removeAllObjects];
     [self setNeedsDisplay];
     }
     */
    self.lineScale = 1.0;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawView:context];
    //[self drawCircle:context];
}

-(void) drawCircle:(CGContextRef)context andPoint:(CGPoint) location
{
  //  CGContextSetRGBStrokeColor(context, self.lineColor);
  //  CGContextSetRGBFillColor(context, 255, 100, 100, 0.5);
    [_lineColor set];
    CGContextSetLineWidth(context, 5.0);
    CGContextAddEllipseInRect(context, CGRectMake(location.x, location.y, 5, 5));//在这个框中画圆
    CGContextStrokePath(context);
    
}

- (void)drawView:(CGContextRef)context
{
    //NSLog(@"drawView");
    for (DrawViewModel *myViewModel in _pathArray) {
        CGContextAddPath(context, myViewModel.path.CGPath);
       
        //CGContextDrawPath(context, kCGPathStroke);
            [myViewModel.color set];
/*
        if (self.deleteLine) {
            CGContextSetLineWidth(context, myViewModel.width);
            CGContextSetLineCap(context, kCGLineCapRound);
            CGContextSetLineJoin(context, kCGLineJoinRound);
            CGContextSetFlatness(context, 0.6);
            CGContextSetMiterLimit(context, 5);
            CGContextStrokePath(context);
            CGContextSaveGState(context);
        }else{
            */
        
        CGContextSetLineWidth(context, myViewModel.width);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineJoin(context, kCGLineJoinRound);
        //CGContextSetFlatness(context, 0.6);
        CGContextSetMiterLimit(context, 2.0);
        CGContextSetAllowsAntialiasing(context, YES);
        CGContextSetShouldAntialias(context, YES);
        CGContextStrokePath(context);
        CGContextSaveGState(context);
        //}
    }
    if (_isHavePath) {
        if(self.IsCutImage){
            self.lineColor = [UIColor  colorWithRed:1.0 green: (204.0/255.0) blue:(204.0/255.0) alpha:0.5];  //[UIColor redColor];
        }
        //        self.lineColor = [UIColor  colorWithRed:0.0 green:0 blue:1.0 alpha:0.5];  //[UIColor redColor];
        CGContextAddPath(context, _path);
            [_lineColor set];
        /*
        if (self.deleteLine) {
            CGContextSetLineWidth(context, _lineWidth*self.lineScale);
            CGContextSetLineCap(context, kCGLineCapRound);
            CGContextSetLineJoin(context, kCGLineJoinRound);
            CGContextSetFlatness(context, 0.6);
            CGContextSetMiterLimit(context, 5);
            CGContextDrawPath(context, kCGPathStroke);
        } else {
            */
            CGContextSetLineWidth(context, _lineWidth*self.lineScale);
            CGContextSetLineCap(context, kCGLineCapRound);
            CGContextSetLineJoin(context, kCGLineJoinRound);
            CGContextSetFlatness(context, 0.6);
            CGContextSetMiterLimit(context, 2.0);
            CGContextDrawPath(context, kCGPathStroke);
       // }
        
    }
    else{//将路径绘制为透明，为了消除路径图像
        if(self.IsCutImage){
            NSLog(@"in drawView:(CGContextRef)context ");
            self.lineColor = [UIColor  colorWithRed:1.0 green: (204.0/255.0) blue:(204.0/255.0) alpha:0.0];  //[UIColor redColor];
            //        self.lineColor = [UIColor  colorWithRed:0.0 green:0 blue:1.0 alpha:0.0];  //[UIColor redColor];
            CGContextAddPath(context, _path);
            [_lineColor set];
            CGContextSetLineWidth(context, _lineWidth*self.lineScale);
            CGContextSetLineCap(context, kCGLineCapRound);
            CGContextDrawPath(context, kCGPathStroke);
            CGPathRelease(_path);
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
        [self.removePathArray removeAllObjects];
        [self.pointArray removeAllObjects];
        UITouch *touch = [touches anyObject];
        CGPoint location =[touch locationInView:self];
        _path = CGPathCreateMutable();
        _isHavePath = YES;
        CGPathMoveToPoint(_path, NULL, location.x, location.y);
       
        [self.pointArray addObject: [NSValue valueWithCGPoint:location]];
        self.startPoint = location;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    CGPathAddLineToPoint(_path, NULL, location.x, location.y);
    [self setNeedsDisplay];
    [self.pointArray addObject: [NSValue valueWithCGPoint:location]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(touches.count == 1){
        if (_pathArray == nil) {
            _pathArray = [NSMutableArray array];
        }
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInView:self];
        CGPathAddLineToPoint(_path, NULL, location.x, location.y);
//        CGPathMoveToPoint(_path, NULL, location.x, location.y);   //用add代替，用于制作双点线段和点
        [self.pointArray addObject: [NSValue valueWithCGPoint:location]];
        if(!self.IsCutImage){
            UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:_path];
            DrawViewModel *myViewModel = [DrawViewModel viewModelWithColor:_lineColor Path:path Width:_lineWidth*self.lineScale];
            [_pathArray addObject:myViewModel];
            if(_pathArray.count == 9000){
                [_pathArray removeObjectAtIndex:0];
            }
            //[self setNeedsDisplay]; //刷新显示
        }
        
        if(self.IsCutImage){
            //[self setNeedsDisplay]; //让path全透明
            if(self.delegate && [self.delegate respondsToSelector:@selector(setPointArray:andLineWide:)]){
                [self.delegate setPointArray:self.pointArray andLineWide:_lineWidth*self.lineScale];
            }
        }
    }
    _isHavePath = NO;
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _isHavePath = NO;
    if (_pathArray == nil) {
        _pathArray = [NSMutableArray array];
    }
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    CGPathAddLineToPoint(_path, NULL, location.x, location.y);
    self.cancelDraw = YES;
    [self setNeedsDisplay];
}

-(void) redo
{
    if(self.pathArray != nil){
        NSLog(@"length = %lu",(unsigned long)self.pathArray.count);
        int sizeOfPathArray = (int)[self.pathArray count];
        if(sizeOfPathArray != 0){
            DrawViewModel *viewModelWillSave = self.pathArray[sizeOfPathArray - 1];
            [self.removePathArray addObject:viewModelWillSave];
            [self.pathArray removeLastObject];
            [self setNeedsDisplay];
        }
    }
}

-(void) undo
{
    if(self.pathArray != nil){
        NSLog(@"length = %lu",(unsigned long)self.pathArray.count);
        if(self.removePathArray.count != 0) //非0时进行后续计算
        {
            int sizeOfRemovePathArray = (int)[self.removePathArray count];
            DrawViewModel *viewModelWillSave = self.removePathArray[sizeOfRemovePathArray - 1];
            [self.pathArray addObject:viewModelWillSave];
            [self.removePathArray removeLastObject];
            [self setNeedsDisplay];
        }
    }
}

- (UIImage *)capture {
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, [UIScreen mainScreen].scale);
    [self drawViewHierarchyInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma --CLR Debug Code
- (void)dealloc
{
    NSLog(@"dealloc DrawView");
}

@end
