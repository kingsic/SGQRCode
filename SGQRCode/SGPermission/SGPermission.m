//
//  SGPermission.m
//  SGQRCodeExample
//
//  Created by kingsic on 2022/7/8.
//  Copyright © 2022 kingsic. All rights reserved.
//

#import "SGPermission.h"
#import "SGPermissionCamera.h"
#import "SGPermissionPhoto.h"

@interface SGPermission ()
@property (nonatomic, assign) SGPermissionType type;
@end

@implementation SGPermission

- (void)initWithType:(SGPermissionType)type completion:(SGPermissionBlock)block {
    [SGPermission permissionWithType:type completion:block];
}

+ (void)permissionWithType:(SGPermissionType)type completion:(SGPermissionBlock)block {
    SGPermission *permission = [[SGPermission alloc] init];
    permission.type = type;
    
    if (type == SGPermissionTypeCamera) {
        [SGPermissionCamera camera:^(SGPermissionCamera * _Nonnull camera, SGPermissionStatus status) {
            if (block) {
                block(permission, status);
            }
        }];
    } else if (type == SGPermissionTypePhoto) {
        [SGPermissionPhoto photo:^(SGPermissionPhoto * _Nonnull photos, SGPermissionStatus status) {
            if (block) {
                block(permission, status);
            }
        }];
    }
}

- (void)request:(void (^)(BOOL))handler {
    if (self.type == SGPermissionTypeCamera) {
        [SGPermissionCamera request:handler];
    } else if (self.type == SGPermissionTypePhoto) {
        [SGPermissionPhoto request:handler];
    }
}

@end
