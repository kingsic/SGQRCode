//
//  SGAuthorization.h
//  SGQRCodeExample
//
//  Created by kingsic on 2021/7/5.
//  Copyright © 2021年 kingsic. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SGAuthorization;

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    /// 授权成功（第一次授权允许及已授权）
    SGAuthorizationStatusSuccess,
    /// 授权失败（已拒绝）
    SGAuthorizationStatusFail,
    /// 未知（受限制）
    SGAuthorizationStatusUnknown,
} SGAuthorizationStatus;

typedef void(^SGAVAuthorizationBlock)(SGAuthorization *authorization, SGAuthorizationStatus status);
typedef void(^SGPHAuthorizationBlock)(SGAuthorization *authorization, SGAuthorizationStatus status);

@interface SGAuthorization : NSObject
/** 类方法创建 */
+ (instancetype)authorization;
/** 打印信息，默认为：NO */
@property (nonatomic, assign) BOOL openLog;

/** 相机授权回调方法 */
- (void)AVAuthorizationBlock:(SGAVAuthorizationBlock)block;
/** 相册授权回调方法 */
- (void)PHAuthorizationBlock:(SGPHAuthorizationBlock)block;

@end

NS_ASSUME_NONNULL_END
