//
//  SGScanView.h
//  SGQRCodeExample
//
//  Created by kingsic on 2017/8/23.
//  Copyright © 2017年 kingsic All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    /// 默认与边框线同中心点
    CornerLoactionDefault,
    /// 在边框线内部
    CornerLoactionInside,
    /// 在边框线外部
    CornerLoactionOutside
} CornerLoaction;

typedef enum : NSUInteger {
    /// 单线扫描样式
    ScanStyleDefault,
    /// 网格扫描样式
    ScanStyleGrid
} ScanStyle;

@interface SGScanView : UIView
/** 扫描样式，默认为：ScanStyleDefault */
@property (nonatomic, assign) ScanStyle scanStyle;
/** 扫描线名 */
@property (nonatomic, copy) NSString *scanLineName;
/** 边框颜色，默认为：白色 */
@property (nonatomic, strong) UIColor *borderColor;
/** 边角位置，默认为：CornerLoactionDefault */
@property (nonatomic, assign) CornerLoaction cornerLocation;
/** 边角颜色，默认为：red:85/255.0 green:183/255.0 blue:55/255.0 alpha:1.0 */
@property (nonatomic, strong) UIColor *cornerColor;
/** 边角宽度，默认为：2.f */
@property (nonatomic, assign) CGFloat cornerWidth;
/** 扫描区周边颜色的 alpha 值，默认为：0.2f */
@property (nonatomic, assign) CGFloat backgroundAlpha;
/** 扫描线动画时间，默认为：0.02s */
@property (nonatomic, assign) NSTimeInterval animationTimeInterval;

/** 扫描线开始扫描 */
- (void)startScanning;
/** 扫描线停止扫描 */
- (void)stopScanning;

@end
