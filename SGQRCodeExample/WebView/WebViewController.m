//
//  WebViewController.m
//  SGQRCodeExample
//
//  Created by kingsic on 16/8/29.
//  Copyright © 2016年 kingsic. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController () <WKNavigationDelegate>
@property (nonatomic, strong) UILabel *barCodeLab;
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation WebViewController

- (void)dealloc {
    NSLog(@"WebViewController - - dealloc");
    
    if (_wkWebView != nil) {
        [self.wkWebView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configNav];
   
    if (self.jump_bar_code) {
        [self.view addSubview:self.barCodeLab];
    } else {
        [self.view addSubview:self.wkWebView];
        [self.view addSubview:self.progressView];
        
        [self loadData];
    }
}

- (void)loadData {
    NSURL *url = [NSURL URLWithString:self.jump_URL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [_wkWebView loadRequest:urlRequest];
}

- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        _wkWebView = [[WKWebView alloc] initWithFrame:frame];
        _wkWebView.navigationDelegate = self;

        [self.wkWebView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:nil];
    }
    return _wkWebView;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.trackTintColor = [UIColor clearColor];
        CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        _progressView.frame = CGRectMake(0, statusBarHeight == 20 ? 64 : (statusBarHeight + 44), self.view.frame.size.width, 2);
        if (self.comeFromVC == ComeFromWB) {
            _progressView.tintColor = [UIColor orangeColor];
        } else {
            _progressView.tintColor = [UIColor greenColor];
        }
    }
    return _progressView;
}

/// KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.wkWebView) {
        self.progressView.alpha = 1.0;
        BOOL animated = self.wkWebView.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:self.wkWebView.estimatedProgress animated:animated];
        if(self.wkWebView.estimatedProgress >= 0.97) {
            [UIView animateWithDuration:0.1 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.progressView.alpha = 0.0;
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0 animated:NO];
            }];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

/// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.navigationItem.title = self.wkWebView.title;
    
    self.progressView.alpha = 0.0;
}
/// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {

    self.progressView.alpha = 0.0;
}

- (void)configNav {
    UIButton *left_Button = [[UIButton alloc] init];
    [left_Button setTitle:@"back" forState:UIControlStateNormal];
    [left_Button setTitleColor:[UIColor colorWithRed: 21/ 255.0f green: 126/ 255.0f blue: 251/ 255.0f alpha:1.0] forState:(UIControlStateNormal)];
    [left_Button sizeToFit];
    [left_Button addTarget:self action:@selector(left_BarButtonItemAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left_BarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left_Button];
    self.navigationItem.leftBarButtonItem = left_BarButtonItem;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemRefresh) target:self action:@selector(right_BarButtonItemAction)];
}

- (void)left_BarButtonItemAction {
    if (self.comeFromVC == ComeFromWB) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (self.comeFromVC == ComeFromWC) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)right_BarButtonItemAction {
    [self.wkWebView reload];
}

- (UILabel *)barCodeLab {
    if (!_barCodeLab) {
        _barCodeLab = [[UILabel alloc] init];
        _barCodeLab.frame = CGRectMake(0, 200, self.view.frame.size.width, 70);
        _barCodeLab.text = [NSString stringWithFormat:@"条形码：%@", self.jump_bar_code];
        _barCodeLab.textAlignment = NSTextAlignmentCenter;
        _barCodeLab.numberOfLines = 0;
    }
    return _barCodeLab;
}


@end
