//
//  ColorPicker.h
//  GLPaint
//
//  Created by jiaguanglei on 15/12/14.
//  Copyright © 2015年 roseonly. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ColorPickerDelegate <NSObject>

@optional
- (void)aColorPickerDidSelected:(UIColor *)color;

@end

@interface ColorPicker : UIView

+ (instancetype)colorPickerWithFrame:(CGRect)frame;


@property (nonatomic, assign) id<ColorPickerDelegate> delegate;
@end
