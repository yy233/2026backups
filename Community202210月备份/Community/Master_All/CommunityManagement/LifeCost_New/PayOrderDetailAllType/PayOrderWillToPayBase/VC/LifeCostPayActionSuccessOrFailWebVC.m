//
//  LifeCostPayActionSuccessOrFailWebVC.m
//  Community
//
//  Created by 余莹 on 2022/1/10.
//

#import "LifeCostPayActionSuccessOrFailWebVC.h"
#import "LifeCostData.h"
#import "LifeWillToPayOrderDetailModel.h"
#import "LifeCostPayHistoryOrderSubOrderEntityModel.h"
#import "LifeCosePayMoneyEndWithSuccessStatusVC.h"


static NSString *shopWebViewiOSGetJsInfoFunctionName = @"shopWebViewiOSFunction";
static NSString *shopOcSendToJsWithFunctionName = @"ocSendToJsWithFunctionName";

//0408换成了正式的

 #define H5Pay_WxWebView_Referer       @"yaoyao.cebbank.com://eHomeH5WxPayBack"
// static const NSString* schemeString = @"yaoyao.cebbank.com";//做本页用到的redirectUrl的来法
 static const NSString* schemeStringAndAppDelegateUrlHostBackStr = @"yaoyao.cebbank.com://eHomeH5WxPayBack/";
// schemeString 添加到info这是正式版用的返回响应数据



//0408换成正式服的 ｜测试可用的
/** 可正常跳转的*/
/**
 //#define H5Pay_WxWebView_Referer       @"yaoyaotest.cebbank.com://" 加返回时appdelegate url host
 #define H5Pay_WxWebView_Referer       @"yaoyaotest.cebbank.com://eHomeH5WxPayBack"
 static const NSString* schemeString = @"yaoyaotest.cebbank.com";//做本页用到的redirectUrl的来法
 static const NSString* schemeStringAndAppDelegateUrlHostBackStr = @"yaoyaotest.cebbank.com://eHomeH5WxPayBack/";
 */
 

//文档内的Referer schem useragent
/**
 云缴费客户端测试环境 Referer 为 https://yaoyaotest.cebbank.com
 云缴费客户端生产环境 Referer 为 https://yaoyao.cebbank.com
 接入云缴费客户端的服务需要设置的 User-Agent:YunjiaofeiClient
 接入云缴费客户端需要设置的 Url Scheme:yunjiaofei
 */
/**  微信能拉起 但不会回app的文档内用到参数据
 //#define H5Pay_WxWebView_Referer       @"https://yaoyaotest.cebbank.com" //用本https回返回到这个网页网址
 #define H5Pay_WxWebView_Referer       @"yaoyaotest.cebbank.com" //去掉https 不会返回到网页
 static const NSString* schemeString = @"yunjiaofei";//做本页用到的redirectUrl的来法
 static const NSString* schemeStringAndAppDelegateUrlHostBackStr = @"yunjiaofei://eHomeH5WxPayBack/";
 //#define H5Pay_WxWebView_UserAgent    @"YunjiaofeiClient"  //带UserAgent后 微信能拉起 但不会回app
 
 */


 
 
@interface LifeCostPayActionSuccessOrFailWebVC () <UINavigationControllerDelegate,WKScriptMessageHandler,WKUIDelegate,WKNavigationDelegate,UIGestureRecognizerDelegate>
@property (nonatomic,strong) NSString *savereloadURLstr;
@end

@implementation LifeCostPayActionSuccessOrFailWebVC

 - (void)viewDidLoad {
    [super viewDidLoad];
    // pop返回手势
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [self initAll];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"支付";
    [self.navigationController setNavigationBarHidden:NO animated:YES];//用作返回
    [self setupNavigationBarWhiteStyle];//白色状态
    
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
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"shopWebViewiOSGetJsInfoFunctionName"];
 
}
- (void)dellocNotices{
    Y_NSNotificationCenter_RemoveNotice_Name(PaySuccessedEndInfo_Notice_Name);
    Y_NSNotificationCenter_RemoveNotice_Name(PayFailEndInfo_Notice_Name);
    Y_NSNotificationCenter_RemoveNotice_Name(NoticeName_WxPayBackH5Type);
}

#pragma mark === notice
- (void)initNotice{
    [self addNoticeOfPay];
}
- (void)addNoticeOfPay{
    Y_NSNotificationCenter_Creat_NameAction(PaySuccessedEndInfo_Notice_Name, paySuccessNotice:);
    Y_NSNotificationCenter_Creat_NameAction(PayFailEndInfo_Notice_Name, payFailNotice:);
    Y_NSNotificationCenter_Creat_NameAction(NoticeName_WxPayBackH5Type, wxPayBackNotice:)
}
 
#pragma mark ======= notice—————————— pay  get
- (void)payFailNotice:(NSNotification *)notice{
    NSString *failMsg =  [notice.userInfo objectForKey:[notice.userInfo allKeys].firstObject];
    Y_SVP_SHOW_INFO_MES(failMsg);
}

- (void)paySuccessNotice:(NSNotification *)notice{
   NSString  *orderStatusMessage = @"当前订单 支付成功。";//回生活缴费主页
    Y_SVP_SHOW_SUCCESS_MES(orderStatusMessage);
    dispatch_async(dispatch_get_main_queue(), ^{
        LifeCosePayMoneyEndWithSuccessStatusVC *vc = [[LifeCosePayMoneyEndWithSuccessStatusVC alloc]init];
        [self pushVc:vc];
    });

}
/**
 从微信回来后
 */
- (void)wxPayBackNotice:(NSNotification *)notice{
    /**参数错误等问题 不刷新存的url  |做查询弹出框
     //用跳转前保存的url 刷新当前界面
     if (self.savereloadURLstr.length <= 0) {
         return;
     }
     dispatch_async(dispatch_get_main_queue(), ^{
         NSLog(@"跳转前保存的url刷新当前界面");
         NSURL *url = [NSURL URLWithString:self.savereloadURLstr];
         NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
         [self.webView loadRequest:req];
     });
     */
 
    //加载提示框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"暂未得到支付状态" message:@"是否前往查询" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"去查询" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        DLog(@"去查询");
        [self checkOrderStatusAction];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    alert.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alert animated:YES completion:nil];
}
//查看 订单状态
- (void)checkOrderStatusAction{ 
    if (self.orderNoStr.length<=0) {
        NSLog(@"无法获取 当前订单详情。");
        return;
    }
    [LifeCostData lifeCostCheckOrderNoStr:self.orderNoStr withBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
        if (success) {
            NSLog(@"当前订单详情数据 = %@",dic);
            LifeCostPayHistoryOrderSubOrderEntityModel *model =  [LifeCostPayHistoryOrderSubOrderEntityModel mj_objectWithKeyValues:dic];
            [self dealWithOrderStatus:model.orderStatus];
        }
    }];
}
/**
 "orderStatus":  --0:订单创建成功;1:支付成功;2:支付失败;3:销账成功;4:销账失败;5:未知状态;8:实时退款
 */
- (void)dealWithOrderStatus:(NSInteger)orderStatus{
    
    NSString *orderStatusMessage = @"未知状态";
    switch (orderStatus) {
        case 0:
            orderStatusMessage = @"当前订单未支付。";
            break;
        case 1:
        {
            orderStatusMessage = @"当前订单 支付成功。";
            Y_SVP_SHOW_SUCCESS_MES(orderStatusMessage);
            dispatch_async(dispatch_get_main_queue(), ^{
                LifeCosePayMoneyEndWithSuccessStatusVC *vc = [[LifeCosePayMoneyEndWithSuccessStatusVC alloc]init];
                [self pushVc:vc];
            });
            return;
        }
            break;
        case 2:
            orderStatusMessage = @"当前订单 支付失败。";
            break;
        case 3:
            orderStatusMessage = @"销账成功。";
            break;
        case 4:
            orderStatusMessage = @"销账失败。";
            break;
        case 5:
            orderStatusMessage = @"未知状态";
            break;
        case 8:
            orderStatusMessage = @"当前订单 已实时退款";
            break;
        default:
            break;
    }
    Y_SVP_SHOW_INFO_MES(orderStatusMessage);
    
  
   
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
    [self initNotice];
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
    if (self.payActionPlaceOrderEndGetUrlStr.length <= 0) {
        return;
    }
    self.savereloadURLstr = @"";
    NSString *allUrlStr = self.payActionPlaceOrderEndGetUrlStr;
    NSLog(@"initData allUrlStr %@",allUrlStr);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:allUrlStr] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:15.0];//缓存属性
//    [request setValue:H5Pay_WxWebView_Referer forHTTPHeaderField:@"Referer"];
    [request setHTTPMethod:@"GET"];
    [_webView loadRequest:request];
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
    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];
//    self.webView.customUserAgent = H5Pay_WxWebView_UserAgent;
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    [self.view addSubview:self.webView];
}
 
#pragma mark - WKNavigationDelegate
// 根据WebView对于即将跳转的HTTP请求头信息和相关信息来决定是否跳转
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
//
//
//       NSURLRequest *request = navigationAction.request;
//       NSString *absoluteString = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
//       NSString *urlString = absoluteString ;
//    NSLog(@"allHTTPHeaderFields = %@",request.allHTTPHeaderFields);
//    NSLog(@"url = %@",navigationAction.request.URL.absoluteString);
//       // 拦截WKWebView加载的微信支付统一下单链接, 将redirect_url参数修改为唤起自己App的URLScheme
////       if ([absoluteString hasPrefix:@"https://wx.tenpay.com/"] && ![absoluteString hasSuffix:[NSString stringWithFormat:@"&redirect_url=%@",H5Pay_WxWebView_URLScheme]]) {
////           decisionHandler(WKNavigationActionPolicyCancel);
////           NSString *redirectUrl = nil;
////           if ([absoluteString containsString:@"redirect_url="]) {
////               NSRange redirectRange = [absoluteString rangeOfString:@"redirect_url"];
////               redirectUrl = [[absoluteString substringToIndex:redirectRange.location] stringByAppendingString:[NSString stringWithFormat:@"redirect_url=%@",H5Pay_WxWebView_URLScheme]];
////           } else {
////               redirectUrl = [absoluteString stringByAppendingString:[NSString stringWithFormat:@"&redirect_url=%@",H5Pay_WxWebView_URLScheme]];
////           }
////           NSMutableURLRequest *newRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:redirectUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
////           newRequest.allHTTPHeaderFields = request.allHTTPHeaderFields;
////           newRequest.URL = [NSURL URLWithString:redirectUrl];
////           [newRequest setValue:H5Pay_WxWebView_Referer forHTTPHeaderField:@"Referer"];
////           [newRequest setHTTPMethod:@"GET"];
////           NSLog(@"newRequest.URL = %@",newRequest.URL);
////           [webView loadRequest:newRequest];
////           return;
////       }
//    //----
////    NSString *jumpString = @"https://wx.tenpay.com";
////    NSString *redirectKeyAndObjWillToEncode = [NSString stringWithFormat:@"%@=%@://",redirectKeyString,schemeString];
////    NSString *changeredirectString = [Tool encodeToPercentEscapeString:redirectKeyAndObjWillToEncode];
////    NSString *redirectObjEncode = [Tool encodeToPercentEscapeString:schemeString] ;
////    NSString *changeredirectString = [NSString stringWithFormat:@"%@=%@://",redirectKeyString,redirectObjEncode];;
////    if([urlString hasPrefix:jumpString] && ![urlString containsString:changeredirectString]) {
////        decisionHandler(WKNavigationActionPolicyCancel);
////        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
////
////            dispatch_async(dispatch_get_main_queue(), ^{
////
////                NSRange redirectRange = [urlString rangeOfString:@"redirect_url"];
////
////                //更改redirect_url 为scheme的地址
////
////              //  NSString*redirectUrl = [[urlString substringToIndex:redirectRange.location]stringByAppendingString:changeredirectString];
////                NSString*redirectUrl = urlString;
////                //记录本来跳转的地址，用于APP回来之后的刷新
////
////                NSArray*reloadArray = [urlString componentsSeparatedByString:@"redirect_url="];
////
////                if(reloadArray.count>1) {
////
////                    self.savereloadURLstr = [[reloadArray lastObject]stringByRemovingPercentEncoding];
////
////                }else{
////
////                    self.savereloadURLstr =[NSString stringWithFormat:@"https:%@",schemeString] ;
////
////                }
////
////                NSLog(@"savereloadURLstr == %@",self.savereloadURLstr);
////
////                //发送请求
////                NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:redirectUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
////
////                NSLog(@"redirectUrl == %@",redirectUrl);
////                NSLog(@"allHTTPHeaderFields = %@",request.allHTTPHeaderFields);
////                [request setHTTPMethod:@"GET"];
////                //referer为空会提示"出现商家参数格式有误，请联系商家解决"
////
////                //设置Referer 此地址必须注册到商户后台
////
////                [request setValue:H5Pay_WxWebView_Referer forHTTPHeaderField:@"Referer"];
////
////                [webView loadRequest:request];
////
////            });
////
////        });
////        return;
////    }
//
 
//}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSString*urlString = navigationAction.request.URL.absoluteString;
    urlString = [urlString stringByRemovingPercentEncoding];
    NSString *absoluteString = urlString;
    NSLog(@"decidePolicyForNavigationAction ------------- %@",absoluteString);
    //wx:______
    // 拦截WKWebView加载的微信支付统一下单链接, 将redirect_url参数修改为唤起自己App的URLScheme https://yaoyaotest.cebbank.com/
    if ([absoluteString hasPrefix:@"https://wx.tenpay.com/cgi-bin/mmpayweb-bin/checkmweb?"] && ![absoluteString containsString:[NSString stringWithFormat:@"&redirect_url=%@",schemeStringAndAppDelegateUrlHostBackStr]]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        NSString *redirectUrl = nil;
        
        if ([NSString stringWithFormat:@"redirect_url=%@",schemeStringAndAppDelegateUrlHostBackStr]) {
            
            NSMutableArray *allRULArray = [NSMutableArray arrayWithArray:[absoluteString componentsSeparatedByString:@"&"]];
            NSMutableArray *saveAllURlArr = [[NSMutableArray alloc]initWithArray:allRULArray];
            for (int i = 0 ; i < allRULArray.count; i++) {
                NSString *absoluteStringSubStr = allRULArray[i];
                if ([absoluteStringSubStr containsString:@"redirect_url"]){
                    NSString *newRedirectKeyObjstr = [Tool encodeToPercentEscapeString:[NSString stringWithFormat:@"redirect_url=%@",schemeStringAndAppDelegateUrlHostBackStr]];
                    [saveAllURlArr replaceObjectAtIndex:i withObject: newRedirectKeyObjstr];
                }
            }
            redirectUrl = [NSString stringWithFormat:@"%@",[saveAllURlArr componentsJoinedByString:@"&"]];
        } else {
            redirectUrl = [absoluteString stringByAppendingString:[NSString stringWithFormat:@"&redirect_url=%@",schemeStringAndAppDelegateUrlHostBackStr]];
        }
        self.savereloadURLstr = redirectUrl;
        NSLog(@"跳转微信之前 保存的用于回来后刷新的URL == %@ ",self.savereloadURLstr);
        NSMutableURLRequest *newRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:redirectUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
        newRequest.URL = [NSURL URLWithString:redirectUrl];
        if (isNil(newRequest.allHTTPHeaderFields) || ![[newRequest.allHTTPHeaderFields allKeys]containsObject:@"Referer"]) {
            NSLog(@"redirectUrl == %@",redirectUrl);
            NSLog(@"allHTTPHeaderFields = %@",newRequest.allHTTPHeaderFields);
            [newRequest setHTTPMethod:@"GET"];
            //referer为空会提示"出现商家参数格式有误，请联系商家解决"设置Referer 此地址必须注册到商户后台
            [newRequest setValue:H5Pay_WxWebView_Referer forHTTPHeaderField:@"Referer"];
            [webView loadRequest:newRequest];
        }else{
            [webView loadRequest:newRequest];
            
        }
        return;
    }
    //wx:---
    if ([urlString containsString:@"weixin://wap/pay?"]) {//微信
        //解决wkwebview weixin://无法打开微信客户端的处理
        if ( [WXApi isWXAppInstalled]) {
            //back
            NSLog(@"urlString = %@",urlString);
            NSURL *url = [NSURL URLWithString:urlString];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if(@available(iOS 10.0, *)) {
                    [[UIApplication sharedApplication] openURL:url options:@{UIApplicationOpenURLOptionUniversalLinksOnly: @NO} completionHandler:^(BOOL success) {
                        DLog(@"打开wx");
                    }];
                }else{
                    // Fallback on earlier versions
                }
            });
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }else{
            decisionHandler(WKNavigationActionPolicyCancel);
            Y_SVP_SHOW_INFO_MES(@"您未安装微信，暂不可使用微信支付。");
            NSLog(@"/未安装微信, 自行处理");
            //重新加载主页
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSURL *url = [NSURL URLWithString:self.payActionPlaceOrderEndGetUrlStr];
                NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
                [self.webView loadRequest:req];
            });
            return;
        }
        //zfb:---
    }else if ([urlString containsString:@"alipay://"]){//alipay://alipayclient/
        NSLog(@"拉起支付宝 wkwebview alipay:// 无法打开支付宝客户端的处理___  %@",urlString);
        //———————— 无app
        if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay:"]]) {
            //如果没有安装支付宝客户端
            decisionHandler(WKNavigationActionPolicyAllow);
        }else{//———————— 有app
            //拦截到之后不允许跳转
            decisionHandler(WKNavigationActionPolicyCancel);
            //截取到的是参数拼成的json字符串
            NSString* dataStr=[urlString substringFromIndex:23];
            //将json字符串转化成字典
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[dataStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
            /**因为我本身项目中就已经集成过支付宝支付的sdk，所以我就试了一下看能否直接用他们的sdk唤起支付宝客户端,结果证明可以，还顺便解决了返回原app的问题。
             payOrder     --->   订单信息
             fromScheme   --->   填写你自己app的scheme,这样可以解决，支付后返回到本app的问题。
             */
            NSLog(@"zfbPay str = %@",dict[@"dataString"]);
            [[ZfbPayManager shareManager]hangleZFPayOrderStr:dict[@"dataString"]];
        }
    //微信回来 暂没见过调用
    }else if ([urlString isEqualToString:[NSString stringWithFormat:@"%@",schemeStringAndAppDelegateUrlHostBackStr]]){//没有得到过
        NSLog(@"从微信回来后刷新url %@",schemeStringAndAppDelegateUrlHostBackStr);
        decisionHandler(WKNavigationActionPolicyCancel);
        if (self.savereloadURLstr.length <= 0) {
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURL *url = [NSURL URLWithString:self.savereloadURLstr];
            NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
            [self.webView loadRequest:req];
        });
        
    //云闪付 去 商店
    }else if([urlString containsString:@"itms-appss://apps.apple.com"]){//去 商店
        decisionHandler(WKNavigationActionPolicyCancel);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if(@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{UIApplicationOpenURLOptionUniversalLinksOnly: @NO} completionHandler:^(BOOL success) {
                    DLog(@"打开商店");
                }];
            }else{
                // Fallback on earlier versions
            }
        });
    //云闪付 去云闪付的app
    }else if ([urlString containsString:@"uppaywallet://uppay?"]){
           //———————— 无app
        if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"uppaywallet:"]]) {
            //如果没有安装 云闪付的app客户端
            DLog(@"没有安装云闪付的app");
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_ERR_MES(@"暂没安装云闪付的APP");
            });
            decisionHandler(WKNavigationActionPolicyAllow);
        }else{//———————— 有app
            decisionHandler(WKNavigationActionPolicyCancel);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if(@available(iOS 10.0, *)) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{UIApplicationOpenURLOptionUniversalLinksOnly: @NO} completionHandler:^(BOOL success) {
                        DLog(@"打开 云闪付的app");
                    }];
                }else{
                    // Fallback on earlier versions
                }
            });
        }
        
    }else{
        NSLog(@"普通未截断的 URL：\n \n   %@  \n \n ",urlString);
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    
}

#pragma mark == 商户APP的WebView处理alipays协议 end
- (NSDictionary *)turnStringToDictionary:(NSString *)turnString
{
    NSData *turnData = [turnString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *turnDic = [NSJSONSerialization JSONObjectWithData:turnData options:NSJSONReadingMutableLeaves error:nil];
    return turnDic;
}

//接收到相应数据后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSLog(@"知道返回内容之后，是否允许加载，允许加载");
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
//重定向打开新界面
- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    NSLog(@"。createWebViewWithConfiguration 111");
    
    WKFrameInfo *frameInfo = navigationAction.targetFrame;
    if (![frameInfo isMainFrame]) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}
//uiwebview 中这个方法是私有方法 通过category可以拦截alert
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
        self.webView.backgroundColor = [UIColor greenColor];
    }]];
    alert.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    alert.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alert animated:YES completion:nil];
    
}
// 显示一个带有输入框和一个确定按钮的，通过completionHandler回调用户输入的内容
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"t" message:@"m" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler(alertController.textFields.lastObject.text);
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    
    NSDictionary *bodyParam = (NSDictionary*)message.body;
    NSString *func = [bodyParam objectForKey:@"function"];
    
    NSLog(@"MessageHandler Name:%@", message.name);
    NSLog(@"MessageHandler Body:%@", message.body);
    NSLog(@"MessageHandler Function:%@",func);
}

@end
