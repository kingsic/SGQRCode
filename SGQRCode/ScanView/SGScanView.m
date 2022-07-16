//
//  SGScanView.m
//  SGQRCodeExample
//
//  Created by kingsic on 2017/8/23.
//  Copyright © 2017年 kingsic All rights reserved.
//

#import "SGScanView.h"
#import "SGScanViewConfigure.h"
#import "SGWeakProxy.h"
#import "SGQRCodeLog.h"

@interface SGScanView ()
@property (nonatomic, strong) SGScanViewConfigure *configure;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *scanlineImgView;
@property (nonatomic, strong) CADisplayLink *link;
@property (nonatomic, assign) BOOL isTop;
@property (nonatomic, assign) BOOL isSelected;
@end

@implementation SGScanView

- (void)dealloc {
    if ([SGQRCodeLog sharedQRCodeLog].log) {
        NSLog(@"SGScanView - - dealloc");
    }
}

- (instancetype)initWithFrame:(CGRect)frame configure:(SGScanViewConfigure *)configure {
    if (self = [super initWithFrame:frame]) {
        self.configure = configure;
        
        self.backgroundColor = [UIColor clearColor];

        [self initialization];
        [self addSubview:self.contentView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap_action)];
        tap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:tap];
    }
    return self;
}

+ (instancetype)scanViewWithFrame:(CGRect)frame configure:(SGScanViewConfigure *)configure {
    return [[SGScanView alloc] initWithFrame:frame configure:configure];
}

- (void)initialization {
    CGFloat w = 0.7 * self.frame.size.width;
    CGFloat h = w;
    CGFloat x = 0.5 * (self.frame.size.width - w);
    CGFloat y = 0.5 * (self.frame.size.height - h);
    _borderFrame = CGRectMake(x, y, w, h);
    _scanFrame = CGRectMake(x, y, w, h);
    
    self.isTop = YES;
}

- (UIView *)contentView {
    if (!_contentView) {
        CGFloat x = _scanFrame.origin.x;
        CGFloat y = _scanFrame.origin.y;
        CGFloat w = _scanFrame.size.width;
        CGFloat h = _scanFrame.size.height;
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.clipsToBounds = YES;
    }
    return _contentView;
}

- (UIImageView *)scanlineImgView {
    if (!_scanlineImgView) {
        _scanlineImgView = [[UIImageView alloc] init];
        
        /// 静态库 url 的获取
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"SGQRCode" withExtension:@"bundle"];
        if (!url) {
            /// 动态库 url 的获取
            url = [[NSBundle bundleForClass:[self class]] URLForResource:@"SGQRCode" withExtension:@"bundle"];
        }
        NSBundle *bundle = [NSBundle bundleWithURL:url];
        
        UIImage *image = [UIImage imageNamed:self.configure.scanline inBundle:bundle compatibleWithTraitCollection:nil];
        if (!image) {
            image = [UIImage imageNamed:self.configure.scanline];
        }
        _scanlineImgView.image = image;
        
        if (image) {
            [self updateScanLineFrame];
        }
    }
    return _scanlineImgView;
}

- (void)tap_action {
    if (self.isSelected) {
        self.isSelected = NO;
    } else {
        self.isSelected = YES;
    }
    
    if (self.doubleTapBlock) {
        self.doubleTapBlock(self.isSelected);
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (self.configure.isShowBorder == NO) {
        return;
    }
    
    /// 边框 frame
    CGFloat borderW = self.borderFrame.size.width;
    CGFloat borderH = self.borderFrame.size.height;
    CGFloat borderX = self.borderFrame.origin.x;
    CGFloat borderY = self.borderFrame.origin.y;
    CGFloat borderLineW = self.configure.borderWidth;

    /// 空白区域设置
    [self.configure.color setFill];
    UIRectFill(rect);
    // 获取上下文，并设置混合模式 -> kCGBlendModeDestinationOut
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetBlendMode(context, kCGBlendModeDestinationOut);
    // 设置空白区
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:CGRectMake(borderX + 0.5 * borderLineW, borderY + 0.5 *borderLineW, borderW - borderLineW, borderH - borderLineW)];
    [bezierPath fill];
    // 执行混合模式
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    
    
    /// 边框设置
    UIBezierPath *borderPath = [UIBezierPath bezierPathWithRect:CGRectMake(borderX, borderY, borderW, borderH)];
    borderPath.lineCapStyle = kCGLineCapButt;
    borderPath.lineWidth = borderLineW;
    [self.configure.borderColor set];
    [borderPath stroke];
    
    
    CGFloat cornerLength = self.configure.cornerLength;
    CGFloat insideExcess = fabs(0.5 * (self.configure.cornerWidth - borderLineW));
    CGFloat outsideExcess = 0.5 * (borderLineW + self.configure.cornerWidth);
    
    /// 左上角小图标
    [self leftTop:borderX borderY:borderY cornerLength:cornerLength insideExcess:insideExcess outsideExcess:outsideExcess];
    
    /// 左下角小图标
    [self leftBottom:borderX borderY:borderY borderH:borderH cornerLength:cornerLength insideExcess:insideExcess outsideExcess:outsideExcess];
    
    /// 右上角小图标
    [self rightTop:borderX borderY:borderY borderW:borderW cornerLength:cornerLength insideExcess:insideExcess outsideExcess:outsideExcess];
    
    /// 右下角小图标
    [self rightBottom:borderX borderY:borderY borderW:borderW borderH:borderH cornerLength:cornerLength insideExcess:insideExcess outsideExcess:outsideExcess];
}

- (void)leftTop:(CGFloat)borderX borderY:(CGFloat)borderY cornerLength:(CGFloat)cornerLength insideExcess:(CGFloat) insideExcess outsideExcess:(CGFloat)outsideExcess {
    UIBezierPath *leftTopPath = [UIBezierPath bezierPath];
    leftTopPath.lineWidth = self.configure.cornerWidth;
    [self.configure.cornerColor set];

    if (self.configure.cornerLocation == SGCornerLoactionInside) {
        [leftTopPath moveToPoint:CGPointMake(borderX + insideExcess, borderY + cornerLength + insideExcess)];
        [leftTopPath addLineToPoint:CGPointMake(borderX + insideExcess, borderY + insideExcess)];
        [leftTopPath addLineToPoint:CGPointMake(borderX + cornerLength + insideExcess, borderY + insideExcess)];
    } else if (self.configure.cornerLocation == SGCornerLoactionOutside) {
        [leftTopPath moveToPoint:CGPointMake(borderX - outsideExcess, borderY + cornerLength - outsideExcess)];
        [leftTopPath addLineToPoint:CGPointMake(borderX - outsideExcess, borderY - outsideExcess)];
        [leftTopPath addLineToPoint:CGPointMake(borderX + cornerLength - outsideExcess, borderY - outsideExcess)];
    } else {
        [leftTopPath moveToPoint:CGPointMake(borderX, borderY + cornerLength)];
        [leftTopPath addLineToPoint:CGPointMake(borderX, borderY)];
        [leftTopPath addLineToPoint:CGPointMake(borderX + cornerLength, borderY)];
    }

    [leftTopPath stroke];
}

- (void)rightTop:(CGFloat)borderX borderY:(CGFloat)borderY borderW:(CGFloat)borderW cornerLength:(CGFloat)cornerLength insideExcess:(CGFloat) insideExcess outsideExcess:(CGFloat)outsideExcess {
    UIBezierPath *rightTopPath = [UIBezierPath bezierPath];
    rightTopPath.lineWidth = self.configure.cornerWidth;
    [self.configure.cornerColor set];
    
    if (self.configure.cornerLocation == SGCornerLoactionInside) {
        [rightTopPath moveToPoint:CGPointMake(borderX + borderW - cornerLength - insideExcess, borderY + insideExcess)];
        [rightTopPath addLineToPoint:CGPointMake(borderX + borderW - insideExcess, borderY + insideExcess)];
        [rightTopPath addLineToPoint:CGPointMake(borderX + borderW - insideExcess, borderY + cornerLength + insideExcess)];
    } else if (self.configure.cornerLocation == SGCornerLoactionOutside) {
        [rightTopPath moveToPoint:CGPointMake(borderX + borderW - cornerLength + outsideExcess, borderY - outsideExcess)];
        [rightTopPath addLineToPoint:CGPointMake(borderX + borderW + outsideExcess, borderY - outsideExcess)];
        [rightTopPath addLineToPoint:CGPointMake(borderX + borderW + outsideExcess, borderY + cornerLength - outsideExcess)];
    } else {
        [rightTopPath moveToPoint:CGPointMake(borderX + borderW - cornerLength, borderY)];
        [rightTopPath addLineToPoint:CGPointMake(borderX + borderW, borderY)];
        [rightTopPath addLineToPoint:CGPointMake(borderX + borderW, borderY + cornerLength)];
    }

    [rightTopPath stroke];
}

- (void)leftBottom:(CGFloat)borderX borderY:(CGFloat)borderY borderH:(CGFloat)borderH cornerLength:(CGFloat)cornerLength insideExcess:(CGFloat) insideExcess outsideExcess:(CGFloat)outsideExcess {
    UIBezierPath *leftBottomPath = [UIBezierPath bezierPath];
    leftBottomPath.lineWidth = self.configure.cornerWidth;
    [self.configure.cornerColor set];
    
    if (self.configure.cornerLocation == SGCornerLoactionInside) {
        [leftBottomPath moveToPoint:CGPointMake(borderX + cornerLength + insideExcess, borderY + borderH - insideExcess)];
        [leftBottomPath addLineToPoint:CGPointMake(borderX + insideExcess, borderY + borderH - insideExcess)];
        [leftBottomPath addLineToPoint:CGPointMake(borderX + insideExcess, borderY + borderH - cornerLength - insideExcess)];
    } else if (self.configure.cornerLocation == SGCornerLoactionOutside) {
        [leftBottomPath moveToPoint:CGPointMake(borderX + cornerLength - outsideExcess, borderY + borderH + outsideExcess)];
        [leftBottomPath addLineToPoint:CGPointMake(borderX - outsideExcess, borderY + borderH + outsideExcess)];
        [leftBottomPath addLineToPoint:CGPointMake(borderX - outsideExcess, borderY + borderH - cornerLength + outsideExcess)];
    } else {
        [leftBottomPath moveToPoint:CGPointMake(borderX + cornerLength, borderY + borderH)];
        [leftBottomPath addLineToPoint:CGPointMake(borderX, borderY + borderH)];
        [leftBottomPath addLineToPoint:CGPointMake(borderX, borderY + borderH - cornerLength)];
    }

    [leftBottomPath stroke];
}

- (void)rightBottom:(CGFloat)borderX borderY:(CGFloat)borderY borderW:(CGFloat)borderW borderH:(CGFloat)borderH cornerLength:(CGFloat)cornerLength insideExcess:(CGFloat) insideExcess outsideExcess:(CGFloat)outsideExcess {
    UIBezierPath *rightBottomPath = [UIBezierPath bezierPath];
    rightBottomPath.lineWidth = self.configure.cornerWidth;
    [self.configure.cornerColor set];
    
    if (self.configure.cornerLocation == SGCornerLoactionInside) {
        [rightBottomPath moveToPoint:CGPointMake(borderX + borderW - insideExcess, borderY + borderH - cornerLength - insideExcess)];
        [rightBottomPath addLineToPoint:CGPointMake(borderX + borderW - insideExcess, borderY + borderH - insideExcess)];
        [rightBottomPath addLineToPoint:CGPointMake(borderX + borderW - cornerLength - insideExcess, borderY + borderH - insideExcess)];
    } else if (self.configure.cornerLocation == SGCornerLoactionOutside) {
        [rightBottomPath moveToPoint:CGPointMake(borderX + borderW + outsideExcess, borderY + borderH - cornerLength + outsideExcess)];
        [rightBottomPath addLineToPoint:CGPointMake(borderX + borderW + outsideExcess, borderY + borderH + outsideExcess)];
        [rightBottomPath addLineToPoint:CGPointMake(borderX + borderW - cornerLength + outsideExcess, borderY + borderH + outsideExcess)];
    } else {
        [rightBottomPath moveToPoint:CGPointMake(borderX + borderW, borderY + borderH - cornerLength)];
        [rightBottomPath addLineToPoint:CGPointMake(borderX + borderW, borderY + borderH)];
        [rightBottomPath addLineToPoint:CGPointMake(borderX + borderW - cornerLength, borderY + borderH)];
    }

    [rightBottomPath stroke];
}

- (void)setBorderFrame:(CGRect)borderFrame {
    _borderFrame = borderFrame;
}

- (void)setScanFrame:(CGRect)scanFrame {
    _scanFrame = scanFrame;
    
    self.contentView.frame = scanFrame;
    
    if (self.scanlineImgView.image) {
        [self updateScanLineFrame];
    }
}
    
- (void)updateScanLineFrame {
    CGFloat w = _contentView.frame.size.width;
    CGFloat h = (w * self.scanlineImgView.image.size.height) / self.scanlineImgView.image.size.width;
    CGFloat x = 0;
    CGFloat y = self.configure.isFromTop ? -h : 0;
    self.scanlineImgView.frame = CGRectMake(x, y, w, h);
}

- (void)startScanning {
    if (self.scanlineImgView.image == nil) {
        return;
    }
    
    [self.contentView addSubview:self.scanlineImgView];
    
    if (self.link == nil) {
        self.link = [CADisplayLink displayLinkWithTarget:[SGWeakProxy weakProxyWithTarget:self] selector:@selector(updateUI)];
        [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)stopScanning {
    if (self.scanlineImgView.image == nil) {
        return;
    }
    
    // 此代码防止由于外界逻辑，可能会导致多次停止
    if (self.link == nil) {
        return;
    }
    
    [self.scanlineImgView removeFromSuperview];
    self.scanlineImgView = nil;
    
    [self.link invalidate];
    self.link = nil;
}

- (void)updateUI {
    CGRect frame = self.scanlineImgView.frame;
    CGFloat contentViewHeight = CGRectGetHeight(self.contentView.frame);
    
    CGFloat scanlineY = self.scanlineImgView.frame.origin.y + (self.configure.isFromTop ? 0 : self.scanlineImgView.frame.size.height);
    
    if (self.configure.autoreverses) {
        if (self.isTop) {
            frame.origin.y += self.configure.scanlineStep;
            self.scanlineImgView.frame = frame;
            
            if (contentViewHeight <= scanlineY) {
                self.isTop = NO;
            }
        } else {
            frame.origin.y -= self.configure.scanlineStep;
            self.scanlineImgView.frame = frame;
            
            if (scanlineY <= self.scanlineImgView.frame.size.height) {
                self.isTop = YES;
            }
        }
    } else {
        if (contentViewHeight <= scanlineY) {
            CGFloat scanlineH = self.scanlineImgView.frame.size.height;
            frame.origin.y = -scanlineH + (self.configure.isFromTop ? 0 : scanlineH);
            self.scanlineImgView.frame = frame;
        } else {
            frame.origin.y += self.configure.scanlineStep;
            self.scanlineImgView.frame = frame;
        }
    }
}

@end
