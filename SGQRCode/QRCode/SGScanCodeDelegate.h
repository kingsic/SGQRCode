//
//  SGScanCodeDelegate.h
//  SGQRCodeExample
//
//  Created by kingsic on 2022/7/8.
//  Copyright © 2022 kingsic. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SGScanCode;

@protocol SGScanCodeDelegate <NSObject>
/// 扫描二维码结果函数
///
/// @param scanCode     SGScanCode 对象
/// @param result       扫描二维码数据
- (void)scanCode:(SGScanCode *)scanCode result:(NSString *)result;

@end


@protocol SGScanCodeSampleBufferDelegate <NSObject>
/// 扫描时捕获外界光线强弱函数
///
/// @param scanCode     SGScanCode 对象
/// @param brightness   光线强弱值
- (void)scanCode:(SGScanCode *)scanCode brightness:(CGFloat)brightness;

@end

