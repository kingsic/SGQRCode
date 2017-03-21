//
//  QRCodeScanningVC.m
//  SGQRCodeExample
//
//  Created by apple on 17/3/21.
//  Copyright © 2017年 JP_lee. All rights reserved.
//

#import "QRCodeScanningVC.h"
#import "ScanSuccessJumpVC.h"

@interface QRCodeScanningVC ()

@end

@implementation QRCodeScanningVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 注册观察者
    [SGQRCodeNotificationCenter addObserver:self selector:@selector(SGQRCodeInformationFromeAibum:) name:SGQRCodeInformationFromeAibum object:nil];
    [SGQRCodeNotificationCenter addObserver:self selector:@selector(SGQRCodeInformationFromeScanning:) name:SGQRCodeInformationFromeScanning object:nil];
}

- (void)SGQRCodeInformationFromeAibum:(NSNotification *)noti {
    NSString *string = noti.object;

    ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
    jumpVC.jump_URL = string;
    [self.navigationController pushViewController:jumpVC animated:YES];
}

- (void)SGQRCodeInformationFromeScanning:(NSNotification *)noti {
    NSLog(@"noti - - %@", noti);
    NSString *string = noti.object;
    
    if ([string hasPrefix:@"http"]) {
        ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
        jumpVC.jump_URL = string;
        [self.navigationController pushViewController:jumpVC animated:YES];
        
    } else { // 扫描结果为条形码
        
        ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
        jumpVC.jump_bar_code = string;
        [self.navigationController pushViewController:jumpVC animated:YES];
    }
}

- (void)dealloc {
    NSLog(@"dealloc");
    
    [SGQRCodeNotificationCenter removeObserver:self];
}

@end
