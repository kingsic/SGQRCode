//
//  SGCreateCode.m
//  SGQRCodeExample
//
//  Created by kingsic on 2021/7/5.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import "SGCreateCode.h"

@implementation SGCreateCode

+ (UIImage *)createQRCodeWithData:(NSString *)data size:(CGFloat)size {
    return [self createQRCodeWithData:data size:size color:[UIColor blackColor] backgroundColor:[UIColor whiteColor]];
}

+ (UIImage *)createQRCodeWithData:(NSString *)data size:(CGFloat)size color:(UIColor *)color backgroundColor:(UIColor *)backgroundColor {
    NSData *string_data = [data dataUsingEncoding:NSUTF8StringEncoding];
    // 1、二维码滤镜
    CIFilter *fileter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [fileter setValue:string_data forKey:@"inputMessage"];
    [fileter setValue:@"H" forKey:@"inputCorrectionLevel"];
    CIImage *ciImage = fileter.outputImage;
    // 2、颜色滤镜
    CIFilter *color_filter = [CIFilter filterWithName:@"CIFalseColor"];
    [color_filter setValue:ciImage forKey:@"inputImage"];
    [color_filter setValue:[CIColor colorWithCGColor:color.CGColor] forKey:@"inputColor0"];
    [color_filter setValue:[CIColor colorWithCGColor:backgroundColor.CGColor] forKey:@"inputColor1"];
    // 3、生成处理
    CIImage *outImage = color_filter.outputImage;
    CGFloat scale = size / outImage.extent.size.width;
    outImage = [outImage imageByApplyingTransform:CGAffineTransformMakeScale(scale, scale)];
    return [UIImage imageWithCIImage:outImage];
}

+ (UIImage *)createQRCodeWithData:(NSString *)data size:(CGFloat)size logoImage:(UIImage *)logoImage ratio:(CGFloat)ratio {
    return [self createQRCodeWithData:data size:size logoImage:logoImage ratio:ratio logoImageCornerRadius:5 logoImageBorderWidth:5 logoImageBorderColor:[UIColor whiteColor]];
}

+ (UIImage *)createQRCodeWithData:(NSString *)data size:(CGFloat)size logoImage:(UIImage *)logoImage ratio:(CGFloat)ratio logoImageCornerRadius:(CGFloat)logoImageCornerRadius logoImageBorderWidth:(CGFloat)logoImageBorderWidth logoImageBorderColor:(UIColor *)logoImageBorderColor {
    UIImage *image = [self createQRCodeWithData:data size:size color:[UIColor blackColor] backgroundColor:[UIColor whiteColor]];
    if (logoImage == nil) return image;
    if (ratio < 0.0 || ratio > 0.5) {
        ratio = 0.25;
    }
    CGFloat logoImageW = ratio * size;
    CGFloat logoImageH = logoImageW;
    CGFloat logoImageX = 0.5 * (image.size.width - logoImageW);
    CGFloat logoImageY = 0.5 * (image.size.height - logoImageH);
    CGRect logoImageRect = CGRectMake(logoImageX, logoImageY, logoImageW, logoImageH);
    // 绘制logo
    UIGraphicsBeginImageContextWithOptions(image.size, false, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    if (logoImageCornerRadius < 0.0 || logoImageCornerRadius > 10) {
        logoImageCornerRadius = 5;
    }
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:logoImageRect cornerRadius:logoImageCornerRadius];
    if (logoImageBorderWidth < 0.0 || logoImageBorderWidth > 10) {
        logoImageBorderWidth = 5;
    }
    path.lineWidth = logoImageBorderWidth;
    [logoImageBorderColor setStroke];
    [path stroke];
    [path addClip];
    [logoImage drawInRect:logoImageRect];
    UIImage *QRCodeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return QRCodeImage;
}

@end
