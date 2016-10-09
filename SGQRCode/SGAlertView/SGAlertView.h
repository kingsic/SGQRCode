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

typedef enum : NSUInteger {
    SGAlertViewBottomViewTypeOne,
    SGAlertViewBottomViewTypeTwo,
} SGAlertViewBottomViewType;

@protocol SGAlertViewDelegate <NSObject>

- (void)didSelectedSureButtonClick;

@end

@interface SGAlertView : UIView

/** 底部按钮样式 */
@property (nonatomic, assign) SGAlertViewBottomViewType alertViewBottomViewType;

@property (nonatomic, weak) id<SGAlertViewDelegate> delegate_SG;

/**
 *  对象方法创建 SGAlertView
 *
 *  @param title                   提示标题
 *  @param delegate                SGAlertViewDelegate
 *  @param contentTitle            内容
 *  @param alertViewBottomViewType alertViewBottomViewType类型， 设置为SGAlertViewBottomViewTypeOne不用设置代理即可
 *
 *  @return SGAlertView
 */

- (instancetype)initWithTitle:(NSString *)title delegate:(id<SGAlertViewDelegate>)delegate contentTitle:(NSString *)contentTitle alertViewBottomViewType:(SGAlertViewBottomViewType)alertViewBottomViewType;

/**
 *  类方法创建 SGAlertView
 *
 *  @param title                   提示标题
 *  @param delegate                SGAlertViewDelegate
 *  @param contentTitle            内容
 *  @param alertViewBottomViewType alertViewBottomViewType类型
 *
 *  @return SGAlertView
 */
+ (instancetype)alertViewWithTitle:(NSString *)title delegate:(id<SGAlertViewDelegate>)delegate contentTitle:(NSString *)contentTitle alertViewBottomViewType:(SGAlertViewBottomViewType)alertViewBottomViewType;

- (void)show;

@end
