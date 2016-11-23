//
//  SGAlertView.m
//  SGAlertViewExample
//
//  Created by Sorgle on 2016/9/25.
//  Copyright © 2016年 Sorgle. All rights reserved.
//
//  - - - - - - - - - - - - - - 交流QQ：1357127436 - - - - - - - - - - - - - - - //
//
//  - - 如在使用中, 遇到什么问题或者有更好建议者, 请于 kingsic@126.com 邮箱联系 - - - - //
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//  - - GitHub下载地址 https://github.com/kingsic/SGQRCode.git - - - - - - - - - //
//
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //

#import "SGAlertView.h"

#define SG_screenWidth [UIScreen mainScreen].bounds.size.width
#define SG_screenHeight [UIScreen mainScreen].bounds.size.height
#define SG_alertView_width 280
#define SG_margin_X (SG_screenWidth - SG_alertView_width) * 0.5
#define SG_lineColor [UIColor colorWithRed:200 / 255.0 green:200 / 255.0 blue:200 / 255.0 alpha:1.0]
@interface SGAlertView ()

/** 遮盖 */
@property (nonatomic, strong) UIButton *coverView;
/** 背景View */
@property (nonatomic, strong) UIView *bg_view;

/** 标题提示文字 */
@property (nonatomic, copy) NSString *messageTitle;
/** 内容提示文字 */
@property (nonatomic, copy) NSString *contentTitle;

/** SGAlertViewBottomViewTypeOne */
@property (nonatomic, strong) UIView *bottomViewOne;
/** SGAlertViewBottomViewTypeTwo */
@property (nonatomic, strong) UIView *bottomViewTwo;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIButton *right_button;
@property (nonatomic, strong) UIButton *left_button;

@end

@implementation SGAlertView

/** 动画时间 */
static CGFloat const SG_animateWithDuration = 0.2;
/** 距离X轴的间距 */
static CGFloat const margin_X = 20;
/** 距离Y轴的间距 */
static CGFloat const margin_Y = 20;
/** 标题字体大小 */
static CGFloat const message_text_fond = 17;
/** 内容字体大小 */
static CGFloat const content_text_fond = 14;

- (instancetype)initWithTitle:(NSString *)title delegate:(id<SGAlertViewDelegate>)delegate contentTitle:(NSString *)contentTitle alertViewBottomViewType:(SGAlertViewBottomViewType)alertViewBottomViewType {
    
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor clearColor];
        
        self.messageTitle = title;
        self.delegate_SG = delegate;
        self.contentTitle = contentTitle;
        self.alertViewBottomViewType = alertViewBottomViewType;
        [self setupAlertView];
    }
    return self;
}

+ (instancetype)alertViewWithTitle:(NSString *)title delegate:(id<SGAlertViewDelegate>)delegate contentTitle:(NSString *)contentTitle alertViewBottomViewType:(SGAlertViewBottomViewType)alertViewBottomViewType{
    
    return [[self alloc] initWithTitle:title delegate:delegate contentTitle:contentTitle alertViewBottomViewType:alertViewBottomViewType];
}

- (void)show {
    
    if (self.superview != nil) return;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    [UIView animateWithDuration:SG_animateWithDuration animations:^{
        [self animationWithAlertView];
    }];
}

- (void)rightButtonClick {
    [UIView animateWithDuration:SG_animateWithDuration animations:^{
        [self dismiss];
    } completion:^(BOOL finished) {
        if ([self.delegate_SG respondsToSelector:@selector(didSelectedRightButtonClick)]) {
            [self.delegate_SG didSelectedRightButtonClick];
        }
    }];
}

- (void)leftButtonClick {
    [UIView animateWithDuration:SG_animateWithDuration animations:^{
        [self dismiss];
    } completion:^(BOOL finished) {
        if ([self.delegate_SG respondsToSelector:@selector(didSelectedLeftButtonClick)]) {
            [self.delegate_SG didSelectedLeftButtonClick];
        }
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:SG_animateWithDuration animations:^{

    } completion:^(BOOL finished) {
        [self.coverView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

/**
 *  计算文字尺寸
 *
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (void)setupAlertView {
    
    // 遮盖视图
    self.coverView = [[UIButton alloc] init];
    self.coverView.frame = self.bounds;
    self.coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
//    [self.coverView addTarget:self action:@selector(dismiss) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.coverView];
    
    // 提示标题
    UILabel *message_label = [[UILabel alloc] init];
    message_label.textAlignment = NSTextAlignmentCenter;
    message_label.numberOfLines = 0;
    message_label.text = self.messageTitle;
    message_label.font = [UIFont boldSystemFontOfSize:17];
    CGSize message_labelSize = [self sizeWithText:message_label.text font:[UIFont systemFontOfSize:message_text_fond] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    // 设置Message的frame
    CGFloat message_label_X = margin_X;
    CGFloat message_label_Y;
    if (message_label.text == nil) {
        message_label_Y = 5;
    } else {
        message_label_Y = margin_Y;
    }
    CGFloat message_label_W = SG_alertView_width - 2 * message_label_X;
    CGFloat message_label_H = message_labelSize.height;
    message_label.frame = CGRectMake(message_label_X, message_label_Y, message_label_W, message_label_H);
    
    // 提示内容
    UILabel *content_label = [[UILabel alloc] init];
    content_label.textAlignment = NSTextAlignmentCenter;
    content_label.numberOfLines = 0;
    content_label.text = self.contentTitle;
    content_label.font = [UIFont systemFontOfSize:content_text_fond];
    content_label.textColor = [UIColor colorWithWhite:0.3 alpha:1.0];
    CGSize content_labelSize = [self sizeWithText:content_label.text font:[UIFont systemFontOfSize:content_text_fond] maxSize:CGSizeMake(SG_alertView_width - 2 * margin_X, MAXFLOAT)];
    // 设置内容的frame
    CGFloat content_label_X = margin_X;
    CGFloat content_label_Y = CGRectGetMaxY(message_label.frame) + margin_Y * 0.8;
    CGFloat content_label_W = SG_alertView_width - 2 * content_label_X;
    CGFloat content_label_H = content_labelSize.height;
    content_label.frame = CGRectMake(content_label_X, content_label_Y, content_label_W, content_label_H);
    
    // 顶部View
    UIView *topView = [[UIView alloc] init];
    // 设置顶部View的frame
    CGFloat topView_X = 0;
    CGFloat topView_Y = 0;
    CGFloat topView_W = SG_alertView_width;
    CGFloat topView_H;
    if (content_label.text == nil) {
        topView_H = CGRectGetMaxY(message_label.frame) + margin_Y;
    } else {
        topView_H = CGRectGetMaxY(content_label.frame) + margin_Y;
    }
    topView.frame = CGRectMake(topView_X, topView_Y, topView_W, topView_H);
    
    [topView addSubview:message_label];
    [topView addSubview:content_label];

    if (self.alertViewBottomViewType == SGAlertViewBottomViewTypeOne) {
        // 创建底部View
        self.bottomViewOne = [[UIView alloc] init];
        CGFloat bottomView_X = 0;
        CGFloat bottomView_Y = CGRectGetMaxY(topView.frame);
        CGFloat bottomView_W = SG_alertView_width;
        CGFloat bottomView_H = 45;
        _bottomViewOne.frame = CGRectMake(bottomView_X, bottomView_Y, bottomView_W, bottomView_H);
        _bottomViewOne.backgroundColor = SG_lineColor;
        
        // 给 bottomViewOne 添加子视图
        self.button = [[UIButton alloc] init];
        CGFloat button_X = 0;
        CGFloat button_Y = 1;
        CGFloat button_W = bottomView_W;
        CGFloat button_H = bottomView_H - button_Y;
        _button.frame = CGRectMake(button_X, button_Y, button_W, button_H);
        _button.backgroundColor = [UIColor whiteColor];
        [_button setTitle:@"确定" forState:(UIControlStateNormal)];
        [_button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        _button.titleLabel.font = [UIFont systemFontOfSize:16];
        [_button addTarget:self action:@selector(rightButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
        [self.bottomViewOne addSubview:_button];

        // 背景View
        self.bg_view = [[UIView alloc] init];
        CGFloat bg_viewW = SG_alertView_width;
        CGFloat bg_viewH = topView.frame.size.height + 45;
        CGFloat bg_viewX = SG_margin_X;
        CGFloat bg_viewY = (SG_screenHeight - bg_viewH) * 0.5;
        _bg_view.frame = CGRectMake(bg_viewX, bg_viewY, bg_viewW, bg_viewH);
        _bg_view.layer.cornerRadius = 7;
        _bg_view.layer.masksToBounds = YES;
        _bg_view.backgroundColor = [UIColor whiteColor];
        
        [_bg_view addSubview:topView];
        [_bg_view addSubview:_bottomViewOne];
        [self.coverView addSubview:_bg_view];

    } else {
        
        // 创建底部View
        self.bottomViewTwo = [[UIView alloc] init];
        CGFloat bottomView_X = 0;
        CGFloat bottomView_Y = CGRectGetMaxY(topView.frame);
        CGFloat bottomView_W = SG_alertView_width;
        CGFloat bottomView_H = 45;
        _bottomViewTwo.frame = CGRectMake(bottomView_X, bottomView_Y, bottomView_W, bottomView_H);
        _bottomViewTwo.backgroundColor = SG_lineColor;
        
        // 给 bottomViewOne 添加子视图
        self.left_button = [[UIButton alloc] init];
        CGFloat left_button_X = 0;
        CGFloat left_button_Y = 1;
        CGFloat left_button_W = bottomView_W * 0.5;
        CGFloat left_button_H = bottomView_H - left_button_Y;
        _left_button.frame = CGRectMake(left_button_X, left_button_Y, left_button_W, left_button_H);
        _left_button.backgroundColor = [UIColor whiteColor];
        [_left_button setTitle:@"取消" forState:(UIControlStateNormal)];
        [_left_button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        _left_button.titleLabel.font = [UIFont systemFontOfSize:16];
        [_left_button addTarget:self action:@selector(leftButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
        [self.bottomViewTwo addSubview:_left_button];
        
        self.right_button = [[UIButton alloc] init];
        CGFloat right_button_X = CGRectGetMaxX(_left_button.frame) + 1;
        CGFloat right_button_Y = 1;
        CGFloat right_button_W = bottomView_W - right_button_X;
        CGFloat right_button_H = bottomView_H - left_button_Y;
        _right_button.frame = CGRectMake(right_button_X, right_button_Y, right_button_W, right_button_H);
        _right_button.backgroundColor = [UIColor whiteColor];
        [_right_button setTitle:@"确定" forState:(UIControlStateNormal)];
        [_right_button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        _right_button.titleLabel.font = [UIFont systemFontOfSize:16];
        [_right_button addTarget:self action:@selector(rightButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
        [self.bottomViewTwo addSubview:_right_button];
        
        // 背景View
        self.bg_view = [[UIView alloc] init];
        CGFloat bg_viewW = SG_alertView_width;
        CGFloat bg_viewH = topView.frame.size.height + 45;
        CGFloat bg_viewX = SG_margin_X;
        CGFloat bg_viewY = (SG_screenHeight - bg_viewH) * 0.5;
        _bg_view.frame = CGRectMake(bg_viewX, bg_viewY, bg_viewW, bg_viewH);
        _bg_view.layer.cornerRadius = 7;
        _bg_view.layer.masksToBounds = YES;
        _bg_view.backgroundColor = [UIColor whiteColor];
        
        [_bg_view addSubview:topView];
        [_bg_view addSubview:_bottomViewTwo];
        [self.coverView addSubview:_bg_view];
    }
}

-(void)animationWithAlertView {
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.15;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [self.bg_view.layer addAnimation:animation forKey:nil];
}


- (void)setSure_btnTitle:(NSString *)sure_btnTitle {
    _sure_btnTitle = sure_btnTitle;
    [_button setTitle:sure_btnTitle forState:(UIControlStateNormal)];
    [_right_button setTitle:sure_btnTitle forState:(UIControlStateNormal)];
}

- (void)setLeft_btnTitle:(NSString *)left_btnTitle {
    _left_btnTitle = left_btnTitle;
    [_left_button setTitle:left_btnTitle forState:(UIControlStateNormal)];
}

- (void)setSure_btnTitleColor:(UIColor *)sure_btnTitleColor {
    _sure_btnTitleColor = sure_btnTitleColor;
    [_button setTitleColor:sure_btnTitleColor forState:(UIControlStateNormal)];
    [_right_button setTitleColor:sure_btnTitleColor forState:(UIControlStateNormal)];
}

- (void)setLeft_btnTitleColor:(UIColor *)left_btnTitleColor {
    _left_btnTitleColor = left_btnTitleColor;
    [_left_button setTitleColor:left_btnTitleColor forState:(UIControlStateNormal)];
}



@end


