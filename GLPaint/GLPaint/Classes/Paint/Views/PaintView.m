//
//  PaintView.m
//  GLPaint
//
//  Created by jiaguanglei on 15/12/14.
//  Copyright © 2015年 roseonly. All rights reserved.
//

#import "PaintView.h"
#import "Common.h"
#import "UIImage+Extention.h"

@implementation PaintView{
    BOOL _isEraser;
    
}
//@synthesize currentLine, lines, paintColor;
- (NSMutableArray *)lines{
    if (!_lines) {
        _lines = [[NSMutableArray alloc] init];
    }
    return _lines;
}


+ (instancetype)paintView
{
    return [[self alloc] init];
}

/**
 *  初始化
 * 当此view被创建的时候这个方法自动调用
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
        // 初始化
//        self.lines = [NSMutableArray array];
        
        // 开启多点触摸
        self.multipleTouchEnabled = YES;
        
        // 设置默认颜色
        self.paintColor = [UIColor blackColor];
        self.lineWidth = 4.0f;
        
        // 开启第一相应项
        [self becomeFirstResponder];
        
    }
    return self;
}


/**
 *  画线
 * 每次当屏幕需要重新显示或者刷新的时候这个方法会被调用
 */
- (void)drawRect:(CGRect)rect
{
    // 获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 设置线宽
    CGContextSetLineWidth(context, self.lineWidth);
    // 设置线端点样式
    CGContextSetLineCap(context, kCGLineCapRound);
    // 设置线条颜色
//    [self.paintColor set];
    
    for (Line *line in self.lines) {
        [[line lineColor] set];
        // 起点, 终点
        CGContextMoveToPoint(context, line.begin.x, line.begin.y);
        CGContextAddLineToPoint(context, line.end.x, line.end.y);
//        LogGreen(@"%f -- %f", line.begin.x, line.begin.y);
        
        // 渲染
        CGContextStrokePath(context);
    }
}

- (void)undo
{
    if ([self.undoManager canUndo]) {
        [self.undoManager undo];
    }
}

- (void)redo
{
    if ([self.undoManager canRedo]) {
        [self.undoManager redo];
    }
}

#pragma mark - touchesBegan
// 当你的手指点击到屏幕的时候这个方法会被调用
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //
    [self.undoManager beginUndoGrouping];
    
    for (UITouch *touch in touches) {
        CGPoint loc = [touch locationInView:self];
        Line *newLine = [[Line alloc] init];
        [newLine setBegin:loc];
        [newLine setEnd:loc];
        [newLine setLineColor:self.paintColor];
        self.currentLine = newLine;
    }
}


#pragma mark - touchesMoved
// 当你的手指点击屏幕后开始在屏幕移动，它会被调用。随着手指的移动，相关的对象会秩序发送该消息
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        [self.currentLine setLineColor:self.paintColor];
        // 设置终点
        CGPoint loc = [touch locationInView:self];
        LogGreen(@"%@ ---- ", NSStringFromCGPoint(loc));
        [self.currentLine setEnd:loc];
        
        if(self.currentLine){
            
            if ([Common color:self.paintColor isEqualToColor:[UIColor clearColor] withTolerance:0.2]) {
                // 插除
                _isEraser = YES;
            }else{
                _isEraser = NO;
                
                [self addLine:self.currentLine];
            }
        }
        
        Line *newLine = [[Line alloc] init];
        [newLine setBegin:loc];
        [newLine setEnd:loc];
        [newLine setLineColor:self.paintColor];
        self.currentLine = newLine;
    }
    [self setNeedsDisplay];
}

/**
 *  添加线
 */
- (void)addLine:(Line *)line
{
    [[self.undoManager prepareWithInvocationTarget:self] removeLine:line];
    
    // 添加线条
    [self.lines addObject:line];
    
    [self setNeedsDisplay];
}


/**
 *  删除线
 */
- (void)removeLine:(Line *)line
{
    if([self.lines containsObject:line]){
        [[self.undoManager prepareWithInvocationTarget:self] addLine:line];
        [self.lines removeObject:line];
        [self setNeedsDisplay];
    }
}

- (void)removeLineByEndPoint:(CGPoint)point
{
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        Line *evaluatedLine = (Line *)evaluatedObject;
        return (evaluatedLine.end.x <= point.x-1 || evaluatedLine.end.x > point.x+1) &&
        (evaluatedLine.end.y <= point.y-1 || evaluatedLine.end.y > point.y+1);
    }];

    NSArray *result = [self.lines filteredArrayUsingPredicate:predicate];
    if (result && result.count > 0) {
        [self.lines removeObject:result[0]];
    }
}


#pragma mark - touchesEnded
//  当你的手指点击屏幕之后离开的时候，它会被调用
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endTouch:touches];
    [self.undoManager endUndoGrouping];
}

- (void)endTouch:(NSSet<UITouch *> *)touches
{
    if (!_isCleared) {
        [self setNeedsDisplay];
    }else{
        _isCleared = NO;
    }
}

#pragma mark - touchesCancelled
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endTouch:touches];
}


- (UIImage *)paintImage
{
    return [UIImage captureWithView:(UIView *)self];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)didMoveToWindow
{
    [self becomeFirstResponder];
}

@end
