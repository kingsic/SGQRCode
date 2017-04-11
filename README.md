
## 前沿

* 在此首先感谢那些曾经对 SGQRCode 提出宝贵建议者

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


## 代码介绍 (详细使用方法，请参考 Demo)

#### 1、添加 info.plist 字段 

* 需要添加的字段

* `NSCameraUsageDescription (相机权限访问)`<br>

* `NSPhotoLibraryUsageDescription (相册权限访问)`<br>

#### 2、导入 SGQRCode 文件夹

#### 3、生成二维码

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

#### 3、扫描二维码

* 新建一个扫描控制器继承 SGQRCodeScanningVC ，并在 .h 中导入 “SGQRCode.h”

* SGQRCodeScanningVC.m
```Objective-C
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 注册观察者
    
    [SGQRCodeNotificationCenter addObserver:self selector:@selector(SGQRCodeInformationFromeAibum:) name:SGQRCodeInformationFromeAibum object:nil];
    
    [SGQRCodeNotificationCenter addObserver:self selector:@selector(SGQRCodeInformationFromeScanning:) name:SGQRCodeInformationFromeScanning object:nil];
}
```

```Objective-C
- (void)SGQRCodeInformationFromeAibum:(NSNotification *)noti {

    NSString *string = noti.object;
    
    // 在此处理数据（将拿到的 string 传递给下一个界面）
}
```


## 效果图

![](https://github.com/kingsic/SGQRCode/raw/master/Picture/sorgle.png)       ![](https://github.com/kingsic/SGQRCode/raw/master/Picture/sorgle2.png) 

![](https://github.com/kingsic/SGQRCode/raw/master/Picture/sorgle3.png)       ![](https://github.com/kingsic/SGQRCode/raw/master/Picture/sorgle4.png)


## 更新介绍

* 2016-9-30 ：新增从相册中获取二维码功能 (注意: 从相册中读取二维码, 需要在 iOS8.0 以后)

* 2016-10-12：解决从相册中读取二维码重复 push 问题 (一张照片中包含多个二维码，这里会选取第一个二维码进行解读)

* 2016-10-27：解决从相册中读取二维码，取消选择返回时，图层卡死问题（修改了创建扫描边框里的问题）

* 2016-12-2 ：新增 SGQRCodeTool，对生成二维码代码进行封装（只需一句代码进行调用）；删除了 CIImage 分类

* 2017-1-29 ：对扫描二维码部分代码的封装，从相册中读取二维码采用新方法；扫描视图布局采用 CALayer

* 2017-2-14 ：相机访问权限崩溃问题处理

* 2017-3-21 ：版本升级处理 (2.0 采用继承)

* 2017-3-27 ：从相册中读取二维码照片的优化处理


## Concluding remarks

* 如在使用中, 遇到什么问题或有更好建议者, 请记得 [Issues me](https://github.com/kingsic/SGQRCode/issues) 或 kingsic@126.com 邮箱联系我

* 感谢邮箱号为：notifications@github.com 的这位朋友提供的从相册中读取二维码照片的优化方案
