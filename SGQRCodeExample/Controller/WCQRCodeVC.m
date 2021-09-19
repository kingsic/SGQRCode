//
//  WCQRCodeVC.m
//  SGQRCodeExample
//
//  Created by kingsic on 17/3/20.
//  Copyright © 2017年 kingsic. All rights reserved.
//

#import "WCQRCodeVC.h"
#import "SGQRCode.h"
#import "ScanSuccessJumpVC.h"
#import "MBProgressHUD+SGQRCode.h"

@interface WCQRCodeVC () {
    SGScanCode *scanCode;
}
@property (nonatomic, strong) SGScanView *scanView;
@property (nonatomic, strong) UIButton *flashlightBtn;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, assign) BOOL isSelectedFlashlightBtn;
@property (nonatomic, strong) UIView *bottomView;
@end

@implementation WCQRCodeVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    /// 二维码开启方法
    [scanCode startRunningWithBefore:nil completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.scanView startScanning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.scanView stopScanning];
    [self removeFlashlightBtn];
    [scanCode stopRunning];
}

- (void)dealloc {
    NSLog(@"WCQRCodeVC - dealloc");
    [self removeScanningView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor blackColor];
    
    scanCode = [SGScanCode scanCode];
    
    [self setupQRCodeScan];
    [self setupNavigationBar];
    [self.view addSubview:self.scanView];
    [self.view addSubview:self.promptLabel];
    /// 为了 UI 效果
    [self.view addSubview:self.bottomView];
}

- (void)setupQRCodeScan {
    BOOL isCameraDeviceRearAvailable = scanCode.isCameraDeviceRearAvailable;
    if (isCameraDeviceRearAvailable == NO) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    scanCode.openLog = YES;
    scanCode.brightness = YES;
    
<<<<<<< HEAD
    SGQRCodeObtainConfigure *configure = [SGQRCodeObtainConfigure QRCodeObtainConfigure];
    configure.sampleBufferDelegate = YES;
    [obtain establishQRCodeObtainScanWithController:self configure:configure];
    [obtain setBlockWithQRCodeObtainScanResult:^(SGQRCodeObtain *obtain, NSArray *result) {
=======
    [scanCode scanWithController:self resultBlock:^(SGScanCode *scanCode, NSString *result) {
>>>>>>> 1e7c2b81ea8ac636fb0e3d48a2e8fb1e3eb35149
        if (result) {
            [scanCode stopRunning];
            [scanCode playSoundName:@"SGQRCode.bundle/scanEndSound.caf"];
            ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
<<<<<<< HEAD
            jumpVC.comeFromVC = ScanSuccessJumpComeFromWC;
            jumpVC.jump_URL = result[0];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD SG_hideHUDForView:weakSelf.view];
                [weakSelf.navigationController pushViewController:jumpVC animated:YES];
            });
=======
            [weakSelf.navigationController pushViewController:jumpVC animated:YES];
            
            if ([result hasPrefix:@"http"]) {
                jumpVC.comeFromVC = ScanSuccessJumpComeFromWC;
                jumpVC.jump_URL = result;
            } else {
                jumpVC.comeFromVC = ScanSuccessJumpComeFromWC;
                jumpVC.jump_URL = result;
            }
>>>>>>> 1e7c2b81ea8ac636fb0e3d48a2e8fb1e3eb35149
        }
    }];
    
    [scanCode scanWithBrightnessBlock:^(SGScanCode *scanCode, CGFloat brightness) {
        if (brightness < - 1) {
            [weakSelf.view addSubview:weakSelf.flashlightBtn];
        } else {
            if (weakSelf.isSelectedFlashlightBtn == NO) {
                [weakSelf removeFlashlightBtn];
            }
        }
    }];
}

- (SGScanView *)scanView {
    if (!_scanView) {
        _scanView = [[SGScanView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.9 * self.view.frame.size.height)];
    }
    return _scanView;
}
- (void)removeScanningView {
    [self.scanView stopScanning];
    [self.scanView removeFromSuperview];
    self.scanView = nil;
}

- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.backgroundColor = [UIColor clearColor];
        CGFloat promptLabelX = 0;
        CGFloat promptLabelY = 0.73 * self.view.frame.size.height;
        CGFloat promptLabelW = self.view.frame.size.width;
        CGFloat promptLabelH = 25;
        _promptLabel.frame = CGRectMake(promptLabelX, promptLabelY, promptLabelW, promptLabelH);
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.font = [UIFont boldSystemFontOfSize:13.0];
        _promptLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        _promptLabel.text = @"将二维码/条码放入框内, 即可自动扫描";
    }
    return _promptLabel;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scanView.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(self.scanView.frame))];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

#pragma mark - - - 闪光灯按钮
- (UIButton *)flashlightBtn {
    if (!_flashlightBtn) {
        // 添加闪光灯按钮
        _flashlightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        CGFloat flashlightBtnW = 30;
        CGFloat flashlightBtnH = 30;
        CGFloat flashlightBtnX = 0.5 * (self.view.frame.size.width - flashlightBtnW);
        CGFloat flashlightBtnY = 0.55 * self.view.frame.size.height;
        _flashlightBtn.frame = CGRectMake(flashlightBtnX, flashlightBtnY, flashlightBtnW, flashlightBtnH);
        [_flashlightBtn setBackgroundImage:[UIImage imageNamed:@"SGQRCodeFlashlightOpenImage"] forState:(UIControlStateNormal)];
        [_flashlightBtn setBackgroundImage:[UIImage imageNamed:@"SGQRCodeFlashlightCloseImage"] forState:(UIControlStateSelected)];
        [_flashlightBtn addTarget:self action:@selector(flashlightBtn_action:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _flashlightBtn;
}

- (void)flashlightBtn_action:(UIButton *)button {
    if (button.selected == NO) {
        [scanCode turnOnFlashlight];
        self.isSelectedFlashlightBtn = YES;
        button.selected = YES;
    } else {
        [self removeFlashlightBtn];
    }
}

- (void)removeFlashlightBtn {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self->scanCode turnOffFlashlight];
        self.isSelectedFlashlightBtn = NO;
        self.flashlightBtn.selected = NO;
        [self.flashlightBtn removeFromSuperview];
    });
}

- (void)setupNavigationBar {
    self.navigationItem.title = @"扫一扫";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightBarButtonItenAction)];
}

- (void)rightBarButtonItenAction {
    __weak typeof(self) weakSelf = self;
    [scanCode readWithResultBlock:^(SGScanCode *scanCode, NSString *result) {
        [MBProgressHUD SG_showMBProgressHUDWithModifyStyleMessage:@"正在处理..." toView:weakSelf.view];
        if (result == nil) {
            NSLog(@"暂未识别出二维码");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD SG_hideHUDForView:weakSelf.view];
                [MBProgressHUD SG_showMBProgressHUDWithOnlyMessage:@"未发现二维码/条形码" delayTime:1.0];
            });
        } else {
            ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
            jumpVC.comeFromVC = ScanSuccessJumpComeFromWC;
            if ([result hasPrefix:@"http"]) {
                jumpVC.jump_URL = result;
            } else {
                jumpVC.jump_bar_code = result;
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD SG_hideHUDForView:weakSelf.view];
                [weakSelf.navigationController pushViewController:jumpVC animated:YES];
            });
        }
    }];
    
    if (scanCode.albumAuthorization == YES) {
        [self.scanView stopScanning];
    }
    [scanCode albumDidCancelBlock:^(SGScanCode *scanCode) {
        [weakSelf.scanView startScanning];
    }];
}

@end
