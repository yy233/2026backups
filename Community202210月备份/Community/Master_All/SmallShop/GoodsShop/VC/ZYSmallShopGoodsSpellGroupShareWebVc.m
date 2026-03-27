//
//  ZYSmallShopGoodsSpellGroupShareWebVc.m
//  Community
//
//  Created by ZY on 2022/3/16.
//

#import "ZYSmallShopGoodsSpellGroupShareWebVc.h"
#import "SmallShopOneGoodsPayVC.h"
#import "SmallShppOrderVC.h"
#import "ZYSmallShopGoodsDetailModel.h"
#import "ZYSmallShopGoodsSpellGroupDetailModel.h"

static NSString *shopWebViewiOSGetJsInfoFunctionName = @"shopWebViewiOSFunction";
static NSString *shopOcSendToJsWithFunctionName = @"ocSendToJsWithFunctionName";

typedef enum : NSUInteger {
    SpellGroup_Type_Back = 1,       //返回
    SpellGroup_Type_ShareWX = 14,   //微信分享
    SpellGroup_Type_Join = 15,      //立即拼团
    SpellGroup_Type_Invite = 16,    //邀请拼团
    SpellGroup_Type_Check = 17      //查看订单
} SpellGroup_Type;

@interface ZYSmallShopGoodsSpellGroupShareWebVc () <UINavigationControllerDelegate,WKScriptMessageHandler,WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation ZYSmallShopGoodsSpellGroupShareWebVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"%@ 特惠拼团", [ShareUserInfo sharedUserInfo].commuityInfo.name];
    // pop返回手势
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [self initAll];
}

- (void)viewWillAppear:(BOOL)animated {
   [super viewWillAppear:animated];
   
   self.view.backgroundColor = [UIColor zy_colorWithHexString:@"#F0F1F6"];
   [self hiddenNavigationBar];
    
    [self initAddScriptMessageHandler];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self deallocAllScriptMessageHandler];
    [self setupNavigationBarClearTransparentStyle];
}

- (void)setUI{
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_webView.superview);
    }];
}

#pragma mark === webView addScriptMessageHandler
- (void)initAddScriptMessageHandler {
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:shopWebViewiOSGetJsInfoFunctionName];
}

- (void)deallocAllScriptMessageHandler{
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:shopWebViewiOSGetJsInfoFunctionName];
}

#pragma mark === all init
- (void)initAll{
    [self initView];
    [self initData];
 }

#pragma mark == UI
- (void)initView{
    [self initWKWebView];
    [self setUI];
}

- (void)initData{
    NSString *token = [ShareUserInfo sharedUserInfo].token;
    NSInteger height = status_height*2;
    NSString *paramStr = [NSString stringWithFormat:@"?statusHeight=%ld&token=%@&communityId=%@&spellId=%@&temp=111",height,token,self.communityId,self.spellId];
    NSString *utf8ParamStr = [paramStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *allUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kShellGroupWeb, utf8ParamStr]];
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
        [webView evaluateJavaScript:@"document.body.style.backgroundColor=\"#f0f1f6\"" completionHandler:nil];
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
    ZYSmallShopGoodsSpellGroupDetailModel *model = [ZYSmallShopGoodsSpellGroupDetailModel yy_modelWithJSON:dic[@"data"]];
    ZYSmallShopGoodsDetailModel *model1 = [[ZYSmallShopGoodsDetailModel alloc] init];
    ZYSmallShopGoodsDetailPayModel *payModel = [[ZYSmallShopGoodsDetailPayModel alloc] init];
    ZYSmallShopGoodsDetailDataInfoModel *infoModel = [[ZYSmallShopGoodsDetailDataInfoModel alloc] init];
    model1.ID = model.commodityId;
    model1.spellId = model.spellId;
    model1.commodityName = model.commodityName;
    model1.commodityHeadImg = model.commodityHeadImg;
    payModel.commoditySellPrice = model.groupSpellPrice;
    payModel.commodityOriginalPrice = model.commodityOriginalPrice;
    payModel.actualPrice = model.groupSpellPrice;
    infoModel.storeAddress = model.storeAddress;
    infoModel.storePhone = model.storePhone;
    infoModel.longitude = model.longitude;
    infoModel.latitude = model.latitude;
    model1.payDto = payModel;
    model1.informationDto = infoModel;
    NSLog(@"type=%ld", type);
    if (type == SpellGroup_Type_Back) {
        [self popVC];
        [self deallocAllScriptMessageHandler];
    }else if (type == SpellGroup_Type_ShareWX) {
        NSLog(@"微信分享");
        [self shareWX:dic];
    }else if (type == SpellGroup_Type_Join) {
        NSLog(@"立即拼团");
        SmallShopOneGoodsPayVC *vc = [[SmallShopOneGoodsPayVC alloc] init];
        vc.nowGoodsSeviceBoxType = SmallShopOneGoodsPayVC_Type_SpellGroupActivities;
        vc.detailVcUseModelDic = [NSMutableDictionary dictionaryWithDictionary:[model1 yy_modelToJSONObject]];
        [self pushVc:vc];
        [self deallocAllScriptMessageHandler];
    }else if (type == SpellGroup_Type_Invite) {
        NSLog(@"邀请拼团");
    }else if (type == SpellGroup_Type_Check) {
        NSLog(@"查看订单");
        SmallShppOrderVC *vc = [[SmallShppOrderVC alloc]init];
        [self pushVc:vc];
        [self deallocAllScriptMessageHandler];
    }
}

// 微信分享
- (void)shareWX:(NSDictionary *)dict {
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    WXWebpageObject *webpageObject = [[WXWebpageObject alloc] init];
    webpageObject.webpageUrl = dict[@"webpageUrl"];
    WXMediaMessage *message = [[WXMediaMessage alloc] init];
    message.title = dict[@"title"];
    message.description = dict[@"description"];
    [message setThumbImage:[UIImage imageNamed:dict[@"imagePath"]]];
    message.mediaObject = webpageObject;
    req.bText = NO;
    req.message = message;
    // 目标场景
    // 发送到聊天界面  WXSceneSession
    // 发送到朋友圈    WXSceneTimeline
    // 发送到微信收藏  WXSceneFavorite
    NSNumber *shareType = dict[@"shareType"];
    if ([shareType integerValue] == 1) {
        req.scene = WXSceneSession;
    }else if ([shareType integerValue] == 2) {
        req.scene = WXSceneTimeline;
    }
    [WXApi sendReq:req completion:^(BOOL success) {
        if (success) {
            NSLog(@"分享成功");
        }else {
            Y_SVP_SHOW_ERR_MES(@"分享失败");
        }
    }];
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

@end
