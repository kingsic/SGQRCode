//
//  SGPermissionPhoto.h
//  SGQRCodeExample
//
//  Created by kingsic on 2022/7/8.
//  Copyright © 2022 kingsic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGPermission.h"

@class SGPermissionPhoto;

NS_ASSUME_NONNULL_BEGIN

typedef void(^SGPermissionPhotoBlock)(SGPermissionPhoto *photos, SGPermissionStatus status);

@interface SGPermissionPhoto : NSObject
+ (void)photo:(SGPermissionPhotoBlock)block;
+ (void)request:(void (^)(BOOL granted))handler;
@end

NS_ASSUME_NONNULL_END
