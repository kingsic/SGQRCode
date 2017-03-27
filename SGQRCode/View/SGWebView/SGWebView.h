//
//  SGWebView.h
//  SGWebViewExample
//
//  Created by apple on 17/3/27.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SGWebView;

@protocol SGWebViewDelegate <NSObject>
@optional
/** 页面开始加载时调用 */
- (void)webViewDidStartLoad:(SGWebView *)webView;
/** 内容开始返回时调用 */
- (void)webView:(SGWebView *)webView didCommitWithURL:(NSURL *)url;
/** 页面加载完成之后调用 */
- (void)webView:(SGWebView *)webView didFailLoadWithError:(NSError *)error;
/** 页面加载失败时调用 */
- (void)webView:(SGWebView *)webView didFinishLoadWithURL:(NSURL *)url;
@end

@interface SGWebView : UIView
/** SGDelegate */
@property (nonatomic, weak) id<SGWebViewDelegate> SGDelegate;
/** 进度条颜色(默认蓝色) */
@property (nonatomic, strong) UIColor *progressViewColor;
/** 导航栏标题 */
@property (nonatomic, copy) NSString *navigationItemTitle;
/** 是否有或者隐藏导航栏(默认有并不隐藏) */
@property (nonatomic, assign) BOOL isHaveOrHideNavigationBar;
/** 加载 web */
- (void)loadRequest:(NSURLRequest *)request;
/** 加载 HTML */
- (void)loadHTMLString:(NSString *)HTMLString;
/** 刷新数据 */
- (void)reloadData;

@end
