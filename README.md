
# SGQRCode

* `QQ群：825339547`

* `注意：3.5.1 版本重构：API 功能的拓展及扫码识别优化`

## 主要内容的介绍

* `生成二维码`<br>

* `扫描二维码`<br>

* `从相册中读取二维码`<br>

* `根据光线强弱开启手电筒`<br>

* `扫描成功之后界面之间逻辑跳转处理`<br>

* `扫描界面可自定义（线扫描条样式以及网格样式）`<br>

* `扫描界面仿微信（请根据项目需求，自行布局或调整）`<br>


## SGQRCode 集成

* 1、CocoaPods 导入 pod 'SGQRCode', '~> 3.5.1'

* 2、下载、拖拽 “SGQRCode” 文件夹到工程中


## 代码介绍 (详细使用，请参考 Demo)

#### 1、在 info.plist 中添加以下字段（iOS 10 之后需添加的字段）

* `NSCameraUsageDescription (相机权限访问)`<br>

* `NSPhotoLibraryUsageDescription (相册权限访问)`<br>

#### 2、二维码扫描

```Objective-C
    /// 创建二维码扫描类
    scanCode = [SGScanCode scanCode];
    
    /// 二维码扫描回调方法
    [scanCode scanWithController:self resultBlock:^(SGScanCode *scanCode, NSString *result) {
        <#code#>
    }];
    
    /// 开启二维码扫描回调方法: 需手动开启
    [scanCode startRunningWithBefore:^{
        // 在此可添加 HUD
    } completion:^{
        // 在此可移除 HUD
    }];
    
    /// 外界光线强弱值回调方法
    [scanCode scanWithBrightnessBlock:^(SGScanCode *scanCode, CGFloat brightness) {
        <#code#>
    }];
    
    /// 从相册中读取二维码回调方法    
    [scanCode readWithResultBlock:^(SGScanCode *scanCode, NSString *result) {
        <#code#>
    }];
```

#### 3、二维码生成

```Objective-C
    /// 常规二维码
    _imageView.image = [SGCreateCode createQRCodeWithData:@"https://github.com/kingsic" size:size];
    
    /// 带 logo 的二维码
    _imageView.image = [SGCreateCode createQRCodeWithData:@"https://github.com/kingsic" size:size logoImage:logoImage ratio:ratio];
```


## 效果图

![](https://github.com/kingsic/SGQRCode/raw/master/Picture/sorgle1.png)       ![](https://github.com/kingsic/SGQRCode/raw/master/Picture/sorgle2.png)

![](https://github.com/kingsic/SGQRCode/raw/master/Picture/sorgle3.png)       ![](https://github.com/kingsic/SGQRCode/raw/master/Picture/sorgle4.png)


## 问题及解决方案

* 若在使用 CocoaPods 安装第三方时，出现 [!] Unable to find a specification for SGQRCode 提示时，打开终端先输入 pod repo remove master；执行完毕后再输入 pod setup 即可 (可能会等待一段时间)

* 参考资料 [iOS 从相册中读取条形码/二维码遇到的问题](https://blog.csdn.net/gaomingyangc/article/details/54017879)

* 3.5.0 版本支持 9.0+，之前的版本支持 8.0+（iOS 扫描支持 7.0+；从相册中读取二维码支持 8.0+）


## 更新介绍

* 2016-09-30 ：新增从相册中读取二维码功能

* 2016-10-27 ：解决从相册中读取二维码，取消选择返回时，图层卡死问题（修改了创建扫描边框问题）

* 2017-01-29 ：对扫描二维码部分代码的封装；扫描视图布局采用 CALayer

* 2017-03-21 ：v2.0.0 使用继承的思想进行二维码扫描管理

* 2017-05-16 ：v2.0.5 使用封装的思想进行二维码扫描管理

* 2017-06-26 ：v2.1.0 加入 CocoaPods 管理

* 2017-08-17 ：v2.1.5 新增根据光线强弱判断是否打开手电筒

* 2017-08-23 ：v2.1.6 扫描界面使用 UIBezierPath 布局且可根据不同需求实现自定义（扫描线条以及网格样式）

* 2018-02-08 ：v2.2.0 新增新浪微博示例、新增从相册中读取二维码失败回调函数以及分类名称的更换

* 2018-11-09 ：v3.0.0 版本重构：Block 取代 Delegate，更多内容请在 [releases](https://github.com/kingsic/SGQRCode/releases) 中查看

* 2018-11-27 ：v3.0.1 SGQRCodeObtain 类中新增二维码生成方法

* 2021-05-30 ：v3.5.0 版本重构：API 功能的拓展及扫码识别优化，更多内容请在 [releases](https://github.com/kingsic/SGQRCode/releases/tag/3.5.0) 中查看

* 2021-05-30 ：v3.5.1 版本重构：修复 [#163] 问题，更多内容请在 [releases](https://github.com/kingsic/SGQRCode/releases/tag/3.5.1) 中查看


## License
SGQRCode is released under the Apache License 2.0. See [LICENSE](https://github.com/kingsic/SGQRCode/blob/master/LICENSE) for details.
