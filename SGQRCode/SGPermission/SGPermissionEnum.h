//
//  SGPermissionEnum.h
//  SGQRCodeExample
//
//  Created by kingsic on 2022/7/8.
//  Copyright © 2022 kingsic. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    /// 相机
    SGPermissionTypeCamera,
    /// 相册
    SGPermissionTypePhoto,
} SGPermissionType;

typedef enum : NSUInteger {
    /// 未授权
    SGPermissionStatusNotDetermined,
    /// 已授权
    SGPermissionStatusAuthorized,
    /// 已拒绝
    SGPermissionStatusDenied,
    /// 受限制
    SGPermissionStatusRestricted,
} SGPermissionStatus;
