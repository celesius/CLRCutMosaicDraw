//
//  CLRSelectDrawView.m
//  CLRCutMosaicDraw
//
//  Created by vk on 16/1/31.
//  Copyright © 2016年 clover. All rights reserved.
//

#import "CLRSelectDrawView.h"
#import "SMVerticalSegmentedControl.h"

static const int kSegmentedControlWidth = 85;
#define UI_COLOR_FROM_RGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                                                    green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                                                    blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface CLRSelectDrawView ()
{
    SMVerticalSegmentedControl *mVerticalSegmentedControl;
    CLRDrawElementModelStore *drawElementModelStore;
}

@end

@implementation CLRSelectDrawView

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        //UIToolbar *mt = [[UIToolbar alloc]initWithFrame:frame];
        //[self addSubview:mt];
        
        drawElementModelStore = [CLRDrawElementModelStore sharedStore];
        NSMutableArray *nameArray = [[NSMutableArray alloc]init];
        
        for(int i = 0;i<(int)AllTypeNum;i++)
        {
            [nameArray addObject:[CLRDrawElementModelStore getElementName:i]];
        }
        mVerticalSegmentedControl = [[SMVerticalSegmentedControl alloc]initWithSectionTitles:nameArray];
        
        mVerticalSegmentedControl.backgroundColor = UI_COLOR_FROM_RGB(0x3498db);
        mVerticalSegmentedControl.textColor = [UIColor whiteColor];
        mVerticalSegmentedControl.selectedTextColor = UI_COLOR_FROM_RGB(0x34495e);
        mVerticalSegmentedControl.selectionIndicatorColor = UI_COLOR_FROM_RGB(0x34495e);
        
        mVerticalSegmentedControl.textAlignment = SMVerticalSegmentedControlTextAlignmentCenter;
        mVerticalSegmentedControl.selectionStyle = SMVerticalSegmentedControlSelectionStyleBox;
        mVerticalSegmentedControl.selectionIndicatorThickness = 0;
        mVerticalSegmentedControl.selectionBoxBorderWidth = 0;
        mVerticalSegmentedControl.selectedSegmentIndex = drawElementModelStore.currentElmentType;
        
        float segmentedControlW = CGRectGetWidth(self.bounds) * 3.0 / 4.0;
        float segmentedControlH = segmentedControlW * 4.0 / 3.0;
        mVerticalSegmentedControl.frame = CGRectMake(0, 0, segmentedControlW, segmentedControlH);
        mVerticalSegmentedControl.center = self.center;
        
        [mVerticalSegmentedControl addTarget:self action:@selector(segmentedFoo:) forControlEvents:UIControlEventValueChanged];
        
        [self addSubview:mVerticalSegmentedControl];
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        NSLog(@"drawElementModelStore in CLRSelectDrawView = %@",drawElementModelStore);
    }
    return self;
}

- (void)segmentedFoo:(id)sender
{
    //NSLog(@"111");
    UISegmentedControl *segmentButton = (UISegmentedControl *)sender;
    CLRElementType  index = (CLRElementType)[segmentButton  selectedSegmentIndex];
    NSLog(@"%@",[CLRDrawElementModelStore getElementName:index]);
    drawElementModelStore.currentElmentType = index;
    [self hiddenSeldDelay:0.2];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGRect endRect = CGRectMake(0, CGRectGetMaxY(mVerticalSegmentedControl.frame), CGRectGetWidth(self.bounds), CGRectGetMaxY(self.bounds) - CGRectGetMaxY(mVerticalSegmentedControl.frame));
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    if(CGRectContainsPoint(endRect, location)){
        [self hiddenSelf];
    }
}

- (void)hiddenSelf
{
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         self.hidden = YES;
                     }];
}

- (void)hiddenSeldDelay:(NSTimeInterval) time
{
    [UIView animateWithDuration:0.2
                          delay:time
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         self.hidden = YES;
                     }];
}

@end
