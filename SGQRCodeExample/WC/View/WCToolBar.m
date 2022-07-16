//
//  WCToolBar.m
//  SGQRCodeExample
//
//  Created by kingsic on 2022/7/9.
//  Copyright © 2022 kingsic. All rights reserved.
//

#import "WCToolBar.h"
#import "SGQRCode.h"

@interface WCToolBar ()
@property (nonatomic, strong) UIButton *torchBtn;
@property (nonatomic, strong) UILabel *torchLab;
@property (nonatomic, strong) UILabel *tipsLab;
@property (nonatomic, strong) UIImageView *qrcodeImgView;
@property (nonatomic, strong) UILabel *qrcodeLab;
@property (nonatomic, strong) UIImageView *albumImgView;
@property (nonatomic, strong) UILabel *albumLab;
@end

@implementation WCToolBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.torchBtn];
        
        [self addSubview:self.torchLab];
        
        [self addSubview:self.tipsLab];

        [self addSubview:self.qrcodeImgView];

        [self addSubview:self.qrcodeLab];
        
        [self addSubview:self.albumImgView];

        [self addSubview:self.albumLab];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat tBtn_w = 50;
    CGFloat tBtn_h = 70;
    CGFloat tBtn_x = 0.5 * (self.frame.size.width - tBtn_w);
    CGFloat tBtn_y = 0;
    self.torchBtn.frame = CGRectMake(tBtn_x, tBtn_y, tBtn_w, tBtn_h);
    
    CGFloat tLab_w = self.frame.size.width;
    CGFloat tLab_h = 12;
    CGFloat tLab_x = 0;
    CGFloat tLab_y = CGRectGetMaxY(self.torchBtn.frame) + 5;
    self.torchLab.frame = CGRectMake(tLab_x, tLab_y, tLab_w, tLab_h);
    
    CGFloat tipsLab_w = self.frame.size.width;
    CGFloat tipsLab_h = 15;
    CGFloat tipsLab_x = 0;
    CGFloat tipsLab_y = CGRectGetMaxY(self.torchLab.frame) + 10;
    self.tipsLab.frame = CGRectMake(tipsLab_x, tipsLab_y, tipsLab_w, tipsLab_h);
    
    CGFloat qrLab_w = 100;
    CGFloat qrLab_h = 12;
    CGFloat qrLab_x = 0;
    CGFloat qrLab_y = self.frame.size.height - qrLab_h - 20;
    self.qrcodeLab.frame = CGRectMake(qrLab_x, qrLab_y, qrLab_w, qrLab_h);
    
    CGFloat qrImgView_w = 50;
    CGFloat qrImgView_h = 50;
    CGFloat qrImgView_x = 0.5 * (qrLab_w - qrImgView_w);
    CGFloat qrImgView_y = CGRectGetMinY(self.qrcodeLab.frame) - qrImgView_h - 9;
    self.qrcodeImgView.frame = CGRectMake(qrImgView_x, qrImgView_y, qrImgView_w, qrImgView_h);
    
    CGFloat alLab_w = qrLab_w;
    CGFloat alLab_h = qrLab_h;
    CGFloat alLab_x = self.frame.size.width - alLab_w;
    CGFloat alLab_y = qrLab_y;
    self.albumLab.frame = CGRectMake(alLab_x, alLab_y, alLab_w, alLab_h);
    
    CGFloat alImgView_w = qrImgView_w;
    CGFloat alImgView_h = qrImgView_h;
    CGFloat alImgView_x = self.frame.size.width - alImgView_w - 0.5 * (qrLab_w - alImgView_w);
    CGFloat alImgView_y = qrImgView_y;
    self.albumImgView.frame = CGRectMake(alImgView_x, alImgView_y, alImgView_w, alImgView_h);
    
    self.qrcodeImgView.layer.cornerRadius = 0.5 * qrImgView_w;
    self.albumImgView.layer.cornerRadius = 0.5 * qrImgView_w;
}

- (UIButton *)torchBtn {
    if (!_torchBtn) {
        _torchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_torchBtn setBackgroundImage:[UIImage imageNamed:@"wc_scan_torch"] forState:(UIControlStateNormal)];
        [_torchBtn addTarget:self action:@selector(torchBtn_action:) forControlEvents:(UIControlEventTouchUpInside)];
        _torchBtn.hidden = YES;
    }
    return _torchBtn;
}

- (UILabel *)torchLab {
    if (!_torchLab) {
        _torchLab = [[UILabel alloc] init];
        _torchLab.text = @"轻触照亮";
        _torchLab.textAlignment = NSTextAlignmentCenter;
        _torchLab.textColor = [UIColor whiteColor];
        _torchLab.font = [UIFont systemFontOfSize:12];
        _torchLab.hidden = YES;
    }
    return _torchLab;
}

- (void)torchBtn_action:(UIButton *)btn {
    if (btn.selected) {
        btn.selected = NO;
        [btn setBackgroundImage:[UIImage imageNamed:@"wc_scan_torch"] forState:(UIControlStateNormal)];
        [SGTorch turnOffTorch];
        self.torchLab.text = @"轻触照亮";
    } else {
        btn.selected = YES;
        [btn setBackgroundImage:[UIImage imageNamed:@"wc_scan_torch_hl"] forState:(UIControlStateNormal)];
        self.torchLab.text = @"轻触关闭";
        [SGTorch turnOnTorch];
    }
}

- (UILabel *)tipsLab {
    if (!_tipsLab) {
        _tipsLab = [[UILabel alloc] init];
        _tipsLab.text = @"识别二维码";
        _tipsLab.textAlignment = NSTextAlignmentCenter;
        _tipsLab.textColor = [UIColor whiteColor];
        _tipsLab.font = [UIFont systemFontOfSize:17];
    }
    return _tipsLab;
}

- (UIImageView *)qrcodeImgView {
    if (!_qrcodeImgView) {
        _qrcodeImgView = [[UIImageView alloc] init];
        _qrcodeImgView.userInteractionEnabled = YES;
        _qrcodeImgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _qrcodeImgView.image = [UIImage imageNamed:@"wc_scan_mine_qrcode"];
    }
    return _qrcodeImgView;
}

- (UILabel *)qrcodeLab {
    if (!_qrcodeLab) {
        _qrcodeLab = [[UILabel alloc] init];
        _qrcodeLab.text = @"我的二维码";
        _qrcodeLab.textAlignment = NSTextAlignmentCenter;
        _qrcodeLab.textColor = [UIColor whiteColor];
        _qrcodeLab.font = [UIFont systemFontOfSize:13];
    }
    return _qrcodeLab;
}

- (UIImageView *)albumImgView {
    if (!_albumImgView) {
        _albumImgView = [[UIImageView alloc] init];
        _albumImgView.userInteractionEnabled = YES;
        _albumImgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _albumImgView.image = [UIImage imageNamed:@"wc_scan_album"];
    }
    return _albumImgView;
}

- (UILabel *)albumLab {
    if (!_albumLab) {
        _albumLab = [[UILabel alloc] init];
        _albumLab.text = @"相册";
        _albumLab.textAlignment = NSTextAlignmentCenter;
        _albumLab.textColor = [UIColor whiteColor];
        _albumLab.font = [UIFont systemFontOfSize:13];
    }
    return _albumLab;
}

- (void)showTorch {
    self.torchBtn.hidden = NO;
    self.torchLab.hidden = NO;
    self.tipsLab.hidden = YES;
}
- (void)dismissTorch {
    if (!self.torchBtn.isSelected) {
        self.torchBtn.hidden = YES;
        self.torchLab.hidden = YES;
        self.tipsLab.hidden = NO;
    }
}

- (void)addQRCodeTarget:(id)aTarget action:(SEL)aAction {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:aTarget action:aAction];
    [self.qrcodeImgView addGestureRecognizer:tap];
}
- (void)addAlbumTarget:(id)aTarget action:(SEL)aAction {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:aTarget action:aAction];
    [self.albumImgView addGestureRecognizer:tap];
}

@end
