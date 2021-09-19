//
//  SGScanCode.h
//  SGQRCodeExample
//
//  Created by kingsic on 2016/8/16.
//  Copyright © 2016年 kingsic. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SGScanCode;

typedef void(^SGScanCodeScanResultBlock)(SGScanCode *scanCode, NSString *result);
typedef void(^SGScanCodeScanBrightnessBlock)(SGScanCode *scanCode, CGFloat brightness);
typedef void(^SGScanCodeReadResultBlock)(SGScanCode *scanCode, NSString *result);
typedef void(^SGScanCodeAlbumDidCancelBlock)(SGScanCode *scanCode);

@interface SGScanCode : NSObject
/** 扫描区域，默认为整个视图，取值范围：0～1（以屏幕右上角为坐标原点）*/
@property (nonatomic, assign) CGRect scanArea;
/** 捕获外界光线亮度，默认为：NO */
@property (nonatomic, assign) BOOL brightness;
/** 判断相册访问权限是否授权 */
@property (nonatomic, assign) BOOL albumAuthorization;
/** 打印信息，默认为：NO */
@property (nonatomic, assign) BOOL openLog;

/** 类方法创建 */
+ (instancetype)scanCode;

/** 后置摄像头是否可用 */
- (BOOL)isCameraDeviceRearAvailable;

/** 扫码回调方法 */
- (void)scanWithController:(UIViewController *)controller resultBlock:(SGScanCodeScanResultBlock)blcok;
/** 扫码时，捕获外界光线强弱回调方法（brightness = YES 时，此回调方法才有效）*/
- (void)scanWithBrightnessBlock:(SGScanCodeScanBrightnessBlock)blcok;

/** 从相册中读码回调方法 */
- (void)readWithResultBlock:(SGScanCodeReadResultBlock)block;
/** 相册选择控制器取消按钮的点击回调方法 */
- (void)albumDidCancelBlock:(SGScanCodeAlbumDidCancelBlock)block;

/** 开启扫描回调 */
- (void)startRunningWithBefore:(void (^)(void))before completion:(void (^)(void))completion;
/** 停止扫描 */
- (void)stopRunning;

/** 播放音效文件 */
- (void)playSoundName:(NSString *)name;

/** 打开手电筒 */
- (void)turnOnFlashlight;
/** 关闭手电筒 */
- (void)turnOffFlashlight;

@end
