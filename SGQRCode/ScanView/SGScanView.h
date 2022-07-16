//
//  SGScanView.h
//  SGQRCodeExample
//
//  Created by kingsic on 2017/8/23.
//  Copyright © 2017年 kingsic All rights reserved.
//

#import <UIKit/UIKit.h>

@class SGScanViewConfigure;

typedef void(^SGScanViewDoubleTapBlock)(BOOL selected);

@interface SGScanView : UIView
/// 对象方法创建 SGScanView
///
/// @param frame           SGScanView 的 frame
/// @param configure       SGScanView 的配置类 SGScanViewConfigure
- (instancetype)initWithFrame:(CGRect)frame configure:(SGScanViewConfigure *)configure;

/// 类方法创建 SGScanView
///
/// @param frame           SGScanView 的 frame
/// @param configure       SGScanView 的配置类 SGScanViewConfigure
+ (instancetype)scanViewWithFrame:(CGRect)frame configure:(SGScanViewConfigure *)configure;

/// 辅助扫描边框区域的frame
/// 
/// 默认x为：0.5 * (self.frame.size.width - w)
/// 默认y为：0.5 * (self.frame.size.height - w)
/// 默认width和height为：0.7 * self.frame.size.width
@property (nonatomic, assign) CGRect borderFrame;

/// 扫描区域的frame
@property (nonatomic, assign) CGRect scanFrame;

/// 双击回调方法
@property (nonatomic, copy) SGScanViewDoubleTapBlock doubleTapBlock;


/// 开始扫描
- (void)startScanning;

/// 停止扫描
- (void)stopScanning;

@end
