
# SGQRCode

| Version | UIKit | Use |
|:-----:|:-----:|:-----:|
| 3.5x    | iOS 9.0+  | Block
| 4.x     | iOS 11.0+ | Delegate

* QQ群：825339547

* [3.5.1版本 API 使用说明](https://github.com/kingsic/SGQRCode/wiki/3.5.1版本API说明)


## 主要功能

`生成二维码`<br>

`扫描二维码`<br>

`捕获内容缩放功能`<br>

`图片中识别二维码`<br>

`相机、相册权限判断`<br>

`根据光线强弱开启关闭手电筒`<br>

`扫描成功后界面间的逻辑跳转处理`<br>

`扫描界面可高度自定义（满足所有主流app）`<br>


## 主要类说明
| 类名 | 说明 |
|-----|-----|
| SGScanCode    | 扫描二维码 |
| SGScanViewConfigure     | 扫描视图配置 |
| SGScanView     | 扫描视图 |
| SGPermission     | 相册、相机权限管理 |
| SGTorch     | 手电筒管理 |
| SGQRCodeLog     | 调试日志 |


## SGQRCode 集成流程

**手动集成**

`添加 SGQRCode 文件夹到工程中`

**通过 CocoaPods 集成**

`pod 'SGQRCode', '~> 4.1.0'`


**Info.plist 添加以下字段**

`NSCameraUsageDescription (相机权限访问)`<br>

`NSPhotoLibraryUsageDescription (相册权限访问)`<br>


**引用头文件**

`#import <SGQRCode/SGQRCode.h>`


**扫描二维码相关代码**
```Objective-C
// 创建二维码扫描类
scanCode = [SGScanCode scanCode];

// 预览视图，必须设置
scanCode.preview = self.view;

// 遵循 SGScanCodeDelegate
scanCode.delegate = self;

// 遵循 SGScanCodeSampleBufferDelegate
scanCode.sampleBufferDelegate = self;

// 开启扫描
[scanCode startRunning];

// 结束扫描
[scanCode stopRunning];
```

**Delegate 方法**
```Objective-C
// SGScanCodeDelegate
- (void)scanCode:(SGScanCode *)scanCode result:(NSString *)result {
    <#code#>
}

// SGScanCodeSampleBufferDelegate
- (void)scanCode:(SGScanCode *)scanCode brightness:(CGFloat)brightness {
    <#code#>
}
```

**图片中识别二维码方法**
```Objective-C
[scanCode readQRCode:image completion:^(NSString *result) {
    <#code#>
}];
```

**生成二维码相关方法**
```Objective-C
// 普通二维码生成方法
[SGGenerateQRCode generateQRCodeWithData:data size:size];

// 带 logo 的二维码生成方法
[SGGenerateQRCode generateQRCodeWithData:data size:size logoImage:logoImage ratio:ratio];
```


## 效果图

<img src="https://github.com/kingsic/SGQRCode/raw/master/Pictures/sgqrcode_1.png" width="40%" height="40%">  <img src="https://github.com/kingsic/SGQRCode/raw/master/Pictures/sgqrcode_2.png" width="40%" height="40%">
<img src="https://github.com/kingsic/SGQRCode/raw/master/Pictures/sgqrcode_3.png" width="40%" height="40%">  <img src="https://github.com/kingsic/SGQRCode/raw/master/Pictures/sgqrcode_4.png" width="40%" height="40%">
<img src="https://github.com/kingsic/SGQRCode/raw/master/Pictures/sgqrcode_5.png" width="40%" height="40%">  <img src="https://github.com/kingsic/SGQRCode/raw/master/Pictures/sgqrcode_6.png" width="40%" height="40%">


## 问题及解决方案

* 若在使用 CocoaPods 安装第三方时，出现 [!] Unable to find a specification for SGQRCode 提示时，打开终端先输入 pod repo remove master；执行完毕后再输入 pod setup 即可 (可能会等待一段时间)

* CIDetector 类只能识别图片中的二维码，目前暂不支持识别图片中的条形码 [解决方案](https://juejin.cn/post/6844903910428114952l)


## 更新说明

* 2021-07-05 ：v3.5.1 版本重构：修复 [#163](https://github.com/kingsic/SGQRCode/issues/163) 问题，更多内容请在 [releases](https://github.com/kingsic/SGQRCode/releases/tag/3.5.1) 中查看

* 2022-07-16 ：v4.0.0 版本重构：Delegate 取代 Block，新增手动对焦功能，优化拓展扫描视图，更多内容请在 [releases](https://github.com/kingsic/SGQRCode/releases/tag/4.0.0) 中查看

* 2022-07-16 ：v4.1.0 优化SGScanView内部代码逻辑，修复无扫描线时，导致程序崩溃问题


## License
SGQRCode is released under the Apache License 2.0. See [LICENSE](https://github.com/kingsic/SGQRCode/blob/master/LICENSE) for details.
