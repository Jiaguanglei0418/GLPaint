//
//  Line.h
//  GLPaint
//
//  Created by jiaguanglei on 15/12/14.
//  Copyright © 2015年 roseonly. All rights reserved.
//


@interface Line : NSObject

 /**  起始点 ***/
@property (nonatomic, assign) CGPoint begin;
 /**  终止点 ***/
@property (nonatomic, assign) CGPoint end;
 /**  线的颜色 ***/
@property (nonatomic, strong) UIColor *lineColor;

@end
