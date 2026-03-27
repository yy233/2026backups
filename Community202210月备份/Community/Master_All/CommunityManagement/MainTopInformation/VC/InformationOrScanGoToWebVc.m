//
//  InformationOrScanGoToWebVc.m
//  Community
//
//  Created by 余莹 on 2021/10/14.
//

#import "InformationOrScanGoToWebVc.h"
#define BindingPopAction  @"BindingPopAction"    //返回

@interface InformationOrScanGoToWebVc ()<WKScriptMessageHandler,WKUIDelegate,WKNavigationDelegate, UIGestureRecognizerDelegate>


@property (nonatomic,strong)   UIProgressView   *progressView;

@end

@implementation InformationOrScanGoToWebVc

 
- (void)viewDidLoad {
    [super viewDidLoad];

    // pop返回手势
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [self initView];
    [self initKvo];
    [self initData];
    [self initAddScriptMessageHandler];
//    [self initNotice];
 
}
#pragma mark ===
- (void)dealloc{
    [self dellocAllScriptMessageHandler];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
 }
 
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark ===
- (void)initAddScriptMessageHandler{
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:BindingPopAction];
 

}
- (void)dellocAllScriptMessageHandler{
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:BindingPopAction];
}
#pragma mark ===
- (void)initKvo{
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil]; 
}
#pragma mark == UI
 
 
- (void)initView{
    [self initWKWebView];
    [self initProgressView];
    [self setUI];
}
- (void)setUI{
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_webView.superview);
    }];
//    UIView *statusView = [[UIView alloc] init];
//    statusView.backgroundColor = Y_RGBA(244, 77, 68, 1);
//    statusView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:statusView];
//    [statusView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.equalTo(statusView.superview);
//        make.height.offset(status_height);
//    }];
//    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(statusView.mas_bottom);
//        make.left.right.equalTo(_webView.superview);
////        make.height.offset(Screen_H-KTabBarHeight-status_height);
//        make.height.offset(Screen_H-status_height);
//    }];
}
- (void)initProgressView
{
    CGFloat kScreenWidth = [[UIScreen mainScreen] bounds].size.width;
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, kGHSafeAreaBottomHeight, kScreenWidth, 2)];//34.0 0
    //UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, status_height, kScreenWidth, 2)];//本界面的nav被隐藏掉了 进度条的UI高度更改成0
    progressView.tintColor = Color_38BlueColor;
    progressView.trackTintColor = [UIColor lightGrayColor];
    [self.view addSubview:progressView];
    self.progressView = progressView;
    
}
- (void)initData{
    
    //1021 不做每个键值都要拼接httpAllUseStr 只有本uid拼接
    NSString *useUrlStr = [NSString stringWithFormat:@"%@&yhUid=%@",self.httpAllUseStr,[TextShowWithModelStr textShowWithModelStr:[ShareUserInfo sharedUserInfo].userInfo.uid]];
    DLog(@"打开的url地址是== %@",useUrlStr);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:useUrlStr] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:15.0];
    [_webView loadRequest:request];
    /**
     if (self.infoIdStr.length>0) {
         DLog(@"自己app扫码等");
        //在跳转前做判断
 //         WEAKSELF
 //        if (![self.phoneStr isEqualToString: [TextShowWithModelStr textShowWithModelStr:[ShareUserInfo sharedUserInfo].userInfo.mobile]]) {// //phoneStr [TextShowWithModelStr textShowWithModelStr:[ShareUserInfo sharedUserInfo].userInfo.mobile] )
 //            Y_SVP_SHOW_ERR_MES(@"用户手机号与本数据不匹配，不能做绑定！");
 //            dispatch_async(dispatch_get_main_queue(), ^{
 //                [weakSelf.navigationController popViewControllerAnimated:YES];
 //            });
 //            return;
 //        }
         //符合的数据
        NSString *allUrl = [NSString stringWithFormat:@"%@?id=%@&mobile=%@&yhUid=%@",URL_UserBangDingFamileOrRent ,self.infoIdStr,self.phoneStr,[TextShowWithModelStr textShowWithModelStr:[ShareUserInfo sharedUserInfo].userInfo.uid]];
         NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:allUrl] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:15.0];//缓存属性
         [_webView loadRequest:request];
     }else{
         DLog(@"其他app打开");
         NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL_UserBangDingFamileOrRent] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:15.0];//缓存属性
         [_webView loadRequest:request];

     }
     */
   
 
}
#pragma mark ==== webv
- (void)initWKWebView
{
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    
//    WKPreferences *preferences = [WKPreferences new];
//    preferences.javaScriptCanOpenWindowsAutomatically = YES;
//    preferences.minimumFontSize = 40.0;
    // 创建设置对象
    WKPreferences *preference = [[WKPreferences alloc]init];
    //最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
    preference.minimumFontSize = 0;
    //设置是否支持javaScript 默认是支持的
    preference.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
//    preference.javaScriptCanOpenWindowsAutomatically = YES;
    preference.javaScriptCanOpenWindowsAutomatically = NO;
    configuration.preferences = preference;
//    [configuration.userContentController addScriptMessageHandler:self name:@"toVideoios"];
    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];
    
    
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    [self.view addSubview:self.webView];
}


#pragma mark ===
#pragma mark - KVO
// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    //_____
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            [self.progressView setProgress:1.0 animated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressView.hidden = YES;
                [self.progressView setProgress:0 animated:NO];
            });
            
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}
#pragma mark - WKNavigationDelegate
// 根据WebView对于即将跳转的HTTP请求头信息和相关信息来决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"decidePolicyForNavigationAction-------------%@",navigationAction.request.URL.absoluteString);
    decisionHandler(WKNavigationActionPolicyAllow);
}

//接收到相应数据后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSLog(@"decidePolicyForNavigationResponse   ==  %@",navigationResponse.response.URL.absoluteString);
    decisionHandler(WKNavigationResponsePolicyAllow);
}
//页面开始加载时调用

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

//跳转失败时调用

- ( void )webView:( WKWebView *)webView didFailNavigation:( null_unspecified WKNavigation *)navigation withError:( NSError *)error{
    DLog(@"");
}
 
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
//    [self.webView evaluateJavaScript:@"document.title" completionHandler:^(NSString *title, NSError *error) {
//           self.title = title;
//       }];
    DLog(@"");
}
//9.0才能使用，web内容处理中断时会触发

- ( void )webViewWebContentProcessDidTerminate:( WKWebView *)webView API_AVAILABLE(macosx( 10.11 ), ios( 9.0 )){
    DLog(@"");
}
#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    alert.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
     NSLog(@"WKScriptMessageHandler ___ name:%@    body:%@",message.name,message.body);
    if ([message.name isEqualToString:BindingPopAction]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } else{
        DLog(@"—————————userContentController———————");
    }
}

#pragma mark ===
 

@end
