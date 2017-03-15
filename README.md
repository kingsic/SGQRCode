
## 前沿

* 在此首先感谢那些曾经对 SGQRCode 提出宝贵建议者

* 轻轻的我走了，正如我轻轻的来，我动一动鼠标，就是为了给你 Star (喜欢的朋友别忘了哦 😊 😊）

* 这是对iOS原生二维码生成与扫描的总结 (之所以在此做总结：是为了方便更多的人去很好的使用iOS原生二维码生成与扫描的这块知识点)


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


## 代码介绍(详细使用方法，请参考 Demo)
#### 生成二维码

* 普通二维码生成
```Objective-C
imageView.image = [SGQRCodeTool SG_generateWithDefaultQRCodeData:@"https://github.com/kingsic" imageViewWidth:imageViewW];
```

* logo 二维码生成
```Objective-C
imageView.image = [SGQRCodeTool SG_generateWithLogoQRCodeData:@"https://github.com/kingsic" logoImageName:@"icon_image" logoScaleToSuperView:scale];
```

* 彩色二维码生成
```Objective-C
imageView.image = [SGQRCodeTool SG_generateWithColorQRCodeData:@"https://github.com/kingsic" backgroundColor:[CIColor colorWithRed:1 green:0 blue:0.8] mainColor:[CIColor colorWithRed:0.3 green:0.2 blue:0.4]];
```

#### 扫描二维码

* 扫描视图创建
```Objective-C
self.scanningView = [[SGScanningQRCodeView alloc] initWithFrame:self.view.frame outsideViewLayer:self.view.layer];
[self.view addSubview:self.scanningView];
```

* 扫描二维码方法
```Objective-C
// 初始化链接对象（会话对象）
self.session = [[AVCaptureSession alloc] init];
// 实例化预览图层, 传递_session是为了告诉图层将来显示什么内容
self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
[SGQRCodeTool SG_scanningQRCodeOutsideVC:self session:_session previewLayer:_previewLayer];
```


## 效果图

![](https://github.com/kingsic/SGQRCode/raw/master/Picture/sorgle.png)       ![](https://github.com/kingsic/SGQRCode/raw/master/Picture/sorgle2.png) 

![](https://github.com/kingsic/SGQRCode/raw/master/Picture/sorgle3.png)       ![](https://github.com/kingsic/SGQRCode/raw/master/Picture/sorgle4.png)


## 更新介绍

* 2016-9-30 ：新增从相册中获取二维码功能 (注意: 从相册中读取二维码, 需要在 iOS8.0 以后)
* 2016-10-12：解决从相册中读取二维码重复 push 问题(一张照片中包含多个二维码，这里会选取第一个二维码进行解读)
* 2016-10-27：解决从相册中读取二维码，取消选择返回时，图层卡死问题（修改了创建扫描边框里的问题）
* 2016-12-2 ：新增 SGQRCodeTool，对生成二维码代码进行封装（只需一句代码进行调用）；删除了 CIImage 分类
* 2017-1-29 ：对扫描二维码部分代码的封装，从相册中读取二维码采用新方法；扫描视图布局采用CALayer
* 2017-2-14 ：相机访问权限崩溃问题处理


## Concluding remarks

* 如在使用中, 遇到什么问题或有更好建议者, 请记得 [Issues me](https://github.com/kingsic/SGQRCode/issues) 或 kingsic@126.com 邮箱联系我
