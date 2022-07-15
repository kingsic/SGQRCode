//
//  ViewController.m
//  SGQRCodeExample
//
//  Created by kingsic on 16/8/25.
//  Copyright © 2016年 kingsic. All rights reserved.
//

#import "ViewController.h"
#import "SGQRCode.h"
#import "WCQRCodeVC.h"
#import "WBQRCodeVC.h"
#import "QQQRCodeVC.h"
#import "XCQRCodeVC.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataList;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configTableView];
}

- (void)configTableView {
    _dataList = @[@"微信", @"QQ", @"携程", @"原微博"];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = _dataList[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [SGPermission permissionWithType:SGPermissionTypeCamera completion:^(SGPermission * _Nonnull permission, SGPermissionStatus status) {
        if (status == SGPermissionStatusNotDetermined) {
            [permission request:^(BOOL granted) {
                if (granted) {
                    NSLog(@"第一次授权成功");
                    UIViewController *VC;
                    if (indexPath.row == 0) {
                        VC = [[WCQRCodeVC alloc] init];
                    } else if (indexPath.row == 1) {
                        VC = [[QQQRCodeVC alloc] init];
                    } else if (indexPath.row == 2) {
                        VC = [[XCQRCodeVC alloc] init];
                    } else if (indexPath.row == 3) {
                        VC = [[WBQRCodeVC alloc] init];
                    }
                    [self.navigationController pushViewController:VC animated:YES];

                } else {
                    NSLog(@"第一次授权失败");
                }
            }];
        } else if (status == SGPermissionStatusAuthorized) {
            NSLog(@"SGPermissionStatusAuthorized");
            UIViewController *VC;
            if (indexPath.row == 0) {
                VC = [[WCQRCodeVC alloc] init];
            } else if (indexPath.row == 1) {
                VC = [[QQQRCodeVC alloc] init];
            } else if (indexPath.row == 2) {
                VC = [[XCQRCodeVC alloc] init];
            } else if (indexPath.row == 3) {
                VC = [[WBQRCodeVC alloc] init];
            }
            [self.navigationController pushViewController:VC animated:YES];

        } else if (status == SGPermissionStatusDenied) {
            NSLog(@"SGPermissionStatusDenied");
            [self failed];
        } else if (status == SGPermissionStatusRestricted) {
            NSLog(@"SGPermissionStatusRestricted");
            [self unknown];
        }

    }];
    
}

- (void)failed {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"[前往：设置 - 隐私 - 相机 - SGQRCode] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertC addAction:alertA];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertC animated:YES completion:nil];
    });
}

- (void)unknown {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertC addAction:alertA];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertC animated:YES completion:nil];
    });
}


@end
