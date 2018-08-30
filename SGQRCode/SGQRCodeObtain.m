//
//  SGQRCodeObtain.m
//  SGQRCodeExample
//
//  Created by kingsic on 2016/8/16.
//  Copyright © 2016年 kingsic. All rights reserved.
//

#import "SGQRCodeObtain.h"
#import "SGQRCodeObtainConfigure.h"
#import <Photos/Photos.h>

@interface SGQRCodeObtain () <AVCaptureMetadataOutputObjectsDelegate, AVCaptureVideoDataOutputSampleBufferDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, weak) UIViewController *controller;
@property (nonatomic, strong) SGQRCodeObtainConfigure *configure;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, copy) SGQRCodeObtainScanResultBlock scanResultBlock;
@property (nonatomic, copy) SGQRCodeObtainScanBrightnessBlock scanBrightnessBlock;
@property (nonatomic, copy) SGQRCodeObtainAlbumDidCancelImagePickerControllerBlock albumDidCancelImagePickerControllerBlock;
@property (nonatomic, copy) SGQRCodeObtainAlbumResultBlock albumResultBlock;
@property (nonatomic, copy) NSString *detectorString;

@end

@implementation SGQRCodeObtain

+ (instancetype)QRCodeObtain {
    return [[self alloc] init];
}

- (void)dealloc {
    if (_configure.openLog == YES) {
        NSLog(@"SGQRCodeObtain - - dealloc");
    }
}

- (void)establishQRCodeObtainScanWithController:(UIViewController *)controller configure:(SGQRCodeObtainConfigure *)configure {
    if (controller == nil) {
        @throw [NSException exceptionWithName:@"SGQRCode" reason:@"SGQRCodeObtain 中 establishQRCodeObtainScanWithController:configuration:方法的 controller 参数不能为空" userInfo:nil];
    }
    if (configure == nil) {
        @throw [NSException exceptionWithName:@"SGQRCode" reason:@"SGQRCodeObtain 中 establishQRCodeObtainScanWithController:configure:方法的 configure 参数不能为空" userInfo:nil];
    }
    
    _controller = controller;
    _configure = configure;
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // 1、捕获设备输入流
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    // 2、捕获元数据输出流
    AVCaptureMetadataOutput *metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 设置扫描范围（每一个取值0～1，以屏幕右上角为坐标原点）
    // 注：微信二维码的扫描范围是整个屏幕，这里并没有做处理（可不用设置）
    if (configure.rectOfInterest.origin.x == 0 && configure.rectOfInterest.origin.y == 0 && configure.rectOfInterest.size.width == 0 && configure.rectOfInterest.size.height == 0) {
    } else {
        metadataOutput.rectOfInterest = configure.rectOfInterest;
    }

    // 3、设置会话采集率
    self.captureSession.sessionPreset = configure.sessionPreset;
    
    // 4(1)、添加捕获元数据输出流到会话对象
    [_captureSession addOutput:metadataOutput];
    // 4(2)、添加捕获输出流到会话对象；构成识了别光线强弱
    if (configure.sampleBufferDelegate == YES) {
        AVCaptureVideoDataOutput *videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
        [videoDataOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
        [_captureSession addOutput:videoDataOutput];
    }
    // 4(3)、添加捕获设备输入流到会话对象
    [_captureSession addInput:deviceInput];
    
    // 5、设置数据输出类型，需要将数据输出添加到会话后，才能指定元数据类型，否则会报错
    metadataOutput.metadataObjectTypes = configure.metadataObjectTypes;
    
    // 6、预览图层
    AVCaptureVideoPreviewLayer *videoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_captureSession];
    // 保持纵横比，填充层边界
    videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    videoPreviewLayer.frame = controller.view.frame;
    [controller.view.layer insertSublayer:videoPreviewLayer atIndex:0];
}

- (AVCaptureSession *)captureSession {
    if (!_captureSession) {
        _captureSession = [[AVCaptureSession alloc] init];
    }
    return _captureSession;
}

- (void)startRunningWithBefore:(void (^)(void))before completion:(void (^)(void))completion {
    if (before) {
        before();
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.captureSession startRunning];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
    });
}
- (void)stopRunning {
    [self.captureSession stopRunning];
}

#pragma mark - - AVCaptureMetadataOutputObjectsDelegate 的方法
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    NSString *resultString = nil;
    if (metadataObjects != nil && metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        resultString = [obj stringValue];
        if (_scanResultBlock) {
            _scanResultBlock(self, resultString);
        }
    }
}
#pragma mark - - AVCaptureVideoDataOutputSampleBufferDelegate 的方法
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL,sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary*)metadataDict];
    CFRelease(metadataDict);
    NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
    CGFloat brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] floatValue];
    if (_scanBrightnessBlock) {
        _scanBrightnessBlock(self, brightnessValue);
    }
}

- (void)setBlockWithQRCodeObtainScanResult:(SGQRCodeObtainScanResultBlock)block {
    _scanResultBlock = block;
}
- (void)setBlockWithQRCodeObtainScanBrightness:(SGQRCodeObtainScanBrightnessBlock)block {
    _scanBrightnessBlock = block;
}

- (void)playSoundName:(NSString *)name {
    /// 静态库 path 的获取
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    if (!path) {
        /// 动态库 path 的获取
        path = [[NSBundle bundleForClass:[self class]] pathForResource:name ofType:nil];
    }
    NSURL *fileUrl = [NSURL fileURLWithPath:path];
    
    SystemSoundID soundID = 0;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
    AudioServicesPlaySystemSound(soundID);
}
void soundCompleteCallback(SystemSoundID soundID, void *clientData){
    
}

#pragma mark - - 相册中读取二维码相关方法
- (void)establishAuthorizationQRCodeObtainAlbumWithController:(UIViewController *)controller {
    if (controller == nil && _controller == nil) {
        @throw [NSException exceptionWithName:@"SGQRCode" reason:@"SGQRCodeObtain 中 establishAuthorizationQRCodeObtainAlbumWithController: 方法的 controller 参数不能为空" userInfo:nil];
    }
    if (_controller == nil) {
        _controller = controller;
    }
    
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
                        [self P_enterImagePickerController];
                    });
                    if (self.configure.openLog == YES) {
                        NSLog(@"用户第一次同意了访问相册权限");
                    }
                } else { // 用户第一次拒绝了访问相机权限
                    if (self.configure.openLog == YES) {
                        NSLog(@"用户第一次拒绝了访问相册权限");
                    }
                }
            }];
        } else if (status == PHAuthorizationStatusAuthorized) { // 用户允许当前应用访问相册
            self.isPHAuthorization = YES;
            if (_configure.openLog == YES) {
                NSLog(@"用户允许访问相册权限");
            }
            [self P_enterImagePickerController];
        } else if (status == PHAuthorizationStatusDenied) { // 用户拒绝当前应用访问相册
            NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
            NSString *app_Name = [infoDict objectForKey:@"CFBundleDisplayName"];
            if (app_Name == nil) {
                app_Name = [infoDict objectForKey:@"CFBundleName"];
            }
            
            NSString *messageString = [NSString stringWithFormat:@"[前往：设置 - 隐私 - 照片 - %@] 允许应用访问", app_Name];
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:messageString preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertC addAction:alertA];
            [_controller presentViewController:alertC animated:YES completion:nil];
        } else if (status == PHAuthorizationStatusRestricted) {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"由于系统原因, 无法访问相册" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertC addAction:alertA];
            [_controller presentViewController:alertC animated:YES completion:nil];
        }
    }
}

- (void)P_enterImagePickerController {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [_controller presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - - UIImagePickerControllerDelegate 的方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [_controller dismissViewControllerAnimated:YES completion:nil];
    if (_albumDidCancelImagePickerControllerBlock) {
        _albumDidCancelImagePickerControllerBlock(self);
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    // 创建 CIDetector，并设定识别类型：CIDetectorTypeQRCode
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
    // 获取识别结果
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    if (features.count == 0) {
        [_controller dismissViewControllerAnimated:YES completion:^{
            if (self.albumResultBlock) {
                self.albumResultBlock(self, nil);
            }
        }];
        return;
    } else {
        for (int index = 0; index < [features count]; index ++) {
            CIQRCodeFeature *feature = [features objectAtIndex:index];
            NSString *resultStr = feature.messageString;
            if (_configure.openLog == YES) {
                NSLog(@"相册中读取二维码数据信息 - - %@", resultStr);
            }
            self.detectorString = resultStr;
        }
        [_controller dismissViewControllerAnimated:YES completion:^{
            if (self.albumResultBlock) {
                self.albumResultBlock(self, self.detectorString);
            }
        }];
    }
}

- (void)setBlockWithQRCodeObtainAlbumDidCancelImagePickerController:(SGQRCodeObtainAlbumDidCancelImagePickerControllerBlock)block {
    _albumDidCancelImagePickerControllerBlock = block;
}
- (void)setBlockWithQRCodeObtainAlbumResult:(SGQRCodeObtainAlbumResultBlock)block {
    _albumResultBlock = block;
}

#pragma mark - - 手电筒相关方法
- (void)openFlashlight {
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    if ([captureDevice hasTorch]) {
        BOOL locked = [captureDevice lockForConfiguration:&error];
        if (locked) {
            [captureDevice setTorchMode:AVCaptureTorchModeOn];
            [captureDevice unlockForConfiguration];
        }
    }
}
- (void)closeFlashlight {
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([captureDevice hasTorch]) {
        [captureDevice lockForConfiguration:nil];
        [captureDevice setTorchMode:AVCaptureTorchModeOff];
        [captureDevice unlockForConfiguration];
    }
}

@end
