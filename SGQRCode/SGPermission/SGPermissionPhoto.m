//
//  SGPermissionPhoto.m
//  SGQRCodeExample
//
//  Created by kingsic on 2022/7/8.
//  Copyright © 2022 kingsic. All rights reserved.
//

#import "SGPermissionPhoto.h"
#import <Photos/Photos.h>

@implementation SGPermissionPhoto

+ (void)photo:(SGPermissionPhotoBlock)block {
    SGPermissionPhoto *photo = [[SGPermissionPhoto alloc] init];

    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusNotDetermined) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(photo, SGPermissionStatusNotDetermined);
            }
        });
    } else if (status == PHAuthorizationStatusAuthorized) {
        if (block) {
            block(photo, SGPermissionStatusAuthorized);
        }
    } else if (status == PHAuthorizationStatusDenied) {
        if (block) {
            block(photo, SGPermissionStatusDenied);
        }
    } else if (status == PHAuthorizationStatusRestricted) {
        if (block) {
            block(photo, SGPermissionStatusRestricted);
        }
    }
}

+ (void)request:(void (^)(BOOL granted))handler {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(YES);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(NO);
            });
        }
    }];
}

@end
