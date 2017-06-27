//
//  如遇到问题或有更好方案，请通过以下方式进行联系
//      QQ：1357127436
//      邮箱：kingsic@126.com
//  GitHub：(https://github.com/kingsic/SGQRCode.git）
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
 *  二维码扫描获取数据回调方法
 *
 *  @param QRCodeManager    SGQRCodeManager
 *  @param metadataObjects    扫描二维码数据信息
 */
- (void)QRCodeManager:(SGQRCodeManager *)QRCodeManager didOutputMetadataObjects:(NSArray *)metadataObjects;
/**
 *  图片选择控制器取消按钮的点击回调方法
 *
 *  @param QRCodeManager    SGQRCodeManager
 */
- (void)QRCodeManagerDidCancelWithImagePickerController:(SGQRCodeManager *)QRCodeManager;
/**
 *  图片选择控制器选取图片完成之后的回调方法
 *
 *  @param QRCodeManager    SGQRCodeManager
 *  @param result    获取的二维码数据
 */
- (void)QRCodeManager:(SGQRCodeManager *)QRCodeManager didFinishPickingMediaWithResult:(NSString *)result;

@end

@interface SGQRCodeManager : NSObject
/// 快速创建单利方法
+ (instancetype)sharedQRCodeManager;

/// 当前 SGQRCodeManager 所在的控制器；必须设置且在 SG_setupeSsionPreset:metadataObjectTypes 方法前设置
@property (nonatomic, strong) UIViewController *currentVC;
/// 判断相册访问权限是否授权
@property (nonatomic, assign) BOOL isPHAuthorization;
/// 是否开启 log 打印，默认为 YES
@property (nonatomic, assign) BOOL isOpenLog;
/// SGQRCodeManagerDelegate
@property (nonatomic, weak) id<SGQRCodeManagerDelegate> delegate;
/**
 *  创建扫描二维码会话对象以及会话采集数据类型和扫码支持的编码格式的设置
 *
 *  @param sessionPreset    会话采集数据类型
 *  @param metadataObjectTypes    扫码支持的编码格式
 */
- (void)SG_setupSessionPreset:(NSString *)sessionPreset metadataObjectTypes:(NSArray *)metadataObjectTypes;
/// 从相册中读取二维码方法
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

