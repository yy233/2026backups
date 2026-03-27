//
//  ZYLifeCostBindHouseholdWebVC.m
//  Community
//
//  Created by ZY on 2022/1/11.
//

#import "ZYLifeCostBindHouseholdWebVC.h"
#import "LifeCostMainVC.h"
#import "YMCitySelect.h"
#import "PaymentCompanyListVC.h"
#import "ZYLifeCostAddGroupVC.h"
#import "ZYLifeCostPaymentAgreementVC.h"
#import "LifeCostPayOrderDetailWithNotHaveMoneyNumCanSaveMoneyToPayDetailVc.h"//直接缴费详情页
#import "LifeCostMainVcTopGroupSubAccountEntityModel.h"//直接缴费详情页用到的数据model


static NSString *shopWebViewiOSGetJsInfoFunctionName = @"shopWebViewiOSFunction";
static NSString *shopOcSendToJsWithFunctionName = @"ocSendToJsWithFunctionName";

typedef enum : NSUInteger {
    LifeCost_GetTypeNum_SelectCity = 7, //选择城市
    LifeCost_GetTypeNum_SelectCompany = 8, //选择缴费单位
    LifeCost_GetTypeNum_SelectGroup = 9, //选择分组
    LifeCost_GetTypeNum_DirectPayment = 10, //直接缴费
    LifeCost_GetTypeNum_PaymentAgreement = 11, //缴费协议
    LifeCost_GetTypeNum_HouseholdBindSuccess = 12 //户号绑定成功
    
} LifeCost_GetTypeNum;

@interface ZYLifeCostBindHouseholdWebVC () <UINavigationControllerDelegate,WKScriptMessageHandler,WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) WKWebView *webView;

//@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation ZYLifeCostBindHouseholdWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"新增%@", self.typeModel.typeName];
    [self initAll];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self navigationBarStyleWithThemeColorChanged:[ZYThemeManager shareManager].navigationBarBackgroundThemeColor_Lf0f1f6_D001534];
    self.view.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor_Lf0f1f6;
    
    [self initAddScriptMessageHandler];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self deallocAllScriptMessageHandler];
}

#pragma mark === dealloc
- (void)dealloc{
    [self deallocNotices];
    self.navigationController.delegate = nil;
}

- (void)deallocAllScriptMessageHandler{
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:shopWebViewiOSGetJsInfoFunctionName];
}

- (void)deallocNotices{
    Y_NSNotificationCenter_RemoveNotice_Name(@"LIFE_COST_SELSECT_COMPANY_BACK")
    Y_NSNotificationCenter_RemoveNotice_Name(@"LIFE_COST_SELSECT_GOURP_BACK")
}

#pragma mark === notice
- (void)initNotice{
    [self addNoticeOfPay];
}

- (void)addNoticeOfPay{
    // 注册选择缴费单位通知
    Y_NSNotificationCenter_Creat_NameAction(@"LIFE_COST_SELSECT_COMPANY_BACK", lifeCostSelectCompanyBack:)
    // 注册选择户号分组通知
    Y_NSNotificationCenter_Creat_NameAction(@"LIFE_COST_SELSECT_GOURP_BACK", lifeCostSelectGourpBack:)
}

// 选择公司回调
- (void)lifeCostSelectCompanyBack:(NSNotification *)noti {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *cityJsStr = [NSString stringWithFormat:@"setCityName('%@')", self.cityName];
        [self.webView evaluateJavaScript:cityJsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            NSLog(@"%@---%@", result, error);
        }];
        PaymentCompanyUseShowModel *model = noti.object;
        self.companyModel = model;
        NSString *paramJsonStr = [self convertToJsonData:model.mj_keyValues];
        NSString *jsStr = [NSString stringWithFormat:@"setCommpany(%@)", paramJsonStr];
        [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            NSLog(@"%@---%@", result, error);
        }];
    });
}

// 选择分组回调
- (void)lifeCostSelectGourpBack:(NSNotification *)noti {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dict = noti.userInfo;
        NSString *groupId = dict[@"groupId"];
        NSString *groupName = dict[@"groupName"];
        NSString *jsStr = [NSString stringWithFormat:@"setGroup('%@', '%@')", groupId, groupName];
        [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            NSLog(@"%@---%@", result, error);
        }];
    });
}

#pragma mark === webView addScriptMessageHandler
- (void)initAddScriptMessageHandler {
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:shopWebViewiOSGetJsInfoFunctionName];
}

#pragma mark === all init
- (void)initAll{
    [self initView];
    [self initData];
    [self initNotice];
 }

#pragma mark == UI
- (void)initView{
    [self initWKWebView];
    [self setUI];
//    [self initProgressView];
}

//- (void)initProgressView {
//    //进度条初始化
//    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 2)];
//    self.progressView.tintColor = Color_38BlueColor;
//    self.progressView.trackTintColor = [UIColor lightGrayColor];
//    [self.view addSubview:self.progressView];
//    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
//}

- (void)setUI{
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_webView.superview);
    }];
}

- (void)initData{
    NSString *token = [ShareUserInfo sharedUserInfo].token;
    NSInteger height = status_height*2;
    NSString *jsonStr = [self convertToJsonData:self.companyModel.mj_keyValues];
    NSInteger themeType; //主题色
    if ([ZYThemeManager shareManager].themeType == ZYThemeType_White) {
        themeType = 1;
    }else {
        themeType = 0;
    }
    NSString *paramStr = [NSString stringWithFormat:@"?statusHeight=%ld&themeType=%ld&token=%@&cityName=%@&type=%ld&payTypeName=%@&payTypeIcon=%@&companyData=%@",height,themeType,token,self.cityName,self.typeModel.type,self.typeModel.typeName,self.typeModel.picUrlClient,jsonStr];
    NSString *utf8ParamStr = [paramStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *allUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kLifeCostBindHouseholdWebUrl, utf8ParamStr]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:allUrl cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:15.0];//缓存属性
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
    [_webView loadRequest:request];
}

#pragma mark ==== webv
- (void)initWKWebView {
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
  // 创建设置对象
    WKPreferences *preference = [[WKPreferences alloc] init];
    //最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
    preference.minimumFontSize = 0;
    //设置是否支持javaScript 默认是支持的
    preference.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
//    preference.javaScriptCanOpenWindowsAutomatically = YES;
    preference.javaScriptCanOpenWindowsAutomatically = NO;
    configuration.preferences = preference;
    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];
    self.webView.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor_Lf0f1f6;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.webView.scrollView.delegate = self;
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    self.webView.hidden = YES;
    [self.view addSubview:self.webView];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[self.webView.scrollView class]]) {
        //防止左右滚动
        CGPoint point = scrollView.contentOffset;
        scrollView.contentOffset = CGPointMake(0, point.y);
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
        if ([ZYThemeManager shareManager].themeType == ZYThemeType_White) {
            [webView evaluateJavaScript:@"document.body.style.backgroundColor=\"#f0f1f6\"" completionHandler:nil];
        }else {
            [webView evaluateJavaScript:@"document.body.style.backgroundColor=\"#001534\"" completionHandler:nil];
        }
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        Y_SVP_DISMISS
        self.webView.hidden = NO;
    });
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
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    alert.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"MessageHandler Name:%@", message.name);
    NSLog(@"MessageHandler Body:%@", message.body);
    if ([message.name isEqualToString:shopWebViewiOSGetJsInfoFunctionName]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:message.body];
        [self getShopWebViewSendInfoWithDic:dic];
     } else{
        DLog(@"—————————userContentController———————其他约定协议明");
    }
}

#pragma mark === web交互处理
- (void)getShopWebViewSendInfoWithDic:(NSDictionary *)dic{
    if ([self shouldShowLoginVcOrBindVcBool]) {
        return;
    }
    NSString *typeStr = dic[@"type"];
    NSInteger type = [typeStr integerValue];
    if (type == LifeCost_GetTypeNum_SelectCity) {
        NSLog(@"选择城市");
        PaymentCompanyListVC *vc = [[PaymentCompanyListVC alloc]init];
        vc.payTypeIdStr = [NSString stringWithFormat:@"%ld", self.typeModel.type];
        vc.saveNowCityTextStr = self.cityName;
        vc.typeModel = self.typeModel;
        [self pushVc:vc];
    }else if (type == LifeCost_GetTypeNum_SelectCompany) {
        NSLog(@"选择缴费单位");
        PaymentCompanyListVC *vc = [[PaymentCompanyListVC alloc]init];
        vc.payTypeIdStr = [NSString stringWithFormat:@"%ld", self.typeModel.type];
        vc.saveNowCityTextStr = self.cityName;
        vc.typeModel = self.typeModel;
        [self pushVc:vc];
    }else if (type == LifeCost_GetTypeNum_SelectGroup) {
        NSLog(@"选择分组");
        ZYLifeCostAddGroupVC *vc = [[ZYLifeCostAddGroupVC alloc] init];
        vc.type = ZYLife_Cost_Type_AddHousehold;
        [self pushVc:vc];
    }else if (type == LifeCost_GetTypeNum_PaymentAgreement) {
        NSLog(@"缴费协议");
        ZYLifeCostPaymentAgreementVC *vc = [[ZYLifeCostPaymentAgreementVC alloc] init];
        [self pushVc:vc];
    }else if (type == LifeCost_GetTypeNum_HouseholdBindSuccess) {
        // 户号
        NSString *account = dic[@"account"];
        // 业务流程
        NSNumber *businessFlow = dic[@"businessFlow"];
        //if ([businessFlow integerValue] == 1) {//重庆的直接缴费后台状态为0
        if ([businessFlow integerValue] == 1 || [self.companyModel.paymentItemName containsString:@"电信"] || [self.companyModel.paymentItemName containsString:@"联通"] || [self.companyModel.paymentItemName containsString:@"移动"]) {
            NSLog(@"直接缴费");
            LifeCostMainVcTopGroupSubAccountEntityModel *willUserModel = [[LifeCostMainVcTopGroupSubAccountEntityModel alloc]init];
            willUserModel.account = account;
            willUserModel.itemCode = self.companyModel.paymentItemCode;
            willUserModel.itemId = self.companyModel.paymentItemId;
            willUserModel.typeId = [NSString stringWithFormat:@"%ld", self.typeModel.type];
            willUserModel.typePicUrl = self.typeModel.picUrlClient;
            LifeCostPayOrderDetailWithNotHaveMoneyNumCanSaveMoneyToPayDetailVc *vc = [[LifeCostPayOrderDetailWithNotHaveMoneyNumCanSaveMoneyToPayDetailVc alloc]init];
            vc.mianVcGroupListSubOrderModel = willUserModel;
            [self pushVc:vc];
        }else {
            NSLog(@"户号绑定成功");
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[LifeCostMainVC class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
        }
        Y_NSNotificationCenter_PostNotice_NilObject_Name(@"LIFE_COST_CHANGE_GROUP_BACK")
    }
}

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

#pragma mark - 字典转json字符串方法
- (NSString *)convertToJsonData:(NSDictionary *)dict {
    if (!isNotNil(dict)) {
        return @"";
    }
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
}

//#pragma mark - KVO进度条监听事件
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
//    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
//        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
//        if (newprogress == 1) {
//            [self.progressView setProgress:1.0 animated:YES];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                self.progressView.hidden = YES;
//                [self.progressView setProgress:0 animated:NO];
//            });
//
//        }else {
//            self.progressView.hidden = NO;
//            [self.progressView setProgress:newprogress animated:YES];
//        }
//    }
//}

@end
