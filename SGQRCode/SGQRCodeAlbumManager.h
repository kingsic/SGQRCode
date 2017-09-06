//
//  如遇到问题或有更好方案，请通过以下方式进行联系
//      QQ：1357127436
//      Email：kingsic@126.com
//      GitHub：https://github.com/kingsic/SGQRCode.git
//
//  SGQRCodeAlbumManager.h
//  SGQRCodeExample
//
//  Created by kingsic on 2017/6/27.
//  Copyright © 2017年 kingsic. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SGQRCodeAlbumManager;

@protocol SGQRCodeAlbumManagerDelegate <NSObject>

@required
/** 图片选择控制器取消按钮的点击回调方法 */
- (void)QRCodeAlbumManagerDidCancelWithImagePickerController:(SGQRCodeAlbumManager *)albumManager;
/** 图片选择控制器选取图片完成之后的回调方法 (result: 获取的二维码数据) */
- (void)QRCodeAlbumManager:(SGQRCodeAlbumManager *)albumManager didFinishPickingMediaWithResult:(NSString *)result;

@end

@interface SGQRCodeAlbumManager : NSObject
/** 快速创建单利方法 */
+ (instancetype)sharedManager;
/** SGQRCodeAlbumManagerDelegate */
@property (nonatomic, weak) id<SGQRCodeAlbumManagerDelegate> delegate;
/** 判断相册访问权限是否授权 */
@property (nonatomic, assign) BOOL isPHAuthorization;
/** 是否开启 log 打印，默认为 YES */
@property (nonatomic, assign) BOOL isOpenLog;

/** 从相册中读取二维码方法，必须实现的方法 */
- (void)readQRCodeFromAlbumWithCurrentController:(UIViewController *)currentController;

@end
