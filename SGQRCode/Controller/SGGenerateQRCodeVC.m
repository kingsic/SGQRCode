//
//  SGGenerateQRCodeVC.m
//  SGQRCodeExample
//
//  Created by Sorgle on 16/8/25.
//  Copyright © 2016年 Sorgle. All rights reserved.
//
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //
//
//  - - 如在使用中, 遇到什么问题或者有更好建议者, 请于kingsic@126.com邮箱联系 - - - - - //
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//  - - GitHub下载地址 https://github.com/kingsic/SGQRCode.git - - - - - - - - - //
//
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //

#import "SGGenerateQRCodeVC.h"
#import "CIImage+SGExtension.h"

@interface SGGenerateQRCodeVC ()

@end

@implementation SGGenerateQRCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 生成二维码(Default)
    [self setupGenerateQRCode];
    
    // 生成二维码(中间带有图标)
    [self setupGenerate_Icon_QRCode];
    
    // 生成二维码(彩色)
    [self setupGenerate_Color_QRCode];

}

// 生成二维码
- (void)setupGenerateQRCode {
    
    // 1、创建滤镜对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 恢复滤镜的默认属性
    [filter setDefaults];
    
    // 2、设置数据
    NSString *info = @"https://github.com/kingsic";
    // 将字符串转换成
    NSData *infoData = [info dataUsingEncoding:NSUTF8StringEncoding];
    
    // 通过KVC设置滤镜inputMessage数据
    [filter setValue:infoData forKeyPath:@"inputMessage"];
    
    // 3、获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    
    // 4、借助UIImageView显示二维码
    UIImageView *imageView = [[UIImageView alloc] init];
    CGFloat imageViewW = 150;
    CGFloat imageViewH = imageViewW;
    CGFloat imageViewX = (self.view.frame.size.width - imageViewW) / 2;
    CGFloat imageViewY = 80;
    imageView.frame =CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
    [self.view addSubview:imageView];
    
    // 5、将CIImage转换成UIImage，并放大显示
    imageView.image = [outputImage SG_createNonInterpolatedWithSize:imageViewW];
}

#pragma mark - - - 中间带有图标二维码生成
- (void)setupGenerate_Icon_QRCode {
    
    //    NSArray *filters = [CIFilter filterNamesInCategory:kCICategoryBuiltIn];
    
    // 1、创建滤镜对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 恢复滤镜的默认属性
    [filter setDefaults];
    
    // 2、设置数据
    NSString *string_data = @"https://github.com/kingsic";
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
    NSString *icon_imageName = @"icon_image";
    UIImage *icon_image = [UIImage imageNamed:icon_imageName];
    CGFloat icon_imageW = 100;
    CGFloat icon_imageH = icon_imageW;
    CGFloat icon_imageX = (start_image.size.width - icon_imageW) * 0.5;
    CGFloat icon_imageY = (start_image.size.height - icon_imageH) * 0.5;
    
    [icon_image drawInRect:CGRectMake(icon_imageX, icon_imageY, icon_imageW, icon_imageH)];
    
    // 6、获取当前画得的这张图片
    UIImage *final_image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 7、关闭图形上下文
    UIGraphicsEndImageContext();
    
    // 8、借助UIImageView显示二维码
    UIImageView *imageView = [[UIImageView alloc] init];
    CGFloat imageViewW = 150;
    CGFloat imageViewH = imageViewW;
    CGFloat imageViewX = (self.view.frame.size.width - imageViewW) / 2;
    CGFloat imageViewY = 240;
    imageView.frame =CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
    [self.view addSubview:imageView];
    
    // 9、将最终合得的图片显示在UIImageView上
    imageView.image = final_image;
    
}

#pragma mark - - - 彩色图标二维码生成
- (void)setupGenerate_Color_QRCode {
    
    // 1、创建滤镜对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 恢复滤镜的默认属性
    [filter setDefaults];
    
    // 2、设置数据
    NSString *string_data = @"https://github.com/kingsic";
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
    [color_filter setValue:[CIColor colorWithRed:1 green:0 blue:0.8] forKey:@"inputColor0"];
    [color_filter setValue:[CIColor colorWithRed:0.3 green:0.2 blue:0.4] forKey:@"inputColor1"];
    
    // 7、设置输出
    CIImage *colorImage = [color_filter outputImage];
    
    // 8、借助UIImageView显示二维码
    UIImageView *imageView = [[UIImageView alloc] init];
    CGFloat imageViewW = 150;
    CGFloat imageViewH = imageViewW;
    CGFloat imageViewX = (self.view.frame.size.width - imageViewW) / 2;
    CGFloat imageViewY = 400;
    imageView.frame =CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
    [self.view addSubview:imageView];
    
    // 9、将二维码显示在UIImageView上
    imageView.image = [UIImage imageWithCIImage:colorImage];
}



@end


