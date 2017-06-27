
## 前沿

* 在此首先感谢那些曾经对 SGQRCode 提出宝贵建议者

* 这是对iOS原生二维码生成与扫描的总结 (之所以在此做总结：是为了方便更多的人去很好的使用iOS原生二维码生成与扫描的这块知识点)

* v2.0 采用的是继承，只需接收通知（拿到数据做处理）即可，如果你想使用继承，那么可在 releases 中下载 v2.0 版本；最新的版本采用封装思想（由于 v2.0 采用的继承，代码耦合性比较高且设备输入流、数据输出流、会话对象、预览图层及代理方法全部写在控制器中，造成了代码的可读性较差）


## 主要内容的介绍

* `普通二维码生成`<br>

* `彩色二维码生成`<br>

* `带有小图标二维码生成`<br>

* `扫描二维码的自定义`<br>

* `是否开启闪光灯`<br>

* `从相册中获取二维码`<br>

* `扫描成功之后提示音`<br>

* `扫描成功之后的界面之间的跳转`<br>

* `扫描二维码界面采取了微信二维码界面的布局`<br>


## 代码介绍 (详细使用方法，请参考 Demo)

#### 1、在 info.plist 中需添加的字段

* `NSCameraUsageDescription (相机权限访问)`<br>

* `NSPhotoLibraryUsageDescription (相册权限访问)`<br>

#### 2、SGQRCode 集成

* 1、CocoaPods 导入 pod 'SGQRCode'”

* 2、下载、拖拽 “SGQRCode” 文件夹到工程中

#### 3、二维码生成

* 普通二维码生成
```Objective-C
imageView.image = [SGQRCodeGenerateManager SG_generateWithDefaultQRCodeData:@"https://github.com/kingsic" imageViewWidth:imageViewW];
```

* logo 二维码生成
```Objective-C
imageView.image = [SGQRCodeGenerateManager SG_generateWithLogoQRCodeData:@"https://github.com/kingsic" logoImageName:@"icon_image" logoScaleToSuperView:scale];
```

* 彩色二维码生成
```Objective-C
imageView.image = [SGQRCodeGenerateManager SG_generateWithColorQRCodeData:@"https://github.com/kingsic" backgroundColor:[CIColor colorWithRed:1 green:0 blue:0.8] mainColor:[CIColor colorWithRed:0.3 green:0.2 blue:0.4]];
```

#### 4、二维码扫描

```Objective-C
- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// 扫描二维码创建
    SGQRCodeScanManager *scanManager = [SGQRCodeScanManager sharedManager];
    NSArray *arr = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    // AVCaptureSessionPreset1920x1080 推荐使用，对于小型的二维码读取率较高
    [scanManager SG_setupSessionPreset:AVCaptureSessionPreset1920x1080 metadataObjectTypes:arr];
    scanManager.delegate = self;
    
    
    /// 从相册中读取二维码方法
    SGQRCodeAlbumManager *albumManager = [SGQRCodeAlbumManager sharedManager];
    [albumManager SG_readQRCodeFromAlbum];
    albumManager.delegate = self;
}
```

* * 扫面二维码的代理方法
```Objective-C
/// 二维码扫描获取数据的回调方法
- (void)QRCodeScanManager:(SGQRCodeScanManager *)scanManager didOutputMetadataObjects:(NSArray *)metadataObjects；
```

* * 从相册中读取二维码的代理方法
```Objective-C
/// 图片选择控制器取消按钮的点击回调方法
- (void)QRCodeAlbumManagerDidCancelWithImagePickerController:(SGQRCodeAlbumManager *)albumManager；

/// 图片选择控制器选取图片完成之后的回调方法
- (void)QRCodeAlbumManager:(SGQRCodeAlbumManager *)albumManager didFinishPickingMediaWithResult:(NSString *)result；
```


## 效果图

![](https://github.com/kingsic/SGQRCode/raw/master/Picture/sorgle.png)       ![](https://github.com/kingsic/SGQRCode/raw/master/Picture/sorgle2.png) 

![](https://github.com/kingsic/SGQRCode/raw/master/Picture/sorgle3.png)       ![](https://github.com/kingsic/SGQRCode/raw/master/Picture/sorgle4.png)


## 更新介绍

* 2016-9-30 ：新增从相册中读取二维码功能

* 2016-10-27：解决从相册中读取二维码，取消选择返回时，图层卡死问题（修改了创建扫描边框里的问题）

* 2017-1-29 ：对扫描二维码部分代码的封装，从相册中读取二维码采用新方法；扫描视图布局采用 CALayer

* 2017-2-14 ：相机访问权限崩溃问题处理

* 2017-3-21 ：版本升级处理 (v2.0 采用继承)

* 2017-5-16 ：v2.0.5 采用封装的思想进行二维码扫描管理

* 2017-6-26 ：v2.1.0 加入 CocoaPods 管理


## Concluding remarks

* 如在使用中, 遇到什么问题或有更好建议者, 请记得 [Issues me](https://github.com/kingsic/SGQRCode/issues) 或 kingsic@126.com 邮箱联系我

* 感谢邮箱号为：notifications@github.com 的这位朋友提供的从相册中读取二维码照片的优化方案
