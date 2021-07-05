//
//  SGCreateCode.h
//  SGQRCodeExample
//
//  Created by kingsic on 2021/7/5.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SGCreateCode : NSObject
/** 生成二维码 */
+ (UIImage *)createQRCodeWithData:(NSString *)data size:(CGFloat)size;
/**
 *  生成二维码（自定义颜色）
 *
 *  @param data     二维码数据
 *  @param size     二维码大小
 *  @param color    二维码颜色
 *  @param backgroundColor    二维码背景颜色
 */
+ (UIImage *)createQRCodeWithData:(NSString *)data size:(CGFloat)size color:(UIColor *)color backgroundColor:(UIColor *)backgroundColor;
/**
 *  生成带 logo 的二维码（推荐使用）
 *
 *  @param data     二维码数据
 *  @param size     二维码大小
 *  @param logoImage    logo
 *  @param ratio        logo 相对二维码的比例（取值范围 0.0 ～ 0.5f）
 */
+ (UIImage *)createQRCodeWithData:(NSString *)data size:(CGFloat)size logoImage:(UIImage *)logoImage ratio:(CGFloat)ratio;
/**
 *  生成带 logo 的二维码（拓展）
 *
 *  @param data     二维码数据
 *  @param size     二维码大小
 *  @param logoImage    logo
 *  @param ratio        logo 相对二维码的比例（取值范围 0.0 ～ 0.5f）
 *  @param logoImageCornerRadius    logo 外边框圆角（取值范围 0.0 ～ 10.0f）
 *  @param logoImageBorderWidth     logo 外边框宽度（取值范围 0.0 ～ 10.0f）
 *  @param logoImageBorderColor     logo 外边框颜色
 */
+ (UIImage *)createQRCodeWithData:(NSString *)data size:(CGFloat)size logoImage:(UIImage *)logoImage ratio:(CGFloat)ratio logoImageCornerRadius:(CGFloat)logoImageCornerRadius logoImageBorderWidth:(CGFloat)logoImageBorderWidth logoImageBorderColor:(UIColor *)logoImageBorderColor;

@end

NS_ASSUME_NONNULL_END
