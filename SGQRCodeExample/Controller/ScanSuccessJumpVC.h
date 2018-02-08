//
//  ScanSuccessJumpVC.h
//  SGQRCodeExample
//
//  Created by kingsic on 16/8/29.
//  Copyright © 2016年 kingsic. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ScanSuccessJumpComeFromWB,
    ScanSuccessJumpComeFromWC
} ScanSuccessJumpComeFrom;

@interface ScanSuccessJumpVC : UIViewController
/** 判断从哪个控制器 push 过来 */
@property (nonatomic, assign) ScanSuccessJumpComeFrom comeFromVC;
/** 接收扫描的二维码信息 */
@property (nonatomic, copy) NSString *jump_URL;
/** 接收扫描的条形码信息 */
@property (nonatomic, copy) NSString *jump_bar_code;

@end
