//
//  SGAlertView.h
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

#import <UIKit/UIKit.h>
@class SGAlertView;

@protocol SGAlertViewDelegate <NSObject>

- (void)didSelectedSureButtonClick;

@end

@interface SGAlertView : UIView

@property (nonatomic, weak) id<SGAlertViewDelegate> delegate_SG;

- (instancetype)initWithTitle:(NSString *)title delegate:(id<SGAlertViewDelegate>)delegate contentTitle:(NSString *)contentTitle;

+ (instancetype)alertViewWithTitle:(NSString *)title delegate:(id<SGAlertViewDelegate>)delegate contentTitle:(NSString *)contentTitle;


- (void)show;

@end
