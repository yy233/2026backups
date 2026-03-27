//
//  ZYLifeCostHelpCenterDetailVC.m
//  Community
//
//  Created by ZY on 2022/1/5.
//

#import "ZYLifeCostHelpCenterDetailVC.h"

@interface ZYLifeCostHelpCenterDetailVC () <UIScrollViewDelegate, WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) WKWebViewConfiguration *webConfig;

@end

@implementation ZYLifeCostHelpCenterDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.titleStr;
    [self setUI];
    [self loadWebView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self navigationBarStyleWithThemeColorChanged:[ZYThemeManager shareManager].navigationBarBackgroundThemeColor_D001534];
}

- (void)setUI {
    
    [self.view addSubview:self.webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_webView.superview);
    }];
}

#pragma mark - 懒加载
- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] init];
        _webView.backgroundColor = [UIColor clearColor];
        _webView.scrollView.backgroundColor = [UIColor clearColor];
        _webView.hidden = YES;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.scrollView.delegate = self;
        // UI代理
        _webView.UIDelegate = self;
        // 导航代理
        _webView.navigationDelegate = self;
    }
    
    return _webView;
}

- (WKWebViewConfiguration *)webConfig {
    if (!_webConfig) {
        _webConfig = [[WKWebViewConfiguration alloc] init];
    }
    
    return _webConfig;
}

#pragma mark - 加载webView
- (void)loadWebView {
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
}

#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    DLog(@"");
}

// 主机地址被重定向时调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    DLog(@"");
}

// 页面加载失败时调用
- ( void )webView:( WKWebView *)webView didFailProvisionalNavigation:( null_unspecified WKNavigation *)navigation withError:( NSError *)error{
    DLog(@"");
}
 
// 当内容开始返回时调用
- ( void )webView:( WKWebView *)webView didCommitNavigation:( null_unspecified WKNavigation *)navigation{
    DLog(@"");
}

// 跳转失败时调用
- ( void )webView:( WKWebView *)webView didFailNavigation:( null_unspecified WKNavigation *)navigation withError:( NSError *)error{
    DLog(@"");
}
 
// 页面加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    DLog(@"");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.webView.hidden = NO;
        if ([ZYThemeManager shareManager].themeType == ZYThemeType_White) {
            [webView evaluateJavaScript:@"document.body.style.backgroundColor=\"#ffffff\"" completionHandler:nil];
        }else {
            [webView evaluateJavaScript:@"document.body.style.backgroundColor=\"#001534\"" completionHandler:nil];
        }
    });
    
    // 通过js注入关闭webView缩放
    NSString *injectionJSString=@"var script = document.createElement('meta');"
                                                "script.name = 'viewport';"
                                                "script.content=\"width=device-width, user-scalable=no\";"
                                                "document.getElementsByTagName('head')[0].appendChild(script);";
    [webView evaluateJavaScript:injectionJSString completionHandler:nil];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[self.webView.scrollView class]]) {
        //防止左右滚动
        CGPoint point = scrollView.contentOffset;
        scrollView.contentOffset = CGPointMake(0, point.y);
    }
}

@end
