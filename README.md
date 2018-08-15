
# SGQRCode


## 前沿

* v2.0.0 使用继承的思想进行二维码扫描管理（只需接收通知获取到数据即可；如果你想使用继承，那么可在 releases 中下载 v2.0.0 版本）；之后使用封装的思想进行二维码扫描管理（由于使用继承，设备输入流、数据输出流、会话对象、预览图层及代理方法的代码全部书写在控制器中，导致了代码的可读性较差以及耦合性较高）

* v2.5.0 Block 取代 delegate


## 主要内容的介绍

* `扫描二维码`<br>

* `从相册中读取二维码`<br>

* `根据光线强弱开启手电筒`<br>

* `扫描成功之后界面之间逻辑跳转处理`<br>

* `扫描界面可自定义（线扫描条样式以及网格样式）`<br>

* `扫描界面仿微信（请根据项目需求，自行布局或调整）`<br>


## SGQRCode 集成

* 1、CocoaPods 导入 pod 'SGQRCode', '~> 2.5.3'

* 2、下载、拖拽 “SGQRCode” 文件夹到工程中


## 代码介绍 (详细使用，请参考 Demo)

#### 1、在 info.plist 中添加以下字段

* `NSCameraUsageDescription (相机权限访问)`<br>

* `NSPhotoLibraryUsageDescription (相册权限访问)`<br>


#### 2、二维码扫描

```Objective-C
    __weak typeof(self) weakSelf = self;

    /// 扫描二维码
    SGQRCodeObtainConfigure *configure = [SGQRCodeObtainConfigure QRCodeObtainConfigure];
    [obtain establishQRCodeObtainScanWithController:self configure:configure];
    // 二维码扫描回调方法
    [obtain setBlockWithQRCodeObtainScanResult:^(SGQRCodeObtain *obtain, NSString *result) {
        <#code#>
    }];
    // 二维码开启方法: 需手动开启扫描
    [obtain startRunningWithBefore:^{
        // 在此可添加 HUD
    } completion:^{
        // 在此可移除 HUD
    }];
    // 根据外界光线值判断是否自动打开手电筒
    [obtain setBlockWithQRCodeObtainScanBrightness:^(SGQRCodeObtain *obtain, CGFloat brightness) {
        <#code#>
    }];
    
    
    /// 从相册中读取二维码    
    [obtain establishAuthorizationQRCodeObtainAlbumWithController:self];
    // 从相册中读取图片上的二维码回调方法
    [obtain setBlockWithQRCodeObtainAlbumResult:^(SGQRCodeObtain *obtain, NSString *result) {
        <#code#>
    }];
}
```


## 效果图

![](https://github.com/kingsic/SGQRCode/raw/master/Picture/sorgle1.png)       ![](https://github.com/kingsic/SGQRCode/raw/master/Picture/sorgle2.png)

![](https://github.com/kingsic/SGQRCode/raw/master/Picture/sorgle3.png)       ![](https://github.com/kingsic/SGQRCode/raw/master/Picture/sorgle4.png)


## 问题及解决方案

* 若在使用 CocoaPods 安装第三方时，出现 [!] Unable to find a specification for SGQRCode 提示时，打开终端先输入 pod repo remove master；执行完毕后再输入 pod setup 即可 (可能会等待一段时间)

* [iOS 从相册中读取条形码/二维码遇到的问题](https://blog.csdn.net/gaomingyangc/article/details/54017879)

* iOS 扫描支持 7.0+；从相册中读取二维码支持 8.0+；因此，CocoaPods 版本最低支持 8.0+


## 更新介绍

* 2016-09-30 ：新增从相册中读取二维码功能

* 2016-10-27 ：解决从相册中读取二维码，取消选择返回时，图层卡死问题（修改了创建扫描边框问题）

* 2017-01-29 ：对扫描二维码部分代码的封装；扫描视图布局采用 CALayer

* 2017-02-14 ：相机访问权限崩溃问题处理

* 2017-03-21 ：v2.0.0 使用继承的思想进行二维码扫描管理

* 2017-05-16 ：v2.0.5 使用封装的思想进行二维码扫描管理

* 2017-06-26 ：v2.1.0 加入 CocoaPods 管理

* 2017-08-17 ：v2.1.5 新增根据光线强弱判断是否打开手电筒

* 2017-08-23 ：v2.1.6 扫描界面使用 UIBezierPath 布局且可根据不同需求实现自定义（扫描线条以及网格样式）

* 2018-02-08  ：v2.2.0 新增新浪微博示例、新增从相册中读取二维码失败回调函数以及分类名称的更换

* 2018-07-29  ：v2.5.0 版本升级【Block 取代 delegate 以及代码整合与优化】

* 2018-08-02  ：v2.5.2 二维码扫描需手动开启以及优化从相册中识别二维码

* 2018-08-15  ：v2.5.3 开启扫描回调方法及停止扫描方法内部优化处理


## Concluding remarks

* 如在使用中, 遇到什么问题或有更好建议者, 请记得 [Issues me](https://github.com/kingsic/SGQRCode/issues) 或 kingsic@126.com 邮箱联系我
