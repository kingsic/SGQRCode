//
//  SGAlertView.m
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

#import "SGAlertView.h"
#import "SGBottomView.h"

#define SG_screenWidth [UIScreen mainScreen].bounds.size.width
#define SG_screenHeight [UIScreen mainScreen].bounds.size.height
#define SG_alertView_width 280
#define SG_margin_X (SG_screenWidth - SG_alertView_width) * 0.5

@interface SGAlertView ()
/** 遮盖 */
@property (nonatomic, strong) UIButton *coverView;
/** 背景View */
@property (nonatomic, strong) UIView *bg_view;

/** 信息提示文字 */
@property (nonatomic, copy) NSString *messageTitle;
/** 内容提示文字 */
@property (nonatomic, copy) NSString *contentTitle;

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

- (instancetype)initWithTitle:(NSString *)title delegate:(id<SGAlertViewDelegate>)delegate contentTitle:(NSString *)contentTitle {
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor clearColor];
        
        self.messageTitle = title;
        self.delegate_SG = delegate;
        self.contentTitle = contentTitle;
        
        [self setupAlertView];
    }
    return self;
}

+ (instancetype)alertViewWithTitle:(NSString *)title delegate:(id<SGAlertViewDelegate>)delegate contentTitle:(NSString *)contentTitle {
    return [[self alloc] initWithTitle:title delegate:delegate contentTitle:contentTitle];
}

- (void)show {
    if (self.superview != nil) return;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    [UIView animateWithDuration:SG_animateWithDuration animations:^{
        [self animationWithAlertView];
    }];
}

- (void)sureButtonClick {
    [UIView animateWithDuration:SG_animateWithDuration animations:^{
        [self dismiss];
    } completion:^(BOOL finished) {
        if ([self.delegate_SG respondsToSelector:@selector(didSelectedSureButtonClick)]) {
            [self.delegate_SG didSelectedSureButtonClick];
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
    [self.coverView addTarget:self action:@selector(dismiss) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.coverView];
    
    // 提示标题
    UILabel *message_label = [[UILabel alloc] init];
    message_label.textAlignment = NSTextAlignmentCenter;
    message_label.numberOfLines = 0;
    message_label.text = self.messageTitle;
    message_label.backgroundColor = [UIColor yellowColor];
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
    content_label.backgroundColor = [UIColor redColor];
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

    // 创建底部View
    SGBottomView *bottomView = [[[NSBundle mainBundle] loadNibNamed:@"SGBottomView" owner:nil options:nil] firstObject];
    CGFloat bottomView_X = 0;
    CGFloat bottomView_Y = CGRectGetMaxY(topView.frame);
    CGFloat bottomView_W = SG_alertView_width;
    CGFloat bottomView_H = 45;
    bottomView.frame = CGRectMake(bottomView_X, bottomView_Y, bottomView_W, bottomView_H);
    [bottomView addTargetCancelBtn:self action:@selector(dismiss)];
    [bottomView addTargetSureBtn:self action:@selector(sureButtonClick)];
    
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
    [_bg_view addSubview:bottomView];
    [self.coverView addSubview:_bg_view];
}

-(void)animationWithAlertView {
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.15;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [self.bg_view.layer addAnimation:animation forKey:nil];
}

@end


