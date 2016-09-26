//
//  SGBottomView.m
//  SGAlertViewExample
//
//  Created by Sorgle on 2016/9/25.
//  Copyright © 2016年 Sorgle. All rights reserved.
//
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //
//
//  - - 如在使用中, 遇到什么问题或者有更好建议者, 请于kingsic@126.com邮箱联系 - - - - - //
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//  - - GitHub下载地址 https://github.com/kingsic/SGActionSheet.git - - - - - - //
//
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //

#import "SGBottomView.h"

@interface SGBottomView ()
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@end

@implementation SGBottomView

/** 取消按钮的点击事件 */
- (void)addTargetCancelBtn:(id)target action:(SEL)action {
    [self.cancelButton addTarget:target action:action forControlEvents:(UIControlEventTouchUpInside)];
}

/** 确定按钮的点击事件 */
- (void)addTargetSureBtn:(id)target action:(SEL)action {
    [self.sureButton addTarget:target action:action forControlEvents:(UIControlEventTouchUpInside)];
}

@end
