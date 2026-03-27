//
//  MedicalWebViewVc.m
//  Community
//
//  Created by 余莹 on 2021/12/7.
//

#import "MedicalWebViewVc.h"
#import "ZYPensionMainVC.h"
#import "ZYChatVc.h"
#import "MainAllTypeInformationVC.h"
#import "ShoppingMallWebViewData.h"
#import "HouseRentBuniessDetailVcChatApplyViewModel.h"
#import "HouserBuniessChatInfoModel.h"

#define WebView_ShoppingURL_NotPost_successPay          @"pages/successA/successA" //支付成功

#define WebView_ShoppingURL_NotPost_MallGoods           @"pages/mall/mall"  //养老医疗商城物品 推荐产品

#define WebView_ShoppingURL_NotPost_MedicalServices     @"pages/medical/medical"  //医疗服务 &childrens={"name":"医疗服务","id":"6"}

#define WebView_ShoppingURL_NotPost_StoreDetailIndex    @"pages/storeIndex/storeIndex"  // 店铺详情 shopid=1467745568508461058&name=aabbcc

#define WebView_ShoppingURL_NotPost_ServicesDetailIndex @"pages/foodDetails/foodDetails"  //  服务详情 foodid=1471765024242049026&type=1

#define WebView_ShoppingURL_NotPost_FillInTheDiseaseExpertInformation  @"pages/archives/archives" //填写病症得专家消息  类型4 +name

#define WebView_ShoppingURL_NotPost_MyOrder             @"pages/Myorder/Myorder"  //  我的订单

 
 

static NSString *shopWebViewiOSGetJsInfoFunctionName = @"shopWebViewiOSFunction";
static NSString *shopOcSendToJsWithFunctionName = @"ocSendToJsWithFunctionName";

typedef enum : NSUInteger {
    ShopWebViewiOSFunction_GetTypeNum_BackPopVC=1,
    ShopWebViewiOSFunction_GetTypeNum_Pay=3,
    ShopWebViewiOSFunction_GetTypeNum_GotoChatVc=5,
    ShopWebViewiOSFunction_GetTypeNum_GotoInformationVc=6,//跳转消息页面
    ShopWebViewiOSFunction_GetTypeNum_CallPhone=7,//打电话
    
} ShopWebViewiOSFunction_GetTypeNum;

@interface MedicalWebViewVc () <UINavigationControllerDelegate,WKScriptMessageHandler,WKUIDelegate,WKNavigationDelegate,UIGestureRecognizerDelegate>
@property (nonatomic,strong)   WKWebView        *webView;
@property (nonatomic,strong)   UIProgressView   *progressView;

@end

@implementation MedicalWebViewVc

#pragma mark === nav

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断如果是需要隐藏导航控制器的类，则隐藏
    BOOL isHideNav = ([viewController isKindOfClass:[self class]] ||
                      [viewController isKindOfClass:[ZYPensionMainVC class]]);//上一页 也是隐藏了nav用的view
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
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];//隐藏nav
    
    //chatvc informantionvc not hiden

}
 
#pragma mark === dealloc
- (void)dealloc{
    [self dellocAllScriptMessageHandler];
    [self dellocNotices];
    self.navigationController.delegate = nil;
    
}
- (void)dellocAllScriptMessageHandler{
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:shopWebViewiOSGetJsInfoFunctionName];
}
- (void)dellocNotices{
    Y_NSNotificationCenter_RemoveNotice_Name(PaySuccessedEndInfo_Notice_Name);
    Y_NSNotificationCenter_RemoveNotice_Name(PayFailEndInfo_Notice_Name);
}

#pragma mark === notice
- (void)initNotice{
    [self addNoticeOfPay];
}
- (void)addNoticeOfPay{
    Y_NSNotificationCenter_Creat_NameAction(PaySuccessedEndInfo_Notice_Name, paySuccessNotice:);
    Y_NSNotificationCenter_Creat_NameAction(PayFailEndInfo_Notice_Name, payFailNotice:);
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
    NSString *token = [ShareUserInfo sharedUserInfo].token;
    NSInteger height = status_height*2;
    NSString *allUrlStr = @"";
    switch (self.selfInitType ) {
        case MedicalWebViewVc_ShowInitType_BaseShoppingMain://总商城
        {
            allUrlStr = [NSString stringWithFormat:@"%@?statusHeight=%ld&token=%@&APPreturn=1",BaseURLWithShopping_BaseAndPost,height,token];

        }
            break;
        case MedicalWebViewVc_ShowInitType_MedicalServices: //医疗服务
        {
            NSDictionary *initMedicalServicesDic = @{@"name":@"医疗服务",@"id":@"6"};
            NSString *jsonWithDic = [Tool jsonStrWithDic:initMedicalServicesDic];
            NSString *encodeStr = [Tool encodeToPercentEscapeString:jsonWithDic];
            allUrlStr = [NSString stringWithFormat:@"%@%@?statusHeight=%ld&token=%@&childrens=%@&APPreturn=1",BaseURLWithShopping_BaseAndPost,WebView_ShoppingURL_NotPost_MedicalServices,height,token,encodeStr];
        }
            break;
        case MedicalWebViewVc_ShowInitType_MallGoods: //推荐产品
        {
            allUrlStr = [NSString stringWithFormat:@"%@%@?statusHeight=%ld&token=%@&APPreturn=1",BaseURLWithShopping_BaseAndPost,WebView_ShoppingURL_NotPost_MallGoods,height,token];

        }
            break;
        case MedicalWebViewVc_ShowInitType_StoreDetail: //商铺
        {
            NSString *initInfoStr = [NSString stringWithFormat:@"shopid=%@&name=%@",self.shopIdStr, [Tool encodeToPercentEscapeString:self.shopNameStr]];
            allUrlStr = [NSString stringWithFormat:@"%@%@?statusHeight=%ld&token=%@&%@&APPreturn=1",BaseURLWithShopping_BaseAndPost,WebView_ShoppingURL_NotPost_StoreDetailIndex,height,token,initInfoStr];

        }
            break;
        case MedicalWebViewVc_ShowInitType_ServicesDetail://服务
        {
            NSString *initInfoStr = [NSString stringWithFormat:@"foodid=%@&type=%ld",self.serviceIdStr,self.serviceType];
            allUrlStr = [NSString stringWithFormat:@"%@%@?statusHeight=%ld&token=%@&%@&APPreturn=1",BaseURLWithShopping_BaseAndPost,WebView_ShoppingURL_NotPost_ServicesDetailIndex,height,token,initInfoStr];
            
        }
            break;
        case MedicalWebViewVc_ShowInitType_FillInTheDiseaseExpertInformation://填写病症得专家消息
        {
            NSString *initInfoStr = [NSString stringWithFormat:@"type=%d&title=%@",4, [Tool encodeToPercentEscapeString:@"社区医疗"]];
            allUrlStr = [NSString stringWithFormat:@"%@%@?statusHeight=%ld&token=%@&%@&APPreturn=1",BaseURLWithShopping_BaseAndPost,WebView_ShoppingURL_NotPost_FillInTheDiseaseExpertInformation,height,token,initInfoStr];
            
        }
            break;
            
        case MedicalWebViewVc_ShowInitType_MyOrder:
        {
            //&APPreturn=1 多处使用 h5用以区分响应
            allUrlStr = [NSString stringWithFormat:@"%@%@?statusHeight=%ld&token=%@&APPreturn=1",BaseURLWithShopping_BaseAndPost,WebView_ShoppingURL_NotPost_MyOrder,height,token];
        }
            break;
            
            
        default:
            break;
    }
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
    //最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
    preference.minimumFontSize = 0;
    //设置是否支持javaScript 默认是支持的
    preference.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
//    preference.javaScriptCanOpenWindowsAutomatically = YES;
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
    if ([self shouldShowLoginVcOrBindVcBool]) {
        return;
    }
    NSInteger type = [[dic allKeys] containsObject:@"type"] ?  [[dic objectForKey:@"type"] integerValue] : 0;
    NSString *orderId = [[dic allKeys] containsObject:@"orderId"] ? [NSString stringWithFormat:@"%@",[dic objectForKey:@"orderId"]] : @"";
    NSString *imId = [[dic allKeys] containsObject:@"imId"] ? [NSString stringWithFormat:@"%@",[dic objectForKey:@"imId"]] : @"";
    NSString *phoneString = [[dic allKeys] containsObject:@"phoneString"] ? [NSString stringWithFormat:@"%@",[dic objectForKey:@"phoneString"]] : @"";
    
    switch (type) {
        case ShopWebViewiOSFunction_GetTypeNum_BackPopVC:
        {
            //返回
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
            
        case ShopWebViewiOSFunction_GetTypeNum_Pay:
        {
            //type=3 支付
            if (orderId.length>0){
                [self payMoneyActionWithOrderId:orderId withNotUseType:type];
            }
        }
            break;
        case ShopWebViewiOSFunction_GetTypeNum_GotoChatVc:
        {
            //type=5 聊天
            if (imId.length>0){
                [self goToChatVcActionWithImId:imId];
            }
        }
            break;
            
        case ShopWebViewiOSFunction_GetTypeNum_GotoInformationVc:
        {
            //type=6  跳转消息页面
            [self goToInformationVcAction];
            
        }
            break;
        case ShopWebViewiOSFunction_GetTypeNum_CallPhone:
        {
            [self callPhoneWithStr:phoneString];
        }
            break;
        default:
        {
            DLog(@"type=%ld",type);
        }
            
            break;
    }
}

#pragma mark == 打电话

- (void)callPhoneWithStr:(NSString *)phoneStr{
    DLog(@"callPhoneWithStr %@",phoneStr);
    NSMutableString *callStr=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phoneStr];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callStr] options:@{} completionHandler:nil];

}
#pragma mark == 跳转消息页面
- (void)goToInformationVcAction{
    
    MainAllTypeInformationVC *vc = [[MainAllTypeInformationVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
 
#pragma mark == 聊天相关
- (void)goToChatVcActionWithImId:(NSString *)imId{
    NSLog(@"goToChatVcActionWithImId 交流");
    WEAKSELF
    //医疗服务模块 --- 商家类型的陌生人
    [ChatVcWillGoOneChatVcTool chatVcPushInfoWithClearnUseID:0 withImIdStr:imId withThisStrangerChatType:ChatVc_Stranger_Chat_Application_merchantBuniess withBlock:^(ZYChatVc * _Nonnull willPushVc, BOOL success) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.navigationController pushViewController:willPushVc animated:YES];
            });
        
        }
    }];
    
    /**
     //非好友的通信申请
     //和商家聊天
     [HouseRentBuniessDetailVcChatApplyViewModel webViewShopBuniessDetailVcChatApplyWithImIdStr:imId withBlock:^(NSDictionary * dic, BOOL success) {
         if (success) {
             NSString *ownHeaderImgUrlStr = [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].chatUserMyOwn.headImgMaxUrl;
             HouserBuniessChatInfoModel *chatInfoModel = [HouserBuniessChatInfoModel mj_objectWithKeyValues:dic];
             NSString *ownUUID = [TextShowWithModelStr textShowWithModelStr:chatInfoModel.userAccount];
             NSString *toUserHeaderImgUrlStr = [TextShowWithModelStr textShowWithModelStr:chatInfoModel.head_img_max_url];
             NSString *toUserUUID = [TextShowWithModelStr textShowWithModelStr:chatInfoModel.otherAccount];
             NSString *toUserNickName = [TextShowWithModelStr textShowWithModelStr:chatInfoModel.nickName];
             DLog(@" \n ____________  非好友的通信申请 得到数据  \n %@ \n",[chatInfoModel mj_keyValues]);

             if (ownUUID.length<=0 || toUserUUID.length<=0) {
                 Y_SVP_SHOW_ERR_MES(@"用户信息 暂无即时通讯ID！");
                 return;
             }
             dispatch_async(dispatch_get_main_queue(), ^{
                 ZYChatVc *vc = [[ZYChatVc alloc] init];
                 vc.thisChatVc_Seesion_type = ChatVc_Seesion_type_BuniessShop;
                 vc.friendNickName = toUserNickName.length>0 ? toUserNickName  : @"暂无昵称";// top名字 暂用联系名不用chat昵称
                 vc.friendUUID =  toUserUUID;
                 vc.chatVcWillUseImId = imId;
                 vc.isMoShengRenTypeBoolNotShowRightItem = YES;
                 [weakSelf.navigationController pushViewController:vc animated:YES];
             });
         }else{
             Y_SVP_SHOW_ERR_MES(@"请求聊天失败。");
             return;
         }
        
     }];
     
     */
   
    
}


#pragma mark == 支付相关
- (void)payMoneyActionWithOrderId:(NSString *)orderId withNotUseType:(NSInteger)type{
    [[AlertManager shareManager] creatAlertWithTitle:@"支付方式" message:@"" preferredStyle:UIAlertControllerStyleActionSheet cancelTitle:@"取消" otherTitleArr: [AlertManager shareManager].payTitleArr];
    [[AlertManager shareManager]showWithViewController:self IndexBlock:^(NSInteger index) {
        switch (index) {
            case AlertManagerCancelIndex:
                break;
            case  AlertManagerWXIndex :
            {
                Y_SVP_SHOW_MES_IsDealing_15Delay
                  [ShoppingMallWebViewData willWeChatInWebViewWithPayOrderType:type withOrderId:orderId withGetOrderInfo:^(WillPayOrderInfoModel * _Nonnull model, BOOL success) {
                      if (success) {
                          NSLog(@"WillPayOrderInfoMode 微信 %@",model);
                          if (success) {
                              PayReq *req   = [[PayReq alloc] init];
                              req.openID = [TextShowWithModelStr textShowWithModelStr:model.appid] ;                   //商家id
                              req.nonceStr  = [TextShowWithModelStr textShowWithModelStr:model.noncestr];
                              req.timeStamp = [[TextShowWithModelStr textShowWithModelStr:model.timestamp] intValue];  //时间戳
                              req.package   = [TextShowWithModelStr textShowWithModelStr:model.package];
                              req.partnerId = [TextShowWithModelStr textShowWithModelStr:model.partnerid];
                              req.prepayId  = [TextShowWithModelStr textShowWithModelStr:model.prepayid];
                              req.sign      = [TextShowWithModelStr textShowWithModelStr:model.sign];
                              dispatch_async( dispatch_get_main_queue(), ^{
                                  [[WeChatPayManager shareManager] hangleWechatPayWithPayReq:req];  //gowx
                              });
                          }
                      }
                  }];
            }
                break;
            case AlertManagerZFBIndex:
            {
                  Y_SVP_SHOW_MES_IsDealing_15Delay
                  [ShoppingMallWebViewData willZFBInWebViewWithPayOrderType:type withOrderId:orderId withGetOrderInfo:^(WillPayOrderInfoModel * _Nonnull model, BOOL success) {
                      if (success) {
                          NSLog(@"WillPayOrderInfoModel 支付宝 %@",model);
                          if (success) {
                              
                              NSString *zfbOrderStr = [TextShowWithModelStr textShowWithModelStr:model.orderStr];
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [[ZfbPayManager shareManager] hangleZFPayOrderStr:zfbOrderStr];
                              });
                            
                          }
                      }
                  }];
            }
                break;
                
            default:
                break;
        }
    }];
}

#pragma mark ==  支付结果
- (void)paySuccessNotice:(NSNotification *)notification{
    Y_SVP_SHOW_SUCCESS_MES(@"支付成功");
    //1224 跳转success 改成发送js空信息 以供h5跳转去支付成功界面等
    /**
     NSString *successWebViewStr = [BaseURLWithShopping_BaseAndPost stringByAppendingString:WebView_ShoppingURL_NotPost_successPay];//支付成功后的跳转url
     [self changeURLWithAfterStr:successWebViewStr];
     */
    NSString *jsStr = [NSString stringWithFormat:@"%@()", shopOcSendToJsWithFunctionName];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            NSLog(@" shopOcSendToJsWithFunctionName ==  %@----%@",result, error);
        }];
    });
}
- (void)changeURLWithAfterStr:(NSString *)allUrlNotHeightStr{
 
    NSString *token = [ShareUserInfo sharedUserInfo].token;
    NSInteger height = kStatusBarHeight;
    NSString *allUrlStr = [NSString stringWithFormat:@"%@?statusHeight=%ld&token=%@",allUrlNotHeightStr,height,token];
    NSLog(@"changeURLWithAfterStr  allUrlStr %@",allUrlStr);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:allUrlStr] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:15.0];//缓存属性
    [_webView loadRequest:request];
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
@end
