//
//  UIImage+Extention.h
//  loveonly
//
//  Created by jiaguanglei on 15/10/28.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DownloadFinish)(void);


@interface UIImage (Extention)

/**
 *  返回一张自由拉伸的图片
 */
+ (UIImage *)resizedImageWithName:(NSString *)name;


/**
 *  压缩图片
 */
+(UIImage *)imageWithImageSimple:(UIImage *)image scaledToSize:(CGSize)newSize;


/*** *** *** *** *** ***      切图      *** *** *** *** ***  *** *** *** *** ***/
#pragma mark - 切图

/**
 *  屏幕截图
 *
 *  @param view 需要截图的view
 *
 *  @return 新的图片
 */
+ (UIImage *)captureWithView:(UIView *)view;

/**
 *  - 切圆形图
 *
 *  @param borderW     边框宽度
 *  @param borderColor 边框颜色
 *  @param imageName   原始图片的名称
 *
 *  @return 新的图片
 */
+ (UIImage *)clipARCImageWithBorderWidth:(CGFloat)borderW borderColor:(UIColor *)borderColor imageName:(NSString *)imageName;

/**
 *  切方形图
 **/
+ (UIImage *)clipRectImageWithBorderWidth:(CGFloat)borderW borderColor:(UIColor *)borderColor imageName:(NSString *)imageName;

/**
 *  打水印
 *
 *  @param bg   背景图片
 *  @param logo 水印
 *
 *  @return 新的图片
 */
+ (UIImage *)blockImageWithBg:(NSString *)bg logo:(NSString *)logo;


// *************************                    *************************
// *************************      TODO         *******************************
// *************************                    *************************

// 下载网络图片有默认图片
//- (void)downloadImageFromUrl:(NSString *)imageUrl placeHoder:(BOOL)placeHoder finish:(DownloadFinish)finish;


- (UIImage *)croppedImage:(CGRect)bounds;
- (UIImage *)thumbnailImage:(NSInteger)thumbnailSize
          transparentBorder:(NSUInteger)borderSize
               cornerRadius:(NSUInteger)cornerRadius
       interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImage:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality;
- (CGAffineTransform)transformForOrientation:(CGSize)newSize;

@end
