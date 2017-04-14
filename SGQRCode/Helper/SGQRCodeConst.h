//
//  SGQRCodeConst.h
//  SGQRCodeExample
//
//  Created by apple on 17/3/21.
//  Copyright © 2017年 Sorgle. All rights reserved.
//
//  - - - - - - - - - - - - - - 交流QQ：1357127436 - - - - - - - - - - - - - - - //
//
//  - - 如在使用中, 遇到什么问题或者有更好建议者, 请于 kingsic@126.com 邮箱联系 - - - - //
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//  - - GitHub下载地址 https://github.com/kingsic/SGQRCode.git - - - - - - - - - //
//
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //

#import <UIKit/UIKit.h>

#ifdef DEBUG
#define SGQRCodeLog(...) NSLog(__VA_ARGS__)
#else
#define SGQRCodeLog(...)
#endif

#define SGQRCodeNotificationCenter [NSNotificationCenter defaultCenter]
#define SGQRCodeScreenWidth [UIScreen mainScreen].bounds.size.width
#define SGQRCodeScreenHeight [UIScreen mainScreen].bounds.size.height

/** 二维码冲击波动画时间 */
UIKIT_EXTERN CGFloat const SGQRCodeScanningLineAnimation;

/** 扫描得到的二维码信息 */
UIKIT_EXTERN NSString *const SGQRCodeInformationFromeScanning;

/** 从相册里得到的二维码信息 */
UIKIT_EXTERN NSString *const SGQRCodeInformationFromeAibum;

