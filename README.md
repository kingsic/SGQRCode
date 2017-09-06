
# SGQRCode


## 前沿

* 项目中的二维码扫描逻辑仿微信二维码逻辑；具体扫描业务逻辑设置请参考 SGQRCodeScanManager.h 方法中 api 进行相应处理

* 关于根据光线强弱值打开手电筒的 delegate 方法，是时刻调用的，且不对内存产生影响（可自行调试看看昂），尽请放心使用，如若不需要根据光线强弱值打开手电筒，调用 cancelSampleBufferDelegate 方法即可

* v2.0.0 使用继承的思想进行二维码扫描管理（只需接收通知获取到数据即可；如果你想使用继承，那么可在 releases 中下载 v2.0.0 版本）；之后使用封装的思想进行二维码扫描管理（由于使用继承，设备输入流、数据输出流、会话对象、预览图层及代理方法的代码全部书写在控制器中，导致了代码的可读性较差以及耦合性较高）


## 主要内容的介绍

* `普通二维码生成`<br>

* `彩色二维码生成`<br>

* `带有小图标二维码生成`<br>

* `根据光线强弱开启手电筒`<br>

* `从相册中读取二维码`<br>

* `扫描成功之后提示音`<br>

* `扫描成功之后界面之间的跳转`<br>

* `扫描界面仿微信（请根据项目需求，自行布局或调整）`<br>

* `扫描界面可自定义（扫描线条以及网格样式）`<br>


## SGQRCode 集成

* 1、CocoaPods 导入 pod 'SGQRCode'

* 2、下载、拖拽 “SGQRCode” 文件夹到工程中


## 代码介绍 (详细使用，请参考 Demo)

#### 1、在 info.plist 中添加以下字段

* `NSCameraUsageDescription (相机权限访问)`<br>

* `NSPhotoLibraryUsageDescription (相册权限访问)`<br>

#### 2、二维码生成

* 普通二维码生成
```Objective-C
imageView.image = [SGQRCodeGenerateManager generateWithDefaultQRCodeData:@"https://github.com/kingsic" imageViewWidth:imageViewW];
```

* logo 二维码生成
```Objective-C
imageView.image = [SGQRCodeGenerateManager generateWithLogoQRCodeData:@"https://github.com/kingsic" logoImageName:@"icon_image" logoScaleToSuperView:scale];
```

* 彩色二维码生成
```Objective-C
imageView.image = [SGQRCodeGenerateManager generateWithColorQRCodeData:@"https://github.com/kingsic" backgroundColor:[CIColor colorWithRed:1 green:0 blue:0.8] mainColor:[CIColor colorWithRed:0.3 green:0.2 blue:0.4]];
```

#### 3、二维码扫描

```Objective-C
- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// 扫描二维码创建
    SGQRCodeScanManager *scanManager = [SGQRCodeScanManager sharedManager];
    NSArray *arr = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    // AVCaptureSessionPreset1920x1080 推荐使用，对于小型的二维码读取率较高
    [scanManager setupSessionPreset:AVCaptureSessionPreset1920x1080 metadataObjectTypes:arr currentController:self];
    scanManager.delegate = self;
    
    
    /// 从相册中读取二维码方法
    SGQRCodeAlbumManager *albumManager = [SGQRCodeAlbumManager sharedManager];
    [albumManager readQRCodeFromAlbumWithCurrentController:self];
    albumManager.delegate = self;
}
```

* * 扫面二维码的代理方法
```Objective-C
/// 二维码扫描获取数据的回调方法
- (void)QRCodeScanManager:(SGQRCodeScanManager *)scanManager didOutputMetadataObjects:(NSArray *)metadataObjects；

/// 根据光线强弱值打开手电筒的回调方法
- (void)QRCodeScanManager:(SGQRCodeScanManager *)scanManager brightnessValue:(CGFloat)brightnessValue;
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

![](https://github.com/kingsic/SGQRCode/raw/master/Picture/sorgle5.png)       ![](https://github.com/kingsic/SGQRCode/raw/master/Picture/sorgle6.png)


## 问题及解决方案

* 若在使用 CocoaPods 安装第三方时，出现 [!] Unable to find a specification for SGQRCode 提示时，打开终端先输入 pod repo remove master；执行完毕后再输入 pod setup 即可 (可能会等待一段时间)


## 更新介绍

* 2016-9-30 ：新增从相册中读取二维码功能

* 2016-10-27：解决从相册中读取二维码，取消选择返回时，图层卡死问题（修改了创建扫描边框问题）

* 2017-1-29 ：对扫描二维码部分代码的封装；扫描视图布局采用 CALayer

* 2017-2-14 ：相机访问权限崩溃问题处理

* 2017-3-21 ：v2.0.0 使用继承的思想进行二维码扫描管理

* 2017-5-16 ：v2.0.5 使用封装的思想进行二维码扫描管理

* 2017-6-26 ：v2.1.0 加入 CocoaPods 管理

* 2017-8-17 ：v2.1.5 新增根据光线强弱判断是否打开手电筒

* 2017-8-23 ：v2.1.6 扫描界面使用 UIBezierPath 布局且可根据不同需求实现自定义（扫描线条以及网格样式）

* 2017-9-6  ：v2.1.7 根据光线强弱值代理方法性能优化以及解决与第三方[MMDrawerController](https://github.com/mutualmobile/MMDrawerController)产生的图层尺寸问题


## Concluding remarks

* 如在使用中, 遇到什么问题或有更好建议者, 请记得 [Issues me](https://github.com/kingsic/SGQRCode/issues) 或 kingsic@126.com 邮箱联系我

* 感谢邮箱号为：notifications@github.com 的这位朋友提供的从相册中读取二维码照片的优化方案
