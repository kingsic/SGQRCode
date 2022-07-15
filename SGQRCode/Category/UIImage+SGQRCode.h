//
//  UIImage+SGQRCode.h
//  SGQRCodeExample
//
//  Created by kingsic on 2022/7/9.
//  Copyright © 2022 kingsic. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (SGQRCode)
/// 加载资源包下的图片
///
/// @param name            资源包名
/// @param imageName       图片名称
+ (UIImage *)SG_imageWithResource:(NSString *)name imageName:(NSString *)imageName;

@end

NS_ASSUME_NONNULL_END
