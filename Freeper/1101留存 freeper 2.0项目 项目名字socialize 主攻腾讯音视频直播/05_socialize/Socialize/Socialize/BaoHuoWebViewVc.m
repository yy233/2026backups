//
//  BaoHuoWebViewVc.m
//  Socialize
//
//  Created by 余莹 on 2023/7/12.
//
#import "MainTabbarControll.h"
#import "BaoHuoWebViewVc.h"
#import "SceneDelegate.h"
#import "DappUseBaseVc.h"

#define WebView_goWalletPage_NoticeName  @"WebView_goWalletPage_NoticeName" //kOcSendToJsFunction_apiCall_methodObj_goWalletPage



@interface BaoHuoWebViewVc ()
{
    dispatch_source_t gcdTimer;
//    dispatch_queue_t sqlUse_Updata_conCurrentQueue;//并行 同步
    dispatch_queue_t sqlUse_serialQueue;//串行队列+异步任务：开启新的线程，任务逐步完成
}
@property (nonatomic,assign) NSInteger daoJiShiPingNum;
@end

 
@implementation BaoHuoWebViewVc


 

- (void)viewDidLoad {
    self.thisVcUseUrlStr = [NSString stringWithFormat:@"%@?%@",WebView_LoginView_Url,[WebVcsTool getWebUrlLocaleStr]];
    self.daoJiShiPingNum = 30;//每三十秒发送一次心跳
    [super viewDidLoad];
    [self initSqlUseQu];
    [self addDappWalletNotice];
    [self addLoginNotice];
    self.agreeLoadNum = 0;
    [self initBaoHuoWebData];
    [self addOthersss];
    //self.webView.backgroundColor =  [[UIColor greenColor] colorWithAlphaComponent:0.5]; //底部背景露出一截了
    self.view.backgroundColor = [UIColor clearColor];//保活页 有透明需求，背景先为透明色
    
   
}
- (void)addOthersss{
    Y_NSNotificationCenter_Creat_NameAction(WebView_goWalletPage_NoticeName, goWalletPage_Action:);
}


#define MySubVc_Url_Suix_MyWallet        @"/pages/wallet/index"

#pragma mark === goWalletPage_Action
- (void)goWalletPage_Action:(NSNotification *)notice{
    DLog(@"保活界面 goWalletPage_Action");
    if(!self.walletLoadFinishedBool){
        NSString *showS = Y_LocaleTypeFile_NSLocalString(@"钱包正在加载，请等待");
        Y_SVP_SHOW_INFO_MES(showS);
        [self checkSelfIsNoAddToWindow];
        return;//为加载完成 不做心跳动作
    }
    NSMutableDictionary *goWDic = @{}.mutableCopy;
    NSString *timeIvStr = [YTimeStamp getNowTimeTimestamp_haoMiao];
    NSString *toStr = @"WALLET";
    NSString *types = @"req";
    NSString *refers = @"PLATFORM";
    
    [goWDic setValue:timeIvStr forKey:@"id"];
    [goWDic setValue:toStr forKey:@"to"];
    [goWDic setValue:types forKey:@"type"];
    [goWDic setValue:refers forKey:@"refer"];
    [goWDic setValue:@(5000) forKey:@"timeout"];
    
    
    
    NSString *goW_urlstr  = @"";
    
//    NSString *WebVc_Base_URL_Str = [WebVc_Base_URL substringFromIndex: WebVc_Base_URL.length - 1];//最末位
    NSString *this_WebVcBaseUrl = WebVc_Base_URL;
    NSString *WebVc_Base_URL_Str = [this_WebVcBaseUrl substringFromIndex: this_WebVcBaseUrl.length - 1];//最末位
//    if([WebVc_Base_URL_Str containsString:@"#"]){//带了 不拼WebCenterUrlUseStr 且位置不一样所以无需/
//        goW_urlstr = [NSString stringWithFormat:@"%@?%@",MySubVc_Url_Suix_MyWallet,[WebVcsTool getWebUrlLocaleStr]];
//    }else{
//        goW_urlstr = [NSString stringWithFormat:@"%@%@?%@",WebCenterUrlUseStr,MySubVc_Url_Suix_MyWallet,[WebVcsTool getWebUrlLocaleStr]];
//    }
    goW_urlstr = [NSString stringWithFormat:@"%@?%@",MySubVc_Url_Suix_MyWallet,[WebVcsTool getWebUrlLocaleStr]];

    NSDictionary *pingDic_Sub_DataDic = @{
        @"method":kOcSendToJsFunction_apiCall_methodObj_goWalletPage,
        @"param":@{@"page":goW_urlstr}
    };
    
    [goWDic setValue:pingDic_Sub_DataDic forKey:@"data"];
    
    
     NSString * jsDataStr = [Y_ToolOfOthers jsonStrWithDic:goWDic];
     DLog(@"发送的 唤起钱包功能—————————dic : %@ \n  ————— jsDataStr : %@  \n ",goWDic,jsDataStr);
     NSString *jsStr = [NSString stringWithFormat:@"%@(%@)", kOcSendToJsFunction_apiCall,jsDataStr];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            NSLog(@"唤起钱包功能—— 数据回复 jsDataStr %@：result=%@ ，error：%@",jsDataStr,result, error);
            WebViewUseDataModelSubDataModel *model = [WebViewUseDataModelSubDataModel mj_objectWithKeyValues:result];
            if(model.status == 200){
                NSLog(@"status 200 成功")
            }else{
                NSLog(@"status %ld",model.status);
            }
        }];
    });

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear: animated];
    BOOL isBlankViewBool =  [self isBlankView:self.webView];
    DLog(@"isBlankViewBool --- %d",isBlankViewBool);
 
}

- (void)initSqlUseQu{
//    sqlUse_Updata_conCurrentQueue = dispatch_queue_create("sqlUseUpData.conCurrentQueue",DISPATCH_QUEUE_CONCURRENT);
    sqlUse_serialQueue = dispatch_queue_create("sqlUse.serialQueue", DISPATCH_QUEUE_SERIAL);
}

- (void)thisWebViewIsLoadFinishOk{
    //定时ping 单开一个非主线程。0829暂时不走心跳 查看卡顿相关再放开
    /**
     dispatch_async(dispatch_get_global_queue(0, 0), ^{
         [self pingSendAction];//先发一个ping
         [self upDataTimerrrInfo];//定时器开着
     });

     */

}

- (void)webGetJsInfoWithPong{//得到回复resultpong
    
}

- (void)pingSendAction{
    if(!self.walletLoadFinishedBool){
        return;//为加载完成 不做心跳动作
    }
    NSMutableDictionary *pingDic = @{}.mutableCopy;
    NSString *timeIvStr = [YTimeStamp getNowTimeTimestamp_haoMiao];
    NSString *toStr = @"WALLET";
    [pingDic setValue:timeIvStr forKey:@"id"];
    [pingDic setValue:toStr forKey:@"to"];
    
    NSDictionary *pingDic_Sub_DataDic = @{
        @"method":kOcSendToJsFunction_apiCall_methodObj_Ping,
    };
    [pingDic setValue:pingDic_Sub_DataDic forKey:@"data"];
    
    
     NSString * jsDataStr = [Y_ToolOfOthers jsonStrWithDic:pingDic];
     DLog(@"发送的心跳ping信息————————— pingDic  ——————jsDataStr — \n %@ \n ",jsDataStr);
     NSString *jsStr = [NSString stringWithFormat:@"%@(%@)", kOcSendToJsFunction_apiCall,jsDataStr];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            NSLog(@"pingDic 数据回复 jsDataStr %@：result=%@ ，error：%@",jsDataStr,result, error);
            WebViewUseDataModelSubDataModel *model = [WebViewUseDataModelSubDataModel mj_objectWithKeyValues:result];
            if(model.status == 200){
                NSLog(@"status 200 成功")
            }else{
                NSLog(@"status %ld",model.status);
            }
        }];
    });
    
}

#pragma mark ============================================
//倒计时相关
- (void)upDataTimerrrInfo{
    [self timerPpause];//每次新界面重新更新重置timer数据
    
    WEAKSELF
    //创建GCD定时器
    gcdTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0)); //    //将定时器写成属性，是因为内存管理的原因，使用了dispatch_source_create方法，这种方法GCD是不会帮你管理内存的。
    //设置定时器
    dispatch_source_set_timer(gcdTimer, dispatch_walltime(NULL, 0), 1ull * NSEC_PER_SEC, 0);
    /*
     第二个参数：dispatch_time_t start, 定时器开始时间，类型为 dispatch_time_t，其API的abstract标明可参照dispatch_time()和dispatch_walltime()，同为设置时间，但是后者为“钟表”时间，相对比较准确，所以选择使用后者。dispatch_walltime(const struct timespec *_Nullable when, int64_t delta),参数when可以为Null，默认为获取当前时间，参数delta为增量，即获取当前时间的基础上，增加X秒的时间为开始计时时间，此处传0即可。
     第三个参数：uint64_t interval，定时器间隔时长，由业务需求而定。
     第四个参数：uint64_t leeway， 允许误差，此处传0即可。
    */
    //定时器需要执行的操作
    dispatch_source_set_event_handler(gcdTimer, ^{
        //设置对应的时间差
        if( weakSelf.daoJiShiPingNum <= 0){
            weakSelf.daoJiShiPingNum = 30;
            [weakSelf pingSendAction];
        }else{
            weakSelf.daoJiShiPingNum -= 1;
            
        }
     

    });
    // 启动任务，GCD计时器创建后需要手动启动
    dispatch_resume(gcdTimer);
    
}
- (void)timerPpause{
    if (gcdTimer) {
        dispatch_cancel(gcdTimer);
        gcdTimer = nil;
    }
    NSLog(@"pause gcdTimer --- %@",gcdTimer);
    /**
     停止 Dispatch Timer 有两种方法，一种是使用 dispatch_suspend，另外一种是使用 dispatch_source_cancel。
     dispatch_suspend 严格上只是把 Timer 暂时挂起   dispatch_suspend 之后的 Timer，是不能被释放的 会引起崩溃。
     用 dispatch_source_cancel 则没有这个限制
     */
}

- (void)dealloc{
    [self timerPpause];
 
    
}


#pragma mark ====== ====== ====== ====== ====== timerrr end

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];//不需要显示nav
    
  
}


- (void)getWebViewSend1005type{//会到第一页没
}
 
 
#pragma mark === dealloc
 
- (void)dellocOtherScriptMessageHandler{
    
}
#pragma mark === notice
- (void)initOtherNotices{
    
}

//- (void)noticeLanguageChange{
//    //[self.webView reload];//数据相关更新时可以刷新一下 这里不能调用
//    DLog(@"webvc收到 切换 %s \n %@",__FUNCTION__, self.thisVcUseUrlStr );
//}

 
// 页面加载失败时调用
- ( void )webView:( WKWebView *)webView didFailProvisionalNavigation:( null_unspecified WKNavigation *)navigation withError:( NSError *)error{
    DLog(@"");
    DLog(@"didFailProvisionalNavigation  description = %@ code=%ld",error.description,(long)error.code)
    if(error){
        if(error.code == -1009){
            DLog(@"agreeLoadNum == %ld",  self.agreeLoadNum);
            if(self.agreeLoadNum <= 5){
                self.agreeLoadNum += 1;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{//显示
                    [self initBaoHuoWebData];
                });
            }
           
        }
    }
}
- (void)initBaoHuoWebData{
    if(isNil((self.thisVcUseUrlStr))){
        return;
    }
    NSString *allUrlStr = self.thisVcUseUrlStr;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:allUrlStr] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:15.0];//缓存属性
    //加载缓和几秒 防止初始时 还没同意网络
    DLog(@"加载缓和几秒 防止初始时 还没同意网络  ");
    DLog(@" initBaoHuoWebData agreeLoadNum == %ld",  self.agreeLoadNum);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.webView loadRequest:request];
        DLog(@"------------------------------------------------ initBaoHuoWebData loadRequest 9998888888");
    });


  
}
- (void)initData{//重写 防止加载basevc
}

- (void)initSelfViews{
//    //渐变色去掉
 
}

- (void)setUI{
    
    WEAKSELF
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.edges.equalTo(weakSelf.webView.superview).insets(UIEdgeInsetsMake(kStatusBar_Height, 0, kTabBar_Height, 0));
        make.edges.equalTo(weakSelf.webView.superview).insets(UIEdgeInsetsMake(kStatusBar_Height, 0, 0, 0));
    }];
    [self.popWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.webView.superview).insets(UIEdgeInsetsMake(kStatusBar_Height+100, 0, kTabBar_Height, 0));
    }];
    self.popWebView.hidden = YES;
    
    
}

#pragma mark=== 方法相关

#pragma mark === sql
- (void)haveSqlInfoWithType:(NSInteger)type
              withSqlStrArr:(NSArray *)sqlArr
         withMessageBodyDic:(NSDictionary *)messageBodyDic{

   DLog(@"[Y_ToolOfOthers toolGetKeyWindow].rootViewController ---- %@",[Y_ToolOfOthers toolGetKeyWindow].rootViewController);

    if([[Y_ToolOfOthers toolGetKeyWindow].rootViewController isKindOfClass: [UITabBarController class]]){
        DLog(@"当前为UITabBarController ");
        //UITabBarController
        //如果当前有登录页面 不走sql 让loginvc走sql
        //如果当前root非登录页可走后续代码
    }else{
        DLog(@"当前为UITabBarController ");
        return;
    }
     
    switch (type) {    //0 delet 1 insert  2update 3查询select
        case 0:   case 1:   case 2:
        {
            dispatch_async(sqlUse_serialQueue, ^{
                NSLog(@"type %ld withSqlStrArr === %@",(long)type,sqlArr)
                WEAKSELF
                [[WalletSqlTools share] updataThingsWithSqlArr:sqlArr withBlock:^(BOOL successs, NSMutableArray * _Nonnull resArr) {
                    if(successs){
                        NSLog(@"成功的更新");
                    }else{
                        NSLog(@"失败的更新");
                    }
                    [weakSelf appiCallDealSqlInfoWithType:type WithResArr:resArr WithOldMessagebody:messageBodyDic];
                }];
                
            });
      
            
            //并行队列同步：操作不会新建线程、操作顺序执行； 创建时用这个（并行+同步它是串行之心的哦）
            //并行队列异步操作会新建多个线程（有多少任务，就开n个线程执行）、操作无序执行；队列前如果有其他任务，会等待前面的任务完成之后再执行；场景：既不影响主线程，又不需要顺序执行的操作！
        }
            break;
        case 3:
        {
            // 串行队列+同步任务：不会开启新的线程，任务逐步完成（不要向同一个串行队列添加同步任务，进行中的任务等待添加任务完成，添加的任务等待上一个任务完成，因为相互等待死循环）。
            // 串行队列异步：操作需要一个子线程，会新建线程、线程的创建和回收不需要程序员参与，操作顺序执行，是最安全的选择；）
            
            dispatch_async(sqlUse_serialQueue, ^{
                NSLog(@"type %ld withSqlStrArr === %@",(long)type,sqlArr)
                WEAKSELF
                [[WalletSqlTools share] selectThingsWithSqlArr:sqlArr withBlock:^(BOOL successs, NSMutableArray * _Nonnull resArr) {
                    if(successs){
                        NSLog(@"sql成功的查询");
                    }else{
                        NSLog(@"sql失败的查询");
                    }
                    [weakSelf appiCallDealSqlInfoWithType:type WithResArr:resArr WithOldMessagebody:messageBodyDic];
                }];
               });
        }
            break;
            
        default:
        {
            
        }
            break;
    }
    
    /**
     
     a.串行队列+同步任务：不会开启新的线程，任务逐步完成。
     b.并行队列+同步任务：不会开启新的线程，任务逐步完成。
     c.串行队列+异步任务：开启新的线程，任务逐步完成。 。。。。是最安全的选择
     d.并行队列+异步任务：开启新的线程，任务是同步执行的。
     */
    /*
    dispatch_queue_t：队列
    DISPATCH_QUEUE_SERIAL：串行
    DISPATCH_QUEUE_CONCURRENT：并行
    */
    
}

- (void)appiCallDealSqlInfoWithType:(NSInteger)type WithResArr:(NSMutableArray *)resArr WithOldMessagebody:(NSDictionary *)messageBodyDic{
    
    //处理info
    WebViewUseDataModel_sqlUse *mainDataModel = [WebViewUseDataModel_sqlUse mj_objectWithKeyValues:messageBodyDic];
    NSMutableDictionary *willUseSendWkDic = @{}.mutableCopy;
    
    [willUseSendWkDic setValue:@"res" forKey:@"type"];//固定值
    [willUseSendWkDic setValue:[TextShowWithModelStr textShowWithModelStr:mainDataModel.ID] forKey:@"id"];
    [willUseSendWkDic setValue:[TextShowWithModelStr textShowWithModelStr:mainDataModel.refer] forKey:@"to"];
    [willUseSendWkDic setValue:[TextShowWithModelStr textShowWithModelStr:mainDataModel.data.method] forKey:@"method"];

    //0 delet 1 insert  2update 3查询select
    if(type == 3){//查询
        [willUseSendWkDic setValue:resArr forKey:@"result"];
    }else {//更新
        NSInteger numI = 0;
        for (NSNumber *resArrSubNum in resArr) {
            if([resArrSubNum isEqualToNumber: @(1)]){
                numI += 1;
            }
        }
        [willUseSendWkDic setValue:@(numI) forKey:@"result"];
    }
   
    
    NSString *willSendDataJsonStr = [Y_ToolOfOthers jsonStrWithDic:willUseSendWkDic];
    NSString *jsStr = [NSString stringWithFormat:@"%@(%@)", kOcSendToJsFunction_apiCall,willSendDataJsonStr];
    NSLog(@"=====  kOcSendToJsFunction_apiCall ===== jsStr === %@",jsStr);

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            NSLog(@" 得到数据 kOcSendToJsFunction_apiCall ==  %@----%@",result, error);
            WebViewUseDataModelSubDataModel *model = [WebViewUseDataModelSubDataModel mj_objectWithKeyValues:result];
            if(model.status == 200){
             NSLog(@"kOcSendToJsFunction_apiCall 成功")
            }else{
             NSLog(@"kOcSendToJsFunction_apiCall status %ld",model.status);
            }
        }];
     });
}


#pragma mark === login action 触发登录sign
- (void)addLoginNotice{
    Y_NSNotificationCenter_Creat_NameAction(NociceName_WindowSubBaoHUOWebView_ShowAndNeedSendSigWithDoLoginAction, noticeOfDoLoginAction:);

}
- (void)checkSelfIsNoAddToWindow{
    DLog();
    if(self.walletLoadFinishedBool == NO){
        [self initBaoHuoWebData];
    }
}
- (void)noticeOfDoLoginAction:(NSNotification *)notice{
    DLog(@"noticeOfDoLoginAction 保活触发登录sign ----  notice.object == %@",notice.object);

    if(!self.walletLoadFinishedBool){
        NSString *showS =Y_LocaleTypeFile_NSLocalString(@"钱包正在加载，请等待");
        Y_SVP_SHOW_INFO_MES(showS);
        [self checkSelfIsNoAddToWindow];
        return;//为加载完成 不做心跳动作
    }
    [self triggerLoginActionOfNoticeTouch];
    
}
/** 登录页加载完成时的数据一样 triggerLoginAction 和 triggerLoginActionOfNoticeTouch 区分触发方式不同
 */

- (NSString *)softwareVersion
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDic objectForKey:@"CFBundleShortVersionString"];// app版本
    NSString *app_build = [infoDic objectForKey:@"CFBundleVersion"];// app build版本
    NSString *currentVersion = [NSString stringWithFormat:@"%@",app_Version];
    return currentVersion;
}
- (void)triggerLoginActionOfNoticeTouch{
    
    NSMutableDictionary *willUseTriggerLoginDic = @{}.mutableCopy;
    NSString *timeIvStr = [YTimeStamp getNowTimeTimestamp_haoMiao];
    NSNumber *timeoutNum = @(60*5*1000);//五分钟的时间
    NSString *typeStr = @"req";
    NSString *toStr = @"WALLET";
    NSString *referStr = @"PLATFORM";
    
    //base
    [willUseTriggerLoginDic setValue:timeIvStr forKey:@"id"];
    [willUseTriggerLoginDic setValue:typeStr forKey:@"type"];
    [willUseTriggerLoginDic setValue:timeoutNum forKey:@"timeout"];
    //to ref
    [willUseTriggerLoginDic setValue:referStr forKey:@"refer"];
    [willUseTriggerLoginDic setValue:toStr forKey:@"to"];
    //
    //1008增入当前版本数据
    NSString *version_Str = [self softwareVersion];
    
    //parms
    NSDictionary *willUseTriggerLogin_Sub_Sub_paramDic = @{
        @"chainId":@(LoginUseParm_ChanID),
        @"baseUrl":LoginUseParm_BaseUrl,
        @"version": version_Str,
        @"deviceType": @"ios"
    };
    
    //parms sup data
    NSDictionary *willUseTriggerLogin_Sub_DataDic = @{
        @"method":kLoginRqpersonalSignInfo_Sub_Mothod_login,
        @"param": willUseTriggerLogin_Sub_Sub_paramDic,
    };
    //data sup okdic
    [willUseTriggerLoginDic setValue:willUseTriggerLogin_Sub_DataDic forKey:@"data"];
    // @"msssage":@""//如果mesg空则必须传入本数据 ，有msg可以不传
    

   
    NSString * jsDataStr = [Y_ToolOfOthers jsonStrWithDic:willUseTriggerLoginDic];
    DLog(@"————保活界面————— triggerLoginAction OfNotice Touch  ——————jsDataStr — \n %@ \n ",jsDataStr);
    NSString *jsStr = [NSString stringWithFormat:@"%@(%@)", kOcSendToJsFunction_apiCall,jsDataStr];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{//    //显示后期再走登录    给2秒
        [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            NSLog(@"triggerLoginAction OfNotice Touch 请求签名数据回复 ：result=%@ ，error：%@",result, error);
            WebViewUseDataModelSubDataModel *model = [WebViewUseDataModelSubDataModel mj_objectWithKeyValues:result];
            if(model.status == 200){
                NSLog(@"status 200 成功")
            }else{
                NSLog(@"status %ld",model.status);
                if(isNotNil(error)){
                    Y_SVP_SHOW_ERR_MES([TextShowWithModelStr textShowWithModelStr:error.description]);
                }
            }
        }];
     });
    
}

//扫码拿到成功后的登录用的sig和tran信息
- (void)dealLoginSignInfoData:(WebViewUseDataModel_LoginPersonalSign_Sub_resultData *)resultDataModel{
    
    NSLog(@"扫码拿到成功后的登录信息 验签数据---- %@",[resultDataModel mj_keyValues])
    //isVerify等于0 不验签
    if(resultDataModel.signature.length==0 && resultDataModel.userData.allValues.count==0){// status = 1;已经登录不做后续处理
        return;
    }
    if(resultDataModel.signature.length == 0 && resultDataModel.isVerify == 0){//无签名数据且验证签名为0不验证签名 当前为审核状态
        NSLog(@"=====不验证签名 当前为审核状态 === %@",resultDataModel.userData);
        UserModel *useInf = [UserModel mj_objectWithKeyValues:resultDataModel.userData];
        [[ShareUserInfo share] saveDefaultsLoginUserInfo :useInf];
        [self goTabbarMainVc];
        
    }else{
        if(resultDataModel.address.length>0 && resultDataModel.signature.length>0){
            [LoginUseModel loginVerifySignatureWithResultModel:resultDataModel withBlock:^(NSDictionary * _Nonnull dicOfBlock, BOOL succes) {
               //得到登录相关数据 做存储处理 再做调用web后台设置用户登录信息
               
                if(succes){
                    NSLog(@"=====dicOfBlock=== %@",dicOfBlock);
                    UserModel *useInf = [UserModel mj_objectWithKeyValues:dicOfBlock];
                    [[ShareUserInfo share] saveDefaultsLoginUserInfo :useInf];
                    [self goTabbarMainVc];

                }else{
                    NSLog(@"========dealLoginInfo 失败 ");
                }
            }];
        }
    }
    
}

- (void)goTabbarMainVc{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        Y_NSNotificationCenter_PostNotice_HaveObject_Name(NociceName_WindowSubBaoHUOWebView_ShowOrHidden, @(1));//隐藏
        //通知各个主页刷新界面数据和登录各模块 -- rootvc 更新
        //self.view.window.rootViewController = [[MainTabbarControll alloc]init];
        UIScene *scene = UIApplication.sharedApplication.connectedScenes.anyObject;
        SceneDelegate *sceDelge = (SceneDelegate *)scene.delegate;
        [self iOS13ShowCustomWindowWithsceDelge:sceDelge WithWindow:sceDelge.window];
        /**
         在协议sceDelge 里判断总处理
         UIView *save_baoHuoViews;
         if(sceDelge.window.subviews.lastObject.tag == 9999){//_baoHuoViews.tag
         save_baoHuoViews = sceDelge.window.subviews.lastObject;
         }
         
         */
    });
    
    
}

- (void)iOS13ShowCustomWindowWithsceDelge:(SceneDelegate *)sceDelge WithWindow:(UIWindow *)window {
    if (@available(iOS 13.0, *)) {
        NSArray *array = [[[UIApplication sharedApplication] connectedScenes] allObjects];
        //iOS 13以上 window不再由AppDelegate来管理，所以通过AppDelegate来设置keyWindowAndVisable无效；需通过connectedScenes来获取处于活跃状态的Scene，并将window的windowScene设置为活跃状态的Scene，完成windowScene的注册。此时该window则由该Scene来管理，才能显示
        //iOS13以下 window 的 windowScene 属性有值；iOS13以上 window 的 windowScene 属性无值，需要手动赋值
        if (!window.windowScene) {
            for (UIWindowScene *windowScene in array) {
                if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                    window.windowScene = windowScene;
                    
                    NSLog(@"333 window   %@ ",window);
                    NSLog(@"333 window  subviews %@ ",window.subviews);
                    NSLog(@"333 screen  %@",window.screen);
                    [sceDelge addNoticeAndBaoHuoViewsWithwindowScene:window.windowScene ];
                    return;
                }
            }
        }else{
            NSLog(@"window.windowScene 存在");
            [sceDelge addNoticeAndBaoHuoViewsWithwindowScene:window.windowScene];
            DLog(@"sceDelge end window %@ ",sceDelge.window);
            DLog(@"sceDelge end window %@ ",sceDelge.window.subviews);//UITransitionView UIView

        }
        
    }
}



//钱包保活界面相关才使用
/**
 pageChanged处理透明非透明
 */

- (void)dealBaoHuoBkView:(NSDictionary *)bodyDic{
    //
    //to --检索关键字 /pages/wallet/Modal" ---设为透明 。其他主题色
    /**
     19:49:45:801000 BaseWebVc.m 809 -[BaseWebVc userContentController:didReceiveScriptMessage:]~ 打印 = baseWebvc--userContentController_Body:{"id":"1693309785798103352","type":"req","refer":"WALLET","to":"PLATFORM","timeout":30,"data":{"method":"pageChanged","param":{"from":"/pages/index","to":"/pages/wallet/index"}}}
     */
    WebViewUseDataModel *modell = [WebViewUseDataModel mj_objectWithKeyValues:bodyDic];
 
    NSString *toStr = [TextShowWithModelStr textShowWithModelStr:modell.data.param.to];
    if(toStr.length<=0){//没有本键值时
        return;//无需处理
    }
    if([toStr containsString:@"/pages/wallet/Modal"]){
        self.view.backgroundColor = [UIColor clearColor];
        self.webView.backgroundColor = [UIColor clearColor];
        self.webView.superview.backgroundColor = [UIColor clearColor];
        self.webView.superview.superview.backgroundColor = [UIColor clearColor];
        NSLog(@" self.webView %@", self.webView);
        NSLog(@" self.webView s %@", self.webView.superview);
        NSLog(@" self.webView ss %@", self.webView.superview.superview);
    }else{
        [self setWebViewZhuTiColor];
    }
}
- (void)setWebViewZhuTiColor{
    
    NSString *nowThemeStr =  [[NSUserDefaults standardUserDefaults] objectForKey:kTheme_Type_Key];
    UIColor *lightColor = [Y_ToolOfOthers getColorWithHexString:Theme_Bk_COlOR_Light_Str];
    UIColor *drakColor = [Y_ToolOfOthers getColorWithHexString:Theme_Bk_COlOR_Drak_Str];
    if([nowThemeStr isEqualToString: @"light"]){
        self.webView.backgroundColor =  lightColor; //底部背景露出一截了
    }else{
        self.webView.backgroundColor =  drakColor;;
    }
}

 
#pragma mark ===

#define NociceName_DappSendToWallet  @"NociceName_DappSendToWallet"
#define NociceName_WalletSendToDapp  @"NociceName_WalletSendToDapp"
- (void)addDappWalletNotice{
    Y_NSNotificationCenter_Creat_NameAction(NociceName_DappSendToWallet, dappSendToWalletAction:);
}

- (void)dellocOtherNotices{
    Y_NSNotificationCenter_RemoveNotice_Name(NociceName_DappSendToWallet);
    Y_NSNotificationCenter_RemoveNotice_Name(NociceName_WindowSubBaoHUOWebView_ShowAndNeedSendSigWithDoLoginAction);
    Y_NSNotificationCenter_RemoveNotice_Name(WebView_goWalletPage_NoticeName);

}
-(void)dappSendToWalletAction:(NSNotification *)notice{
    NSDictionary *bodyDic = [NSDictionary dictionaryWithDictionary:notice.object];
    DLog(@"钱包页收到 即将发给dapp")
    NSString *willSendDataJsonStr = [Y_ToolOfOthers jsonStrWithDic:bodyDic];
    NSString *jsStr = [NSString stringWithFormat:@"%@(%@)", kOcSendToJsFunction_apiCall,willSendDataJsonStr];
    NSLog(@"=====  webInfoDappSendToWalletvcWithDic ===== jsStr === %@",jsStr);

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            NSLog(@" 得到数据 webInfoDappSendToWalletvcWithDic ==  %@----%@",result, error);
            WebViewUseDataModelSubDataModel *model = [WebViewUseDataModelSubDataModel mj_objectWithKeyValues:result];
            if(model.status == 200){
             NSLog(@"webInfoDappSendToWalletvcWithDic 成功")
            }else{
             NSLog(@"webInfoDappSendToWalletvcWithDic status %ld",model.status);
            }
        }];
     });
}

//to谁 谁处理
- (void)webInfoDappSendToWalletvcWithDic:(NSDictionary *)bodyDic{
}
- (void)webInfoWalletSendToDappvcWithDic:(NSDictionary *)bodyDic{
    Y_NSNotificationCenter_PostNotice_HaveObject_Name(NociceName_WalletSendToDapp, bodyDic)
}

#pragma mark ===== 钱包相关

//重写
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断如果是需要隐藏导航控制器的类，则隐藏
    
    if(![self.webView.URL.absoluteString containsString:MySubVc_Url_Suix_MyWallet]){//钱包
        return;
    }
    NSLog(@"当前钱包ur  == %@",self.webView.URL.absoluteString);
    BOOL isHideNav = ([viewController isKindOfClass:[self class]] );// 隐藏了nav用的view
    [self.navigationController setNavigationBarHidden:isHideNav animated:YES];
    
}

//钱包vc专用
- (void)walletWebVcGetHideWallet{
//    if([self.subTypeUrlSuix isEqualToString:MySubVc_Url_Suix_MyWallet]){//钱包页返回按钮
//    if([self.webView.URL.absoluteString containsString:MySubVc_Url_Suix_MyWallet]){
//        DLog(@"当前钱包主页 返回 walletWebVcGetHideWallet");
//        [self popVC];
//    }else{
//        DLog(@"当前非钱包主页 不做返回");
//    }
}
- (void)webGetOpenDappAction:(NSDictionary *)bodyDic{ //发现页和钱包页也用到
    
    if(![self.webView.URL.absoluteString containsString:MySubVc_Url_Suix_MyWallet]){//钱包
        return;
    }
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


//给钱包页面用的 0824


- (NSMutableDictionary *)baseWillBeconmjsWtihMethod:(NSString *)methodStr
                                          withParam:(id)parms
                                           withtype:(NSString *)typeStr
                                          withIDstr:(NSString *)iDstr
                                         withRrefer:(NSString *)referStr
                                             withTo:(NSString *)toStr
{
    
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc]init];
    
    NSMutableDictionary *subDic = [[NSMutableDictionary alloc]init];
    [subDic setValue:methodStr forKey:@"method"];
    [subDic setValue:parms forKey:@"param"];
    
    [resultDic setValue:subDic forKey:@"data"];
    [resultDic setValue:typeStr forKey:@"type"];
    [resultDic setValue:@(5000) forKey:@"timeout"];
    
    if(referStr.length > 0){
        [resultDic setValue:referStr forKey:@"refer"];
    }else{
        [resultDic setValue:@"PLATFORM" forKey:@"refer"];
    }
    if(toStr.length > 0){
        [resultDic setValue:toStr forKey:@"to"];
    }else{
        [resultDic setValue:@"WALLET" forKey:@"to"];
    }
    
    if(iDstr.length > 0){
        [resultDic setValue:iDstr forKey:@"id"];
    }else{
        [resultDic setValue:[YTimeStamp getNowTimeTimestamp_haoMiao] forKey:@"id"];
    }
    return resultDic;
    
}


//0916
#pragma mark === 红包相关

  static NSString *redCellType_morePerson = @"redCellType_morePerson";
  static NSString *redCellType_moneyNum = @"redCellType_moneyNum";
  static NSString *redCellType_moneyTip = @"redCellType_moneyTip";
  static NSString *redCellType_moneyType = @"redCellType_moneyType";

- (void)creatredEnvOfWebInfo:(NSDictionary *)redEnvDic{
    
    
    
    NSString *welcom_Str = @"Welcome to the red envelope function!";
    NSString *moneyStr = ([[redEnvDic allKeys] containsObject:redCellType_moneyNum]) ? [redEnvDic objectForKey:redCellType_moneyNum] : @"";
    NSString *addressStr = ([[redEnvDic allKeys] containsObject:@"address"]) ? [redEnvDic objectForKey:@"address"] : @"";//合约地址
    NSString *crearUserAddressStr = [[ShareUserInfo share].userInfo.address lowercaseString];    //小写
    NSString *timeStr = [YTimeStamp getNowTimeTimestamp_haoMiao];
    self.creatredEnvOfThisTimeStr = timeStr;
    NSArray *parm = @[welcom_Str,moneyStr,crearUserAddressStr,timeStr];
    NSArray *parmkeyObj = @[welcom_Str,[@"Amount: " stringByAppendingString:moneyStr],[@"Address: " stringByAppendingString:crearUserAddressStr],[@"Time: " stringByAppendingString:timeStr]];
    NSString *parmStr = [parmkeyObj componentsJoinedByString:@"\r\n\r\n"];
    NSLog(@"creatredEnvOfWebInfo parmStr --- %@",parmStr);
    //格式更改0928
    NSMutableDictionary *bodyDic = [self baseWillBeconmjsWtihMethod:kOCSendRedEnvUseFunction_Sub_Method_personalSign
                                                          withParam:@[@[parmStr,crearUserAddressStr]]
                                                           withtype:@"req"
                                                          withIDstr:@""
                                                         withRrefer:@""
                                                             withTo:@""];
        
    NSString *willSendDataJsonStr = [Y_ToolOfOthers jsonStrWithDic:bodyDic];
    NSString *jsStr = [NSString stringWithFormat:@"%@(%@)", kOcSendToJsFunction_apiCall,willSendDataJsonStr];
    NSLog(@"=====web即将发送  creatredEnvOfWebInfo ===== jsStr === %@",jsStr);

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            NSLog(@" 得到数据 creatredEnvOfWebInfo ==  %@----%@",result, error);
            WebViewUseDataModelSubDataModel *model = [WebViewUseDataModelSubDataModel mj_objectWithKeyValues:result];
            if(model.status == 200){
             NSLog(@"creatredEnvOfWebInfo 成功")
            }else{
             NSLog(@"creatredEnvOfWebInfo status %ld",model.status);
            }
        }];
     });
}


//红包数据调取web后，web的到信息发送过来 继续走创建红包接口的通知
#define RedEnv_OnWebVc_SignGeted_Notice        @"RedEnv_OnWebVc_SignGeted_Notice"
- (void)RedEnv_OnWebVc_SignGetedWithData:(NSString *)resultStr{
    if(isNil(resultStr)){
        Y_SVP_SHOW_ERR_MES(@"红包签名有误");
        return;
    }
    NSLog(@"RedEnv_OnWebVc_SignGetedWithData  %@,%@",self.creatredEnvOfThisTimeStr,resultStr);
    dispatch_async(dispatch_get_main_queue(), ^{
      NSString *endS =  [[resultStr stringByAppendingString:@","] stringByAppendingString: self.creatredEnvOfThisTimeStr];
//        Y_NSNotificationCenter_PostNotice_HaveObject_Name(RedEnv_OnWebVc_SignGeted_Notice, resultStr);
        Y_NSNotificationCenter_PostNotice_HaveObject_Name(RedEnv_OnWebVc_SignGeted_Notice, endS);

    });
}
@end
