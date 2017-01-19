//
//  SGQRCodeTool.m
//  SGQRCodeExample
//
//  Created by Sorgle on 16/12/2.
//  Copyright © 2016年 Sorgle. All rights reserved.
//
//  - - - - - - - - - - - - - - 交流QQ：1357127436 - - - - - - - - - - - - - - - //
//
//  - - 如在使用中, 遇到什么问题或者有更好建议者, 请于 kingsic@126.com 邮箱联系 - - - - //
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//  - - GitHub下载地址 https://github.com/kingsic/SGQRCode.git - - - - - - - - - //
//
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //

#import "SGQRCodeTool.h"

@implementation SGQRCodeTool

/**
 *  生成一张普通的二维码
 *
 *  @param data    传入你要生成二维码的数据
 *  @param imageViewWidth    图片的宽度
 */
+ (UIImage *)SG_generateWithDefaultQRCodeData:(NSString *)data imageViewWidth:(CGFloat)imageViewWidth {
    // 1、创建滤镜对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 恢复滤镜的默认属性
    [filter setDefaults];
    
    // 2、设置数据
    NSString *info = data;
    // 将字符串转换成
    NSData *infoData = [info dataUsingEncoding:NSUTF8StringEncoding];
    
    // 通过KVC设置滤镜inputMessage数据
    [filter setValue:infoData forKeyPath:@"inputMessage"];
    
    // 3、获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    
    
    return [SGQRCodeTool createNonInterpolatedUIImageFormCIImage:outputImage withSize:imageViewWidth];
}

/** 根据CIImage生成指定大小的UIImage */
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

/**
 *  生成一张带有logo的二维码
 *
 *  @param data    传入你要生成二维码的数据
 *  @param logoImageName    logo的image名
 *  @param logoScaleToSuperView    logo相对于父视图的缩放比（取值范围：0-1，0，代表不显示，1，代表与父视图大小相同）
 */
+ (UIImage *)SG_generateWithLogoQRCodeData:(NSString *)data logoImageName:(NSString *)logoImageName logoScaleToSuperView:(CGFloat)logoScaleToSuperView {
    // 1、创建滤镜对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 恢复滤镜的默认属性
    [filter setDefaults];
    
    // 2、设置数据
    NSString *string_data = data;
    // 将字符串转换成 NSdata (虽然二维码本质上是字符串, 但是这里需要转换, 不转换就崩溃)
    NSData *qrImageData = [string_data dataUsingEncoding:NSUTF8StringEncoding];
    
    // 设置过滤器的输入值, KVC赋值
    [filter setValue:qrImageData forKey:@"inputMessage"];
    
    // 3、获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    
    // 图片小于(27,27),我们需要放大
    outputImage = [outputImage imageByApplyingTransform:CGAffineTransformMakeScale(20, 20)];
    
    // 4、将CIImage类型转成UIImage类型
    UIImage *start_image = [UIImage imageWithCIImage:outputImage];
    
    
    // - - - - - - - - - - - - - - - - 添加中间小图标 - - - - - - - - - - - - - - - -
    // 5、开启绘图, 获取图形上下文 (上下文的大小, 就是二维码的大小)
    UIGraphicsBeginImageContext(start_image.size);
    
    // 把二维码图片画上去 (这里是以图形上下文, 左上角为(0,0)点
    [start_image drawInRect:CGRectMake(0, 0, start_image.size.width, start_image.size.height)];
    
    // 再把小图片画上去
    NSString *icon_imageName = logoImageName;
    UIImage *icon_image = [UIImage imageNamed:icon_imageName];
    CGFloat icon_imageW = start_image.size.width * logoScaleToSuperView;
    CGFloat icon_imageH = start_image.size.height * logoScaleToSuperView;
    CGFloat icon_imageX = (start_image.size.width - icon_imageW) * 0.5;
    CGFloat icon_imageY = (start_image.size.height - icon_imageH) * 0.5;
    
    [icon_image drawInRect:CGRectMake(icon_imageX, icon_imageY, icon_imageW, icon_imageH)];
    
    // 6、获取当前画得的这张图片
    UIImage *final_image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 7、关闭图形上下文
    UIGraphicsEndImageContext();
    
    return final_image;
}

/**
 *  生成一张彩色的二维码
 *
 *  @param data    传入你要生成二维码的数据
 *  @param backgroundColor    背景色
 *  @param mainColor    主颜色
 */
+ (UIImage *)SG_generateWithColorQRCodeData:(NSString *)data backgroundColor:(CIColor *)backgroundColor mainColor:(CIColor *)mainColor {
    // 1、创建滤镜对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 恢复滤镜的默认属性
    [filter setDefaults];
    
    // 2、设置数据
    NSString *string_data = data;
    // 将字符串转换成 NSdata (虽然二维码本质上是字符串, 但是这里需要转换, 不转换就崩溃)
    NSData *qrImageData = [string_data dataUsingEncoding:NSUTF8StringEncoding];
    
    // 设置过滤器的输入值, KVC赋值
    [filter setValue:qrImageData forKey:@"inputMessage"];
    
    // 3、获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    
    // 图片小于(27,27),我们需要放大
    outputImage = [outputImage imageByApplyingTransform:CGAffineTransformMakeScale(9, 9)];
    
    
    // 4、创建彩色过滤器(彩色的用的不多)
    CIFilter * color_filter = [CIFilter filterWithName:@"CIFalseColor"];
    
    // 设置默认值
    [color_filter setDefaults];
    
    // 5、KVC 给私有属性赋值
    [color_filter setValue:outputImage forKey:@"inputImage"];
    
    // 6、需要使用 CIColor
    [color_filter setValue:backgroundColor forKey:@"inputColor0"];
    [color_filter setValue:mainColor forKey:@"inputColor1"];
    
    // 7、设置输出
    CIImage *colorImage = [color_filter outputImage];
    
    return [UIImage imageWithCIImage:colorImage];
}

/**
 *  扫描二维码
 *
 *  @param outsideVC    外界控制器
 *  @param session    AVCaptureSession 对象
 *  @param previewLayer    AVCaptureVideoPreviewLayer
 */
+ (void)SG_scanningQRCodeOutsideVC:(UIViewController *)outsideVC session:(AVCaptureSession *)session previewLayer:(AVCaptureVideoPreviewLayer *)previewLayer {
    // 1、获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 2、创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    // 3、创建输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    
    // 4、设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:(id)outsideVC queue:dispatch_get_main_queue()];
    
    // 设置扫描范围(每一个取值0～1，以屏幕右上角为坐标原点)
    // 注：微信二维码的扫描范围是整个屏幕，这里并没有做处理（可不用设置）
    output.rectOfInterest = CGRectMake(0.05, 0.2, 0.7, 0.6);
    
    // 5、初始化链接对象（会话对象）
    // 高质量采集率
    //session.sessionPreset = AVCaptureSessionPreset1920x1080; // 如果二维码图片过小、或者模糊请使用这句代码，注释下面那句代码
        session.sessionPreset = AVCaptureSessionPresetHigh;
    
    // 5.1 添加会话输入
    [session addInput:input];
    
    // 5.2 添加会话输出
    [session addOutput:output];
    
    // 6、设置输出数据类型，需要将元数据输出添加到会话后，才能指定元数据类型，否则会报错
    // 设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code,  AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    // 7、实例化预览图层, 传递_session是为了告诉图层将来显示什么内容
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    previewLayer.frame = outsideVC.view.layer.bounds;
    
    // 8、将图层插入当前视图
    [outsideVC.view.layer insertSublayer:previewLayer atIndex:0];
    
    // 9、启动会话
    [session startRunning];
}


@end

