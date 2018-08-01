//
//  如遇到问题或有更好方案，请通过以下方式进行联系
//      QQ群：429899752
//      Email：kingsic@126.com
//      GitHub：https://github.com/kingsic/SGQRCode
//
//  UIImage+SGQRCode.m
//  SGQRCodeExample
//
//  Created by kingsic on 17/3/27.
//  Copyright © 2017年 kingsic. All rights reserved.
//

#import "UIImage+SGQRCode.h"

@implementation UIImage (SGQRCode)

/**
 *  根据传入的 UIImage 返回一张不超过屏幕尺寸的 UIImage
 *
 *  @param image     传入的 UIImage
 *  @return newImage
 */
+ (UIImage *)SG_imageScaleWithImage:(UIImage *)image {
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if (imageWidth <= screenWidth && imageHeight <= screenHeight) {
        return image;
    }
    
    CGFloat widthScale = imageWidth / screenWidth;
    CGFloat heightScale = imageHeight / screenHeight;
    CGFloat scale = MAX(widthScale, heightScale);
    CGSize size = CGSizeMake(imageWidth / scale, imageHeight / scale);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)SG_imageNamed:(NSString *)name inBundle:(NSBundle *)bundle {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    return [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
#elif __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
    return [UIImage imageWithContentsOfFile:[bundle pathForResource:name ofType:@"png"]];
#else
    if ([UIImage respondsToSelector:@selector(imageNamed:inBundle:compatibleWithTraitCollection:)]) {
        return [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
    } else {
        return [UIImage imageWithContentsOfFile:[bundle pathForResource:name ofType:@"png"]];
    }
#endif
}


@end
