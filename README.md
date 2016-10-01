
## 前沿

* 这是对iOS原生二维码生成与扫描的总结，之所以在此做总结：是为了方便更多的人去很好的使用iOS原生二维码生成与扫描的这块知识点

* 扫描二维码界面采取了微信二维码界面的布局

* - > 如果你觉得很实用，别忘了给我鼓励哦（我的要求很简单，只需要你轻轻的 Star 一下下就可以了） < -


## 主要内容的介绍

### * `普通二维码生成`<br>

### * `彩色二维码生成`<br>

### * `带有小图标二维码生成`<br>

### * `扫描二维码的自定义`<br>

### * `是否开启闪光灯`<br>

### * `从相册中获取二维码`<br>

### * `扫描成功之后提示音`<br>

### * `扫描成功之后的界面之间的跳转`<br>


## 代码介绍（这里介绍的是：扫描二维码里的主要方法；至于生成二维码里面的方法使用，请参考Demo）

* 二维码扫描界面创建
```Objective-C
- (void)setupScanningQRCode {

    // 1、 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 2、 创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    // 3、 创建输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    
    // 4、设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 设置扫描范围(每一个取值0～1，以屏幕右上角为坐标原点)（微信并没有设置， 整个View都是扫描区域）
    output.rectOfInterest = CGRectMake(0.05, 0.2, 0.7, 0.6);
    
    // 5、 初始化链接对象（会话对象）
    self.session = [[AVCaptureSession alloc] init];
    
    // 高质量采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    // 5.1 添加会话输入
    [_session addInput:input];
    
    // 5.2 添加会话输出
    [_session addOutput:output];
    
    // 6、设置输出数据类型，需要将元数据输出添加到会话后，才能指定元数据类型，否则会报错
    // 设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code,  AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    // 7、实例化预览图层, 传递_session是为了告诉图层将来显示什么内容
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    _previewLayer.frame = self.view.layer.bounds;
    
    // 8、将图层插入当前视图
    [self.view.layer insertSublayer:_previewLayer atIndex:0];
    
    // 9、启动会话
    [_session startRunning];
}
```

* 从相册中识别二维码, 并进行界面跳转的方法
```Objective-C
- (void)scanQRCodeFromPhotosInTheAlbum:(UIImage *)image {

    // CIDetector(CIDetector可用于人脸识别)进行图片解析，从而使我们可以便捷的从相册中获取到二维码
    
    // 声明一个CIDetector，并设定识别类型 CIDetectorTypeQRCode
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    
    // 取得识别结果
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    
    for (int index = 0; index < [features count]; index ++) {
    
        CIQRCodeFeature *feature = [features objectAtIndex:index];
        
        NSString *scannedResult = feature.messageString;
                
        ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
        
        jumpVC.jump_URL = scannedResult;
        
        [self.navigationController pushViewController:jumpVC animated:YES];
    }
}
```

* 扫描成功之后调用的方法
```Objective-C
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {

    // 会频繁的扫描，调用代理方法
    
    // 0. 扫描成功之后的提示音
    [self playSoundEffect:@"sound.caf"];

    // 1. 如果扫描完成，停止会话
    [self.session stopRunning];
    
    // 2. 删除预览图层
    [self.previewLayer removeFromSuperlayer];
    
     // 3. 设置界面显示扫描结果
    if (metadataObjects.count > 0) {
    
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        
        NSLog(@"metadataObjects = %@", metadataObjects);
        
        if ([obj.stringValue hasPrefix:@"http"]) {
        
            // 提示：如果需要对url或者名片等信息进行扫描，可以在此进行扩展！
    
            ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
            
            jumpVC.jump_URL = obj.stringValue;
            
            [self.navigationController pushViewController:jumpVC animated:YES];
            
        } else { // 扫描结果为条形码
        
            ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
            
            jumpVC.jump_bar_code = obj.stringValue;
            
            [self.navigationController pushViewController:jumpVC animated:YES];
        }
    }
}
```

* 扫描成功之后提示音的设置（播放音效文件方法）
```Objective-C
- (void)playSoundEffect:(NSString *)name{

    NSString *audioFile = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    
    NSURL *fileUrl = [NSURL fileURLWithPath:audioFile];
    
    // 1.获得系统声音ID
    SystemSoundID soundID = 0;
  
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    
    // 如果需要在播放完之后执行某些操作，可以调用如下方法注册一个播放完成回调函数
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
    
    // 2.播放音频
    AudioServicesPlaySystemSound(soundID);//播放音效
}
```


## 版本介绍

* 2016. 9. 30 --> 新增从相册中获取二维码功能 (注意: 从相册中读取二维码, 需要在iOS8.0以后)
* 2016. 10. 1 --> 新增扫描成功之后提示音


## 效果图如下:

![](https://github.com/kingsic/SGQRCode/raw/master/Picture/sorgle.png) 

![](https://github.com/kingsic/SGQRCode/raw/master/Picture/sorgle2.png) 

![](https://github.com/kingsic/SGQRCode/raw/master/Picture/sorgle3.png) 

![](https://github.com/kingsic/SGQRCode/raw/master/Picture/sorgle4.png)


## Concluding remarks

* 如在使用中, 遇到什么问题或者有更好建议者, 请 Issues 我或者通过 kingsic@126.com 邮箱联系我
