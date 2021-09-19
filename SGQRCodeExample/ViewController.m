//
//  ViewController.m
//  SGQRCodeExample
//
//  Created by kingsic on 16/8/25.
//  Copyright © 2016年 kingsic. All rights reserved.
//

#import "ViewController.h"
#import "SGQRCode.h"
#import "WBQRCodeVC.h"
#import "WCQRCodeVC.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataList;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configuration];
}

- (void)configuration {
    _dataList = @[@"WBQRCodeVC (pop 逻辑处理）", @"WCQRCodeVC (popToRoot 逻辑处理)"];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _dataList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        SGAuthorization *authorization = [[SGAuthorization alloc] init];
        authorization.openLog = YES;
        [authorization AVAuthorizationBlock:^(SGAuthorization * _Nonnull authorization, SGAuthorizationStatus status) {
            if (status == SGAuthorizationStatusSuccess) {
                WBQRCodeVC *WBVC = [[WBQRCodeVC alloc] init];
                [self.navigationController pushViewController:WBVC animated:YES];
            } else if (status == SGAuthorizationStatusFail) {
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请去-> [设置 - 隐私 - 相机 - SGQRCodeExample] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                }];
                
                [alertC addAction:alertA];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:alertC animated:YES completion:nil];
                });
            } else {
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                [alertC addAction:alertA];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:alertC animated:YES completion:nil];
                });
            }
        }];
    }
    
    if (indexPath.row == 1) {
        SGAuthorization *authorization = [SGAuthorization authorization];
        [authorization AVAuthorizationBlock:^(SGAuthorization * _Nonnull authorization, SGAuthorizationStatus status) {
            if (status == SGAuthorizationStatusSuccess) {
                WCQRCodeVC *WCVC = [[WCQRCodeVC alloc] init];
                [self.navigationController pushViewController:WCVC animated:YES];
            } else if (status == SGAuthorizationStatusFail) {
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请去-> [设置 - 隐私 - 相机 - SGQRCodeExample] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                [alertC addAction:alertA];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:alertC animated:YES completion:nil];
                });
            } else {
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                [alertC addAction:alertA];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:alertC animated:YES completion:nil];
                });
            }
        }];
    }
}


@end
