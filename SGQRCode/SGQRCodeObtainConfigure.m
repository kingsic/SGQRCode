//
//  SGQRCodeObtainConfigure.m
//  SGQRCodeExample
//
//  Created by kingsic on 2018/7/29.
//  Copyright © 2018年 kingsic. All rights reserved.
//

#import "SGQRCodeObtainConfigure.h"

@implementation SGQRCodeObtainConfigure

+ (instancetype)QRCodeObtainConfigure {
    return [[self alloc] init];
}

- (NSString *)sessionPreset {
    if (!_sessionPreset) {
        _sessionPreset = AVCaptureSessionPreset1920x1080;
    }
    return _sessionPreset;
}

- (NSArray *)metadataObjectTypes {
    if (!_metadataObjectTypes) {
        _metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    }
    return _metadataObjectTypes;
}

@end
