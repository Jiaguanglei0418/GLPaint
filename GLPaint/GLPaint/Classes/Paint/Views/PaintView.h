//
//  PaintView.h
//  GLPaint
//
//  Created by jiaguanglei on 15/12/14.
//  Copyright © 2015年 roseonly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Line.h"

@interface PaintView : UIView{
    BOOL _isCleared;
}

// 设置线宽
@property (nonatomic, assign) CGFloat lineWidth;

 /**  线条 ***/
@property (nonatomic, strong) Line *currentLine;

/**  颜色 ***/
@property (nonatomic, strong) UIColor *paintColor;

/**  线段数组 ***/
@property (nonatomic, strong) NSMutableArray *lines;

- (void)undo;
- (void)redo;
+ (instancetype)paintView;
// 获得截图
- (UIImage *)paintImage;
@end
