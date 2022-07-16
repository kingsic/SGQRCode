//
//  SGScanCode.h
//  SGQRCodeExample
//
//  Created by kingsic on 2016/8/16.
//  Copyright © 2016年 kingsic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGScanCodeDelegate.h"

@interface SGScanCode : NSObject
/// 类方法创建
+ (instancetype)scanCode;

/// 预览视图，必须设置（传外界控制器视图）
@property (nonatomic, strong) UIView *preview;

/// 扫描区域，以屏幕右上角为坐标原点，取值范围：0～1，默认为整个屏幕
@property (nonatomic, assign) CGRect rectOfInterest;

/// 扫描二维码数据代理
@property (nonatomic, weak) id<SGScanCodeDelegate> delegate;

/// 采样缓冲区代理
@property (nonatomic, weak) id<SGScanCodeSampleBufferDelegate> sampleBufferDelegate;


/// 读取图片中的二维码
///
/// @param image            图片
/// @param completion       回调方法，读取成功时，回调参数 result 等于二维码数据，否则等于 nil
- (void)readQRCode:(UIImage *)image completion:(void (^)(NSString *result))completion;

/// 设置视频缩放因子（捕获内容）
- (void)setVideoZoomFactor:(CGFloat)factor;

/// 检测后置摄像头是否可用
- (BOOL)checkCameraDeviceRearAvailable;

/// 开启扫描
- (void)startRunning;
/// 停止扫描
- (void)stopRunning;

/// 播放音效
- (void)playSoundEffect:(NSString *)name;

@end
