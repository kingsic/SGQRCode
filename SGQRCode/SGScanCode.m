//
//  SGScanCode.m
//  SGQRCodeExample
//
//  Created by kingsic on 2016/8/16.
//  Copyright © 2016年 kingsic. All rights reserved.
//

#import "SGScanCode.h"
#import <AVFoundation/AVFoundation.h>
#import "SGAuthorization.h"

@interface SGScanCode () <AVCaptureMetadataOutputObjectsDelegate, AVCaptureVideoDataOutputSampleBufferDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, weak) UIViewController *tempController;
@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureDeviceInput *deviceInput;
@property (nonatomic, strong) AVCaptureMetadataOutput *metadataOutput;
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoDataOutput;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) NSArray *metadataObjectTypes;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, copy) SGScanCodeScanResultBlock scanResultBlock;
@property (nonatomic, copy) SGScanCodeScanBrightnessBlock scanBrightnessBlock;
@property (nonatomic, copy) SGScanCodeReadResultBlock readResultBlock;
@property (nonatomic, copy) SGScanCodeAlbumDidCancelBlock albumDidCancelBlock;
@property (nonatomic, copy) NSString *tempDetectorResultString;
@end

@implementation SGScanCode

- (void)dealloc {
    if (self.openLog == YES) {
        NSLog(@"SGScanCode - - dealloc");
    }
}

+ (instancetype)scanCode {
    return [[self alloc] init];
}

- (BOOL)isCameraDeviceRearAvailable {
    BOOL isRearCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
    return isRearCamera;
}

- (AVCaptureDevice *)device {
    if (!_device) {
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return _device;
}
- (AVCaptureDeviceInput *)deviceInput {
    if (!_deviceInput) {
        _deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    }
    return _deviceInput;
}
- (AVCaptureMetadataOutput *)metadataOutput {
    if (!_metadataOutput) {
        _metadataOutput = [[AVCaptureMetadataOutput alloc] init];
        [_metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    }
    return _metadataOutput;
}
- (NSArray *)metadataObjectTypes {
    if (!_metadataObjectTypes) {
        _metadataObjectTypes = @[
            AVMetadataObjectTypeUPCECode,
            AVMetadataObjectTypeCode39Code,
            AVMetadataObjectTypeCode39Mod43Code,
            AVMetadataObjectTypeEAN13Code,
            AVMetadataObjectTypeEAN8Code,
            AVMetadataObjectTypeCode93Code,
            AVMetadataObjectTypeCode128Code,
            AVMetadataObjectTypePDF417Code,
            AVMetadataObjectTypeQRCode,
            AVMetadataObjectTypeAztecCode,
            AVMetadataObjectTypeInterleaved2of5Code,
            AVMetadataObjectTypeITF14Code,
            AVMetadataObjectTypeDataMatrixCode,
        ];
    }
    return _metadataObjectTypes;
}
- (AVCaptureVideoDataOutput *)videoDataOutput {
    if (!_videoDataOutput) {
        _videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
        [_videoDataOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    }
    return _videoDataOutput;
}
- (AVCaptureSession *)session {
    if (!_session) {
        _session = [[AVCaptureSession alloc] init];
    }
    return _session;
}

- (AVCaptureVideoPreviewLayer *)videoPreviewLayer {
    if (!_videoPreviewLayer) {
        _videoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
        _videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _videoPreviewLayer.frame = _tempController.view.frame;
    }
    return _videoPreviewLayer;
}

- (void)scanWithController:(UIViewController *)controller resultBlock:(SGScanCodeScanResultBlock)blcok {
    if (controller == nil) {
        @throw [NSException exceptionWithName:@"SGQRCode" reason:@"SGScanCode 中的 scanCodeWithController: 方法中的 controller 参数不能为空" userInfo:nil];
    }
    _tempController = controller;
    _scanResultBlock = blcok;

    /// 设置捕获会话采集率
    self.session.sessionPreset = [self _canSetSessionPreset];
    
    /// 将设备输入对象添加到会话对象中
    [_session addInput:self.deviceInput];
    
    /// 将元数据输出对象添加到会话对象中
    [_session addOutput:self.metadataOutput];
    
    /// 添加捕获输出流到会话对象；构成识了别光线强弱
    if (self.brightness == YES) {
        [_session addOutput:self.videoDataOutput];
    }
    
    /// 元数据输出对象的二维码识数据别类型
    _metadataOutput.metadataObjectTypes = self.metadataObjectTypes;
    
    /// 扫码区域
    if (self.scanArea.origin.x == 0 && self.scanArea.origin.y == 0 && self.scanArea.size.width == 0 && self.scanArea.size.height == 0) {
    } else {
        _metadataOutput.rectOfInterest = self.scanArea;
    }
    
    /// 扫码预览图层
    [controller.view.layer insertSublayer:self.videoPreviewLayer atIndex:0];
}

#pragma mark - - AVCaptureMetadataOutputObjectsDelegate 的方法
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    NSString *resultString = nil;
    if (metadataObjects != nil && metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        if (self.openLog) {
            NSLog(@"扫描的二维码数据:%@", obj);
        }
        resultString = [obj stringValue];
        if (_scanResultBlock) {
            _scanResultBlock(self, resultString);
        }
    }
}

- (void)scanWithBrightnessBlock:(SGScanCodeScanBrightnessBlock)blcok {
    _scanBrightnessBlock = blcok;
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

- (void)startRunningWithBefore:(void (^)(void))before completion:(void (^)(void))completion {
    if (before) {
        before();
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.session startRunning];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
    });
}
- (void)stopRunning {
    if (self.session.isRunning) {
        [self.session stopRunning];
    }
}

- (void)readWithResultBlock:(SGScanCodeReadResultBlock)block {
    _readResultBlock = block;
    
    SGAuthorization *auth = [SGAuthorization authorization];
    if (self.openLog) {
        auth.openLog = YES;
    }
    
    __weak typeof(self) weakSelf = self;
    [auth PHAuthorizationBlock:^(SGAuthorization * _Nonnull authorization, SGAuthorizationStatus status) {
        if (status == SGAuthorizationStatusSuccess) {
            self.albumAuthorization = YES;
            [self _enterImagePickerController];
        } else if (status == SGAuthorizationStatusFail) {
            NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
            NSString *app_Name = [infoDict objectForKey:@"CFBundleDisplayName"];
            if (app_Name == nil) {
                app_Name = [infoDict objectForKey:@"CFBundleName"];
            }
            
            NSString *messageString = [NSString stringWithFormat:@"[前往：设置 - 隐私 - 照片 - %@] 允许应用访问", app_Name];
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:messageString preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
            
            [alertC addAction:alertA];
            [weakSelf.tempController presentViewController:alertC animated:YES completion:nil];
        } else {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"由于系统原因, 无法访问相册" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
            [alertC addAction:alertA];
            [weakSelf.tempController presentViewController:alertC animated:YES completion:nil];
        }
    }];
}

- (void)albumDidCancelBlock:(SGScanCodeAlbumDidCancelBlock)block {
    _albumDidCancelBlock = block;
}
#pragma mark - - UIImagePickerControllerDelegate 的方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [_tempController dismissViewControllerAnimated:YES completion:nil];
    if (_albumDidCancelBlock) {
        _albumDidCancelBlock(self);
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    // 创建 CIDetector，并设定识别类型：CIDetectorTypeQRCode
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
    // 获取识别结果
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    if (features.count == 0) {
        [_tempController dismissViewControllerAnimated:YES completion:^{
            if (self.readResultBlock) {
                self.readResultBlock(self, nil);
            }
        }];
        return;
    } else {
        for (int index = 0; index < [features count]; index ++) {
            CIQRCodeFeature *feature = [features objectAtIndex:index];
            NSString *resultStr = feature.messageString;
            if (self.openLog == YES) {
                NSLog(@"相册中读取二维码数据信息:%@", resultStr);
            }
            self.tempDetectorResultString = resultStr;
        }
        [_tempController dismissViewControllerAnimated:YES completion:^{
            if (self.readResultBlock) {
                self.readResultBlock(self, self.tempDetectorResultString);
            }
        }];
    }
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
void soundCompleteCallback(SystemSoundID soundID, void *clientData){}

- (void)turnOnFlashlight {
    if ([self.device hasTorch]) {
        BOOL locked = [self.device lockForConfiguration:nil];
        if (locked) {
            [self.device setTorchMode:AVCaptureTorchModeOn];
            [self.device unlockForConfiguration];
        }
    }
}
- (void)turnOffFlashlight {
    if ([self.device hasTorch]) {
        [self.device lockForConfiguration:nil];
        [self.device setTorchMode:AVCaptureTorchModeOff];
        [self.device unlockForConfiguration];
    }
}

- (void)_enterImagePickerController {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    imagePicker.modalPresentationStyle = UIModalPresentationCustom;
    [_tempController presentViewController:imagePicker animated:YES completion:nil];
}
- (NSString *)_canSetSessionPreset {
    if ([self.device supportsAVCaptureSessionPreset:AVCaptureSessionPreset3840x2160]) {
        return AVCaptureSessionPreset3840x2160;
    }
    if ([self.device supportsAVCaptureSessionPreset:AVCaptureSessionPreset1920x1080]) {
        return AVCaptureSessionPreset1920x1080;
    }
    if ([self.device supportsAVCaptureSessionPreset:AVCaptureSessionPreset1280x720]) {
        return AVCaptureSessionPreset1280x720;
    }
    if ([self.device supportsAVCaptureSessionPreset:AVCaptureSessionPreset640x480]) {
        return AVCaptureSessionPreset640x480;
    }
    if ([self.device supportsAVCaptureSessionPreset:AVCaptureSessionPreset352x288]) {
        return AVCaptureSessionPreset352x288;
    }
    if ([self.device supportsAVCaptureSessionPreset:AVCaptureSessionPresetHigh]) {
        return AVCaptureSessionPresetHigh;
    }
    if ([self.device supportsAVCaptureSessionPreset:AVCaptureSessionPresetMedium]) {
        return AVCaptureSessionPresetMedium;
    }
    
    return AVCaptureSessionPresetLow;
}

@end
