//
//  LoginWebVC.m
//  Socialize
//
//  Created by 余莹 on 2023/6/5.
//

#import "LoginWebVC.h"
#import "MainTabbarControll.h"
#import "WebViewUseDataModel.h" 
#import "LoginUseModel.h"



#define  WebView_Login_Event_Ok   @"fw@load-success"
#define  WebView_Login_Event_personalSign  @"personalSign"


@interface LoginWebVC ()

{
    dispatch_source_t gcdTimer;
//    dispatch_queue_t sqlUse_Updata_conCurrentQueue;//并行 同步
    dispatch_queue_t sqlUse_serialQueue;//串行队列+异步任务：开启新的线程，任务逐步完成
}

@end

@implementation LoginWebVC
- (void)viewDidLoad {
    self.thisVcUseUrlStr = [NSString stringWithFormat:@"%@",WebView_LoginView_Url];
    NSLog(@" --- 登录vc专用 thisVcUseUrlStr  = %@",self.thisVcUseUrlStr);
    [super viewDidLoad];
    [self initSqlUseQu];
    self.webView.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.3];
    
   
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear: animated];
    BOOL isBlankViewBool =  [self isBlankView:self.webView];
    DLog(@"isBlankViewBool --- %d",isBlankViewBool);
}

- (void)otherActionOfdidFailProvisionalNavigation{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //[self.webView reload];//数据相关更新时可以刷新一下  
    });

    
}

//登录vc专用 收到隐藏钱包的指令
- (void)loginWebVcGetHideWallet{
    NSLog(@" --- 登录vc专用 收到隐藏钱包的指令");
}


- (void)initSqlUseQu{
//    sqlUse_Updata_conCurrentQueue = dispatch_queue_create("sqlUseUpData.conCurrentQueue",DISPATCH_QUEUE_CONCURRENT);
    sqlUse_serialQueue = dispatch_queue_create("loginUse_sqlUse.serialQueue", DISPATCH_QUEUE_SERIAL);
}

 
//#pragma mark - WKNavigationDelegate
// 根据WebView对于即将跳转的HTTP请求头信息和相关信息来决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {


    NSLog(@"loginwebvc 根据WebView对于即将跳转的HTTP请求头信息和相关信息来决定是否跳转 decidePolicyForNavigationAction ------------- %@",navigationAction.request.URL.absoluteString);
    decisionHandler(WKNavigationActionPolicyAllow);
}

///在网络加载前调用，用于前置拦截一些网络请求 /接收到相应数据后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
   //decidePolicyForNavigationResponse   ==  https://verify.walletconnect.com/ffd90e04225495e962413e7ca017edbe ？？？
    NSLog(@" loginwebvc 接收到相应数据后，决定是否跳转 decidePolicyForNavigationResponse   ==  %@",navigationResponse.response.URL.absoluteString);
 
    
    decisionHandler(WKNavigationResponsePolicyAllow);
}
 
 
 
- (void)triggerLoginAction{
   /** 格式
    
    { "data":
        {"method":"login",
         "param":
            {"baseUrl":"http://192.168.12.122:52001",
            "chainId":97}
        },
    
        "refer":"PLATFORM",
        "to":"WALLET",
    
        "id":"1689220447066",
        "timeout":300000,
        "type":"req"
        
    }
    */
    
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
    
    //parms
    NSDictionary *willUseTriggerLogin_Sub_Sub_paramDic = @{
        @"chainId":@(LoginUseParm_ChanID),
        @"baseUrl":LoginUseParm_BaseUrl
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
    DLog(@"————————— triggerLoginAction  ——————jsDataStr — \n %@ \n ",jsDataStr);
    NSString *jsStr = [NSString stringWithFormat:@"%@(%@)", kOcSendToJsFunction_apiCall,jsDataStr];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            NSLog(@"triggerLoginAction 请求签名数据回复 ：result=%@ ，error：%@",result, error);
            WebViewUseDataModelSubDataModel *model = [WebViewUseDataModelSubDataModel mj_objectWithKeyValues:result];
            if(model.status == 200){
                NSLog(@"status 200 成功")
            }else{
                NSLog(@"status %ld",model.status);
            }
        }];
     });
    
}

//扫码拿到成功后的登录用的sig和tran信息
- (void)dealLoginSignInfoData:(WebViewUseDataModel_LoginPersonalSign_Sub_resultData *)resultDataModel{
    
    NSLog(@"扫码拿到成功后的登录信息 ---- %@",[resultDataModel mj_keyValues])
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
    /**
     id = 1690010087000;
     method = login;
     result =     {
         address = 0xa3885c5812400eeef554f39b5cdeb53427aaa451;
         baseUrl = "http://192.168.12.122:52001";
         chainId = 97;
         message = "Welcome to Freeper!\n\nClick to sign in and accept the Freeper Terms of Service: https://freeper.io/tos\n\nThis request will not trigger a blockchain transaction or cost any gas fees.\n\nWallet address:\n0xa3885c5812400eeef554f39b5cdeb53427aaa451\n\nNonce:\ne91e12a4-1442-4065-96bd-454d23cb92fe";
         signature = 0x256dcbc57f5b9f9c60278797c3a901d9620c062ad556c18856b485aff2d3cc07225e1f52694cbb2a22935dc365bfebc6974885508219676e14693c5abf620d271b;
     };
     to = PLATFORM;
     type = res;
     
     
     net dic
     address = 0xa3885c5812400eeef554f39b5cdeb53427aaa451;
     cogChannelId = "g2_KfjnVZ7hes";
     imId = uAVExpu8Y3I7T;
     imSignature = "eJyrVgrxCdZLrSjILEpVsjI0NTU1MjAw0AGLlqUWKVkpGekZKEH4xSnZiQUFmSlAdSYGBubmxobmJhCZzJTUvJLMtEywhlLHMNeKglKLSGNP8xCY1sx0oExlWECWS35ipaFXgI9xZLG3Y2BUcZWXt7G5k7tTmXalo19eZEqWh5uxu4eJLVRjSWYuyF1mlgYGhgaGhga1ALWQMxA_";
     imToken = "";
     issueTypes = "";
     profileImageUrl = "";
     rowCreate = "2023-07-03 02:22:06";
     token = KBqnPg5vTc2Er07f;
     twitterName = carlosmx1985;
     uid = 245;
     userVerified =     (
         "account_twitter"
     );
     username = "";
     
     
     oginWebVC.m:157      =====dicOfBlock=== {
         address = 0xf2504a866bed5fb0a58e5fd92e9cec069fa578f5;
         imId = ueVPpA2rSrKnT;
         imSignature = "eJyrVgrxCdZLrSjILEpVsjI0NTU1MjAw0AGLlqUWKVkpGekZKEH4xSnZiQUFmSlAdSYGBubmxobmJhCZzJTUvJLMtEywhtLUsIACR6Oi4CLvvBCY1sx0oExAaGEJEBuHh2VZpEY6Z0bqpxaVJGtHeiQbBfn4m2W5JPo4mmdURulbhtpCNZZk5oLcZWZpYGJqbmRuVgsA3lIzwg__";
         issueTypes = "";
         token = 0afTudEGk3CKZIRS;
         twitterName = "";
         uid = 657583;
         userVerified =     (
         );
     }
     */
}

- (void)goTabbarMainVc{
    if(isNil( [ShareUserInfo share].userInfo.token )){
        Y_SVP_SHOW_MES(@"登录失败");
        return;
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            //登录成功 跳转tabbar
            self.view.window.rootViewController = [[MainTabbarControll alloc]init];
            //处理info//登录点击 去主页
        });
        
    }
     
}


 

#pragma mark === sql
- (void)haveSqlInfoWithType:(NSInteger)type
              withSqlStrArr:(NSArray *)sqlArr
         withMessageBodyDic:(NSDictionary *)messageBodyDic{
    //0 delet 1 insert  2update 3查询select
   
    switch (type) {
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

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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


@end
