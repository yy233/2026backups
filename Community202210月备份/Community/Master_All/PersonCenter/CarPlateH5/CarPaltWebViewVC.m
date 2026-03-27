//
//  CarPaltWebViewVC.m
//  Community
//
//  Created by 余莹 on 2022/1/14.
//

#import "CarPaltWebViewVC.h"


static NSString *shopWebViewiOSGetJsInfoFunctionName = @"shopWebViewiOSFunction";
static NSString *shopOcSendToJsWithFunctionName = @"ocSendToJsWithFunctionName";

@interface CarPaltWebViewVC ()<UINavigationControllerDelegate,WKScriptMessageHandler,WKUIDelegate,WKNavigationDelegate,UIGestureRecognizerDelegate>
@property (nonatomic,strong)   WKWebView        *webView;

@end

@implementation CarPaltWebViewVC


#pragma mark === nav

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断如果是需要隐藏导航控制器的类，则隐藏
    BOOL isHideNav = ([viewController isKindOfClass:[self class]]);//上一页 也是隐藏了nav用的view
    [self.navigationController setNavigationBarHidden:isHideNav animated:YES];
}

- (void)handleNavigationTransition:(UIPanGestureRecognizer *)gesture{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)initPopGesture{
    //will 隐藏了nav 则 设置全屏滑动返回才能响应返回
    self.navigationController.delegate = self;
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    [self.navigationController.view addGestureRecognizer:pan];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}
#pragma mark ===
- (void)viewDidLoad {
    [super viewDidLoad];
  
//    [self initPopGesture];
    // pop返回手势
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [self initAll];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
 
#pragma mark === dealloc
- (void)dealloc{
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:shopWebViewiOSGetJsInfoFunctionName];
    self.navigationController.delegate = nil;
}
 
#pragma mark === webView addScriptMessageHandler
- (void)initAddScriptMessageHandler{
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:shopWebViewiOSGetJsInfoFunctionName];
}

#pragma mark === all init
- (void)initAll{
    [self initView];
    [self initData];
    [self initAddScriptMessageHandler];
   
 }
#pragma mark ==
 
- (void)initView{
    [self initWKWebView];
    [self setUI];

}
- (void)setUI{
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_webView.superview);
    }];
}

- (void)initData{
    NSString *token = [ShareUserInfo sharedUserInfo].token;
    NSInteger height = status_height*2;
    NSString *allUrlStr = [NSString stringWithFormat:@"%@?statusHeight=%ld&token=%@&APPreturn=1",URLAllStr_With_CarPlateNumberInput,height,token];
    
 
    NSLog(@"initData allUrlStr %@",allUrlStr);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:allUrlStr] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:15.0];//缓存属性
    [_webView loadRequest:request];
}
#pragma mark ==== webv
- (void)initWKWebView
{
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
  // 创建设置对象
    WKPreferences *preference = [[WKPreferences alloc]init];
    preference.minimumFontSize = 0;
    preference.javaScriptEnabled = YES;
    preference.javaScriptCanOpenWindowsAutomatically = NO;
    configuration.preferences = preference;
    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];
    
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    [self.view addSubview:self.webView];
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
- (void)webViewDidClose:(WKWebView *)webView {
    NSLog(@"webViewDidClose %s", __FUNCTION__);
}
//uiwebview 中这个方法是私有方法 通过category可以拦截alert
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
    
    NSDictionary *bodyParam = (NSDictionary*)message.body;
    NSString *func = [bodyParam objectForKey:@"function"];
    
    NSLog(@"MessageHandler Name:%@", message.name);
    NSLog(@"MessageHandler Body:%@", message.body);
    NSLog(@"MessageHandler Function:%@",func);
 
    
    if ([message.name isEqualToString:shopWebViewiOSGetJsInfoFunctionName]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:message.body];
        [self getShopWebViewSendInfoWithDic:dic];
     } else{
        DLog(@"—————————userContentController——————— 其他约定协议明");
    }
}

#pragma mark ===
- (void)getShopWebViewSendInfoWithDic:(NSMutableDictionary *)dic{
    NSInteger type = [[dic allKeys] containsObject:@"type"] ?  [[dic objectForKey:@"type"] integerValue] : 0;
    NSString *carNumber = [[dic allKeys] containsObject:@"carNumber"] ? [NSString stringWithFormat:@"%@",[dic objectForKey:@"carNumber"]] : @"";

    switch (type) {
        case 1:
        {
            [self popVC];
        }
            break;
        case 13://carNumber
        {
            [self carPlatOkActionWithCarPlatStr:carNumber];
        }
            break;
            
        default:
            break;
    }
}
 
- (void)carPlatOkActionWithCarPlatStr:(NSString *)carPlatStr{
    DLog(@"");
    if (isNotNil(self.carPlatBlock)) {
        if (carPlatStr.length==0) {
            self.carPlatBlock(@"");
        }else{
            self.carPlatBlock(carPlatStr);
        }
   
    }
    [self popVC];
}
@end
