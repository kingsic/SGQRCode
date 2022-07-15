//
//  SGQRCodeLog.h
//  SGQRCodeExample
//
//  Created by kingsic on 2022/7/15.
//  Copyright © 2022 kingsic. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SGQRCodeLog : NSObject
/// 单例创建 SGQRCodeLog
+ (instancetype)sharedQRCodeLog;

/// 是否需要打印日志信息，默认为：NO
///
/// SGScanCode 和 SGScanView 的 dealloc 方法打印，扫描和读取图片中的二维码信息打印
@property (nonatomic, assign) BOOL log;

@end

NS_ASSUME_NONNULL_END
