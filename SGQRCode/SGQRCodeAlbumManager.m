//
//  如遇到问题或有更好方案，请通过以下方式进行联系
//      QQ：1357127436
//      Email：kingsic@126.com
//      GitHub：https://github.com/kingsic/SGQRCode.git
//
//  SGQRCodeAlbumManager.m
//  SGQRCodeExample
//
//  Created by kingsic on 2017/6/27.
//  Copyright © 2017年 kingsic. All rights reserved.
//

#import "SGQRCodeAlbumManager.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "UIImage+ImageSize.h"

#ifdef DEBUG
#define SGQRCodeLog(...) NSLog(__VA_ARGS__)
#else
#define SGQRCodeLog(...)
#endif

@interface SGQRCodeAlbumManager () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) UIViewController *currentVC;
@property (nonatomic, strong) NSString *detectorString;
@end

@implementation SGQRCodeAlbumManager

+ (instancetype)sharedManager {
    static SGQRCodeAlbumManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SGQRCodeAlbumManager alloc] init];
    });
    return manager;
}

- (void)initialization {
    _isOpenLog = YES;
}

- (void)readQRCodeFromAlbumWithCurrentController:(UIViewController *)currentController {
    [self initialization];
    self.currentVC = currentController;
    
    if (currentController == nil) {
        NSException *excp = [NSException exceptionWithName:@"SGQRCode" reason:@"readQRCodeFromAlbumWithCurrentController: 方法中的 currentController 参数不能为空" userInfo:nil];
        [excp raise];
    }
    
    // 1、 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        // 判断授权状态
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusNotDetermined) { // 用户还没有做出选择
            // 弹框请求用户授权
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) { // 用户第一次同意了访问相册权限
                    self.isPHAuthorization = YES;
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self enterImagePickerController];
                    });
                    if (self.isOpenLog) {
                        SGQRCodeLog(@"用户第一次同意了访问相册权限 - - %@", [NSThread currentThread]);
                    }
                } else { // 用户第一次拒绝了访问相机权限
                    if (self.isOpenLog) {
                        SGQRCodeLog(@"用户第一次拒绝了访问相机权限 - - %@", [NSThread currentThread]);
                    }
                }
            }];
            
        } else if (status == PHAuthorizationStatusAuthorized) { // 用户允许当前应用访问相册
            self.isPHAuthorization = YES;
            if (self.isOpenLog) {
                SGQRCodeLog(@"访问相机权限 - - %@", [NSThread currentThread]);
            }
            [self enterImagePickerController];
        } else if (status == PHAuthorizationStatusDenied) { // 用户拒绝当前应用访问相册
            [self enterImagePickerController];
        } else if (status == PHAuthorizationStatusRestricted) {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"由于系统原因, 无法访问相册" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertC addAction:alertA];
            [self.currentVC presentViewController:alertC animated:YES completion:nil];
        }
    }
}

// 进入 UIImagePickerController
- (void)enterImagePickerController {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [self.currentVC presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - - - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.currentVC dismissViewControllerAnimated:YES completion:nil];
    if (self.delegate && [self.delegate respondsToSelector:@selector(QRCodeAlbumManagerDidCancelWithImagePickerController:)]) {
        [self.delegate QRCodeAlbumManagerDidCancelWithImagePickerController:self];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // 对选取照片的处理，如果选取的图片尺寸过大，则压缩选取图片，否则不作处理
    UIImage *image = [UIImage imageSizeWithScreenImage:info[UIImagePickerControllerOriginalImage]];
    // CIDetector(CIDetector可用于人脸识别)进行图片解析，从而使我们可以便捷的从相册中获取到二维码
    // 声明一个 CIDetector，并设定识别类型 CIDetectorTypeQRCode
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
    
    // 取得识别结果
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    
    if (features.count == 0) {
        if (self.isOpenLog) {
            SGQRCodeLog(@"暂未识别出扫描的二维码 - - %@", features);
        }
        [self.currentVC dismissViewControllerAnimated:YES completion:nil];
        return;
        
    } else {
        for (int index = 0; index < [features count]; index ++) {
            CIQRCodeFeature *feature = [features objectAtIndex:index];
            NSString *resultStr = feature.messageString;
            if (self.isOpenLog) {
                SGQRCodeLog(@"相册中读取二维码数据信息 - - %@", resultStr);
            }
            self.detectorString = resultStr;
        }
        [self.currentVC dismissViewControllerAnimated:YES completion:^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(QRCodeAlbumManager:didFinishPickingMediaWithResult:)]) {
                [self.delegate QRCodeAlbumManager:self didFinishPickingMediaWithResult:self.detectorString];
            }
        }];
    }
}


#pragma mark - - - set
- (void)setIsOpenLog:(BOOL)isOpenLog {
    _isOpenLog = isOpenLog;
}


@end

