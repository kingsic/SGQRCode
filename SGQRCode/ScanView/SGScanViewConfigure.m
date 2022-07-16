//
//  SGScanViewConfigure.m
//  SGQRCodeExample
//
//  Created by kingsic on 2022/7/9.
//  Copyright © 2022 kingsic. All rights reserved.
//

#import "SGScanViewConfigure.h"

@implementation SGScanViewConfigure

- (instancetype)init {
    if (self = [super init]) {
        _isShowBorder = NO;
    }
    return self;
}

+ (instancetype)configure {
    return [[self alloc] init];
}

- (NSString *)scanline {
    if (!_scanline) {
        return @"scan_scanline_wc";
    }
    return _scanline;
}

- (CGFloat)scanlineStep {
    if (!_scanlineStep) {
        return 3.5;
    }
    return _scanlineStep;
}

- (UIColor *)color {
    if (!_color) {
        return [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return _color;
}

- (UIColor *)borderColor {
    if (!_borderColor) {
        return [UIColor whiteColor];
    }
    return _borderColor;
}

- (CGFloat)borderWidth {
    if (!_borderWidth) {
        return 0.2;
    }
    return _borderWidth;
}

- (SGCornerLoaction)cornerLocation {
    if (!_cornerLocation) {
        return SGCornerLoactionDefault;
    }
    return _cornerLocation;
}

- (UIColor *)cornerColor {
    if (!_cornerColor) {
        _cornerColor = [UIColor greenColor];
    }
    return _cornerColor;
}

- (CGFloat)cornerWidth {
    if (!_cornerWidth) {
        return 2.0;
    }
    return _cornerWidth;
}

- (CGFloat)cornerLength {
    if (!_cornerLength) {
        return 20.0;
    }
    return _cornerLength;
}

@end
