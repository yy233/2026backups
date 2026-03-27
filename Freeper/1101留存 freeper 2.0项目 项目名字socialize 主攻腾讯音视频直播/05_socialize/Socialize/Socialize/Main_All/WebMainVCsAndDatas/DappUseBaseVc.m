//
//  DappUseBaseVc.m
//  Socialize
//
//  Created by 余莹 on 2023/6/8.
//

#import "DappUseBaseVc.h"

#import "DappUsePopView.h"
#define Free_DAo   @"freedao"


#pragma mark  ============================================================ WeakWebViewScriptMessageDelegate 自定义的协议
// WKWebView 内存不释放的问题解决
@interface WeakWebViewScriptMessageDelegate : NSObject<WKScriptMessageHandler>
    
//WKScriptMessageHandler 这个协议类专门用来处理JavaScript调用原生OC的方法
@property (nonatomic, weak) id<WKScriptMessageHandler> scriptDelegate;
    
- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;
    
@end

#pragma mark ==============================WeakWebViewScriptMessageDelegate================================@implementation

@implementation WeakWebViewScriptMessageDelegate

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
    if ([message.name isEqualToString: @"JSCallOCMethod1"]) {
           //  message.body   是 `js` 传递的参数 ,一般是 json 字符串
           NSLog(@"DappUseBaseVc WeakWebViewScriptMessageDelegate ---- MessageBody: %@", message.body);
    }else{
        NSLog(@"DappUseBaseVc WeakWebViewScriptMessageDelegate ---- MessageBody: %@", message.body);

    }
    if ([self.scriptDelegate respondsToSelector:@selector(userContentController:didReceiveScriptMessage:)]) {
        [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
    }
}

@end


#pragma mark ==========================WeakWebViewScriptMessageDelegate==============================================end
 

@interface DappUseBaseVc ()<UINavigationControllerDelegate,WKScriptMessageHandler,WKUIDelegate,WKNavigationDelegate,UIGestureRecognizerDelegate,DappUsePopViewDelegate>
{
    NSMutableArray *jsCallOCMethodNames;
}
@property (nonatomic,strong) DappUsePopView *rightMorPopView;
@property (nonatomic,strong) NSString *savenabTitleStr;
@end

@implementation DappUseBaseVc

#pragma mark =============================== viewDidLoad
- (void)viewDidLoad {
    self.savenabTitleStr = @"";
    self.thisVcUseUrlStr = self.thisDappUseUrlStr;
    [super viewDidLoad];
    [self addDappWalletNotice];
   
}

/**
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];//不需要显示nav
}
 */
 - (void)viewWillAppear:(BOOL)animated{
     [super viewWillAppear:animated];
     [self.navigationController setNavigationBarHidden:NO animated:YES];//有需要显示nav 黑白切
     if([[ShareLocale shared].nowThemeStr isEqualToString: Now_Theme_light]){
         [self setupNavigationBarblackTextColorWithBackViewCustomColor:[UIColor  tui_colorWithHex:Theme_Nav_COlOR_Light_Str]];
     }else{
         [self setupNavigationBarWhiteTextColorWithBackViewCustomColor:[UIColor  tui_colorWithHex:Theme_Nav_COlOR_Drak_Str]];
     }

     
     [self addNavItem];//右边按钮
 //    self.tabBarController.tabBar.hidden = YES;//父级别有写
 }

#pragma mark =============================== nav
- (void)addNavItem{
    
    UIBarButtonItem *rightMaxItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"更多"] style:UIBarButtonItemStylePlain target:self action:@selector(rightNavItemAction)];
    [self.navigationItem setRightBarButtonItems:@[rightMaxItem] animated:YES];
    
}

#pragma mark =============================== other view + action

- (DappUsePopView *)rightMorPopView{
    _rightMorPopView = [[DappUsePopView alloc]init];
    _rightMorPopView.popViewTouchDelegate = self;
    _rightMorPopView.isShouCangTypeBool = self.isShouCangeType;//每次调起popv 都会给到最新的收藏状态
    return _rightMorPopView;
}
- (void)rightNavItemAction{
    [self.rightMorPopView showInView:self.view thePopViewSubViewHeight:0 WithArray:@[].mutableCopy];
    /**
     _dataArr = @[@"刷新",
     @"收藏",
     @"复制链接",
     @"分享",
     @"浏览器打开",
     ];
     */
}
//popview 点击事件
- (void)touchIndexType:(NSInteger)indexType{
    switch (indexType) {
        case DappUsePopView_ChooseType_Refresh://刷新
        {
            [self.webView reload];
        }
            break;
        case DappUsePopView_ChooseType_ShouCang://收藏
        {
            //isShouCangeType
            
            self.isShouCangeType = !self.isShouCangeType;
            //界面数据下次pop的状态用self.isShouCangeType 和上传数据 都要记录isShouCangeType
            [self nowShouCangTypeChange];
        }
            break;
        case DappUsePopView_ChooseType_CopyLink://复制链接
        {
            NSString *linkStr = self.thisDappUseUrlStr;
            if(linkStr.length > 0){
                [Y_ToolOfOthers copyStrClickWithStr:linkStr];
            }
            
        }
            break;
        case DappUsePopView_ChooseType_Share://分享
        {
            NSString *linkStr = self.thisDappUseUrlStr;
            if(linkStr.length > 0){
                [Y_ToolOfOthers shareLinkUrlWithStr:linkStr withNowVc:self];
            }
        }
            break;
        case DappUsePopView_ChooseType_LiuLanQiOp://浏览器打开
        {
            NSString *linkStr = self.thisDappUseUrlStr;
            if(linkStr.length > 0){
                [Y_ToolOfOthers openLiuLanQiWithLinkStr:linkStr];
            }
            
        }
            break;
        default:
            break;
    }
}
#pragma mark ===============================  浏览记录
//1002初始的东西
- (void)initSelfWith1002TypeOfLoadFinish{
    DLog(@" 其他需要在1002的初始_dapp暂无1002 浏览记录在拿到title时调用");//加载完成时使用
   
}

#pragma mark =============================== 收藏
////收藏相关 网络数据传出
- (void)nowShouCangTypeChange{
    [self lookDappHistoryOrNowIsSouCangBool:YES];
}
#pragma mark === 浏览记录
//加载完成后设置浏览记录 上传
-(void)lookDappHistoryOrNowIsSouCangBool:(BOOL)isSouCangTypeBool{
 
    if(isNil(self.dappShowUseInfoBodyDic)){
        return;
    }
    WebViewUseDataModel_dapplUse *model = [WebViewUseDataModel_dapplUse mj_objectWithKeyValues:self.dappShowUseInfoBodyDic];
    NSMutableDictionary *willSendDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [willSendDic setValue:[NSString stringWithFormat:@"%@",[YTimeStamp getNowTimeTimestamp_haoMiao]]  forKey:@"id"];
    [willSendDic setValue:@"MARKET" forKey:@"to"];
    [willSendDic setValue:@"PLATFORM" forKey:@"refer"];
    [willSendDic setValue:@"req" forKey:@"type"];
    [willSendDic setValue:@"300000" forKey:@"timeout"];
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dataDic setValue:kSub_Method_SetDappRecord  forKey:@"method"];
    NSMutableDictionary *parmsDic = [NSMutableDictionary dictionaryWithDictionary:model.data.param.value];
    [parmsDic setValue:[NSNumber numberWithBool:self.isShouCangeType] forKey:@"collect"];//当前收藏状态 
    [parmsDic setValue:self.savenabTitleStr forKey:@"title"];//当前页的title
    [dataDic setValue:parmsDic  forKey:@"param"];
    
    [willSendDic setValue:dataDic forKey:@"data"];
    NSString *willSendDataJsonStr = [Y_ToolOfOthers jsonStrWithDic:willSendDic];
    NSString *jsStr = [NSString stringWithFormat:@"%@(%@)",kOcSendToJsFunction_marketApiCall,willSendDataJsonStr];
    DLog(@"  setDappRecord 加载完成后设置浏览记录 或者是 更改收藏状态==%d , 上传的jsStr ==  %@ ",isSouCangTypeBool,jsStr);
    if (jsStr.length>0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(isSouCangTypeBool){
                //收藏
                Y_NSNotificationCenter_PostNotice_HaveObject_Name(WebView_SubDapp_SouCangeInfo_Change_NoticeName, jsStr);
            }else{
                //发浏览记录
                Y_NSNotificationCenter_PostNotice_HaveObject_Name(WebView_SubDapp_LoadFinishOkSendInfoOf_History_NoticeName, jsStr);
            }
        });
       
    }
    
}

#pragma mark ===
//dapp访问记录 也许会收到的回复数据//收浏览记录 相关回调 ｜主要是主动发送 （收藏状态更改和加载完成给到记录 是都要发的）
- (void)dappGetSetDappRecordWithDic:(NSDictionary *)bodyDic{
    DLog(@" dapp访问记录 dappGetSetDappRecordWithDic  --- %@",bodyDic);
    
    
}
#pragma mark ================================================================= web   ===================
//注入js文件
- (void)addOtherJavaScript{
    
    NSLog(@"initWKWebViewRelayJs ");
    NSString *jSString = @"";
    NSString *dapp_js_A = [[NSBundle mainBundle] pathForResource:@"dapp_evm" ofType:@"js"];
    NSString *dapp_js_B = [[NSBundle mainBundle] pathForResource:@"dapp_tvm_tron_web" ofType:@"js"];
    NSString *dapp_js_C = [[NSBundle mainBundle] pathForResource:@"dapp_tvm" ofType:@"js"];
    NSString *content_A = [[NSString alloc] initWithContentsOfFile:dapp_js_A encoding:NSUTF8StringEncoding error:nil];
    NSString *content_B = [[NSString alloc] initWithContentsOfFile:dapp_js_B encoding:NSUTF8StringEncoding error:nil];
    NSString *content_C = [[NSString alloc] initWithContentsOfFile:dapp_js_C encoding:NSUTF8StringEncoding error:nil];
    NSString * content_ALL = [NSString stringWithFormat:@"%@ \n %@ \n %@",content_A,content_B,content_C];
    jSString = content_ALL;
    if(jSString.length<=0){
        NSLog(@"initWKWebViewRelayJs js有误");
        return;
    }else{
        //NSLog(@"initWKWebViewRelayJs js \n %@ \n",jSString);
    }
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
    [self.webView.configuration.userContentController  addUserScript:wkUScript];
}


//弃用initWKWebViewJs
- (void)initWKWebViewJs
{
    jsCallOCMethodNames = @[@"JSCallOCMethod1",@"console1"].mutableCopy;


    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];


    //______________________________
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
    
    
    
    //______________________________  加了一个 JS文件 调用 OC 的方法监听，
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    //以下代码适配文本大小，由UIWebView换为WKWebView后，会发现字体小了很多，这应该是WKWebView与html的兼容问题，解决办法是修改原网页，要么我们手动注入JS
    //    NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    NSString *jSString = @"";
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"relay-service" ofType:@"js"];
    NSString *content = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    jSString = content;
    
    //用于进行JavaScript注入
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
    
    //    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [wkUController addUserScript:wkUScript];
    // 创建一个弱引用的 WeakWebViewScriptMessageDelegate 防止循环引用
    WeakWebViewScriptMessageDelegate *weakScriptMessageDelegate = [[WeakWebViewScriptMessageDelegate alloc] init];
    for (NSString *methodName in jsCallOCMethodNames) {
        // 添加方法名监听 (主要是这步)
        [wkUController addScriptMessageHandler:weakScriptMessageDelegate name:methodName];
    }
    //    configuration.userContentController = wkUController;
    [self.webView.configuration.userContentController  addUserScript:wkUScript];
}

//重写 替代1002所需的
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    [self.webView evaluateJavaScript:@"document.title" completionHandler:^(NSString *title, NSError *error) {
         self.title = title;
        NSLog(@" web nav ============ didFinishNavigation title= %@  当前url拿到的名字",title);
        self.savenabTitleStr = [TextShowWithModelStr textShowWithNotNullStr:title];
        [self lookDappHistoryOrNowIsSouCangBool:NO];//加载完成后设置浏览记录
    }];
    DLog(@"");
}


#pragma mark ================================================================= web end ===================
 
#pragma mark === tabbar位置 显示隐藏

- (void)get1005OfDappTabBarNeedShowOrHidenWithDic:(NSDictionary *)bodyDic{
    
    WebViewUseDataModel *model = [WebViewUseDataModel mj_objectWithKeyValues:bodyDic];
    NSDictionary *valueDic = [NSDictionary dictionaryWithDictionary:model.data.param.value];
    DLog(@"kOcGetJs_TypeNum_1005_NowPage  -valueDic-- %@",valueDic);
    if([[valueDic allKeys] containsObject:@"fullPath"]){
        NSString * nowPathstr =  [NSString stringWithFormat:@"%@",[valueDic objectForKey:@"fullPath"]];
         
        
//
//        if([nowPathstr containsString:[NSString stringWithFormat:@"%@?%@",WebVc_Base_URL,[WebVcsTool getWebUrlLocaleStrNotRandomstr]]] ||
//           [nowPathstr containsString:TuiJian_VC__1005Use_Url_Sufx_Index] ||
//           [nowPathstr containsString:[NSString stringWithFormat:@"%@?%@",FaXian_VC_Url_Sufx_Index,[WebVcsTool getWebUrlLocaleStrNotRandomstr]]]){ //推荐  //发现
//            //控制当前页面tabBar的显示和隐藏
//             self.tabBarController.tabBar.hidden = NO;
//             [self changeUIOfHidenNo];
//
//
//        }else{
//             self.tabBarController.tabBar.hidden = YES;
//            [self changeUIOfHidenYes];
//        }
        
        BOOL isHaveXieXianUrlBool = NO;
//        NSString *WebVc_Base_URL_Str = [WebVc_Base_URL substringFromIndex: WebVc_Base_URL.length - 1];//最末位
        NSString *this_WebVcBaseUrl = WebVc_Base_URL;
        NSString *WebVc_Base_URL_Str = [this_WebVcBaseUrl substringFromIndex: this_WebVcBaseUrl.length - 1];//最末位
        if([WebVc_Base_URL_Str containsString:@"#"]){
            isHaveXieXianUrlBool = YES;
        }
        [self doUrlBiJiaoWithnowPathstr:nowPathstr withHaveXieGangBool:isHaveXieXianUrlBool];//做比较
        
    }else{
         self.tabBarController.tabBar.hidden = YES;
        [self changeUIOfHidenYes];
    }
}

/**
 当前方法和推荐发现页面不同 它需要一直隐藏tabbar*/
- (void)doUrlBiJiaoWithnowPathstr:(NSString *)nowPathstr withHaveXieGangBool:(BOOL)isHaveXieXianUrlBool{//做url的比较
    
    self.tabBarController.tabBar.hidden = YES;
    [self changeUIOfHidenYes];
    return;
    
    
    
    if(isHaveXieXianUrlBool){
        if([nowPathstr containsString:[NSString stringWithFormat:@"%@/?%@",WebVc_Base_URL,[WebVcsTool getWebUrlLocaleStrNotRandomstr]]] ||
           [nowPathstr containsString:TuiJian_VC__1005Use_Url_Sufx_Index] ||
           [nowPathstr containsString:[NSString stringWithFormat:@"%@/?%@",FaXian_VC_Url_Sufx_Index,[WebVcsTool getWebUrlLocaleStrNotRandomstr]]]){ //推荐  //发现
            //控制当前页面tabBar的显示和隐藏
            self.tabBarController.tabBar.hidden = NO;
            [self changeUIOfHidenNo];
            
        }else{
            self.tabBarController.tabBar.hidden = YES;
            [self changeUIOfHidenYes];
        }
    }else{
        if([nowPathstr containsString:[NSString stringWithFormat:@"%@?%@",WebVc_Base_URL,[WebVcsTool getWebUrlLocaleStrNotRandomstr]]] ||
           [nowPathstr containsString:TuiJian_VC__1005Use_Url_Sufx_Index] ||
           [nowPathstr containsString:[NSString stringWithFormat:@"%@?%@",FaXian_VC_Url_Sufx_Index,[WebVcsTool getWebUrlLocaleStrNotRandomstr]]]){ //推荐  //发现
            //控制当前页面tabBar的显示和隐藏
            self.tabBarController.tabBar.hidden = NO;
            [self changeUIOfHidenNo];
            
        }else{
            self.tabBarController.tabBar.hidden = YES;
            [self changeUIOfHidenYes];
        }
    }
    
    
}

- (void)changeUIOfHidenNo{//展示 留tabbar位置
    WEAKSELF
    [self.webView  mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.webView.superview).insets(UIEdgeInsetsMake(kStatusBar_Height, 0, kTabBar_Height, 0));
    }];
    DLog(@"展示 留tabbar位置");
}

- (void)changeUIOfHidenYes{//隐藏 不留tabbar位置
    WEAKSELF
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.webView.superview).insets(UIEdgeInsetsMake(kStatusBar_Height, 0, 0, 0));
    }];
}

#pragma mark ==== getTypeNum1104Action。在dapp页面 拿到非dappurl的界面 可以走用户信息哦
- (void)getTypeNum1104ActionWithDic:(NSDictionary *)bodyDic{
    if([ShareUserInfo share].userInfo.address.length>0 && [ShareUserInfo share].userInfo.token.length>0){//已有登录数据
        DLog(@"已有登录数据 在加载完成时已经发送了个人信息");
        [self send1104WithbodyDic:bodyDic];
        
    }else{//没有登录 则需要调起登录
        DLog(@"没有登录 则需要调起登录");
        //Y_NSNotificationCenter_PostNotice_HaveObject_Name(NociceName_WindowSubBaoHUOWebView_ShowOrHidden, @(0))//0822 只有收到显示隐藏才发这个 不然只发登录notice
        Y_NSNotificationCenter_PostNotice_HaveObject_Name(NociceName_WindowSubBaoHUOWebView_ShowAndNeedSendSigWithDoLoginAction, @"去登录");
    }
}

- (void)send1104WithbodyDic:(NSDictionary *)bodyDic{
    //处理info dappsetUser专用格式

    WebViewUseDataModel *modell = [WebViewUseDataModel mj_objectWithKeyValues:bodyDic];

    NSString *idStr = [TextShowWithModelStr textShowWithModelStr: modell.ID];

    NSDictionary *userDic = [[ShareUserInfo share].userInfo mj_keyValues];
    NSDictionary *loginDic = @{
        @"id":idStr,
        @"refer":@"PLATFORM",
        @"to":@"MARKET",
        @"timeout":@(300000),
        @"type":@"res",
        @"result":userDic
    };
    NSLog(@" send1104WithbodyDic  setUserInfoData  1 bodyDic ====  %@",bodyDic);

    NSLog(@" send1104WithbodyDic  setUserInfoData  2 loginDic ====  %@",loginDic);
    NSString *willSendDataJsonStr = [Y_ToolOfOthers jsonStrWithDic:loginDic];

    NSString *funcName = kOcSendToJsFunction_marketApiCall;

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


#pragma mark === 消息转发相关
//to谁 谁处理
#pragma mark ====================== 得到的所有信息转发类
#define NociceName_DappSendToWallet  @"NociceName_DappSendToWallet"
#define NociceName_WalletSendToDapp  @"NociceName_WalletSendToDapp"
 
 
- (void)addDappWalletNotice{
    Y_NSNotificationCenter_Creat_NameAction(NociceName_WalletSendToDapp, walletSendToDappAction:);
}

- (void)dellocOtherNotices{
    Y_NSNotificationCenter_RemoveNotice_Name(NociceName_WalletSendToDapp);
}

-(void)walletSendToDappAction:(NSNotification *)notice{
    NSDictionary *bodyDic = [NSDictionary dictionaryWithDictionary:notice.object];
    DLog(@"dapp页收到 即将发给钱包");
    NSString *willSendDataJsonStr = [Y_ToolOfOthers jsonStrWithDic:bodyDic];
    NSString *jsStr = [NSString stringWithFormat:@"%@(%@)", kOcSendToJsFunction_apiCall,willSendDataJsonStr];
    NSLog(@"=====  webInfoWalletSendToDappvcWithDic ===== jsStr === %@",jsStr);

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            NSLog(@" 得到数据 webInfoWalletSendToDappvcWithDic ==  %@----%@",result, error);
            WebViewUseDataModelSubDataModel *model = [WebViewUseDataModelSubDataModel mj_objectWithKeyValues:result];
            if(model.status == 200){
             NSLog(@"webInfoWalletSendToDappvcWithDic 成功")
            }else{
             NSLog(@"webInfoWalletSendToDappvcWithDic status %ld",model.status);
            }
        }];
     });
   
}
//to谁 谁处理
- (void)webInfoDappSendToWalletvcWithDic:(NSDictionary *)bodyDic{
    Y_NSNotificationCenter_PostNotice_HaveObject_Name(NociceName_DappSendToWallet, bodyDic)
}
- (void)webInfoWalletSendToDappvcWithDic:(NSDictionary *)bodyDic{
}


@end
