//
//  MyQRCodeVC.m
//  SGQRCodeExample
//
//  Created by kingsic on 2022/7/9.
//  Copyright © 2022 kingsic. All rights reserved.
//

#import "MyQRCodeVC.h"
#import "SGQRCode.h"

@interface MyQRCodeVC ()
@property (nonatomic, strong) UIImageView *qrcodeImgView;
@property (nonatomic, strong) UIImageView *qrcodeImgView2;
@end

@implementation MyQRCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的二维码";
    
    [self.view addSubview:self.qrcodeImgView];
    [self.view addSubview:self.qrcodeImgView2];

    NSString *data = @"https://github.com/kingsic";
    CGFloat size = self.qrcodeImgView.frame.size.width;

    self.qrcodeImgView.image = [SGGenerateQRCode generateQRCodeWithData:data size:size color:[UIColor redColor] backgroundColor:[UIColor greenColor]];
    self.qrcodeImgView2.image = [SGGenerateQRCode generateQRCodeWithData:data size:size logoImage:[UIImage imageNamed:@"bg_image"] ratio:0.25];
}

- (UIImageView *)qrcodeImgView {
    if (!_qrcodeImgView) {
        _qrcodeImgView = [[UIImageView alloc] init];
        CGFloat w = 200;
        CGFloat h = w;
        CGFloat x = 0.5 * (self.view.frame.size.width - w);
        CGFloat y = 150;
        _qrcodeImgView.frame = CGRectMake(x, y, w, h);
    }
    return _qrcodeImgView;
}

- (UIImageView *)qrcodeImgView2 {
    if (!_qrcodeImgView2) {
        _qrcodeImgView2 = [[UIImageView alloc] init];
        CGFloat w = 200;
        CGFloat h = w;
        CGFloat x = 0.5 * (self.view.frame.size.width - w);
        CGFloat y = CGRectGetMaxY(_qrcodeImgView.frame) + 50;
        _qrcodeImgView2.frame = CGRectMake(x, y, w, h);
    }
    return _qrcodeImgView2;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
