//
//  SGPermission.h
//  SGQRCodeExample
//
//  Created by kingsic on 2022/7/8.
//  Copyright © 2022 kingsic. All rights reserved.
//

#import "SGPermissionEnum.h"

@class SGPermission;

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
