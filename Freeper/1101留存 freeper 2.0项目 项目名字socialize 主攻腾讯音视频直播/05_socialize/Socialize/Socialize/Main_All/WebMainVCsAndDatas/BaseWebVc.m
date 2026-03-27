//
//  BaseWebVc.m
//  Socialize
//
//  Created by 余莹 on 2023/6/6.
//

#import "BaseWebVc.h"
#import "MainTabbarControll.h"
#import "DappUseBaseVc.h"
#import "MySetTool.h"
#import "MySubsWebVc.h"

#import "TUIChatConversationModel.h"
#import "ImChatVc.h"
#import "TUIC2CChatViewController_Minimalist.h"
#import <TUIGroupChatViewController_Minimalist.h>
#import "LiveRoomBase.h"
#pragma mark ==============================WeakWebViewScriptMessageDelegate====== 注入用的 响应相关协议 注入log时使用 调用 OC 的方法监听
static NSString *addLogjs = @"console.log = function(message){window.webkit.messageHandlers['log'].postMessage(message)};";//新声明console.log:
static NSString *logJsOfGetInfoMsgName = @"log";
// WKWebView 内存不释放的问题解决
@interface BaseWeakWebViewScriptMessageDelegate : NSObject<WKScriptMessageHandler>

//WKScriptMessageHandler 这个协议类专门用来处理JavaScript调用原生OC的方法
@property (nonatomic, weak) id<WKScriptMessageHandler> scriptDelegate;

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;

@end



@implementation BaseWeakWebViewScriptMessageDelegate

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate {
self = [super init];
if (self) {
    _scriptDelegate = scriptDelegate;
}
return self;
}

#pragma mark - WKScriptMessageHandler
//遵循WKScriptMessageHandler协议，必须实现如下方法，然后把方法向外传递
//通过接收JS传出消息的name进行捕捉的回调方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString: logJsOfGetInfoMsgName]) {
        //  message.body   是 `js` 传递的参数 ,一般是 json 字符串
        NSLog(@"base WeakWebViewScriptMessageDelegate -logJsOfGetInfoMsgName-name %@ ,-- MessageBody: %@",message.name, message.body);
    }else{
        NSLog(@"base WeakWebViewScriptMessageDelegate --name %@ ,-- MessageBody: %@",message.name, message.body);
        
    }
    if ([self.scriptDelegate respondsToSelector:@selector(userContentController:didReceiveScriptMessage:)]) {
        [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
    }
}

@end

#pragma mark ==============================WeakWebViewScriptMessageDelegate====== 注入用的 响应相关协议 注入log时使用 调用 OC 的方法监听
/**
 调用网页方法 window.methodRouter({event, data}),  网页数据上报数据格式 {id, status, message?, data?}
 
 页面加载成功 CallBackType 200， 错误 500

 */



#pragma mark  ============================================================ BaseWebVc

@interface BaseWebVc () <UINavigationControllerDelegate,WKScriptMessageHandler,WKUIDelegate,WKNavigationDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIProgressView   *progressView;

@end

@implementation BaseWebVc

/*
 * 判断是否白屏(WKCompositingView不存在)
 * YES：blank
 */
- (BOOL)isBlankView:(UIView*)view{
    
    return  YES;
}
//- (BOOL)isBlankView:(UIView*)view
//{
//    //NSLog(@"root:%@", NSStringFromClass(view.class));
//    Class wkCompositingView = NSClassFromString(@"WKCompositingView");
//    if ([view isKindOfClass:[wkCompositingView class]])
//    {
//        return NO;
//    }
//    for (UIView *subView in view.subviews)
//    {
//        //NSLog(@"child:%@", NSStringFromClass(subView.class));
//        if (![self isBlankView:subView])
//        {
//            return NO;
//        }else{//有
//
//            return YES;
//            /**
//             //view.backgroundColor = [UIColor cyanColor];//换颜色
//             //subView.backgroundColor = [UIColor greenColor];
//             for (UIView *subViewTwoJi in subView.subviews)
//             {
//
//                 if (![self isBlankView:subView])
//                 {
//                     return  NO;
//                 }else{//有
//                    // subViewTwoJi.backgroundColor = [UIColor purpleColor];//换颜色
//                     for (UIView *subViewThrJi in subViewTwoJi.subviews)
//                     {
//                         //subViewThrJi.backgroundColor = [UIColor redColor];//换颜色
//                     }
//
//                 }
//             }
//             return YES;
//             */
//            //NSLog(@"判断是否白屏(WKCompositingView不存在) ---- view %@",view);
//
//        }
//    }
//
//    return YES;
//}

 
#pragma mark === nav

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断如果是需要隐藏导航控制器的类，则隐藏
    DLog(@"判断如果是需要隐藏导航控制器的类，则隐藏");
    BOOL isHideNav = ([viewController isKindOfClass:[self class]]);// 隐藏了nav用的view
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


- (void)addLogAddScripMes{
    //用于进行JavaScript注入log方法获取
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:addLogjs injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
    NSLog(@"addlog js %@",addLogjs);//重写js中的console.log方法，在重写的方法中触发调用原生方法，将log的输出内容传递出去。
    [self.webView.configuration.userContentController  addUserScript:wkUScript];
    //BaseWeakWebViewScriptMessageDelegate *weakScriptMessageDelegate = [[BaseWeakWebViewScriptMessageDelegate alloc] init];
   // [self.webView.configuration.userContentController addScriptMessageHandler:weakScriptMessageDelegate name:logJsOfGetInfoMsgName];
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:logJsOfGetInfoMsgName];
     
    
    [self addOtherJavaScript];
}
- (void)addOtherJavaScript{
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isGoSubVcDontDealTabbarsHidenOrShow = YES;//全部初始时 不响应处理传入的1005
    self.agreeLoadNum = 0;
    self.walletLoadFinishedBool  = NO;
    // pop返回手势
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [self initAll];
    [self addLogAddScripMes];
    if([[ShareLocale shared].nowThemeStr isEqualToString:Now_Theme_dark]){
        self.view.backgroundColor = [Y_ToolOfOthers getColorWithHexString:Theme_Bk_COlOR_Drak_Str];
        self.webView.backgroundColor = self.view.backgroundColor;
    }else if ([[ShareLocale shared].nowThemeStr isEqualToString:Now_Theme_light]){
        self.view.backgroundColor = [Y_ToolOfOthers getColorWithHexString:Theme_Bk_COlOR_Light_Str];
        self.webView.backgroundColor = self.view.backgroundColor;
    }else{
        NSLog(@"   [[ShareLocale shared] saveNowThemeTypeStr:valueStr];");
    }
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];//不需要显示nav
    
}
 
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

#pragma mark === dealloc
- (void)dealloc{
    [self dellocAllScriptMessageHandler];
    [self dellocNotices];
    self.navigationController.delegate = nil;
    
}
- (void)dellocAllScriptMessageHandler{
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:kOCGetJsInfoFunction];
    [self.popWebView.configuration.userContentController removeScriptMessageHandlerForName:kOCGetJsInfoFunction];

    [self dellocOtherScriptMessageHandler];
}
- (void)dellocOtherScriptMessageHandler{
    
}
- (void)dellocNotices{
    Y_NSNotificationCenter_RemoveNotice_Name(WebView_Langeuge_Change_NoticeName);
    Y_NSNotificationCenter_RemoveNotice_Name(WebView_Theme_Change_NoticeName);
    [self dellocOtherNotices];
}
- (void)dellocOtherNotices{
    
}

#pragma mark === notice
- (void)initLanguageChangeNotice{
    Y_NSNotificationCenter_Creat_NameAction(WebView_Langeuge_Change_NoticeName, noticeLanguageChange);
    Y_NSNotificationCenter_Creat_NameAction(WebView_Theme_Change_NoticeName, noticeThemeChange);
     [self initOtherNotices];
}
- (void)initOtherNotices{
    
}

- (void)noticeLanguageChange{
    
    [self otherLanguageChangeAction];
}
#define  kTheme_Type_Key   @"Theme_Type"
- (void)noticeThemeChange{
    [self noticeLanguageChange];//部分url重载在这个位置
    //changebk
    
//    [self updateStatusBarStyleIsWhite:NO];
    
    NSString *nowThemeStr =  [[NSUserDefaults standardUserDefaults] objectForKey:kTheme_Type_Key];//Theme_Type #define  kTheme_Type_Key   @"Theme_Type"
    [[ShareLocale shared]saveNowThemeTypeStr:nowThemeStr];
    if([nowThemeStr isEqualToString: @"light"]){
        self.view.backgroundColor = [Y_ToolOfOthers getColorWithHexString:@"#F8F8F8"];
        
    }else{
        self.view.backgroundColor = [Y_ToolOfOthers getColorWithHexString:@"#1B1A27"];
    }

    [self otherThemeChangAction];
}

//给钱包页面用的 0824 换成给所有用的

- (void)otherThemeChangAction{
    NSLog(@" otherThemeChangAction ");
    //判断 发现页 用的kOcSendToJsFunction_marketApiCall 其他dealQRresStrInfoWithDataDic
    NSString *apiStr = @"";
    //WebVc_Base_URL  WebVc_Base_walletUse_URL
    //if([self.thisVcUseUrlStr containsString:FaXian_VC_Url_Sufx_Index]){
    
    if([self.webView.URL.absoluteString containsString:WebVc_Base_walletUse_URL]){
        apiStr = kOcSendToJsFunction_apiCall;
    }else{
        apiStr = kOcSendToJsFunction_marketApiCall;
    }
    
    NSMutableDictionary *changeT = @{}.mutableCopy;
    NSString *timeIvStr = [YTimeStamp getNowTimeTimestamp_haoMiao];
    NSString *toStr;
    if([apiStr isEqualToString:kOcSendToJsFunction_apiCall]){
        toStr = @"WALLET";
    }else{
        toStr = @"MARKET";
    }
    NSString *types = @"req";
    NSString *refers = @"PLATFORM";
    
    [changeT setValue:timeIvStr forKey:@"id"];
    [changeT setValue:toStr forKey:@"to"];
    [changeT setValue:types forKey:@"type"];
    [changeT setValue:refers forKey:@"refer"];
    [changeT setValue:@(5000) forKey:@"timeout"];
    
    
    NSDictionary *subDic = @{
        @"method":kOcSendToJsFunction_apiCall_methodObj_setTheme,
        @"param": [ShareLocale shared].nowThemeStr
    };
    
    
    [changeT setValue:subDic forKey:@"data"];
    
    
     NSString * jsDataStr = [Y_ToolOfOthers jsonStrWithDic:changeT];
     DLog(@"发送的 设置主题功能—————————dic : %@ \n  ————— jsDataStr : %@  \n ",changeT,jsDataStr);
    DLog(@"发送的 设置主题功能 当前的url是 -- %@ \n",self.webView.URL.absoluteString);
 
    NSString *jsStr = [NSString stringWithFormat:@"%@(%@)", apiStr,jsDataStr];
    NSLog(@"jsStr ---- 88888   %@",jsStr);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            NSLog(@"发送的 设置主题功能———— — 数据回复 jsDataStr1 %@：result=%@ ，error：%@",jsDataStr,result, error);
            WebViewUseDataModelSubDataModel *model = [WebViewUseDataModelSubDataModel mj_objectWithKeyValues:result];
            if(model.status == 200){
                NSLog(@"status 200 成功")
            }else{
                NSLog(@"status %ld",model.status);
            }
        }];
         
    });
}
- (void)otherLanguageChangeAction{
    NSLog(@" otherLanguageChangeAction ");
    NSString *apiStr = @"";
//    if([self.thisVcUseUrlStr containsString:FaXian_VC_Url_Sufx_Index]){
//        apiStr = kOcSendToJsFunction_marketApiCall;
//    }else{
//        apiStr = kOcSendToJsFunction_apiCall;
//    }
    if([self.webView.URL.absoluteString containsString:WebVc_Base_walletUse_URL]){
        apiStr = kOcSendToJsFunction_apiCall;
    }else{
        apiStr = kOcSendToJsFunction_marketApiCall;
    }
    
    NSMutableDictionary *goWDic = @{}.mutableCopy;
    NSString *timeIvStr = [YTimeStamp getNowTimeTimestamp_haoMiao];
    NSString *toStr;
    if([apiStr isEqualToString:kOcSendToJsFunction_apiCall]){
        toStr = @"WALLET";
    }else{
        toStr = @"MARKET";
    }

    NSString *types = @"req";
    NSString *refers = @"PLATFORM";
    
    [goWDic setValue:timeIvStr forKey:@"id"];
    [goWDic setValue:toStr forKey:@"to"];
    [goWDic setValue:types forKey:@"type"];
    [goWDic setValue:refers forKey:@"refer"];
    [goWDic setValue:@(5000) forKey:@"timeout"];

    NSString *nowLangStr = [[ShareLocale shared].nowLocaleTypeStr isEqualToString:@"ko"] ? @"korean" : [ShareLocale shared].nowLocaleTypeStr;
    NSDictionary *pingDic_Sub_DataDic = @{
        @"method":kOcSendToJsFunction_apiCall_methodObj_setLangue,
        @"param": nowLangStr
    };
    
    [goWDic setValue:pingDic_Sub_DataDic forKey:@"data"];
    
     NSString * jsDataStr = [Y_ToolOfOthers jsonStrWithDic:goWDic];

     NSString *jsStr = [NSString stringWithFormat:@"%@(%@)", apiStr,jsDataStr];
    DLog(@"发送的 设置语言功能——  当前的url是 -- %@ \n",self.webView.URL.absoluteString);

    DLog(@"发送的 设置语言功能—————————dic : %@ \n  ————— jsDataStr : %@  \n ",goWDic,jsStr);

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            NSLog(@"发送的 设置语言功能———— — 数据回复 jsDataStr %@：result=%@ ，error：%@",jsDataStr,result, error);
            WebViewUseDataModelSubDataModel *model = [WebViewUseDataModelSubDataModel mj_objectWithKeyValues:result];
            if(model.status == 200){
                NSLog(@"status 200 成功")
            }else{
                NSLog(@"status %ld",model.status);
            }
        }];
    });
}
//- (void)otherLanguageChangeAction{
//}
//- (void)otherThemeChangAction{
//}

 
- (UIStatusBarStyle)preferredStatusBarStyle{
    if([[ShareLocale shared].nowThemeStr isEqualToString: Now_Theme_light]){
        return UIStatusBarStyleDarkContent ;//黑色内容
    }else{
        return UIStatusBarStyleLightContent;//白色内容
    }
    /**
     navigationBar的setBarTintColor接口，用此接口可改变statusBar的背景色

     注意：一旦你设置了navigationBar的- (void)setBackgroundImage:(UIImage *)backgroundImage forBarMetrics:(UIBarMetrics)barMetrics接口，那么上面的setBarTintColor接口就不能改变statusBar的背景色，statusBar的背景色就会变成纯黑色。*/
}


//- (UIColor *)navColorOne{
//    return [UIColor blackColor];
//}
///// 更新状态栏颜色
//- (void)updateStatusBarStyleIsWhite:(BOOL)isWhite{
//    //修改隐藏导航栏后，状态栏颜色还原
//    UIColor *bgColor = UIColor.whiteColor;
//    if (self.navColorOne.length && !isWhite) {
//        bgColor = self.navColorOne;
//    }
//    if (@available(iOS 13.0, *)) {
//        if (![[UIApplication sharedApplication].keyWindow.subviews containsObject:self.statusBar]) {
//            [[UIApplication sharedApplication].keyWindow addSubview:self.statusBar];
//        }
//        self.statusBar.backgroundColor = bgColor;
//    } else {
//        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
//        if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
//            statusBar.backgroundColor = bgColor;
//        }
//    }
//}

//


 
#pragma mark === webView addScriptMessageHandler
- (void)initAddScriptMessageHandler{
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:kOCGetJsInfoFunction];
    [self.popWebView.configuration.userContentController addScriptMessageHandler:self name:kOCGetJsInfoFunction];

}

#pragma mark === all init
- (void)initAll{
    [self initView];
    [self initData];
    [self initAddScriptMessageHandler];
//    [self initSetUserInfoWithGetBodyDic:(NSDic)bodyDic];//改到在1002处 加载完成后调用
    [self initLanguageChangeNotice];
    
}
 

- (void)initSetUserInfoWithGetBodyDic:(NSDictionary *)bodyDic{
    if(isNil( [ShareUserInfo share].userInfo.token)){
        NSLog(@"无token信息 无需注入");
        //0825隐藏
        //NSString *shwoPleseLogin = Y_LocaleTypeFile_NSLocalString(@"请登录");
        //Y_SVP_SHOW_INFO_MES_5Delay(shwoPleseLogin);//调起登录相关签名
        return;
    }else{
        //处理info
        
        WebViewUseDataModel *modell = [WebViewUseDataModel mj_objectWithKeyValues:bodyDic];
    
        NSString *idStr = [TextShowWithModelStr textShowWithModelStr: modell.ID];
        
        NSDictionary *userDic = [[ShareUserInfo share].userInfo mj_keyValues];
        NSDictionary *loginDic = @{
            @"id":idStr,
            @"refer":@"PLATFORM",
            @"to":@"MARKET",
            @"timeout":@(300000),
            @"type":@"req",
            @"data": @{@"method":@"login",
                          @"param":userDic}
        };
        NSLog(@"   setUserInfoData  1 bodyDic ====  %@",bodyDic);

        NSLog(@"   setUserInfoData  2 loginDic ====  %@",loginDic);

        //NSString *willSendDataJsonStr = [Y_ToolOfOthers jsonStrWithDic:userDic];
        
        NSString *willSendDataJsonStr = [Y_ToolOfOthers jsonStrWithDic:loginDic];
        
        NSString *funcName = kOcSendToJsFunction_apiCall;
        if([self.thisVcUseUrlStr containsString:FaXian_VC_Url_Sufx_Index]){//|| [self.thisVcUseUrlStr containsString:TuiJian_VC_Url] 推荐页面的url是base 无法判断 本marketApiCall方法的initSetUserInfo数据在该vc重写
            funcName = kOcSendToJsFunction_marketApiCall;
        }        
        NSString *jsStr = [NSString stringWithFormat:@"%@(%@)", funcName ,willSendDataJsonStr];//apicall
        NSLog(@"kOcSendToJsFunct    \n  setUserInfoData   ===== jsStr :  \n %@",jsStr);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                NSLog(@" 得到数据 kOcSendToJsFunction_setUserInfoData   ==  %@----%@",result, error);
                WebViewUseDataModelSubDataModel *model = [WebViewUseDataModelSubDataModel mj_objectWithKeyValues:result];
                if(model.status == 200){
                 NSLog(@"setUserInfo 成功")
                }else{
                 NSLog(@"setUserInfo status %ld",model.status);
                }
            }];
         });
 
    }
     
}
#pragma mark ==

- (void)initView{
    [self initSelfViews];
    [self initWKWebView];
    [self initPopWebView];
    [self setUI];
    
    [self initProgressView];
}

- (void)initProgressView {
    //进度条初始化
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, kStatusBar_Height, [[UIScreen mainScreen] bounds].size.width, 2)];
    self.progressView.tintColor = Color_Socialize_GreenColor;
    self.progressView.trackTintColor = [UIColor lightGrayColor];
    [self.view addSubview:self.progressView];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}


- (void)initData{
//    NSString *token = [ShareUserInfo sharedUserInfo].token;
//    NSInteger height = status_height*2;
    if(isNil((self.thisVcUseUrlStr))){
        return;
    }
//    if([self.thisVcUseUrlStr containsString:@"//app"]){//dapp的子页面类型 所有都加载
        NSMutableURLRequest *popUserequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:WebView_LoginView_Url] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:15.0];//缓存属性
        [_popWebView loadRequest:popUserequest];
        NSLog(@" initData    _popWebView  ");
//    }
    
    NSString *allUrlStr = self.thisVcUseUrlStr;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:allUrlStr] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:15.0];//缓存属性
    [_webView loadRequest:request];

}

#pragma mark === bk top green view
- (void)initSelfViews{//推荐发现才做
}


#pragma mark ==== webv
- (void)initWKWebView
{
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
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
    
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, KNavBarHeight, Screen_W,self.view.frame.size.height-KNavBarHeight) configuration:configuration];

//    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];

    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    
    
    if([[ShareLocale shared].nowThemeStr isEqualToString:Now_Theme_dark]){
        self.view.backgroundColor = [Y_ToolOfOthers getColorWithHexString:Theme_Bk_COlOR_Drak_Str];
        self.webView.backgroundColor = self.view.backgroundColor;
    }else if ([[ShareLocale shared].nowThemeStr isEqualToString:Now_Theme_light]){
        self.view.backgroundColor = [Y_ToolOfOthers getColorWithHexString:Theme_Bk_COlOR_Light_Str];
        self.webView.backgroundColor = self.view.backgroundColor;
    }else{
        NSLog(@"   [[ShareLocale shared] saveNowThemeTypeStr:valueStr];");
    }
    [self.view addSubview:self.webView];
    
    
}
 
- (void)initPopWebView{
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
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
    CGRect ffff = CGRectMake(0, 100, Screen_W, Screen_H-100);//self.view.frame
    self.popWebView = [[WKWebView alloc] initWithFrame:ffff configuration:configuration];

    self.popWebView.navigationDelegate = self;
    self.popWebView.UIDelegate = self;
    [self.view addSubview:self.popWebView];
    self.popWebView.tag = PopWebView_Tag;
    self.popWebView.hidden = YES;
    if([[ShareLocale shared].nowThemeStr isEqualToString:Now_Theme_dark]){
        self.view.backgroundColor = [Y_ToolOfOthers getColorWithHexString:Theme_Bk_COlOR_Drak_Str];
        self.popWebView.backgroundColor = self.view.backgroundColor;
    }else if ([[ShareLocale shared].nowThemeStr isEqualToString:Now_Theme_light]){
        self.view.backgroundColor = [Y_ToolOfOthers getColorWithHexString:Theme_Bk_COlOR_Light_Str];
        self.popWebView.backgroundColor = self.view.backgroundColor;
    }else{
        NSLog(@"   [[ShareLocale shared] saveNowThemeTypeStr:valueStr];");
    }
}


- (void)setUI{
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_webView.superview).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [_popWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_webView.superview).insets(UIEdgeInsetsMake(100, 0, 0, 0));
    }];
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
    NSLog(@"didFailProvisionalNavigation  description = %@ code=%ld",error.description,(long)error.code)
    if(error){
        [self otherActionOfdidFailProvisionalNavigation];
        if(error.code == -1009){
            if(self.agreeLoadNum <= 3){
                self.agreeLoadNum += 1;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{//显示
                    [self initData];
                    [self initBaoHuoWebData];
                });
            }
           
        }
    }
}
- (void)otherActionOfdidFailProvisionalNavigation{
    
}
- (void)initBaoHuoWebData{
    
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
    [self.webView evaluateJavaScript:@"document.title" completionHandler:^(NSString *title, NSError *error) {
       // self.title = title;
        NSLog(@" web nav ============  %@ 当前url拿到的名字",title);
    }];
    [self doOtherOfwebViewDidFinishLoad:webView];
    DLog(@"");
}

- (void)doOtherOfwebViewDidFinishLoad:(WKWebView *)webView{
    
//    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='rgba(0,0,0,0)'"];
//    [webView stringByEvaluatingJavaScriptFromString: @"document.body.style.fontFamily = \"-apple-system\""];//字体跟随系统
    NSString *textJsStr =  @"document.body.style.fontFamily = \"-apple-system\"";
    [webView evaluateJavaScript:textJsStr completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        DLog(@"obj --%@",obj)
        DLog(@"error -- %ld %@",error.code,error.description);
    }];
    [webView setOpaque:NO];
    
}
//9.0才能使用，web内容处理中断时会触发

- ( void )webViewWebContentProcessDidTerminate:( WKWebView *)webView API_AVAILABLE(macosx( 10.11 ), ios( 9.0 )){
    DLog(@"");
}
#pragma mark - WKUIDelegate
#pragma mark - WKUIDelegate
- (void)webViewDidClose:(WKWebView *)webView {
    NSLog(@"webViewDidClose %s", __FUNCTION__);
}
//uiwebview 中这个方法是私有方法 通过category可以拦截alert
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    NSLog(@"runJavaScriptAlertPanelWithMessage %s", __FUNCTION__);
    NSLog(@"uiwebview 中这个方法是私有方法 通过category可以拦截alert   message %s", __FUNCTION__);
    if ([self.navigationController visibleViewController] != self)
    {
        completionHandler();
        return;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle: Y_LocaleTypeFile_NSLocalString(@"确定") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) { completionHandler();
    }]];
    alertController.modalPresentationStyle = UIModalPresentationFullScreen;
    if ([self.navigationController visibleViewController] == self)
    {
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        completionHandler();
    }
}
// 显示两个按钮，通过completionHandler回调判断用户点击的确定还是取消按钮
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler
{
    if ([self.navigationController visibleViewController] != self)
    {
        completionHandler(NO);
        return;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:Y_LocaleTypeFile_NSLocalString(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler(YES);
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:Y_LocaleTypeFile_NSLocalString(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler(NO);
    }]];
    
    if ([self.navigationController visibleViewController] == self)
    {
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        completionHandler(NO);
    }
}

// 显示一个带有输入框和一个确定按钮的，通过completionHandler回调用户输入的内容
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    
    if ([self.navigationController visibleViewController] != self)
    {
        completionHandler(@"error");
        return;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:Y_LocaleTypeFile_NSLocalString(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler(alertController.textFields.lastObject.text);
    }]];
    
    if ([self.navigationController visibleViewController] == self)
    {
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        completionHandler(@"error");
    }
}

#pragma mark -

#pragma mark - WKScriptMessageHandler
//遵循WKScriptMessageHandler协议，必须实现如下方法，然后把方法向外传递
//通过接收JS传出消息的name进行捕捉的回调方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSLog(@"baseWebvc--userContentController_Name:%@", message.name);
    NSLog(@"baseWebvc--userContentController_Body:%@", message.body);
    
    if([message.name  isEqualToString:logJsOfGetInfoMsgName]){
        NSLog(@"logJsOfGetInfoMsg  Name:%@", message.name);
        NSLog(@"logJsOfGetInfoMsg  Body:%@", message.body);
        return;
    }
    
    //data-----
    NSDictionary *bodyParam = (NSDictionary*)message.body;
    NSDictionary *bodyDic = (NSDictionary*)message.body;//初始时
    NSLog(@"userContentController  ----- bodyParam ----- %@",bodyParam)
    WebViewUseDataModel *model = [WebViewUseDataModel mj_objectWithKeyValues:bodyParam];
    
    if( isNil(model) && isNotNil(message.body) ){//转型需要多一次jstr转dic
        NSString *bodyStr = message.body;
        [bodyStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
        [bodyStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        [bodyStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        [bodyStr stringByReplacingOccurrencesOfString:@"\\"  withString:@""];
        [bodyStr stringByReplacingOccurrencesOfString:@"\''"  withString:@""""];
        bodyDic = [Y_ToolOfOthers dictionaryWithJsonString:bodyStr];//bodyDic处理后
        model = [WebViewUseDataModel mj_objectWithKeyValues:bodyDic];
        NSLog(@"userContentController  ----- bodyDic 1----- %@",bodyDic)
    }else{
        NSString *bodyStr = message.body;
        bodyDic = [Y_ToolOfOthers dictionaryWithJsonString:bodyStr];//bodyDic处理后
        model = [WebViewUseDataModel mj_objectWithKeyValues:bodyDic];
        NSLog(@"userContentController  nowUrl %@ ----- bodyDic 2----- %@",self.thisVcUseUrlStr,bodyDic)
    }

    NSLog(@"MessageHandler Name:%@", message.name);
    NSLog(@"MessageHandler Body:%@", message.body);
    NSLog(@"MessageHandler ------ error :%@", model.error);
    NSLog(@"MessageHandler  data error :%@", model.data.error);
    NSLog(@"MessageHandler  model.data.event:%@", model.data.event);
    NSLog(@"MessageHandler  model.type : ------ %ld", model.type);
    NSLog(@"MessageHandler  model.to : ------ %@", model.to);
    NSLog(@"MessageHandler  model.data.method : ------ %@", model.data.method);
    NSLog(@"MessageHandler  model,methoddddd : ------ %@", model.method);
    NSLog(@"MessageHandler  model,resultsss  字符串类型null 需要用键值来取: ------ %@", model.result);
    
    //dapp相关---begin
    
    if([model.to isEqualToString:GetInfoType_Wallet_To] && [model.refer isEqualToString:GetInfoType_Dapp_refer]){
        [self webInfoDappSendToWalletvcWithDic:bodyDic];
        return;
    }

    if([model.to isEqualToString:GetInfoType_Dapp_To] && [model.refer isEqualToString:GetInfoType_Wallet_refer]){
        [self webInfoWalletSendToDappvcWithDic:bodyDic];
        return;
    }

    if([model.data.method isEqualToString:kSub_Method_SetDappRecord] ){
        [self dappGetSetDappRecordWithDic:bodyDic];
        return;
    }
    
    //此种类型 在dappWallet内不显示 即优先级更改
    if(isNotNil(model.error) && [model.error allKeys].count >0){
        NSLog(@"model.error %@",model.error);
        if( [[model.error allKeys] containsObject:@"message"]){
            NSString *emsg  = [NSString stringWithFormat:@"%@",[model.error objectForKey:@"message"]];
            Y_SVP_SHOW_ERR_MES(emsg);
            return;
        }
    }
    
    //显示隐藏web窗口口
    if([model.data.method isEqualToString:kOCGetJsInfoFunction_Sub_Method_showWaletPage]){
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{//显示
            Y_NSNotificationCenter_PostNotice_HaveObject_Name(NociceName_WindowSubBaoHUOWebView_ShowOrHidden, @(0));
        });
        
        
        return;
    }
    if([model.data.method isEqualToString:kOCGetJsInfoFunction_Sub_Method_closeWaletPage]){
        NSLog(@"model.data.method  关闭web窗口口");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            Y_NSNotificationCenter_PostNotice_HaveObject_Name(NociceName_WindowSubBaoHUOWebView_ShowOrHidden, @(1));
        });
        [self  loginWebVcGetHideWallet];
        [self walletWebVcGetHideWallet];
        return;
    }
    if([model.data.method isEqualToString:kOCGetJsInfoFunction_Sub_Method_hideWaletPage]){
        NSLog(@"model.data.method  隐藏web窗口口");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            Y_NSNotificationCenter_PostNotice_HaveObject_Name(NociceName_WindowSubBaoHUOWebView_ShowOrHidden, @(1));
        });
        [self  loginWebVcGetHideWallet];
        [self walletWebVcGetHideWallet];

        return;
    }
  
    if([model.method isEqualToString:kOCGetJsInfoFunction_Sub_Method_pong] || [model.method isEqualToString:kOcSendToJsFunction_apiCall_methodObj_Ping]){
        NSLog(@"接收到心跳pong");
        [self webGetJsInfoWithPong];
        return;
    }
    
    if([model.data.method isEqualToString:kOCGetJsInfoFunction_Sub_Method_walletLoadFinished]){
        NSLog(@"model.data.method  kOCGetJsInfoFunction_Sub_Method_walletLoadFinished 加载完成 登录页可以触发走登录信息了");
        [self triggerLoginAction];
        self.walletLoadFinishedBool = YES;
        [self thisWebViewIsLoadFinishOk];
        [self initSetUserInfoWithGetBodyDic:bodyDic];
        [self initSelfWith1002TypeOfLoadFinish];
        return;
    }
    
    if([model.data.method isEqualToString:kLoginRqpersonalSignInfo_Sub_Mothod_login]){//拿到登录
        
    }
 
    if([model.data.method isEqualToString:kOCGetJsInfoFunction_Sub_Method_sacnQR]){
        NSLog(@"model.data.method  得到二维码扫描识别信息");
        [self sacnQRGetInfoDic:bodyDic];
        return;
    }

    if([model.method isEqualToString:kLoginRqpersonalSignInfo_Sub_Mothod_login]){
   
        if(isNil(model.result)){
            NSLog(@"登录数据 result 空 走seruserinfo bodyDic= %@",bodyDic);
            [self initSetUserInfoWithGetBodyDic:bodyDic];
            return;
        }else{
            NSLog(@"得到了登录需要使用的 签名数据  登录调起 ----   bodyDic=  %@",bodyDic);
            [self dealLoginSignInfoData:model.result];
            //1008增入审核相关数据 走不验证签名的数据
        }

        return;
    }
    
    
    if([model.method isEqualToString:kOCGetJsInfoFunction_Sub_Method_personalSign]){
        NSLog(@"model.method  personalSign 红包相关接口 %@",[model mj_keyValues]);
        /**
         {"id":"1694853186000",
         "method":"personalSign",
         "to":"PLATFORM",
         "refer":"WALLET",
         "type":"res",
         "result":"0xb6455000b7e1d92a722904332c16712df3f0bb3fc4f1469e1fcfb2aec821a9dd59ac3241ea1c9bc272ebb4fea20769d45cb368797a296a9013dc2368b76066251b"}
         */
       
        NSString *resultStr = [[bodyDic allKeys] containsObject:@"result"] ? [bodyDic objectForKey:@"result"] : @"";
        NSLog(@"红包相关 resultStr== %@",resultStr);
        NSLog(@"modelresult--- %@",model.result);
        [self RedEnv_OnWebVc_SignGetedWithData:[TextShowWithModelStr textShowWithModelStr:resultStr]];
    }
    
    /**
     if(!self.walletLoadFinishedBool){
         NSLog(@"页面没加载完成 暂时不做数据操作");
         return;
     }else{
         NSLog(@"页面加载完成 将处理其他交互数据");
     }

     */
    
    //sql
    if([model.data.method isEqualToString:kOCGetJsInfoFunction_Sub_Method_executeSqlObj]){
        NSLog(@"kOCGetJsInfoFunction_Sub_Method_executeSqlObj model.data  === %@",model.data);
        NSLog(@"kOCGetJsInfoFunction_Sub_Method_executeSqlObj  === %ld",model.data.param.type);
        NSLog(@"kOCGetJsInfoFunction_Sub_Method_executeSqlObj  === %@",model.data.param.sql);
 
//        [self haveSqlInfoWithType:model.data.param.type withSqlStrArr:model.data.param.sql withMessageBodyDic: bodyDic];//0807暂时不再子vc使用 而转为方法
        [[SqlUseResReqWebDataTool share] haveSqlInfoWithType:model.data.param.type withSqlStrArr:model.data.param.sql withMessageBodyDic: bodyDic ofwillUseSendWkDicBlock:^(NSDictionary * _Nonnull dicOfBlock, BOOL succes) {
            
            if(succes){
                NSString *willSendDataJsonStr = [Y_ToolOfOthers jsonStrWithDic:dicOfBlock];
                NSString *jsStr = [NSString stringWithFormat:@"%@(%@)", kOcSendToJsFunction_apiCall,willSendDataJsonStr];
                NSLog(@"=====  kOcSendToJsFunction_apiCall ===== jsStr === %@",jsStr);
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                        NSLog(@" 得到数据 kOcSendToJsFunction_apiCall ==  %@----%@",result, error);
                        WebViewUseDataModelSubDataModel *model = [WebViewUseDataModelSubDataModel mj_objectWithKeyValues:result];
                        if(model.status == 200){
                            NSLog(@"xecuteSqlObj 成功")
                        }else{
                            NSLog(@"xecuteSqlObj 失败 jsStr= %@",jsStr);
                        }
                    }];
                });
            }
          
        }];
        

        return;
        
    }
    
    if([model.data.method isEqualToString:kOCGetJsInfoFunction_Sub_Method_pageChanged]){
        DLog(@"颜色处理");
        [self dealBaoHuoBkView:bodyDic];
    }
    
    
    


/** dapp 收到的消息部分
 if([model.data.method isEqualToString:kOCGetJsInfoFunction_Sub_DappAndWallet_ethRequestAccounts] ){
     [self dappGetwebInfoWithDic:bodyDic];
     return;
 }
 if([ model.data.param.method  isEqualToString:kOCGetJsInfoFunction_Sub_DappAndWallet_ethRequestAccounts]){
     [self dappGetwebInfoWithDic:bodyDic];
     return;
 }*/
#pragma mark ======== kOcGetJs_TypeNum_
    //dapp相关---end
    if([model.data.method isEqualToString:kOcGetJsInfoFunction_actionType]){
        NSLog(@"kOcGetJsInfoFunction_actionType   ===== %@",bodyDic);
        NSInteger typeNum = model.data.param.type;
        
        switch (typeNum) {
            case kOcGetJs_TypeNum_1000_BackAction:
            {
                [self popVC];
                return;
            }
                break;
            case kOcGetJs_TypeNum_1001_SetLanguage:
            {
                
                NSString *needSetLocale = [TextShowWithModelStr textShowWithModelStr:model.data.param.value];
                if([needSetLocale isEqualToString:@"korean"]){
                    needSetLocale = @"ko";
                }
                [[ShareLocale shared] saveNowLacaleTypeStr:needSetLocale];
                NSLog(@"语言切换  now 数据 === %@",[ShareLocale shared].nowLocaleTypeStr);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self changeTabbarUIsAndOtherModuleNeedNewLanguage];//原生界面语言
                    Y_NSNotificationCenter_PostNotice_NilObject_Name(WebView_Langeuge_Change_NoticeName);//通知其他
                });
                return;
            }
                break;
                
            case kOcGetJs_TypeNum_1002_LoadFinish:
            {
              
                return;
            }
            case kOcGetJs_TypeNum_1003_SetUserInfoOk://已经废弃
            {
                NSLog(@"设置用户信息完成{type:1003,status:0成功，1失败 ---- %ld",model.status);
                return;
            }
            case kOcGetJs_TypeNum_1004_OpenDapp:
            {
                [self webGetOpenDappAction:bodyDic];
                return;
            }
            case kOcGetJs_TypeNum_1005_NowPage:
            {
                //value":{"fullPath":"带参数","route":"不带参数","pages"
                [self get1005OfDappTabBarNeedShowOrHidenWithDic:bodyDic];
                [self initSetUserInfoWithGetBodyDic:bodyDic];
                [self initSelfWith1002TypeOfLoadFinish];
                [self deal1005_hidenNavOrShowNavWithDic:bodyDic];

                return;
            }
            case kOcGetJs_TypeNum_1006_OpenZhiBo:
            {
                [self webGetOpenZhiBoAction];
                return;
            }
            case kOcGetJs_TypeNum_1007_SetZhuTi://theme 主题色
            {
              
                NSString *valueStr = [NSString stringWithFormat:@"%@",model.data.param.value];
                [[ShareLocale shared] saveNowThemeTypeStr:valueStr];
                if([valueStr isEqualToString:@"dark"]){
                    [[ShareLocale shared] saveNowThemeTypeStr:valueStr];
                    self.view.backgroundColor = [Y_ToolOfOthers getColorWithHexString:Theme_Bk_COlOR_Drak_Str];
                    self.webView.backgroundColor = self.view.backgroundColor;
                }else if ([valueStr isEqualToString:@"light"]){
                    [[ShareLocale shared] saveNowThemeTypeStr:valueStr];
                    self.view.backgroundColor = [Y_ToolOfOthers getColorWithHexString:Theme_Bk_COlOR_Light_Str];
                    self.webView.backgroundColor = self.view.backgroundColor;
                }else{
                    NSLog(@"   [[ShareLocale shared] saveNowThemeTypeStr:valueStr];");
                }
                
                Y_NSNotificationCenter_PostNotice_NilObject_Name(WebView_Theme_Change_NoticeName);
                NSLog(@"1007 主题颜色更改 =------ %@",valueStr);
                [self changeTabbarUIsAndOtherModuleNeedNewZhuTiColor];//tabbar主题色 0829
                [self setNeedsStatusBarAppearanceUpdate];//顶部状态栏主题相关0902
                return;
            }
            case kOcGetJs_TypeNum_1008_LoginPopViewShow:
            {
                [self webLoginPopShowAction];
                return;
            }
            case kOcGetJs_TypeNum_1009_LogoutAction:
            {
                [self webGetLogoutAction:bodyDic];
                return;
            }
            case kOcGetJs_TypeNum_1010_OpenWalletMainVc:
            {
                [self webGetOpenWalletAction];
                return;
            }
            case kOcGetJs_TypeNum_1011_OpenShare:
            {
                [self webGetOpenShareAction:bodyDic];
                return;
            }
            case kOcGetJs_TypeNum_1012_ScanQR:
            {
                [self sacnQRGetInfoDic:bodyDic];
                return;
            }
            case kOcGetJs_TypeNum_1013_ChangeUserHeaderImg:
            {
                NSString *valueStr = [NSString stringWithFormat:@"%@",model.data.param.value]; 
                [ShareUserInfo share].userInfo.profileImageUrl = valueStr;
                [LiveRoomBase setIdNickAndHeadImg];
                return;
            }
            case kOcGetJs_TypeNum_1014_ChangeUserNick:
            {
                NSString *valueStr = [NSString stringWithFormat:@"%@",model.data.param.value];
                [ShareUserInfo share].userInfo.username = valueStr;
                [LiveRoomBase setIdNickAndHeadImg];
                return;
            }
            case kOcGetJs_TypeNum_1015_ChangeUserIntro:
            {
                NSString *valueStr = [NSString stringWithFormat:@"%@",model.data.param.value];
//                [ShareUserInfo share].userInfo. = valueStr;//简介位置
                return;
            }
                
            case kOcGetJs_TypeNum_1016_GoSiXin://私信
            {
                NSString *valueStr = [NSString stringWithFormat:@"%@",model.data.param.value];
                NSString *imidStr = valueStr;
                [self gotoSiXinImIDStr:imidStr];
                
                return;
            }
                
            case kOcGetJs_TypeNum_1017_GoGroupChat:
            {
                NSString *valueStr = [NSString stringWithFormat:@"%@",model.data.param.value];
                NSString *groupId = valueStr;
                [self gotoGroupWithGroupIdStr:groupId];
                return;
            }
                break;
            case kOcGetJs_TypeNum_1020_NeedBackVersionNum:
            {
                [self needSendVersionNumActionWithMessageBodyDic:bodyDic];
                return;
            }
                break;

            case kOcGetJs_TypeNum_1104_userInfoCheckAndLoginOrSendUserInfoData:
            {
                [self getTypeNum1104ActionWithDic:bodyDic];
                return;
            }
                break;
                
            default:
                break;
        }
    }
    
    
    
    
    
    
    #pragma mark === 旧的 有些在用
   
    
    if ([message.name isEqualToString:kOCGetJsInfoFunction]) {
        
        if([[NSString stringWithFormat:@"%@",message.body] containsString:@"type"] && [[NSString stringWithFormat:@"%@",message.body] containsString:@"1005"]){
            
            NSDictionary *bodyDic = [Y_ToolOfOthers dictionaryWithJsonString:[NSString stringWithFormat:@"%@",message.body]];
//            WebViewUseDataModel *model1005 = [[WebViewUseDataModel alloc]init];
//            model1005.type = 1005;
            [self getWebViewSend1005type];
            return;
        }
        
        //type类型
        if(isNil(model.to)){
            NSInteger typeNum =  model.type;
            if(typeNum == 1000){//退出vc动作
                [self popVC];
            }else if (typeNum == 1001){//语言切换
                NSString *needSetLocale = [TextShowWithModelStr textShowWithModelStr:model.locale];
                if([needSetLocale isEqualToString:@"korean"]){
                    needSetLocale = @"ko";
                }
                [[ShareLocale shared] saveNowLacaleTypeStr:needSetLocale];
                NSLog(@"语言切换  now 数据 === %@",[ShareLocale shared].nowLocaleTypeStr);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self changeTabbarUIsAndOtherModuleNeedNewLanguage];//原生界面语言
                    Y_NSNotificationCenter_PostNotice_NilObject_Name(WebView_Langeuge_Change_NoticeName);//通知其他
                });
            }else if (typeNum == 1002){
                [self initSetUserInfoWithGetBodyDic:bodyDic];
                [self initSelfWith1002TypeOfLoadFinish];
                
            }else if (typeNum == 1003){
                NSLog(@"设置用户信息完成{type:1003,status:0成功，1失败 ---- %ld",model.status);
                if(model.status){
                }else{
                }
                
            }else if (typeNum == 0){
                NSLog(@"getWebViewSendInfoWithTypeNum  无Type数据");
            }else{
                [self getWebViewSendWithInfoModel:model withTypeNum:typeNum];
            }
        //callBackType存在类型
        }else{
            [self getWebViewSendInfoWithModel:model];
        }
        
    } else{
        DLog(@"—————————userContentController——————— 其他约定协议明");
    }
}


//钱包保活界面相关才使用
- (void)dealBaoHuoBkView:(NSDictionary *)bodyDic{
}
- (void)getWebViewSend1005type{
    
}
- (void)initSelfWith1002TypeOfLoadFinish{
    NSLog(@"其他需要在1002的初始");
}
- (void)changeTabbarUIsAndOtherModuleNeedNewLanguage{
    //设置页 我的 推荐 发现 都是web 继承basewebv 已经reload刷新
    //chat 主页刷新 是原生 主动处理有可能符合的列表消息文本
    Y_NSNotificationCenter_PostNotice_NilObject_Name(kNotice_Name_ChatMainListDataReload);
    //tabbar UI
    UIWindow *w =  [Y_ToolOfOthers toolGetKeyWindow];
    MainTabbarControll *tabvc = (MainTabbarControll *)w.rootViewController;
    if( tabvc.viewControllers.count > 1 ){
        NSArray *vcNavTitles = @[
            Y_LocaleTypeFile_NSLocalString(@"聊天"),
            Y_LocaleTypeFile_NSLocalString(@"推荐"),
            Y_LocaleTypeFile_NSLocalString(@"发现"),
            Y_LocaleTypeFile_NSLocalString(@"我的")];
        
        for (int i = 0; i < vcNavTitles.count; i++) {
            UIViewController *vc = tabvc.viewControllers[i];
            vc.tabBarItem.title = vcNavTitles[i];
        }
    }else{
        DLog(@"————————— changeTabbarUIs tabvc.viewControllers 有问题——————— %lu",(unsigned long)tabvc.viewControllers.count);
    }
}

- (void)changeTabbarUIsAndOtherModuleNeedNewZhuTiColor{
    //tabbar UI
    UIWindow *w =  [Y_ToolOfOthers toolGetKeyWindow];
    MainTabbarControll *tabvc = (MainTabbarControll *)w.rootViewController;
    [tabvc nowColorSetWithThemeChange];
    
}


#pragma mark ===
- (void)getWebViewSendWithInfoModel:(WebViewUseDataModel *)infoModel withTypeNum:(NSInteger)typeNum{
    NSLog(@"getShopWebViewSendInfoWithTypeNum  Type数据 = %ld",(long)typeNum);
    switch (typeNum) {
        case 1:
        {
           
        }
            break;
            
        default:
            break;
    }
}
- (void)getWebViewSendInfoWithModel:(WebViewUseDataModel *)infoModel{

}
 
- (void)haveSqlInfoWithType:(NSInteger)type
              withSqlStrArr:(NSArray *)sqlArr
         withMessageBodyDic:(NSDictionary *)messageBodyDic{
    
    DLog(@" basewebvc haveSqlInfoWithType");
     
    
}

- (void)thisWebViewIsLoadFinishOk{
    
}

- (void)webGetJsInfoWithPong{
    
}

- (void)triggerLoginAction{
    
}

#pragma mark ====

- (void)needSendVersionNumActionWithMessageBodyDic:(NSDictionary *)messageBodyDic{
    WebViewUseDataModel *mainDataModel = [WebViewUseDataModel mj_objectWithKeyValues:messageBodyDic];
    NSString *versionStr = [self softwareVersion];
    NSMutableDictionary *willUseSendWkDic = @{}.mutableCopy;
    [willUseSendWkDic setValue:@"res" forKey:@"type"];//固定值
    [willUseSendWkDic setValue:[TextShowWithModelStr textShowWithModelStr:mainDataModel.ID] forKey:@"id"];
    [willUseSendWkDic setValue:[TextShowWithModelStr textShowWithModelStr:mainDataModel.refer] forKey:@"to"];
    [willUseSendWkDic setValue:[TextShowWithModelStr textShowWithModelStr:mainDataModel.data.method] forKey:@"method"];
    [willUseSendWkDic setValue:versionStr forKey:@"result"];
       
    NSString *willSendDataJsonStr = [Y_ToolOfOthers jsonStrWithDic:willUseSendWkDic];
    
    NSString *apiStr = kOcSendToJsFunction_marketApiCall;
    NSString *jsStr = [NSString stringWithFormat:@"%@(%@)",apiStr ,willSendDataJsonStr];
    NSLog(@"=====  needSendVersionNumActionWithMessageBodyDic ==== jsStr === %@",jsStr);

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            NSLog(@" 得到数据  needSendVersionNumActionWithMessageBodyDic ====  %@----%@",result, error);
            WebViewUseDataModelSubDataModel *model = [WebViewUseDataModelSubDataModel mj_objectWithKeyValues:result];
            if(model.status == 200){
             NSLog(@"needSendVersionNumActionWithMessageBodyDic 成功")
            }else{
             NSLog(@"needSendVersionNumActionWithMessageBodyDic status %ld",model.status);
            }
        }];
     });
    
}
- (NSString *)softwareVersion
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDic objectForKey:@"CFBundleShortVersionString"];// app版本
    NSString *app_build = [infoDic objectForKey:@"CFBundleVersion"];// app build版本
    NSString *currentVersion = [NSString stringWithFormat:@"%@(build:%@)",app_Version,app_build];
    return currentVersion;
}


#pragma mark ====
- (void)sacnQRGetInfoDic:(NSDictionary *)bodyDic{
    NSLog(@"调起扫二维码功能 sacnQRGetInfoDic  : %@",bodyDic);
    WEAKSELF
    STRONGSELF
    [SGPermission permissionWithType:SGPermissionTypeCamera completion:^(SGPermission * _Nonnull permission, SGPermissionStatus status) {
        if (status == SGPermissionStatusNotDetermined) {
            [permission request:^(BOOL granted) {
                if (granted) {
                    NSLog(@"第一次授权成功");
                    XCQRCodeVC *VC = [[XCQRCodeVC alloc] init];
                    VC.hidesBottomBarWhenPushed = YES;
                    VC.modalPresentationStyle = UIModalPresentationFullScreen;
                    VC.resBlock = ^(NSString * _Nullable rStr) {
                        NSLog(@" resBlock 得到的结果是： %@",rStr);
                        [strongSelf dealQRresStrInfoWithDataDic:bodyDic andResStr:rStr];
                    };
                    if(isNotNil(self.navigationController)){
                        VC.isPushType = YES;
                        [self.navigationController pushViewController:VC animated:YES];
                        NSLog(@"二维码 扫码 跳转 push");
                    }else{
                        VC.isPushType = NO;
                        [self presentViewController:VC animated:YES completion:^{
                            NSLog(@"二维码 扫码 跳转 presen");
                        }];
                    }
                    
                    
                } else {
                    NSLog(@"第一次授权失败");
                }
            }];
        } else if (status == SGPermissionStatusAuthorized) {
            NSLog(@"SGPermissionStatusAuthorized");
            XCQRCodeVC *VC = [[XCQRCodeVC alloc] init];
            VC.hidesBottomBarWhenPushed = YES;
            VC.resBlock = ^(NSString * _Nullable rStr) {
                NSLog(@" resBlock 得到的结果是： %@",rStr);
                [strongSelf dealQRresStrInfoWithDataDic:bodyDic andResStr:rStr];
            };
            if(isNotNil(self.navigationController)){
                VC.isPushType = YES;
                VC.modalPresentationStyle = UIModalPresentationFullScreen;
                [self.navigationController pushViewController:VC animated:YES];
                NSLog(@"二维码 扫码 跳转 push");
            }else{
                VC.isPushType = NO;
                VC.modalPresentationStyle = UIModalPresentationFormSheet;//占据屏幕中间的一小块（比较常用）
                [self presentViewController:VC animated:YES completion:^{
                    NSLog(@"二维码 扫码 跳转 presen");
                }];
            }
            
            
            /**
             
             XCQRCodeVC *VC = [[XCQRCodeVC alloc] init];
             VC.resBlock = ^(NSString * _Nullable rStr) {
                 NSLog(@" resBlock 得到的结果是： %@",rStr);
                 [strongSelf dealQRresStrInfoWithDataDic:bodyDic andResStr:rStr];
                 Y_NSNotificationCenter_PostNotice_HaveObject_Name(NociceName_WindowSubBaoHUOWebView_ShowOrHidden, @(0));
             };
             
             if([[Y_ToolOfOthers toolGetKeyWindow].rootViewController isKindOfClass: [UITabBarController class]] || [[Y_ToolOfOthers toolGetKeyWindow].rootViewController isKindOfClass: [MainTabbarControll class]] ){
                 //UITabBarController
                 DLog(@"UITabBarController MainTabbarControll -subNav push SQ");

                 //跳转相关
                 UITabBarController *tabvc = (UITabBarController *)[Y_ToolOfOthers toolGetKeyWindow].rootViewController;
                 if([tabvc.childViewControllers[tabvc.selectedIndex] isKindOfClass:[UINavigationController class]]){
                     UINavigationController * useNav =  (UINavigationController *)tabvc.childViewControllers[tabvc.selectedIndex];
                     useNav.hidesBottomBarWhenPushed = YES;
                     [useNav pushViewController:VC animated:YES];
                     //最顶上一层 扫码的跳转位置 顶部层级无效唉
                     [VC.view sendSubviewToBack:[Y_ToolOfOthers toolGetKeyWindow].rootViewController.view];
                     Y_NSNotificationCenter_PostNotice_HaveObject_Name(NociceName_WindowSubBaoHUOWebView_ShowOrHidden, @(1));//隐藏

                 }else{
                     UIViewController * usevc =  (UIViewController *)tabvc.childViewControllers[tabvc.selectedIndex];
                     usevc.hidesBottomBarWhenPushed = YES;
                     [usevc.navigationController pushViewController:VC animated:YES];
                     //最顶上一层
                     [VC.view sendSubviewToBack:[Y_ToolOfOthers toolGetKeyWindow].rootViewController.view];
                     Y_NSNotificationCenter_PostNotice_HaveObject_Name(NociceName_WindowSubBaoHUOWebView_ShowOrHidden, @(1));//隐藏

                 }
              
                 
             }else if([[Y_ToolOfOthers toolGetKeyWindow].rootViewController isKindOfClass: [UINavigationController class]]){
                 UINavigationController * useNav =  (UINavigationController *)[Y_ToolOfOthers toolGetKeyWindow].rootViewController;
                 useNav.hidesBottomBarWhenPushed = YES;
                 [useNav pushViewController:VC animated:YES];
                 DLog(@"nvc push SQ");
                 
             }else{
                 DLog(@"没有位置跳转");
                 return;
             }
              
             
             **/
            
          
           
            
        } else if (status == SGPermissionStatusDenied) {
            NSLog(@"SGPermissionStatusDenied");
            [self failed];
        } else if (status == SGPermissionStatusRestricted) {
            NSLog(@"SGPermissionStatusRestricted");
            [self unknown];
        }
        
    }];
    
    
}
#pragma mark ====
#define Notice_Name_GotoImOneUserInfoVc                                @"Notice_Name_GotoImOneUserInfoVc"
#define Notice_Name_AddOnePersion                                      @"Notice_Name_AddOnePersion"
#define Notice_Name_ChatGroupQR_ScanActionTool                         @"Notice_Name_ChatGroupQR_ScanActionTool"//群 扫码后 直接进群 或者 申请加群相关
//二维码的扫描结果相关处理和发送数据给web
- (void)dealQRresStrInfoWithDataDic:(NSDictionary *)bodyDic andResStr:(NSString *)resStr{

    //处理info
    WebViewUseDataModel *mainDataModel = [WebViewUseDataModel mj_objectWithKeyValues:bodyDic];
    NSDictionary *resStrDic = [Y_ToolOfOthers dictionaryWithJsonString:resStr];
    //----聊天扫用户imID码
    if( ([[resStrDic allKeys] containsObject:@"imId"] || [[resStrDic allKeys] containsObject:@"groupId"]) && [[resStrDic allKeys] containsObject:@"type"] ){
        NSInteger resTypeNum = [[resStrDic objectForKey:@"type"]  intValue];
        if(resTypeNum == 2000){
            NSString *imId = [NSString stringWithFormat:@"%@",[resStrDic objectForKey:@"imId"]];
            if(imId.length<=0){
                return;
            }
            //延时 等二维码回来后 再通知跳转
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                Y_NSNotificationCenter_PostNotice_HaveObject_Name(Notice_Name_AddOnePersion, imId);//添加好友 而不是个人中心页。
            });
            
            return;
        }else if(resTypeNum == 2001){//群
            NSString *groupId = [NSString stringWithFormat:@"%@",[resStrDic objectForKey:@"groupId"]];
            if(groupId.length<=0){
                return;
            }
            //延时 等二维码回来后 再通知跳转
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //Y_SVP_SHOW_INFO_MES(@"加群功能敬请期待！");
                NSArray *garr = @[groupId,self];
                Y_NSNotificationCenter_PostNotice_HaveObject_Name(Notice_Name_ChatGroupQR_ScanActionTool, garr);//扫码后 加群
            });
            return;
        }
    }
    
    //___其他类型
    NSMutableDictionary *willUseSendWkDic = @{}.mutableCopy;
    
    [willUseSendWkDic setValue:@"res" forKey:@"type"];//固定值
    [willUseSendWkDic setValue:[TextShowWithModelStr textShowWithModelStr:mainDataModel.ID] forKey:@"id"];
    [willUseSendWkDic setValue:[TextShowWithModelStr textShowWithModelStr:mainDataModel.refer] forKey:@"to"];
    [willUseSendWkDic setValue:[TextShowWithModelStr textShowWithModelStr:mainDataModel.data.method] forKey:@"method"];
    [willUseSendWkDic setValue:resStr forKey:@"result"];
       
    NSString *willSendDataJsonStr = [Y_ToolOfOthers jsonStrWithDic:willUseSendWkDic];
    
    
    //判断 发现页 用的kOcSendToJsFunction_marketApiCall 其他dealQRresStrInfoWithDataDic
    NSString *apiStr = @"";
    if([self.thisVcUseUrlStr containsString:FaXian_VC_Url_Sufx_Index]){
        apiStr = kOcSendToJsFunction_marketApiCall;
    }else{
        apiStr = kOcSendToJsFunction_apiCall;
    }
    
    NSString *jsStr = [NSString stringWithFormat:@"%@(%@)",apiStr ,willSendDataJsonStr];
    NSLog(@"=====  kOcSendToJsFunction_apiCall 二维码扫描后传递给web数据==== jsStr === %@",jsStr); 

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            NSLog(@" 得到数据 kOcSendToJsFunction_apiCalll 二维码扫描后传递给web数据====  %@----%@",result, error);
            WebViewUseDataModelSubDataModel *model = [WebViewUseDataModelSubDataModel mj_objectWithKeyValues:result];
            if(model.status == 200){
             NSLog(@"kOcSendToJsFunction_apiCall 成功")
            }else{
             NSLog(@"kOcSendToJsFunction_apiCall status %ld",model.status);
            }
        }];
     });

}

#pragma mark ==== 扫描时可能调用的权限相关alert
- (void)failed {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"[前往：设置 - 隐私 - 相机 - SGQRCode] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertC addAction:alertA];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertC animated:YES completion:nil];
    });
}

- (void)unknown {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertC addAction:alertA];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertC animated:YES completion:nil];
    });
}


#pragma mark ====
//登录vc专用
- (void)loginWebVcGetHideWallet{
    
}

//钱包vc专用
- (void)walletWebVcGetHideWallet{
    
}
#pragma mark ====

- (void)dealLoginSignInfoData:(WebViewUseDataModel_LoginPersonalSign_Sub_resultData *)resultDataModel{
    
}
 



#pragma mark ==== dapp
//打开dapp 1004_OpenDapp
- (void)webGetOpenDappAction:(NSDictionary *)bodyDic{//给发现页用 //钱包页也用到
    
}

//打开dapp后 拿到 1005 Dapp深度位置 看看是否可以处理tabbar
- (void)get1005OfDappTabBarNeedShowOrHidenWithDic:(NSDictionary *)bodyDic{
}

- (void)deal1005_hidenNavOrShowNavWithDic:(NSDictionary *)bodyDic{
    WebViewUseDataModel *model = [WebViewUseDataModel mj_objectWithKeyValues:bodyDic];
    NSDictionary *valueDic = [NSDictionary dictionaryWithDictionary:model.data.param.value];
    DLog(@" deal1005_hidenNavOrShowNavWithDic  -valueDic-- %@",valueDic);
    
    if([[valueDic allKeys] containsObject:@"bg"]){
        NSString * nowPath_BGHidenStr =  [NSString stringWithFormat:@"%@",[valueDic objectForKey:@"bg"]];
        if([nowPath_BGHidenStr isEqualToString:@"false"] ||[nowPath_BGHidenStr isEqualToString:@"0"] ){//黑白
            DLog(@"%@ nowPath_BGHidenStr = %@",bodyDic,nowPath_BGHidenStr);
//            [self.navigationController setNavigationBarHidden:NO animated:YES];
        }else{//true 有色
            DLog(@"%@ nowPath_BGHidenStr = %@",bodyDic,nowPath_BGHidenStr);
//            [self.navigationController setNavigationBarHidden:YES animated:YES];

        }
    }
    
}
//- (void)dappGetwebInfoWithDic:(NSDictionary *)bodyDic{//发现页跳dapp已完成时 //给子页面用
//
//}
#pragma mark ===  直播
- (void)webGetOpenZhiBoAction{//发现页 跳直播主页list 已完成
    DLog(@"");
}


#pragma mark ===  钱包
- (void)webGetOpenWalletAction{//钱包界面的跳转 暂时未被调用过
    DLog(@"");
    DLog()
    MySubsWebVc *vc = [[MySubsWebVc alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.subTypeUrlSuix = MySubVc_Url_Suix_MyWallet;
    [self pushVc:vc];
    Y_NSNotificationCenter_PostNotice_HaveObject_Name(NociceName_WindowSubBaoHUOWebView_ShowOrHidden, @(1));//跳转前隐藏pop
    
}

#pragma mark ===  分享
#define kShareStr_Open_Freeper_Io   @"https://freeper.io"
- (void)webGetOpenShareAction:(NSDictionary *)bodyDic{
    DLog(@"");
    //系统分享
//    NSString *shareStr = kShareStr_Open_Freeper_Io;
//    [Y_ToolOfOthers shareLinkUrlWithStr:shareStr withNowVc:self];
    WebViewUseDataModel *model = [WebViewUseDataModel mj_objectWithKeyValues:bodyDic];
    NSDictionary *valueDic = [NSDictionary dictionaryWithDictionary:model.data.param.value];
    NftModels *nftModel = [NftModels mj_objectWithKeyValues:valueDic];
    NSString *nftModel_title = [TextShowWithModelStr textShowWithModelStr:nftModel.title];
    NSString *nftModel_url = [TextShowWithModelStr textShowWithModelStr:nftModel.url];
    NSString *nftModel_imgStr = [TextShowWithModelStr textShowWithModelStr:nftModel.image];
    if(nftModel_url.length>0){
        NSString *shwoStr = [NSString stringWithFormat:Y_LocaleTypeFile_NSLocalString(@"在Freeper，记录美好生活#【 %@ 】来NFT详情和我一起支持Ta吧。复制下方链接，打开NFT详情"),nftModel_title];
        NSArray *shareArr = @[shwoStr,[NSURL URLWithString:nftModel_url]];
        [Y_ToolOfOthers shareActionWithArr:shareArr withNowVc:self];
    }
  


    
    NSLog(@"分享功能 --- %@",valueDic);
}


#pragma mark ===  登录pop 保活窗口
- (void)webLoginPopShowAction{   
    DLog(@"");
    NSLog(@"webLoginPopShowAction 显示web窗口口");
    DLog(@"webLoginPopShowAction  显示web窗口口 [ShareUserInfo share].userInfo.address %@",[ShareUserInfo share].userInfo.address);
    DLog(@"webLoginPopShowAction  显示web窗口口 [ShareUserInfo share].userInfo.token  %@",[ShareUserInfo share].userInfo.token);
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{//显示 0801去掉显示
//        Y_NSNotificationCenter_PostNotice_HaveObject_Name(NociceName_WindowSubBaoHUOWebView_ShowOrHidden, @(0));
//    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if([ShareUserInfo share].userInfo.address.length <= 0 || [ShareUserInfo share].userInfo.token.length <= 0){//调起弹出框
            Y_NSNotificationCenter_PostNotice_HaveObject_Name(NociceName_WindowSubBaoHUOWebView_ShowAndNeedSendSigWithDoLoginAction, @"去登录");
        }
    });

}

#pragma mark ===  登出
- (void)webGetLogoutAction:(NSDictionary *)bodyDic{
    DLog(@"");
    
    WebViewUseDataModel *modell = [WebViewUseDataModel mj_objectWithKeyValues:bodyDic];
    NSMutableDictionary *willUseSendWkDic = @{}.mutableCopy;
    [willUseSendWkDic setValue:@"res" forKey:@"type"];//固定值
    [willUseSendWkDic setValue:[TextShowWithModelStr textShowWithModelStr:modell.ID] forKey:@"id"];
    [willUseSendWkDic setValue:[TextShowWithModelStr textShowWithModelStr:modell.refer] forKey:@"to"];
    [willUseSendWkDic setValue:[TextShowWithModelStr textShowWithModelStr:modell.data.method] forKey:@"method"];
//
//
//    NSString *idStr = [TextShowWithModelStr textShowWithModelStr: modell.ID];
//    NSDictionary *loginDic = @{
//        @"id":idStr,
//        @"refer":@"PLATFORM",
//        @"to":@"MARKET",
//        @"timeout":@(300000),
//        @"type":@"req",
//        @"data": @{@"method":@"logout"}
//    };
    
    NSString *willSendDataJsonStr = [Y_ToolOfOthers jsonStrWithDic:willUseSendWkDic];
    DLog(@"willSendDataJsonStr == %@",willSendDataJsonStr);
//    NSString *funcName = kOcSendToJsFunction_apiCall;
//    if([self.thisVcUseUrlStr containsString:FaXian_VC_Url_Sufx_Index]){//|| [self.thisVcUseUrlStr containsString:TuiJian_VC_Url] 推荐页面的url是base 无法判断 本marketApiCall方法的initSetUserInfo数据在该vc重写
//        funcName = kOcSendToJsFunction_marketApiCall;
//    }
    //1009 用市场的名字
    NSString *funcName = kOcSendToJsFunction_marketApiCall;
    NSString *jsStr = [NSString stringWithFormat:@"%@(%@)",funcName,willSendDataJsonStr];
    NSLog(@"webGetLogoutAction  jsStr ==  %@ ",jsStr);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            NSLog(@" webGetLogoutAction 回复  == result %@ ，error %@",result, error);
            if(isNotNil(error)){
                Y_SVP_SHOW_ERR_MES([TextShowWithModelStr textShowWithModelStr:error.description]);

            }
        }];
    });
    
    [MySetTool logOutAction];
}
 
#pragma mark === 私信
- (void)gotoSiXinImIDStr:(NSString *)imIdStr{
    
    TUIChatConversationModel *data = [[TUIChatConversationModel alloc] init];
    data.userID = imIdStr;//u07iv2oWepcgC
    data.title = @"";
    //两个都可以 push前需要吧nav显示
//    dispatch_async(dispatch_get_main_queue(), ^{
//        ImChatVc *vc = [[ImChatVc alloc]init];
//        vc.converInfo  = data;
//        vc.isGroupType = NO;
//        vc.friendId = data.userID;
//        vc.title = data.title;
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
//        [self.navigationController pushViewController:vc animated:YES];
//    });
    
    if([ShareUserInfo share].userInfo.token.length<=0){
        NSString *shwoPleseLogin = Y_LocaleTypeFile_NSLocalString(@"请登录");
        Y_SVP_SHOW_INFO_MES_5Delay(shwoPleseLogin);//调起登录相关签名
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        TUIC2CChatViewController_Minimalist *vc = [[TUIC2CChatViewController_Minimalist alloc] init];
        TUIChatConversationModel *converInfo = [[TUIChatConversationModel alloc]init];
        converInfo.userID = imIdStr;
        [vc setConversationData:converInfo];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self.navigationController pushViewController:vc animated:YES];
    });
    
}


#pragma mark === 群
- (void)gotoGroupWithGroupIdStr:(NSString *)groupId{
    
    
    TUIChatConversationModel *data = [[TUIChatConversationModel alloc] init];
    data.groupID = groupId;
    data.title = @"";
    
    dispatch_async(dispatch_get_main_queue(), ^{
//        ImChatVc *vc = [[ImChatVc alloc]init];
//        vc.converInfo  = data;
//        vc.isGroupType = YES;
//        vc.groupId = data.groupID;
//        vc.title = data.title;
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
        TUIChatConversationModel *conversationModel = [TUIChatConversationModel new];
        conversationModel.groupID = data.groupID;
 
        TUIBaseChatViewController_Minimalist *chatVC = nil;
        chatVC = [[TUIGroupChatViewController_Minimalist alloc] init];
        chatVC.conversationData = conversationModel;
        chatVC.title = conversationModel.title;
        chatVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chatVC animated:YES];
    });
    
   
}

#pragma mark ===
- (void)getTypeNum1104ActionWithDic:(NSDictionary *)bodyDic{
    
}

#pragma mark ===
 //dapp访问记录 也许会收到的回复数据
- (void)dappGetSetDappRecordWithDic:(NSDictionary *)bodyDic{
    DLog(@"");
}
#pragma mark === 消息转发 dapp wallet
- (void)webInfoDappSendToWalletvcWithDic:(NSDictionary *)bodyDic{
    DLog(@"");
}


- (void)webInfoWalletSendToDappvcWithDic:(NSDictionary *)bodyDic{
    DLog(@"");
}

#pragma mark ===

#pragma mark - KVO进度条监听事件
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            [self.progressView setProgress:1.0 animated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressView.hidden = YES;
                [self.progressView setProgress:0 animated:NO];
            });

        }else {
            self.progressView.hidden = NO;
            self.progressView.backgroundColor = [UIColor clearColor];
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}


#pragma mark == 红包相关
- (void)RedEnv_OnWebVc_SignGetedWithData:(NSString *)resultStr{
    NSLog(@"model.method  personalSign 红包相关接口");
    
}

@end
