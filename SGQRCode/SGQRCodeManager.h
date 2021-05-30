//
//  SGQRCodeObtain.h
//  SGQRCodeExample
//
//  Created by kingsic on 2016/8/16.
//  Copyright © 2016年 kingsic. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SGQRCodeManager;

typedef enum : NSUInteger {
    SGAuthorizationStatusSuccess,
    SGAuthorizationStatusFail,
    SGAuthorizationStatusUnknown,
} SGAuthorizationStatus;

typedef void(^SGQRCodeManagerScanResultBlock)(SGQRCodeManager *manager, NSString *result);
typedef void(^SGQRCodeManagerScanBrightnessBlock)(SGQRCodeManager *manager, CGFloat brightness);
typedef void(^SGQRCodeManagerReadResultBlock)(SGQRCodeManager *manager, NSString *result);
typedef void(^SGQRCodeManagerAlbumDidCancelBlock)(SGQRCodeManager *manager);
typedef void(^SGQRCodeManagerAuthorizationBlock)(SGQRCodeManager *manager, SGAuthorizationStatus authorizationStatus);

@interface SGQRCodeManager : NSObject
/** 扫描区域，默认为整个视图，取值范围：0～1（以屏幕右上角为坐标原点）*/
@property (nonatomic, assign) CGRect scanArea;
/** 捕获外界光线亮度，默认为：NO */
@property (nonatomic, assign) BOOL brightness;
/** 判断相册访问权限是否授权 */
@property (nonatomic, assign) BOOL albumAuthorization;
/** 打印信息，默认为：NO */
@property (nonatomic, assign) BOOL openLog;

/** 类方法创建 */
+ (instancetype)QRCodeManager;

/** 相机权限访问回调方法 */
- (void)authorizationStatusBlock:(SGQRCodeManagerAuthorizationBlock)block;
/** 后置摄像头是否可用 */
- (BOOL)isCameraDeviceRearAvailable;

/** 扫描二维码回调方法 */
- (void)scanWithController:(UIViewController *)controller resultBlock:(SGQRCodeManagerScanResultBlock)blcok;
/** 扫描二维码时，捕获外界光线强弱回调方法（brightness = YES 时，此回调方法才有效）*/
- (void)scanWithBrightnessBlock:(SGQRCodeManagerScanBrightnessBlock)blcok;

/** 从相册中读取二维码回调方法 */
- (void)readWithResultBlock:(SGQRCodeManagerReadResultBlock)block;
/** 相册选择控制器取消按钮的点击回调方法 */
- (void)albumDidCancelBlock:(SGQRCodeManagerAlbumDidCancelBlock)block;

/** 开启扫描回调 */
- (void)startRunningWithBefore:(void (^)(void))before completion:(void (^)(void))completion;
/** 停止扫描 */
- (void)stopRunning;

#pragma mark - - 生成二维码相关方法
/** 生成二维码 */
+ (UIImage *)generateQRCodeWithData:(NSString *)data size:(CGFloat)size;
/**
 *  生成二维码（自定义颜色）
 *
 *  @param data     二维码数据
 *  @param size     二维码大小
 *  @param color    二维码颜色
 *  @param backgroundColor    二维码背景颜色
 */
+ (UIImage *)generateQRCodeWithData:(NSString *)data size:(CGFloat)size color:(UIColor *)color backgroundColor:(UIColor *)backgroundColor;
/**
 *  生成带 logo 的二维码（推荐使用）
 *
 *  @param data     二维码数据
 *  @param size     二维码大小
 *  @param logoImage    logo
 *  @param ratio        logo 相对二维码的比例（取值范围 0.0 ～ 0.5f）
 */
+ (UIImage *)generateQRCodeWithData:(NSString *)data size:(CGFloat)size logoImage:(UIImage *)logoImage ratio:(CGFloat)ratio;
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
+ (UIImage *)generateQRCodeWithData:(NSString *)data size:(CGFloat)size logoImage:(UIImage *)logoImage ratio:(CGFloat)ratio logoImageCornerRadius:(CGFloat)logoImageCornerRadius logoImageBorderWidth:(CGFloat)logoImageBorderWidth logoImageBorderColor:(UIColor *)logoImageBorderColor;

/** 播放音效文件 */
- (void)playSoundName:(NSString *)name;

/** 打开手电筒 */
- (void)turnOnFlashlight;
/** 关闭手电筒 */
- (void)turnOffFlashlight;

@end
