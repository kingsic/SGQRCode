//
//  SGQRCodeObtain.h
//  SGQRCodeExample
//
//  Created by kingsic on 2016/8/16.
//  Copyright © 2016年 kingsic. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SGQRCodeObtainConfigure, SGQRCodeObtain;

typedef void(^SGQRCodeObtainScanResultBlock)(SGQRCodeObtain *obtain, NSString *result);
typedef void(^SGQRCodeObtainScanBrightnessBlock)(SGQRCodeObtain *obtain, CGFloat brightness);
typedef void(^SGQRCodeObtainAlbumDidCancelImagePickerControllerBlock)(SGQRCodeObtain *obtain);
typedef void(^SGQRCodeObtainAlbumResultBlock)(SGQRCodeObtain *obtain, NSString *result);

@interface SGQRCodeObtain : NSObject
/** 类方法创建 */
+ (instancetype)QRCodeObtain;

#pragma mark - - 扫描二维码相关方法
/** 创建扫描二维码方法 */
- (void)establishQRCodeObtainScanWithController:(UIViewController *)controller configure:(SGQRCodeObtainConfigure *)configure;
/** 扫描二维码回调方法 */
- (void)setBlockWithQRCodeObtainScanResult:(SGQRCodeObtainScanResultBlock)block;
/** 扫描二维码光线强弱回调方法；调用之前配置属性 sampleBufferDelegate 必须为 YES */
- (void)setBlockWithQRCodeObtainScanBrightness:(SGQRCodeObtainScanBrightnessBlock)block;
/** 开启扫描回调方法 */
- (void)startRunningWithBefore:(void (^)(void))before completion:(void (^)(void))completion;
/** 停止扫描方法 */
- (void)stopRunning;

/** 播放音效文件 */
- (void)playSoundName:(NSString *)name;

#pragma mark - - 相册中读取二维码相关方法
/** 创建相册并获取相册授权方法 */
- (void)establishAuthorizationQRCodeObtainAlbumWithController:(UIViewController *)controller;
/** 判断相册访问权限是否授权 */
@property (nonatomic, assign) BOOL isPHAuthorization;
/** 图片选择控制器取消按钮的点击回调方法 */
- (void)setBlockWithQRCodeObtainAlbumDidCancelImagePickerController:(SGQRCodeObtainAlbumDidCancelImagePickerControllerBlock)block;
/** 相册中读取图片二维码信息回调方法 */
- (void)setBlockWithQRCodeObtainAlbumResult:(SGQRCodeObtainAlbumResultBlock)block;

#pragma mark - - 手电筒相关方法
/** 打开手电筒 */
- (void)openFlashlight;
/** 关闭手电筒 */
- (void)closeFlashlight;

@end
