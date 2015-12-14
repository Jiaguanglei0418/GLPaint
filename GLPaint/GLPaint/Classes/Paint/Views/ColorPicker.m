//
//  ColorPicker.m
//  GLPaint
//
//  Created by jiaguanglei on 15/12/14.
//  Copyright © 2015年 roseonly. All rights reserved.
//

#import "ColorPicker.h" // 颜色选择器
#import "UIView+Extension.h"

#define PAINTVIEW_PICKERNUMBER 7
#define PAINTVIEW_MARGIN 10


@interface ColorPicker (){
    NSArray *_colors;
    UIButton *_selectedPicker;
}

@end

@implementation ColorPicker
@synthesize delegate;

+ (instancetype)colorPickerWithFrame:(CGRect)frame
{
    return [[self alloc] initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0.8 alpha:.9];
        
        // initial code
        _colors = [NSArray arrayWithObjects:[UIColor blackColor], [UIColor darkGrayColor],[UIColor lightGrayColor], [UIColor whiteColor], [UIColor grayColor], [UIColor redColor], [UIColor greenColor], [UIColor blueColor], [UIColor cyanColor], [UIColor yellowColor], [UIColor magentaColor], [UIColor orangeColor], [UIColor purpleColor], [UIColor brownColor], nil];
        
        for (int i = 0; i < _colors.count; i++) {
            UIButton *picker = [UIButton buttonWithType:UIButtonTypeCustom];
            CGFloat width = (frame.size.width - PAINTVIEW_MARGIN * (PAINTVIEW_PICKERNUMBER + 1))/ PAINTVIEW_PICKERNUMBER;
            CGFloat height = width;
            picker.size = CGSizeMake(width, height);
            // 设置frame
            picker.x = PAINTVIEW_MARGIN + (width + PAINTVIEW_MARGIN) * (i % PAINTVIEW_PICKERNUMBER);
            picker.y = PAINTVIEW_MARGIN + (height + PAINTVIEW_MARGIN) * (i / PAINTVIEW_PICKERNUMBER);
            
            // 设置背景色
            picker.backgroundColor = _colors[i];
            
            // 监听点击
            [picker addTarget:self action:@selector(pickerMethod:) forControlEvents:UIControlEventTouchUpInside];
            
            if (i == 0) {
                [self pickerMethod:picker];
            }
            
            [self addSubview:picker];
        }
        
    }
    return self;
}

- (void)pickerMethod:(UIButton *)picker
{
    // 选中
    _selectedPicker.layer.borderWidth = 0.0f;
    [_selectedPicker setImage:nil forState:UIControlStateNormal];
    
    if ([delegate respondsToSelector:@selector(aColorPickerDidSelected:)]) {
        [delegate aColorPickerDidSelected:[picker backgroundColor]];
    }
    
//    _selectedPicker = picker;
    
//    LogRed(@"%@", [picker backgroundColor]);
    
    _selectedPicker = picker;
    
    [_selectedPicker setImage:[UIImage imageNamed:@"btn_nav_brand_selected"] forState:UIControlStateNormal];
    _selectedPicker.layer.borderWidth = 2.0f;
    _selectedPicker.layer.borderColor = [UIColor redColor].CGColor;
}
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    
//}

@end
