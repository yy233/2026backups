//
//  BusinessServicesVC.m
//  test
//
//  Created by 余莹 on 2020/11/9.
//  商城

#import "BusinessServicesVC.h"
#import "BusinessServicesData.h"

//
#import "ShippingAddressVC.h"
#import "ShippingAddressData.h"

#define  Color_BuisinessServices_Nav_Red_NavColor           Y_RGBA(252, 80, 71, 1)
#pragma mark ===== 商城主页
#define  URL_Of_BuisinessServices_Main_VC                                  @"http://222.178.212.29/shop/"

#pragma  mark ===============

@interface BusinessServicesVC () <WKScriptMessageHandler,WKUIDelegate,WKNavigationDelegate>
@property (nonatomic,strong)   WKWebView        *webView;
@property (nonatomic,strong)   UIProgressView   *progressView;

@end

@implementation BusinessServicesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBarTransparentStyle];
    [self.navigationController setNavigationBarHidden:YES animated:YES];


//    [self setupNavigationBarClearnTextColorWithBackViewCustomColor:Color_BuisinessServices_Nav_Red_NavColor];
//    [self initNav];
    [self initView];
    [self initKvo];
    [self initData];
    [self initAddScriptMessageHandler];
    [self initNotice];
    [self initSendToToken];
}
#pragma mark === notice
- (void)initNotice{
    [self addNoticeOfAddress];
    [self addNoticeOfPay];
}
- (void)addNoticeOfPay{
    Y_NSNotificationCenter_Creat_NameAction(PaySuccessedEndInfo_Notice_Name, paySuccessNotice:);
    Y_NSNotificationCenter_Creat_NameAction(PayFailEndInfo_Notice_Name, payFailNotice:);
}
- (void)addNoticeOfAddress{
    Y_NSNotificationCenter_Creat_NameAction(Buniess_willPay_To_ChooseAddress, chooseAddressNotice:);
   
}
- (void)dealloc{
    [self dellocAllScriptMessageHandler];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNavigationBarTransparentStyle];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self initSendToToken];//
}
 
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


#pragma mark ===
- (void)initAddScriptMessageHandler{
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"toVideo"];
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"selectAddress"];
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"address"];
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"addressYYY"];

}
- (void)dellocAllScriptMessageHandler{
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"toVideo"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"selectAddress"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"address"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"addressYYY"];
    //
    Y_NSNotificationCenter_RemoveNotice_Name(PaySuccessedEndInfo_Notice_Name);
    Y_NSNotificationCenter_RemoveNotice_Name(PayFailEndInfo_Notice_Name);
    Y_NSNotificationCenter_RemoveNotice_Name(Buniess_willPay_To_ChooseAddress);
}
#pragma mark ===


- (void)initKvo{
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}
#pragma mark == UI
- (void)cityChooseAction{
    DLog(@"");
}
- (void)scanningItemAction{
    DLog(@"");
}
- (void)infoItemAction{
    DLog(@"");
}

#pragma  mark ==  nav
- (void)initNav{
    UIButton *cityItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [cityItem setImage:[UIImage imageNamed:@"Head_Positioning_night"] forState:UIControlStateNormal];
    cityItem.titleLabel.textAlignment = NSTextAlignmentLeft;
    cityItem.titleLabel.font = [UIFont systemFontOfSize:14];
    [cityItem setTitle:@"重庆" forState:UIControlStateNormal];
    [cityItem layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:10];
    [cityItem addTarget:self action:@selector(cityChooseAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cityBarItem = [[UIBarButtonItem alloc]initWithCustomView:cityItem];
    [self.navigationItem setLeftBarButtonItem:cityBarItem];
    //
    UIButton *scanningItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [scanningItem setImage:[UIImage imageNamed:@"Head_Sweepit_night"] forState:UIControlStateNormal];
    scanningItem.bounds = CGRectMake(0 , 0, 24, 24);
    [scanningItem addTarget:self action:@selector(scanningItemAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *scanningItemBar = [[UIBarButtonItem alloc]initWithCustomView:scanningItem];
    UIButton *infoItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [infoItem setImage:[UIImage imageNamed:@"head_news_night"] forState:UIControlStateNormal];
    infoItem.bounds = CGRectMake(0 , 0, 24, 24);
    [infoItem addTarget:self action:@selector(infoItemAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *infoItemBar = [[UIBarButtonItem alloc]initWithCustomView:infoItem];
    
    [self.navigationItem setRightBarButtonItems:@[infoItemBar,scanningItemBar]];
}
- (void)initView{
    [self initWKWebView];
  
    [self initProgressView];
    [self setUI];
}
- (void)setUI{
    UIView *statusView = [[UIView alloc] init];
    statusView.backgroundColor = Y_RGBA(244, 77, 68, 1);
    [self.view addSubview:statusView];
    [statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(statusView.superview);
        make.height.offset(status_height);
    }];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(statusView.mas_bottom);
        make.left.right.equalTo(_webView.superview);
        make.height.offset(Screen_H-KTabBarHeight-status_height);
    }];
}
- (void)initProgressView
{
    CGFloat kScreenWidth = [[UIScreen mainScreen] bounds].size.width;
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, status_height, kScreenWidth, 2)];
    progressView.tintColor = Color_38BlueColor;
    progressView.trackTintColor = [UIColor lightGrayColor];
    [self.view addSubview:progressView];
    self.progressView = progressView;
    
}
- (void)initData{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL_Of_BuisinessServices_Main_VC] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:15.0];//缓存属性
    [_webView loadRequest:request];

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
    
//    NSLog(@"-----------------------------%@",navigationAction.request.URL.absoluteString);
//    NSLog(@"-----WKNavigationDelegate----%@",navigationAction.request.URL.scheme);
//
//    if (![navigationAction.request.URL.absoluteString isEqualToString:URL_Of_BuisinessServices_Main_VC]) {
//        BusinessServicesOthersVC *otherVc = [[BusinessServicesOthersVC alloc]init];
//        otherVc.urlStr = navigationAction.request.URL.absoluteString;
//        otherVc.hidesBottomBarWhenPushed = YES;
//        [self pushVc:otherVc];
//        //
//         decisionHandler(WKNavigationActionPolicyCancel);
//    }else {
//        decisionHandler(WKNavigationActionPolicyAllow);
//    }
//    NSLog(@"other");
    
    NSLog(@"decidePolicyForNavigationAction-------------%@",navigationAction.request.URL.absoluteString);
    decisionHandler(WKNavigationActionPolicyAllow);
}

//接收到相应数据后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
//    DLog(@"decidePolicyForNavigationResponse接收");
//    NSLog(@"decidePolicyForNavigationResponse   ==  %@",navigationResponse.response.URL.absoluteString);
//    if (![navigationResponse.response.URL.absoluteString isEqualToString:URL_Of_BuisinessServices_Main_VC]) {
//        BusinessServicesOthersVC *otherVc = [[BusinessServicesOthersVC alloc]init];
//        otherVc.urlStr = navigationResponse.response.URL.absoluteString;
//        otherVc.hidesBottomBarWhenPushed = YES;
//        [self pushVc:otherVc];
//        //
//        decisionHandler(WKNavigationResponsePolicyCancel);
//    }else {
//        decisionHandler(WKNavigationResponsePolicyAllow);
//    }
//    NSLog(@"other");
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
/**    message.body  --  Allowed types are NSNumber, NSString, NSDate, NSArray,NSDictionary, and NSNull.*/
    NSLog(@"name:%@    body:%@",message.name,message.body);
    
    if ([message.name isEqualToString:@"toVideo"]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:message.body];
        /**支付流程*/
        [self shopCreadOrderWithGetJsDic:dic];
       
    } else if ([message.name isEqualToString:@"selectAddress"]) {
       /**跳转到列表页 回调得到地址 再上传*/
        [self pushToAddressListVc];
    }else if ([message.name isEqualToString:@"address"]) {
           /**跳转到列表页 回调得到地址 再上传*/
            [self pushToAddressListVc];
    }else if ([message.name isEqualToString:@"addressYYY"]) { //caseInsensitiveCompare。
           /**跳转到列表页 回调得到地址 再上传*/
            [self pushToAddressListVc];
       
    } else{
        DLog(@"—————————userContentController———————");
    }
}

#pragma mark === 支付订单新增
- (void)shopCreadOrderWithGetJsDic:(NSMutableDictionary *)parms{
    if ([self shouldShowLoginVcOrBindVcBool]) {//这是最终支付的调用 第一页结算按钮暂无调用 待网页端增方法 
        return;
    }
    NSLog(@"---%@---",parms);
    
//test
//    NSMutableDictionary *parmss = [[NSMutableDictionary alloc]init];
//    [parmss setValue:@"d16df2458ae24e60862c62f5dd5300a2" forKey:@"addressUuid"];
//    [parmss setValue:@"0c9b7441285b41fbb48f6f51be2df002" forKey:@"shopUuid"];
//    [parmss setValue:@"" forKey:@"userRedpacket"];
//    [parms setValue:@"测试描述文本" forKey:@"storeName"];
//    [BusinessServicesData creatOrderWithDic:parmss with:^(NSDictionary * dic, BOOL success) {
    if ( ![[parms allKeys] containsObject:@"storeName"]) {//微信所需要的描述文本"
        [parms setValue:@"wx" forKey:@"storeName"];
    }
  [BusinessServicesData creatOrderWithDic:parms with:^(NSDictionary * dic, BOOL success) {
        if (success) {
            [self shopToPayThisOrderWithJsGetDic:parms withOrderInfoDic:dic.mutableCopy];
        }
    }];
}
#pragma mark === 支付订单已加 处理多种支付方式
- (void)shopToPayThisOrderWithJsGetDic:(NSMutableDictionary *)jsGetDic withOrderInfoDic:(NSMutableDictionary *)dic{
    /**结算 支付 相关*/
    [BusinessServicesData shopOrderInfoToPayWithJsGetDic:jsGetDic andOrderInfo:dic   with:^(NSDictionary * dic, BOOL success) {
        if (success) {
            DLog(@"");//得到系统安排的订单数据-做支付-等待notice
        };
    }];
}

#pragma mark === 地址pushvc
- (void)pushToAddressListVc{
    //游客和没手机号的不可点击到地址页 只做弹出loginVc或绑定vc
    if ([self shouldShowLoginVcOrBindVcBool]) {
        return;
    }
    ShippingAddressVC *vc = [[ShippingAddressVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self pushVc:vc];
}

#pragma mark ==  地址get数据
- (void)chooseAddressNotice:(NSNotification *)notice{
    ShippingAddressModel *model =  [notice.userInfo objectForKey:Notice_UserInfo_Key];
    NSDictionary *addressDic = [model mj_keyValues];
    NSString *addressJsonStr = [Tool jsonStrWithDic:addressDic];
    NSLog(@"dic=%@  \n json=   %@ ",addressDic,addressJsonStr);
  
    NSString *jsStr = [NSString stringWithFormat:@"ocSendToJsWithFunctionName('%@')",addressJsonStr];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            NSLog(@"chooseAddressNotice  ocSendToJsWithFunctionName ==  %@----%@",result, error);
        }];
    });
}
- (void)initSendToToken{
    NSString *tokenS = @"";
    if([ShareUserInfo sharedUserInfo].token!=nil){
        tokenS = [ShareUserInfo sharedUserInfo].token;
    }else if (isNotNil([[NSUserDefaults standardUserDefaults] objectForKey:@"token"])) {
        tokenS =  [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    }else{
        NSLog(@"商城 tokenS = 空");
    }
    
    NSString *jsStr = [NSString stringWithFormat:@"ocSendToJsWithUserTokenName('%@')", tokenS];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            NSLog(@"initSendToToken  ocSendToJsWithUserTokenName ==  %@----%@",result, error);
        }];
    });
}
#pragma mark ==  支付结果
- (void)paySuccessNotice:(NSNotification *)notification{
    Y_SVP_SHOW_SUCCESS_MES(@"支付成功");
}
- (void)payFailNotice:(NSNotification *)notice{
    NSString *failMsg =  [notice.userInfo objectForKey:[notice.userInfo allKeys].firstObject];
    Y_SVP_SHOW_INFO_MES(failMsg);
}

#pragma mark ==
#pragma mark === 判定是否需要弹出登录vc或绑定vc
- (BOOL)shouldShowLoginVcOrBindVcBool{
    WEAKSELF
    STRONGSELF
    if ([IsLoginTool share].save_Login_Type==IS_Login_Tourists) {
        //登录view
        [[IsLoginTool share]willPresentLoginViewControllerWithLoginVCBlock:^(UINavigationController * _Nonnull navc) {
                navc.modalPresentationStyle = UIModalPresentationFullScreen;
                [strongSelf presentViewController:navc animated:YES completion:^{
                    NSLog(@"present弹出登录vc");
                }];
        }];
        return YES;
  
    } else if( [IsLoginTool share].save_Login_Type==IS_Login_UnboundPhone){
        //用三方ID绑定电话
        //苹果 绑定手机操作
        AppleLoginModel *model = [[AppleLoginModel alloc]init];
        model.thirdPlatformId = [IsLoginTool share].appleLoginSaveThridIdWillUseToBindPhone;
        //
        BindingPhoneVC *bindVc = [[BindingPhoneVC alloc]init];
        bindVc.appleUserModel = model;
        bindVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:bindVc animated:YES];
        return YES;
    }
    return NO;
}
//0722
@end
