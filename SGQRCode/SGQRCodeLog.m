//
//  SGQRCodeLog.m
//  SGQRCodeExample
//
//  Created by kingsic on 2022/7/15.
//  Copyright © 2022 kingsic. All rights reserved.
//

#import "SGQRCodeLog.h"

static SGQRCodeLog *singleton = nil;

@implementation SGQRCodeLog

+ (instancetype)sharedQRCodeLog {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (singleton == nil) {
            singleton = [[super allocWithZone:NULL] init];
        }
    });
    return singleton;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [[self class] sharedQRCodeLog];
}

- (id)copyWithZone:(NSZone *)zone {
    return [[self class] sharedQRCodeLog];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[self class] sharedQRCodeLog];
}

@end
