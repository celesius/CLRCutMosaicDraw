//
//  ImageShowView.h
//  cutImageIOS
//
//  Created by vk on 15/8/31.
//  Copyright (c) 2015年 quxiu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DrawViewDelegate <NSObject>
-(void) setPointArray:(NSMutableArray *) pointArray andLineWide:(float) linaWidth;
@end

@interface DrawView: UIView

@property (nonatomic) CGFloat lineWidth;
@property (weak, nonatomic) UIColor *lineColor;
@property (weak, nonatomic) UIImage *backgroundImage;

@property (nonatomic) float lineScale;
@property (nonatomic, weak) id<DrawViewDelegate> delegate;
@property (nonatomic) BOOL deleteLine;

//-(void) setPhotoImage:(UIImage *)setImage;

-(void) redo;
-(void) undo;
-(void) resetDraw;

- (UIImage *)capture;

@end
