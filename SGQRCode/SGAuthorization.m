//
//  SGAuthorization.h
//  SGQRCodeExample
//
//  Created by kingsic on 2021/7/5.
//  Copyright © 2021年 kingsic. All rights reserved.
//

#import "SGAuthorization.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

@implementation SGAuthorization

/** 类方法创建 */
+ (instancetype)authorization {
    return [[self alloc] init];
}

/** 相机授权回调方法 */
- (void)AVAuthorizationBlock:(SGAVAuthorizationBlock)block {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
            // 授权状态未确定
        case AVAuthorizationStatusNotDetermined: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (block) {
                            block(self, SGAuthorizationStatusSuccess);
                        }
                    });
                    if (self.openLog) {
                        NSLog(@"用户第一次允许访问相机权限");
                    }
                } else {
                    if (self.openLog) {
                        NSLog(@"用户第一次拒绝访问相机权限");
                    }
                }
            }];
            break;
        }
            // 已授权
        case AVAuthorizationStatusAuthorized: {
            if (block) {
                block(self, SGAuthorizationStatusSuccess);
            }
            if (self.openLog) {
                NSLog(@"用户已允许访问相机权限");
            }
            break;
        }
            // 已拒绝
        case AVAuthorizationStatusDenied: {
            if (block) {
                block(self, SGAuthorizationStatusFail);
            }
            if (self.openLog) {
                NSLog(@"用户已拒绝访问相机权限");
            }
            break;
        }
            // 受限制
        case AVAuthorizationStatusRestricted: {
            if (block) {
                block(self, SGAuthorizationStatusUnknown);
            }
            if (self.openLog) {
                NSLog(@"系统原因, 无法访问");
            }
            break;
        }
        
    default:
        break;
    }
    return;
}

/** 相册授权回调方法 */
- (void)PHAuthorizationBlock:(SGPHAuthorizationBlock)block {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (block) {
                        block(self, SGAuthorizationStatusSuccess);
                    }
                });
                if (self.openLog == YES) {
                    NSLog(@"用户第一次同意访问相册权限");
                }
            } else {
                if (self.openLog == YES) {
                    NSLog(@"用户第一次拒绝访问相册权限");
                }
            }
        }];
    } else if (status == PHAuthorizationStatusAuthorized) {
        if (block) {
            block(self, SGAuthorizationStatusSuccess);
        }
        if (self.openLog == YES) {
            NSLog(@"用户已允许访问相册权限");
        }
    } else if (status == PHAuthorizationStatusDenied) {
        if (block) {
            block(self, SGAuthorizationStatusFail);
        }
        if (self.openLog) {
            NSLog(@"用户已拒绝访问相册权限");
        }
    } else if (status == PHAuthorizationStatusRestricted) {
        if (block) {
            block(self, SGAuthorizationStatusUnknown);
        }
        if (self.openLog) {
            NSLog(@"系统原因, 无法访问");
        }
    }
}


@end
