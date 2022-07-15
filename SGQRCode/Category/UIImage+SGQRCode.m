//
//  UIImage+SGQRCode.m
//  SGQRCodeExample
//
//  Created by kingsic on 2022/7/9.
//  Copyright © 2022 kingsic. All rights reserved.
//

#import "UIImage+SGQRCode.h"

@implementation UIImage (SGQRCode)

+ (UIImage *)SG_imageWithResource:(NSString *)name imageName:(NSString *)imageName {
    /// 静态库 url 的获取
    NSURL *url = [[NSBundle mainBundle] URLForResource:name withExtension:@"bundle"];
    if (!url) {
        /// 动态库 url 的获取
        url = [[NSBundle bundleForClass:[self class]] URLForResource:name withExtension:@"bundle"];
    }
    NSBundle *bundle = [NSBundle bundleWithURL:url];
    
    UIImage *image = [UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:nil];
    
    return image;
}

@end
