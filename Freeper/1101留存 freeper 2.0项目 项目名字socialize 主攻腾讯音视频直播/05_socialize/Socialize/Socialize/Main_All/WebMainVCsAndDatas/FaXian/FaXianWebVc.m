//
//  FaXianWebVc.m
//  Socialize
//
//  Created by 余莹 on 2023/6/8.
//

#import "FaXianWebVc.h"
#import "DappUseBaseVc.h"
#import "ZhiBoAllMianListAndCanCreatNewZhiBoViewController.h"
#import "Socialize-Swift.h"
#import "ZhiBoTopTypeChooseView.h"
@interface FaXianWebVc () <UINavigationControllerDelegate>
@end

@implementation FaXianWebVc

- (void)viewDidLoad {
//    NSString *WebVc_Base_URL_Str = [WebVc_Base_URL substringFromIndex: WebVc_Base_URL.length - 1];//最末位
    NSString *this_WebVcBaseUrl = WebVc_Base_URL;
    NSString *WebVc_Base_URL_Str = [this_WebVcBaseUrl substringFromIndex: this_WebVcBaseUrl.length - 1];//最末位
    if([WebVc_Base_URL_Str containsString:@"#"]){//WebCenterUrlUseStr 已经有# 不配/#的宏
        self.thisVcUseUrlStr = [NSString stringWithFormat:@"%@%@/?%@",WebVc_Base_URL ,FaXian_VC_Url_Sufx_Index,[WebVcsTool getWebUrlLocaleStr]];
    }else{
        self.thisVcUseUrlStr = [NSString stringWithFormat:@"%@%@%@?%@",WebVc_Base_URL ,WebCenterUrlUseStr,FaXian_VC_Url_Sufx_Index,[WebVcsTool getWebUrlLocaleStr]];
    }
  
    NSLog(@"FaXianWebVc thisVcUseUrlStr = %@",self.thisVcUseUrlStr);
    [super viewDidLoad];
//    self.navigationController.delegate = self;
    self.isGoSubVcDontDealTabbarsHidenOrShow = YES;//全部初始时 不响应处理传入的1005
}

#pragma mark === dealloc
- (void)dellocOtherNotices{
    Y_NSNotificationCenter_RemoveNotice_Name(WebView_SubDapp_SouCangeInfo_Change_NoticeName);
    Y_NSNotificationCenter_RemoveNotice_Name(WebView_SubDapp_LoadFinishOkSendInfoOf_History_NoticeName);
//    Y_NSNotificationCenter_RemoveNotice_Name(WebView_SubDapp_DataInfo_NoticeName );

}

- (void)dellocOtherScriptMessageHandler{
}

#pragma mark === notice
- (void)initOtherNotices{
    Y_NSNotificationCenter_Creat_NameAction(WebView_SubDapp_SouCangeInfo_Change_NoticeName, dappVcSendShouCangInfoNotice:);
    Y_NSNotificationCenter_Creat_NameAction(WebView_SubDapp_LoadFinishOkSendInfoOf_History_NoticeName, dappvcSubDataSendInfoOfHistoryNotice:);
//    Y_NSNotificationCenter_Creat_NameAction(WebView_SubDapp_DataInfo_NoticeName, dappvcSubDataSendNotice:);

}


//- (void)noticeLanguageChange{
   /**
 
    NSString *WebVc_Base_URL_Str = [WebVc_Base_URL substringFromIndex: WebVc_Base_URL.length - 1];//最末位
    if([WebVc_Base_URL_Str containsString:@"#"]){//WebCenterUrlUseStr 已经有# 不配/#的宏
        self.thisVcUseUrlStr = [NSString stringWithFormat:@"%@%@/?%@",WebVc_Base_URL ,FaXian_VC_Url_Sufx_Index,[WebVcsTool getWebUrlLocaleStr]];
    }else{
        self.thisVcUseUrlStr = [NSString stringWithFormat:@"%@%@%@?%@",WebVc_Base_URL ,WebCenterUrlUseStr,FaXian_VC_Url_Sufx_Index,[WebVcsTool getWebUrlLocaleStr]];
    }
    [self initData];
    //[self.webView reload];//数据相关更新时可以刷新一下 这里不能调用

    */
//    DLog(@"webvc收到 切换  %s \n %@",__FUNCTION__, self.thisVcUseUrlStr );
//}


- (void)initData{
//    NSString *token = [ShareUserInfo sharedUserInfo].token;
//    NSInteger height = status_height*2;
    if(isNil((self.thisVcUseUrlStr))){
        return;
    }
    NSString *allUrlStr = self.thisVcUseUrlStr;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:allUrlStr] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:15.0];//缓存属性
    [self.webView loadRequest:request];
}


 
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];//不需要显示nav
    self.isGoSubVcDontDealTabbarsHidenOrShow = NO;
//    if([ShareLocale shared].nowThemeStr == Now_Theme_light){
//        self.navigationController.navigationBar.backgroundColor = JianBian_Blue_Color;
//    }else{
//        self.navigationController.navigationBar.backgroundColor = [UIColor tui_colorWithHex:Theme_Nav_COlOR_Drak_Str];
//    }
//    self.edgesForExtendedLayout = UIRectEdgeAll;//0905 坐标开始位置为默认值
   
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.isGoSubVcDontDealTabbarsHidenOrShow = YES;

}


- (void)getWebViewSend1005type{//回到主界面 没有1005的数据 也没有被调willapper 也没有返回事件
//    if([self.webView.URL.absoluteString containsString:FaXian_VC_Url_Sufx_Index] ){//发现页
//        self.tabBarController.tabBar.hidden = NO;
//    }else{
//        self.tabBarController.tabBar.hidden = YES;
//    }
}
 
 

- (void)initSelfViews{
    //渐变色
    GreenAndJianBianBkView *bgColorView = [[GreenAndJianBianBkView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:bgColorView];
 
}

- (void)setUI{
    
    WEAKSELF
//    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(weakSelf.webView.superview).insets(UIEdgeInsetsMake(kStatusBar_Height, 0, kTabBar_Height, 0));
//    }];
//    [self.popWebView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(weakSelf.webView.superview).insets(UIEdgeInsetsMake(kStatusBar_Height+100, 0, kTabBar_Height, 0));
//    }];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.webView.superview).insets(UIEdgeInsetsMake(0, 0, kTabBar_Height, 0));
    }];
    [self.popWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.webView.superview).insets(UIEdgeInsetsMake(0+100, 0, kTabBar_Height, 0));
    }];
}

#pragma mark ===。dapp内部
//收藏
- (void)dappVcSendShouCangInfoNotice:(NSNotification *)notice{
    
    NSString *noticeObjStr = [NSString stringWithFormat:@"%@",notice.object];
    if(noticeObjStr.length <= 0){
        DLog(@"noticeObjStr 0");
        return;
    }else{
        DLog(@"收藏 noticeObjStr %@",noticeObjStr);
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.webView evaluateJavaScript:noticeObjStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            NSLog(@" kOcSendToJsFunction_ setDappRecord 收藏 ==  %@----%@",result, error);
        }];
    });
}

//浏览记录
- (void)dappvcSubDataSendInfoOfHistoryNotice:(NSNotification *)notice{
    NSString *noticeObjStr = [NSString stringWithFormat:@"%@",notice.object];
    if(noticeObjStr.length <= 0){
        DLog(@"noticeObjStr 0");
        return;
    }else{
        DLog(@" 浏览记录 noticeObjStr %@",noticeObjStr);
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.webView evaluateJavaScript:noticeObjStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            NSLog(@" dappvcSubDataSendInfoOfHistoryNotice ——  浏览记录 ==  %@----%@",result, error);
        }];
    });
}
 



#pragma mark ===  直播
- (void)webGetOpenZhiBoAction{
    dispatch_async(dispatch_get_main_queue(), ^{
        //跳直播主页list
        ZhiBoAllMianListAndCanCreatNewZhiBoViewController_Sw *vc = [[ZhiBoAllMianListAndCanCreatNewZhiBoViewController_Sw alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        self.isGoSubVcDontDealTabbarsHidenOrShow = YES;
        //nav
    //    UINavigationController *willSetViewNav = [[UINavigationController alloc]initWithRootViewController:vc];
    //    willSetViewNav.navigationItem.titleView = [[ZhiBoTopTypeChooseView alloc]init];
        [self pushVc:vc];
    });
    DLog(@"");

}

 

#pragma mark ==== dapp  新0720 0807

- (void)webGetOpenDappAction:(NSDictionary *)bodyDic{ //发现页和钱包页也用到
    WebViewUseDataModel *infoModel = [WebViewUseDataModel mj_objectWithKeyValues:bodyDic];
    
    NSDictionary *valueDic = [NSDictionary dictionaryWithDictionary:infoModel.data.param.value];
    NSString *url = @"";
    BOOL collect = NO;
    if([[valueDic allKeys] containsObject:@"url"]){
        url = [NSString stringWithFormat:@"%@", [valueDic objectForKey:@"url"]];
    }
    if([[valueDic allKeys] containsObject:@"collect"]){
        collect = [[valueDic objectForKey:@"collect"] boolValue];
    }
    
    if(url.length>0){//数据有效
        NSString *willUseUrl = url;
        NSLog(@"1004 willUseUrl == %@",willUseUrl);
        if (willUseUrl.length <= 0) {
            return;
        }
        DappUseBaseVc *vc = [[DappUseBaseVc alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.dappShowUseInfoBodyDic = bodyDic;
        vc.thisDappUseUrlStr = url;
        vc.isShouCangeType = collect;
        self.isGoSubVcDontDealTabbarsHidenOrShow = YES;
        vc.isGoSubVcDontDealTabbarsHidenOrShow = YES;
        [self pushVc:vc];
    }else{
        DLog(@"");
        
    }
}



#pragma mark ===

- (void)get1005OfDappTabBarNeedShowOrHidenWithDic:(NSDictionary *)bodyDic{
    
    WebViewUseDataModel *model = [WebViewUseDataModel mj_objectWithKeyValues:bodyDic];
    NSDictionary *valueDic = [NSDictionary dictionaryWithDictionary:model.data.param.value];
    DLog(@"kOcGetJs_TypeNum_1005_NowPage  -valueDic-- %@",valueDic);
    if([[valueDic allKeys] containsObject:@"fullPath"]){
        NSString * nowPathstr =  [NSString stringWithFormat:@"%@",[valueDic objectForKey:@"fullPath"]];
        
        //                    //市场//推荐
        //                    #define   ShiChang_VC_Url      WebVc_Base_URL
        //                    #define   TuiJian_VC_Url       WebVc_Base_URL
        //
        //                    //发现
        //                    #define   FaXian_VC_Url_Sufx_Index  @"/pages/discover/discover"
        //
        //                    //我的
        //                    #define   WoDe_VC_Url_Sufx_Index    @"/pages/user/index"
        
//        if([nowPathstr containsString:[NSString stringWithFormat:@"%@?%@",WebVc_Base_URL,[WebVcsTool getWebUrlLocaleStrNotRandomstr]]] ||
//           [nowPathstr containsString:TuiJian_VC__1005Use_Url_Sufx_Index] ||
//           [nowPathstr containsString:[NSString stringWithFormat:@"%@?%@",FaXian_VC_Url_Sufx_Index,[WebVcsTool getWebUrlLocaleStrNotRandomstr]]]){ //推荐  //发现
//            //控制当前页面tabBar的显示和隐藏
//             self.tabBarController.tabBar.hidden = NO;
//             [self changeUIOfHidenNo];
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

- (void)doUrlBiJiaoWithnowPathstr:(NSString *)nowPathstr withHaveXieGangBool:(BOOL)isHaveXieXianUrlBool{//做url的比较
    if(self.isGoSubVcDontDealTabbarsHidenOrShow == YES){
        return;//触发状态 不处理显示隐藏
    }
    
    if(isHaveXieXianUrlBool){
        if([nowPathstr containsString:[NSString stringWithFormat:@"%@/?%@",WebVc_Base_URL,[WebVcsTool getWebUrlLocaleStrNotRandomstr]]] ||
           [nowPathstr containsString:TuiJian_VC__1005Use_Url_Sufx_Index] ||
//           [nowPathstr containsString:[NSString stringWithFormat:@"%@/?%@",FaXian_VC_Url_Sufx_Index,[WebVcsTool getWebUrlLocaleStrNotRandomstr]]]){ //推荐  //发现
           [nowPathstr containsString:[NSString stringWithFormat:@"%@",FaXian_VC_Url_Sufx_Index]]){
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
           [nowPathstr containsString:[NSString stringWithFormat:@"%@",FaXian_VC_Url_Sufx_Index]]){ //推荐  //发现
            //控制当前页面tabBar的显示和隐藏
             self.tabBarController.tabBar.hidden = NO;
             [self changeUIOfHidenNo];

        }else{
             self.tabBarController.tabBar.hidden = YES;
            [self changeUIOfHidenYes];
        }
    }
    
    
}

/**
 0907 发现页
 高度闪烁问题
 更改nav后
 不再处理webview的mas
 */

- (void)changeUIOfHidenNo{//展示 留tabbar位置
//    WEAKSELF
//    [self.webView  mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(weakSelf.webView.superview).insets(UIEdgeInsetsMake(kStatusBar_Height, 0, kTabBar_Height, 0));
//    }];
    
}

- (void)changeUIOfHidenYes{//隐藏 不留tabbar位置
//    WEAKSELF
//    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(weakSelf.webView.superview).insets(UIEdgeInsetsMake(kStatusBar_Height, 0, 0, 0));
//    }];
}
@end
