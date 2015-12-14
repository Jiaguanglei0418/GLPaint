//
//  UIImage+Extention.m
//  loveonly
//
//  Created by jiaguanglei on 15/10/28.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "UIImage+Extention.h"

@implementation UIImage (Extention)
/**
 *  瓦片平铺图片
 */
+ (UIImage *)resizedImageWithName:(NSString *)name{
    UIImage *image = [self imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}

/**
 *  压缩图片到固定尺寸 
 */
+(UIImage *)imageWithImageSimple:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


/*** *** *** *** *** ***      切图      *** *** *** *** ***  *** *** *** *** ***/
#pragma mark - 切图
/**
 *  截屏
 **/
+ (UIImage *)captureWithView:(UIView *)view{
    // 1. 开启上下文
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);
    
    // 2. 将控制器View的layer 渲染到上下文
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    
    // 3. 取出图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 4. 结束上下文
    UIGraphicsEndImageContext();
    
    return newImage;
    
}


/**
 *  切圆形图
 **/
+ (UIImage *)clipARCImageWithBorderWidth:(CGFloat)borderW borderColor:(UIColor *)borderColor imageName:(NSString *)imageName
{
    
    // 0.加载原图
    UIImage *image = [UIImage imageNamed:imageName];
    
    
    // 1. 开启一个上下文
    //    CGFloat borderW = borderW;
    CGFloat imageW = image.size.width + borderW * 2;
    CGFloat imageH = image.size.height + borderW * 2;
    CGSize imageSize = CGSizeMake(imageW, imageH);
    UIGraphicsBeginImageContextWithOptions(imageSize , NO, 0.0);
    
    // 2. 取出上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 3.1 画边框(大圆)
    [borderColor set];
    CGFloat bigRadius = imageW * 0.5;
    CGFloat centerX = bigRadius;
    CGFloat centerY = bigRadius;
    CGContextAddArc(context, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    // 渲染
    CGContextFillPath(context);
    
    // 3.2.画小圆 (用来裁剪)
    //    [[UIColor greenColor] set];
    CGFloat smallRadius = bigRadius - borderW;
    CGContextAddArc(context, centerX, centerY, smallRadius, 0, M_PI * 2, 1);
    // 裁剪
    // 后面画的图像,才会受clip影响, 前面无影响
    CGContextClip(context);
    
    // 3.3 画图
    [image drawInRect:CGRectMake(borderW, borderW, imageW, imageH)];
    
    // 4. 取图
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 结束上下文
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 *  切方形图
 **/
+ (UIImage *)clipRectImageWithBorderWidth:(CGFloat)borderW borderColor:(UIColor *)borderColor imageName:(NSString *)imageName
{
    
    // 0.加载原图
    UIImage *image = [UIImage imageNamed:imageName];
    
    
    // 1. 开启一个上下文
    //    CGFloat borderW = borderW;
    CGFloat imageW = image.size.width + borderW * 2;
    CGFloat imageH = image.size.height + borderW * 2;
    CGSize imageSize = CGSizeMake(imageW, imageH);
    UIGraphicsBeginImageContextWithOptions(imageSize , NO, 0.0);
    
    // 2. 取出上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 3.1 画边框(大方框)
    [borderColor set];
    CGFloat imageX = borderW;
    CGFloat imageY = borderW;
    CGContextAddRect(context, CGRectMake(imageX, imageY, imageW, imageH));
    
    // 渲染
    CGContextFillPath(context);
    
    // 3.2.画小圆 (用来裁剪)
    //    [[UIColor greenColor] set];
    CGFloat smallX = imageX + borderW;
    CGFloat smallY = imageY + borderW;
    CGFloat smallW = imageW - borderW * 2;
    CGFloat smallH = imageH - borderW * 2;
    CGContextAddRect(context, CGRectMake(smallX, smallY, smallW, smallH));
    
    // 裁剪
    // 后面画的图像,才会受clip影响, 前面无影响
    CGContextClip(context);
    
    // 3.3 画图
    [image drawInRect:CGRectMake(borderW, borderW, imageW, imageH)];
    
    // 4. 取图
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 结束上下文
    UIGraphicsEndImageContext();
    return newImage;
}


/**
 *  打水印
 **/
+ (UIImage *)blockImageWithBg:(NSString *)bg logo:(NSString *)logo{
    UIImage *bgImage = [UIImage imageNamed:bg];
    
    /**
     *  上下文  -   基于位图(bitmap)
     *
     *  @所有的东西 都要绘制到一张新的图片上去
     */
    // 1.创建一个基于位图的上下文 - 开启一个上下文
    UIGraphicsBeginImageContextWithOptions(bgImage.size, YES, 0.0);
    
    // 2. 将背景图片 画到新的图片上
    [bgImage drawInRect:CGRectMake(0, 0, bgImage.size.width, bgImage.size.height)];
    
    // 3. 将水印画到新的图片上
    UIImage *waterImage = [UIImage imageNamed:logo];
    
    CGFloat scale = 0.4;
    CGFloat margin = 2;
    CGFloat waterW = waterImage.size.width * scale;
    CGFloat waterH = waterImage.size.height * scale;
    CGFloat waterX = bgImage.size.width - waterW - margin;
    CGFloat waterY = bgImage.size.height - waterH - margin;
    
    [waterImage drawInRect:CGRectMake(waterX, waterY, waterW, waterH)];
    
    // 4. 从上下文中取出 制作完成的UIImageView
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 5. 结束上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - todo
// *************************                    *************************
// *************************      TODO         *******************************
// *************************                    *************************

//- (void)downloadImageFromUrl:(NSString *)imageUrl placeHoder:(BOOL)placeHoder finish:(DownloadFinish)finish
//{
//    // 默认图片
//    if(placeHoder)
//    {
//        self.image = [UIImage imageNamed:@"pic_default"];
//    }
//    // 将图片网址分割处理
//    NSArray *array = [imageUrl componentsSeparatedByString:@"/"];
//    NSString *imageName = [array lastObject];
//    [SAFileManager createImageCachePath];
//    // 如果图片存在
//    NSString *imagePath = [NSString stringWithFormat:@"%@%@",[SAFileManager getImageCachePath],imageName];
//    if([SAFileManager fileIsExist:imagePath])
//    {
//        NSData *data = [[NSData alloc]initWithContentsOfFile:imagePath];
//        self.image = [[UIImage alloc]initWithData:data];
//        return;
//    }
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        // 转url及编码
//        NSURL *url = [NSURL URLWithString:[imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//        // 开始下载图片
//        NSData *responseData = [NSData dataWithContentsOfURL:url];
//
//        if (responseData)
//        {
//            // 将图片保存到指定路径中
//            if([responseData writeToFile:imagePath atomically:YES])
//            {
//                NSLog(@"写入图片成功");
//            }
//            UIImage *image = [[UIImage alloc]initWithData:responseData];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self.image = image;
//                finish();
//            });
//        }
//    });
//}


// Returns a copy of this image that is cropped to the given bounds.
// The bounds will be adjusted using CGRectIntegral.
// This method ignores the image's imageOrientation setting.
- (UIImage *)croppedImage:(CGRect)bounds {
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], bounds);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return croppedImage;
}

// Returns a rescaled copy of the image, taking into account its orientation
// The image will be scaled disproportionately if necessary to fit the bounds specified by the parameter
- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality {
    BOOL drawTransposed;
    
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            drawTransposed = YES;
            break;
            
        default:
            drawTransposed = NO;
    }
    
    return [self resizedImage:newSize
                    transform:[self transformForOrientation:newSize]
               drawTransposed:drawTransposed
         interpolationQuality:quality];
}

// Resizes the image according to the given content mode, taking into account the image's orientation
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality {
    CGFloat horizontalRatio = bounds.width / self.size.width;
    CGFloat verticalRatio = bounds.height / self.size.height;
    CGFloat ratio;
    
    switch (contentMode) {
        case UIViewContentModeScaleAspectFill:
            ratio = MAX(horizontalRatio, verticalRatio);
            break;
            
        case UIViewContentModeScaleAspectFit:
            ratio = MIN(horizontalRatio, verticalRatio);
            break;
            
        default:
            [NSException raise:NSInvalidArgumentException format:@"Unsupported content mode: %d", contentMode];
    }
    
    CGSize newSize = CGSizeMake(self.size.width * ratio, self.size.height * ratio);
    
    return [self resizedImage:newSize interpolationQuality:quality];
}

#pragma mark -
#pragma mark Private helper methods

// Returns a copy of the image that has been transformed using the given affine transform and scaled to the new size
// The new image's orientation will be UIImageOrientationUp, regardless of the current image's orientation
// If the new size is not integral, it will be rounded up
- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality {
    
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
    CGImageRef imageRef = self.CGImage;
    
    // Build a context that's the same dimensions as the new size
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                CGImageGetBitsPerComponent(imageRef),
                                                0,
                                                CGImageGetColorSpace(imageRef),
                                                CGImageGetBitmapInfo(imageRef));
    
    // Rotate and/or flip the image if required by its orientation
    CGContextConcatCTM(bitmap, transform);
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(bitmap, quality);
    
    // Draw into the context; this scales the image
    CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
    
    return newImage;
}

// Returns an affine transform that takes into account the image orientation when drawing a scaled image
- (CGAffineTransform)transformForOrientation:(CGSize)newSize {
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:           // EXIF = 3
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:           // EXIF = 6
        case UIImageOrientationLeftMirrored:   // EXIF = 5
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:          // EXIF = 8
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, 0, newSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:     // EXIF = 2
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:   // EXIF = 5
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, newSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    return transform;
}

@end
