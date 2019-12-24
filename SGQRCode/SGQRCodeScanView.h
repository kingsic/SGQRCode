//
//  SGQRCodeScanView.h
//  SGQRCodeExample
//
//  Created by kingsic on 2017/8/23.
//  Copyright © 2017年 kingsic All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    /// 默认与边框线同中心点
    CornerLocationDefault,
    /// 在边框线内部
    CornerLocationInside,
    /// 在边框线外部
    CornerLocationOutside
} CornerLocation;

typedef enum : NSUInteger {
    /// 单线扫描样式
    ScanAnimationStyleDefault,
    /// 网格扫描样式
    ScanAnimationStyleGrid
} ScanAnimationStyle;

@interface SGQRCodeScanView : UIView
/** 扫描样式，默认 ScanAnimationStyleDefault */
@property (nonatomic, assign) ScanAnimationStyle scanAnimationStyle;
/** 扫描线名 */
@property (nonatomic, copy) NSString *scanImageName;
/** 边框颜色，默认白色 */
@property (nonatomic, strong) UIColor *borderColor;
/** 边角位置，默认 CornerLocationDefault */
@property (nonatomic, assign) CornerLocation cornerLocation;
/** 边角颜色，默认微信颜色 */
@property (nonatomic, strong) UIColor *cornerColor;
/** 边角宽度，默认 2.f */
@property (nonatomic, assign) CGFloat cornerWidth;
/** 扫描区周边颜色的 alpha 值，默认 0.2f */
@property (nonatomic, assign) CGFloat backgroundAlpha;
/** 扫描线动画时间，默认 0.02s */
@property (nonatomic, assign) NSTimeInterval animationTimeInterval;

/** 添加定时器 */
- (void)addTimer;
/** 移除定时器 */
- (void)removeTimer;

@end
