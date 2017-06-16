//
//  SGQRCodeManager.h
//  SGQRCodeExample
//
//  Created by apple on 2017/6/16.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@class SGQRCodeManager;

@protocol SGQRCodeManagerDelegate <NSObject>
/**
 *  delegate(扫描二维码获取数据的方法)
 *
 *  @param manager    SGQRCodeManager
 *  @param captureOutput    AVCaptureMetadataOutput（不知道什么用，暂时提供出去）
 *  @param metadataObjects    数据信息
 *  @param connection    AVCaptureConnection（不知道什么用，暂时提供出去）
 */
- (void)manager:(SGQRCodeManager *)manager captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection;

/**
 *  delegate(didFinishPickingMediaWithInfo)
 *
 *  @param manager    SGQRCodeManager
 *  @param picker    UIImagePickerController
 *  @param info    获取图片信息
 */
- (void)manager:(SGQRCodeManager *)manager imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info;

/**
 *  delegate(imagePickerControllerDidCancel)
 *
 *  @param manager    SGQRCodeManager
 *  @param picker    UIImagePickerController
 */
- (void)manager:(SGQRCodeManager *)manager imagePickerControllerDidCancel:(UIImagePickerController *)picker;

@end

@interface SGQRCodeManager : NSObject
/// 快速创建单利方法
+ (instancetype)sharedQRCodeManager;

/// 当前 SGQRCodeManager 所在的控制器；必须设置且在 SG_setupeSsionPreset:metadataObjectTypes 方法前设置
@property (nonatomic, strong) UIViewController *currentVC;
/// 相册访问权限是否打开
@property (nonatomic, assign) BOOL isPHAuthorization;
@property (nonatomic, weak) id<SGQRCodeManagerDelegate> delegate;
/**
 *  设置会话采集数据类型以及扫码支持的编码格式
 *
 *  @param sessionPreset    会话采集数据类型
 *  @param metadataObjectTypes    扫码支持的编码格式
 */
- (void)SG_setupSessionPreset:(NSString *)sessionPreset metadataObjectTypes:(NSArray *)metadataObjectTypes;
/// 从相册中读取二维码
- (void)SG_readQRCodeFromAlbum;
/// 开启会话对象扫描
- (void)SG_startRunning;
/// 停止会话对象扫描
- (void)SG_stopRunning;
/// 移除 videoPreviewLayer 对象
- (void)SG_videoPreviewLayerRemoveFromSuperlayer;
/// 播放音效文件
- (void)SG_palySoundName:(NSString *)name;

/// 生成一张普通的二维码
+ (UIImage *)SG_generateWithDefaultQRCodeData:(NSString *)data imageViewWidth:(CGFloat)imageViewWidth;
/// 生成一张带有logo的二维码（logoScaleToSuperView：相对于父视图的缩放比取值范围0-1；0，不显示，1，代表与父视图大小相同）
+ (UIImage *)SG_generateWithLogoQRCodeData:(NSString *)data logoImageName:(NSString *)logoImageName logoScaleToSuperView:(CGFloat)logoScaleToSuperView;
/// 生成一张彩色的二维码
+ (UIImage *)SG_generateWithColorQRCodeData:(NSString *)data backgroundColor:(CIColor *)backgroundColor mainColor:(CIColor *)mainColor;

@end

