//
//  ViewController.m
//  SGQRCodeExample
//
//  Created by Sorgle on 16/8/25.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

// 欢迎来GitHub下载最新Demo
// GitHub地址:https://github.com/kingsic/SGQRCode.git
// 交流邮箱:kingsic@126.com


#import "ViewController.h"
#import "SGGenerateQRCodeVC.h"
#import "SGScanningQRCodeVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

- (IBAction)generateQRCode:(id)sender {
    SGGenerateQRCodeVC *VC = [[SGGenerateQRCodeVC alloc] init];
    
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)scanningQRCode:(id)sender {
    SGScanningQRCodeVC *VC = [[SGScanningQRCodeVC alloc] init];
    
    [self.navigationController pushViewController:VC animated:YES];
}

@end
