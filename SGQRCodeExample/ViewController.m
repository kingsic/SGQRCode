//
//  ViewController.m
//  SGQRCodeExample
//
//  Created by Sorgle on 16/8/25.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "ViewController.h"
#import "SGGenerateQRCodeVC.h"
#import "SGScanningQRCodeVC.h"
#import <AVFoundation/AVFoundation.h>
#import "SGAlertView.h"
#import <Photos/Photos.h> 

@interface ViewController ()

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

- (IBAction)generateQRCode:(id)sender {
    SGGenerateQRCodeVC *VC = [[SGGenerateQRCodeVC alloc] init];
    
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)scanningQRCode:(id)sender {
    // 1、 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        // 判断授权状态
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusRestricted) { // 因为家长控制, 导致应用无法方法相册(跟用户的选择没有关系)
            NSLog(@"因为系统原因, 无法访问相册");
        } else if (status == PHAuthorizationStatusDenied) { // 用户拒绝当前应用访问相册
            SGAlertView *alertView = [SGAlertView alertViewWithTitle:@"⚠️ 警告" delegate:nil contentTitle:@"请去-> [设置 - 隐私 - 照片 - SGQRCodeExample] 打开访问开关" alertViewBottomViewType:(SGAlertViewBottomViewTypeOne)];
            [alertView show];
        } else if (status == PHAuthorizationStatusAuthorized) { // 用户允许当前应用访问相册
            SGScanningQRCodeVC *scanningQRCodeVC = [[SGScanningQRCodeVC alloc] init];
            [self.navigationController pushViewController:scanningQRCodeVC animated:YES];
        } else if (status == PHAuthorizationStatusNotDetermined) { // 用户还没有做出选择
            // 弹框请求用户授权
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) { // 用户点击了好

                }
            }];
        }

    } else {
        
        SGAlertView *alertView = [SGAlertView alertViewWithTitle:@"⚠️ 警告" delegate:nil contentTitle:@"未检测到您的摄像头, 请在真机上测试" alertViewBottomViewType:(SGAlertViewBottomViewTypeOne)];
        [alertView show];
        
//        // 1、初始化UIAlertController
//        UIAlertController *aC = [UIAlertController alertControllerWithTitle:@"⚠️ 警告" message:@"未检测到您的摄像头, 请在真机上测试" preferredStyle:UIAlertControllerStyleAlert];
//        
//        // 2.设置UIAlertAction样式
//        UIAlertAction *sureAc = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//            
//        }];
//        
//        [aC addAction:sureAc];
//        // 3.显示alertController:presentViewController
//        [self presentViewController:aC animated:YES completion:nil];
    }
}


@end
