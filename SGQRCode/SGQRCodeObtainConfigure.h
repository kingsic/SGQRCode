//
//  SGQRCodeObtainConfigure.h
//  SGQRCodeExample
//
//  Created by kingsic on 2018/7/29.
//  Copyright © 2018年 kingsic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface SGQRCodeObtainConfigure : NSObject
/** 类方法创建 */
+ (instancetype)QRCodeObtainConfigure;

/** 会话预置，默认为：AVCaptureSessionPreset1920x1080 */
@property (nonatomic, copy) NSString *sessionPreset;
/** 元对象类型，默认为：AVMetadataObjectTypeQRCode */
@property (nonatomic, strong) NSArray *metadataObjectTypes;
/** 扫描范围，默认整个视图（每一个取值 0 ～ 1，以屏幕右上角为坐标原点）*/
@property (nonatomic, assign) CGRect rectOfInterest;
/** 是否需要样本缓冲代理（光线强弱），默认为：NO */
@property (nonatomic, assign) BOOL sampleBufferDelegate;
/** 打印信息，默认为：NO */
@property (nonatomic, assign) BOOL openLog;

@end
