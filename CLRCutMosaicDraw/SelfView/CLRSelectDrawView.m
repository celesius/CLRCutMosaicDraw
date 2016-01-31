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
}

@end

@implementation CLRSelectDrawView

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        //UIToolbar *mt = [[UIToolbar alloc]initWithFrame:frame];
        //[self addSubview:mt];
        
        NSMutableArray *nameArray = [[NSMutableArray alloc]init];
        
        for(int i = 0;i<(int)AllTypeNum;i++)
        {
            [nameArray addObject:[CLRDrawElementModelStore getElementName:i]];
        }
        mVerticalSegmentedControl = [[SMVerticalSegmentedControl alloc]initWithSectionTitles:nameArray];
        int totalSegmented = (int)AllTypeNum;
        
        mVerticalSegmentedControl.backgroundColor = UI_COLOR_FROM_RGB(0x3498db);
        mVerticalSegmentedControl.textColor = [UIColor whiteColor];
        mVerticalSegmentedControl.selectedTextColor = UI_COLOR_FROM_RGB(0x34495e);
        mVerticalSegmentedControl.selectionIndicatorColor = UI_COLOR_FROM_RGB(0x34495e);
        float segmentedControlW = CGRectGetWidth(self.bounds) * 3.0 / 4.0;
        float segmentedControlH = segmentedControlW * 4.0 / 3.0;
        mVerticalSegmentedControl.frame = CGRectMake(0, 0, segmentedControlW, segmentedControlH);
        mVerticalSegmentedControl.center = self.center;
        [self addSubview:mVerticalSegmentedControl];
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    }
    return self;
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
    [UIView animateWithDuration:0.4
                     animations:^{
                         self.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         self.hidden = YES;
                     }];
    }
}

@end
