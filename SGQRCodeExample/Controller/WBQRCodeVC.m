//
//  WBQRCodeVC.m
//  SGQRCodeExample
//
//  Created by kingsic on 2018/2/8.
//  Copyright © 2018年 kingsic. All rights reserved.
//

#import "WBQRCodeVC.h"
#import "SGQRCode.h"
#import "ScanSuccessJumpVC.h"
#import "MBProgressHUD+SGQRCode.h"

@interface WBQRCodeVC () {
    SGScanCode *scanCode;
}
@property (nonatomic, strong) SGScanView *scanView;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, assign) BOOL stop;
@end

@implementation WBQRCodeVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_stop) {
        [scanCode startRunningWithBefore:nil completion:nil];
    }
}

- (void)dealloc {
    NSLog(@"WBQRCodeVC - dealloc");
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
    [self.scanView startScanning];
    [self.view addSubview:self.promptLabel];
}

- (void)setupQRCodeScan {
    __weak typeof(self) weakSelf = self;
    
<<<<<<< HEAD
    [obtain establishQRCodeObtainScanWithController:self configure:configure];
    [obtain startRunningWithBefore:^{
        [MBProgressHUD SG_showMBProgressHUDWithModifyStyleMessage:@"正在加载..." toView:weakSelf.view];
    } completion:^{
        [MBProgressHUD SG_hideHUDForView:weakSelf.view];
    }];
    [obtain setBlockWithQRCodeObtainScanResult:^(SGQRCodeObtain *obtain, NSArray *result) {
=======
    [scanCode scanWithController:self resultBlock:^(SGScanCode *scanCode, NSString *result) {
>>>>>>> 1e7c2b81ea8ac636fb0e3d48a2e8fb1e3eb35149
        if (result) {
            [scanCode stopRunning];
            weakSelf.stop = YES;
            [scanCode playSoundName:@"SGQRCode.bundle/scanEndSound.caf"];
            ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
<<<<<<< HEAD
            jumpVC.comeFromVC = ScanSuccessJumpComeFromWB;
            jumpVC.jump_URL = result[0];
=======
>>>>>>> 1e7c2b81ea8ac636fb0e3d48a2e8fb1e3eb35149
            [weakSelf.navigationController pushViewController:jumpVC animated:YES];
            
            if ([result hasPrefix:@"http"]) {
                jumpVC.comeFromVC = ScanSuccessJumpComeFromWB;
                jumpVC.jump_URL = result;
            } else {
                jumpVC.comeFromVC = ScanSuccessJumpComeFromWB;
                jumpVC.jump_bar_code = result;
            }
        }
    }];
    [scanCode startRunningWithBefore:^{
        [MBProgressHUD SG_showMBProgressHUDWithModifyStyleMessage:@"正在加载..." toView:weakSelf.view];
    } completion:^{
        [MBProgressHUD SG_hideHUDForView:weakSelf.view];
    }];
}

- (void)setupNavigationBar {
    self.navigationItem.title = @"扫一扫";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightBarButtonItenAction)];
}

- (void)rightBarButtonItenAction {
    __weak typeof(self) weakSelf = self;
    
    [scanCode readWithResultBlock:^(SGScanCode *scanCode, NSString *result) {
        if (result == nil) {
            NSLog(@"暂未识别出二维码");
        } else {
            if ([result hasPrefix:@"http"]) {
                ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
                jumpVC.comeFromVC = ScanSuccessJumpComeFromWB;
                jumpVC.jump_URL = result;
                [weakSelf.navigationController pushViewController:jumpVC animated:YES];

            } else {
                ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
                jumpVC.comeFromVC = ScanSuccessJumpComeFromWB;
                jumpVC.jump_bar_code = result;
                [weakSelf.navigationController pushViewController:jumpVC animated:YES];
            }
        }
    }];
}

- (SGScanView *)scanView {
    if (!_scanView) {
        _scanView = [[SGScanView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _scanView.scanLineName = @"SGQRCode.bundle/scanLineGrid";
        _scanView.scanStyle = ScanStyleGrid;
        _scanView.cornerLocation = CornerLoactionOutside;
        _scanView.cornerColor = [UIColor orangeColor];
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

@end
