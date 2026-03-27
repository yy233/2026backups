//
//  TUiJianWebVc.m
//  Socialize
//
//  Created by 余莹 on 2023/6/6.
//

#import "TUiJianWebVc.h"
#import "MySetTool.h"
@interface TUiJianWebVc ()

@end

@implementation TUiJianWebVc

#pragma mark =====
//每次启动的时候 做检查是否token过期状态
#define  CheckTokenUse_sufix  @"/domain/auth/list?account="
- (void)checkIsLoginDealUserInfo{
    if([ShareUserInfo share].userInfo.token.length <= 0){
        return;
    }
    if([ShareUserInfo share].userInfo.address.length <= 0){
        return;
    }
    NSString *allU = [NSString stringWithFormat:@"%@%@%@",URL_Main_URL_Prefix,CheckTokenUse_sufix,[ShareUserInfo share].userInfo.address];
    [[Y_NetWorkBaseTool sharedTool]YrequestGetALLURL:allU withParams:@{}.mutableCopy finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success_status) {
                NSLog(@"token没过期 %@",responsObject);
            }else{
                NSInteger sInt = [[responsObject objectForKey:@"status"] intValue];
                if(sInt == 509){//token过期 滞空
                    [ShareUserInfo share].userInfo.token = @"";
                    [[ShareUserInfo share]saveDefaultsLoginUserInfo:[ShareUserInfo share].userInfo];
                    NSLog(@"token过期 %@",responsObject);
                }else{
                    NSLog(@"token未知过期与否 %@",responsObject);
                }
              
            }
        }else{
            NSLog(@"domain/auth/list。 ====== err code %ld des %@",error.code,error.description);
            if((error.code == -1011) && [error.userInfo.allValues containsObject:@"Request failed: bad request (400)"]){
                NSString *shwoPleseLogin = Y_LocaleTypeFile_NSLocalString(@"请登录");
                dispatch_async(dispatch_get_main_queue(), ^{
                    Y_SVP_SHOW_INFO_MES_5Delay(shwoPleseLogin);//调起登录相关签名
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    Y_SVP_SHOW_ERR_DESCRIPTION
                });
            }
        
            
        }
    }];
}


#pragma mark =====

- (void)viewDidLoad {
//    NSString *WebVc_Base_URL_Str = [WebVc_Base_URL substringFromIndex: WebVc_Base_URL.length - 1];//最末位
    NSString *this_WebVcBaseUrl = WebVc_Base_URL;
    NSString *WebVc_Base_URL_Str = [this_WebVcBaseUrl substringFromIndex: this_WebVcBaseUrl.length - 1];//最末位
    if([WebVc_Base_URL_Str containsString:@"#"]){
        self.thisVcUseUrlStr = [NSString stringWithFormat:@"%@/?%@",WebVc_Base_URL,[WebVcsTool getWebUrlLocaleStr]];
    }else{
        self.thisVcUseUrlStr = [NSString stringWithFormat:@"%@?%@",WebVc_Base_URL,[WebVcsTool getWebUrlLocaleStr]];
    }
    
    [super viewDidLoad];
    [self checkIsLoginDealUserInfo];
    self.isGoSubVcDontDealTabbarsHidenOrShow = YES;//全部初始时 不响应处理传入的1005
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];//不需要显示nav8
    self.isGoSubVcDontDealTabbarsHidenOrShow = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.isGoSubVcDontDealTabbarsHidenOrShow = YES;

}

- (void)getWebViewSend1005type{//会到第一页没
}
 
 
#pragma mark === dealloc
- (void)dellocOtherNotices{
    
}

- (void)dellocOtherScriptMessageHandler{
    
}
#pragma mark === notice
- (void)initOtherNotices{
    
}

//- (void)noticeLanguageChange{
    /**
     NSString *WebVc_Base_URL_Str = [WebVc_Base_URL substringFromIndex: WebVc_Base_URL.length - 1];//最末位
     if([WebVc_Base_URL_Str containsString:@"#"]){
         self.thisVcUseUrlStr = [NSString stringWithFormat:@"%@/?%@",WebVc_Base_URL,[WebVcsTool getWebUrlLocaleStr]];
     }else{
         self.thisVcUseUrlStr = [NSString stringWithFormat:@"%@?%@",WebVc_Base_URL,[WebVcsTool getWebUrlLocaleStr]];
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

- (void)initSelfViews{
    //渐变色
    GreenAndJianBianBkView *bgColorView = [[GreenAndJianBianBkView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:bgColorView];
 
}

- (void)setUI{
    
    WEAKSELF
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.webView.superview).insets(UIEdgeInsetsMake(kStatusBar_Height, 0, kTabBar_Height, 0));
    }];
    [self.popWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.webView.superview).insets(UIEdgeInsetsMake(kStatusBar_Height+100, 0, kTabBar_Height, 0));
    }];
}

 
 
#pragma mark ===

- (void)get1005OfDappTabBarNeedShowOrHidenWithDic:(NSDictionary *)bodyDic{
    
    WebViewUseDataModel *model = [WebViewUseDataModel mj_objectWithKeyValues:bodyDic];
    NSDictionary *valueDic = [NSDictionary dictionaryWithDictionary:model.data.param.value];
    DLog(@"kOcGetJs_TypeNum_1005_NowPage  -valueDic-- %@",valueDic);
    if([[valueDic allKeys] containsObject:@"fullPath"]){
        NSString * nowPathstr =  [NSString stringWithFormat:@"%@",[valueDic objectForKey:@"fullPath"]];
        
        //                    //市场//推荐 fullPath = "/pages/index/index";
        //                    #define   ShiChang_VC_Url      WebVc_Base_URL
        //                    #define   TuiJian_VC_Url       WebVc_Base_URL
        //
        //                    //发现
        //                    #define   FaXian_VC_Url_Sufx_Index  @"/pages/discover/discover"
        //
        //                    //我的
        //                    #define   WoDe_VC_Url_Sufx_Index    @"/pages/user/index"
        
        BOOL isHaveXieXianUrlBool = NO;
        NSString *this_WebVcBaseUrl = WebVc_Base_URL;
        NSString *WebVc_Base_URL_Str = [this_WebVcBaseUrl substringFromIndex: this_WebVcBaseUrl.length - 1];//最末位
        //NSString *WebVc_Base_URL_Str = [WebVc_Base_URL substringFromIndex: WebVc_Base_URL.length - 1];//最末位
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
        return;
    }else{
        
    }
    
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
}

- (void)changeUIOfHidenYes{//隐藏 不留tabbar位置
    WEAKSELF
    [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
        //make.edges.equalTo(weakSelf.webView.superview).insets(UIEdgeInsetsMake(kStatusBar_Height, 0, 0, 0));
        make.edges.equalTo(weakSelf.webView.superview).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        make.height.offset(Screen_H);
    }];
}


#pragma mark ===== initSetUserInfo 重写
 
- (void)initSetUserInfoWithGetBodyDic:(NSDictionary *)bodyDic{
    if(isNil( [ShareUserInfo share].userInfo.token)){
        NSLog(@"无token信息 无需注入");
        //0825不谈出
//        NSString *shwoPleseLogin = Y_LocaleTypeFile_NSLocalString(@"请登录");
//        Y_SVP_SHOW_INFO_MES_5Delay(shwoPleseLogin);//调起登录相关签名
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
        DLog(@"   setUserInfoData  收到 1 bodyDic ====  %@",bodyDic);

        DLog(@"   setUserInfoData  即将发送 2 loginDic ====  %@",loginDic);
        
        NSString *willSendDataJsonStr = [Y_ToolOfOthers jsonStrWithDic:loginDic];
        
        NSString *funcName = kOcSendToJsFunction_marketApiCall; //|| [self.thisVcUseUrlStr containsString:TuiJian_VC_Url] 推荐页面的url是base 无法判断 本marketApiCall方法的initSetUserInfo数据在该vc重写
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

#pragma mark ===  登出 重写
 
 
@end
