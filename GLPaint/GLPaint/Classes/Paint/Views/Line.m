//
//  Line.m
//  GLPaint
//
//  Created by jiaguanglei on 15/12/14.
//  Copyright © 2015年 roseonly. All rights reserved.
//

#import "Line.h"

@implementation Line
@synthesize begin, end, lineColor;


- (instancetype)init
{
    if (self = [super init]) {
        // 设置线的默认颜色 为黑色
        [self setLineColor:[UIColor blackColor]];
    }
    return self;
}

@end
