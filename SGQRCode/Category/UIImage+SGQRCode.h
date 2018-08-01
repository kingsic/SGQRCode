//
//  如遇到问题或有更好方案，请通过以下方式进行联系
//      QQ群：429899752
//      Email：kingsic@126.com
//      GitHub：https://github.com/kingsic/SGQRCode
//
//  UIImage+SGQRCode.h
//  SGQRCodeExample
//
//  Created by kingsic on 17/3/27.
//  Copyright © 2017年 kingsic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SGQRCode)
/** 若传入的图片尺寸(宽与高)小于屏幕尺寸直接返回否则返回一张等比缩放等于屏幕尺寸的图片 */
+ (UIImage *)SG_imageScaleWithImage:(UIImage *)image;

/** 根据bundle路径获取图片 */
+ (UIImage *)SG_imageNamed:(NSString *)name inBundle:(NSBundle *)bundle;

@end
