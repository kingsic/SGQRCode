//
//  CIImage+SGExtension.h
//  SGQRCode
//
//  Created by Sorgle on 16/8/25.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

// 欢迎来GitHub下载最新Demo
// GitHub地址:https://github.com/kingsic/SGQRCode.git
// 交流邮箱:kingsic@126.com


#import <CoreImage/CoreImage.h>
#import <UIKit/UIKit.h>

@interface CIImage (SGExtension)

/** 将CIImage转换成UIImage */
- (UIImage *)SG_createNonInterpolatedWithSize:(CGFloat)size;

@end
