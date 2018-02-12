//
//  如遇到问题或有更好方案，请通过以下方式进行联系
//      QQ群：429899752
//      Email：kingsic@126.com
//      GitHub：https://github.com/kingsic/SGQRCode
//
//  UIImage+SGImageSize.h
//  SGQRCodeExample
//
//  Created by kingsic on 17/3/27.
//  Copyright © 2017年 kingsic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SGImageSize)
/** 返回一张不超过屏幕尺寸的 image */
+ (UIImage *)SG_imageSizeWithScreenImage:(UIImage *)image;

@end
