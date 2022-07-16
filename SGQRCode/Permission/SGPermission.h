//
//  SGPermission.h
//  SGQRCodeExample
//
//  Created by kingsic on 2022/7/8.
//  Copyright © 2022 kingsic. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SGPermission;

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

NS_ASSUME_NONNULL_BEGIN

typedef void(^SGPermissionBlock)(SGPermission *permission, SGPermissionStatus status);

@interface SGPermission : NSObject
/// 对象方法获取权限状态
///
/// @param type        权限类型
/// @param block       权限状态回调
- (void)initWithType:(SGPermissionType)type completion:(SGPermissionBlock)block;

/// 类方法获取权限状态
///
/// @param type        权限类型
/// @param block       权限状态回调
+ (void)permissionWithType:(SGPermissionType)type completion:(SGPermissionBlock)block;

/// 权限状态为：SGPermissionStatusNotDetermined时，需请求授权
- (void)request:(void (^)(BOOL granted))handler;

@end

NS_ASSUME_NONNULL_END
