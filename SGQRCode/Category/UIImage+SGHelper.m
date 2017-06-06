//
//  UIImage+SGHelper.m
//  SGQRCodeExample
//
//  Created by apple on 17/3/27.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "UIImage+SGHelper.h"
#import "SGQRCodeConst.h"

@implementation UIImage (SGHelper)
/// 返回一张不超过屏幕尺寸的 image
+ (UIImage *)imageSizeWithScreenImage:(UIImage *)image {
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    CGFloat screenWidth = SGQRCodeScreenWidth;
    CGFloat screenHeight = SGQRCodeScreenHeight;
    
    // 如果读取的二维码照片宽和高小于屏幕尺寸，直接返回原图片
    if (imageWidth <= screenWidth && imageHeight <= screenHeight) {
        return image;
    }
    
    CGFloat scaleW = screenWidth/imageWidth;
    CGFloat scaleH = screenHeight/imageHeight;
    // 取比例较小的
    CGFloat minScale = fminf(scaleW, scaleH);
    // 缩放比向下取 -- 保留四位小数
    minScale = floor(minScale * 10000) / 10000;
    CGFloat scaleWidth = imageWidth * minScale;
    CGFloat scaleHeigth = imageHeight * minScale;
    // 因minScale是向下取 不会出现因小数点进位导致的大于设备尺寸，可四舍五入
    scaleWidth = roundf(scaleWidth);
    scaleHeigth = roundf(scaleHeigth);
    
    return [UIImage imageWithImage:image scaledToSize:CGSizeMake(scaleWidth, scaleHeigth)];
}
/// 返回一张处理后的图片
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end

