//
//  SceneDelegate.m
//  Socialize
//
//  Created by 余莹 on 2023/5/10.
//

#import "SceneDelegate.h"
#import "LoginViewController.h"
#import "LoginWebVC.h"
#import "MainTabbarControll.h"
#import "ZhiBoBaseNetTools.h"
#define  xuanFuView_Max_W   130
#define  xuanFuView_Max_H   60
#import <CoreTelephony/CTCellularData.h>

#import "BaoHuoWebViewVc.h"
#import "IMGoChatOneUserInfoVcTool.h"
#import "ChatAddFriendTool.h"
#import "GroupOfScanOk_DetailInfoVcOfApplingVc.h"
#import "LauncViewController.h"
#import "PopSendOrGetRedNoticeOfDataTool.h"
#import "GroupQrWillShareDoChooseGroupOrFriendListVc.h"
#import "ShareZhiBoOfOtherTool.h"
#import "DappUseBaseVc.h"

@interface SceneDelegate ()

@end
#define IM_userID_005 @"dev005"
#define IM_sig_005 @"eJwtzF0LgjAUxvHvsuuQ49yaE7qwAiGki14ouit22g6hDBWzou*eqZfP74H-hx3yfdBixRLGA2CzYZPBsqE7DWywBZDTU5vH1XsyLAkFgFJRqMT4YOepwt6llBwARm2o*Ns8jlSsJedThWwfvtijeG9tsdQuK3PMcrE*n0JXEfhO39Idd-DarPAZp-WCfX8aBzEd"

#define VoiceAndLiveNotice_ChangeActivity_Statu_Notice    @"VoiceAndLiveNotice_ChangeActivity_Statu_Notice"
#define VoiceAndLiveNotice_ChangeActivity_Info_Notice    @"VoiceAndLiveNotice_ChangeActivity_Info_Notice"

//群 点击详情 跳转二维码界面的notice
#define Notice_Name_ChatGroupQRTool                                    @"Notice_Name_ChatGroupQRTool"
//群 扫码后 直接进群 或者 申请加群相关
#define Notice_Name_ChatGroupQR_ScanActionTool                         @"Notice_Name_ChatGroupQR_ScanActionTool"


@interface SceneDelegate ()

@property (strong, nonatomic) BaoHuoWebViewVc *bhvc;
//发送红包
@property (nonatomic,strong) RedEvnInfoModel *saveCreatRedEvnInfoModel;
@property (nonatomic,assign) BOOL creatRedEnv_isGroupInfo;
@property (nonatomic,strong) NSString *createRedEnv_sendGroupOrFrendImId;
@property (nonatomic,strong) NSString *createRedEnv_sendMoneyType;

//抢红包
@property (nonatomic,assign) BOOL gotRedEnv_isGroupInfo;
@property (nonatomic,strong) NSString *gotRedEnv_sendGroupOrFrendImId;

//
@property (nonatomic,strong) NSString *saveThisZhiBoInfo_ZhuBoCreateRedEnvStr;//当前创建信息 里面的 直播类型键值对象


@end


@implementation SceneDelegate

- (void)initWithShowScen{
    //设置启动页停留时间
#if TARGET_IPHONE_SIMULATOR  //模拟器
    [self performSelectorOnMainThread:@selector(fetchProtocolVersionReq) withObject:nil waitUntilDone:YES];
#elif TARGET_OS_IPHONE      //真机
    
   __block BOOL isNoNetToNet = NO;
    CTCellularData *cellularData = [[CTCellularData alloc] init];
    cellularData.cellularDataRestrictionDidUpdateNotifier=^(CTCellularDataRestrictedState state) {
        NSLog(@"initWithShowScen state=%ld  %@",state,[NSThread currentThread]);
        
        
        switch(state){
            case kCTCellularDataRestricted:
            {
                DLog(@"Restricted  权限关闭的情况下 再次请求网络数据会弹出设置网络提示");
                [self performSelectorOnMainThread:@selector(fetchProtocolVersionReq) withObject:nil waitUntilDone:YES];
                isNoNetToNet = YES;
            }
                break;
            case kCTCellularDataNotRestricted:{
                DLog(@"NotRestricted 已经开启网络权限 监听网络状态");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self performSelector:@selector(fetchProtocolVersionReq) withObject:nil afterDelay:isNoNetToNet ? .3f : .3f];
                    isNoNetToNet = NO;
                    [self performSelector:@selector(doBaoHuoYeWebInitData) withObject:nil afterDelay:isNoNetToNet ? .3f : .3f];
                });
                
                
            }
                break;
            case kCTCellularDataRestrictedStateUnknown:
                DLog(@"Unknown 未知情况 （还没有遇到推测是有网络但是连接不正常的情况下）");
                
                break;
            default:
                break;
        }
    };
    [NSThread sleepForTimeInterval:1.0];//启动页时间
#endif

    [NSThread sleepForTimeInterval:2.0];
}

- (void)doBaoHuoYeWebInitData{
    DLog(@"windowCheckBaoHuoView initBaoHuoWebData");
    [self windowCheckBaoHuoView];    //保活界面检查是否存在
//                    [self.bhvc.webView reload];   //刷新数据
    [self.bhvc initBaoHuoWebData];
}
//任意网络接口
#define  CheckTokenUse_sufix  @"/domain/auth/list"
- (void)fetchProtocolVersionReq{
         //每次启动的时候 做检查是否token过期状态
        NSString *allU = [NSString stringWithFormat:@"%@%@",URL_Main_URL_Prefix,CheckTokenUse_sufix];
        [[Y_NetWorkBaseTool sharedTool]YrequestGetALLURL:allU withParams:@{}.mutableCopy finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
            if (isNotNil(responsObject)) {
                if (Y_IS_Success_status) {
                    DLog(@"token没过期 %@",responsObject);
                }else{
                    NSInteger sInt = [[responsObject objectForKey:@"status"] intValue];
                    if(sInt == 509){//token过期 滞空
                        DLog(@"token过期 %@",responsObject);
                    }else{
                        DLog(@"token未知过期与否 %@",responsObject);
                    }
                  
                }
            }else{
                NSLog(@"domain/auth/list。 ====== err code %ld des %@",error.code,error.description);
                if((error.code == -1011) && [error.userInfo.allValues containsObject:@"Request failed: bad request (400)"]){
                    NSString *shwoPleseLogin = Y_LocaleTypeFile_NSLocalString(@"请登录");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //Y_SVP_SHOW_INFO_MES_5Delay(shwoPleseLogin);//调起登录相关签名
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                       // Y_SVP_SHOW_ERR_DESCRIPTION
                    });
                }
            }
        }];
 

}

#pragma mark =====
- (void)dealloc{
    Y_NSNotificationCenter_RemoveNotice_Name(NociceName_WindowSubBaoHUOWebView_ShowOrHidden);
    Y_NSNotificationCenter_RemoveNotice_Name(Notice_Name_GotoImOneUserInfoVc);
    Y_NSNotificationCenter_RemoveNotice_Name(VoiceAndLiveNotice_ChangeActivity_Statu_Notice);
    Y_NSNotificationCenter_RemoveNotice_Name(VoiceAndLiveNotice_ChangeActivity_Info_Notice);
    Y_NSNotificationCenter_RemoveNotice_Name(Notice_Name_ChatGroupQRTool);
    Y_NSNotificationCenter_RemoveNotice_Name(Notice_Name_ChatGroupQR_ScanActionTool);
    //红包
    Y_NSNotificationCenter_RemoveNotice_Name(Chat_Get_Wallet_List_Notice);
    Y_NSNotificationCenter_RemoveNotice_Name(RedEnv_OnWebVc_SignGeted_Notice);
    Y_NSNotificationCenter_RemoveNotice_Name(Chat_Create_RedEnv_Notice);
    Y_NSNotificationCenter_RemoveNotice_Name(Chat_Got_RedEnv_Notice);
    
    //直播聊天两个涉及到的
    Y_NSNotificationCenter_RemoveNotice_Name(Notice_Name_Chat_ActivityAction_ZhiBoJoinActiveOrKaiBoTool);
    Y_NSNotificationCenter_RemoveNotice_Name(Notice_Name_Chat_ActivityAction_NowIsZhiBoJoin_WillShowShareTool);
    //充值提现跳转notice
    Y_NSNotificationCenter_RemoveNotice_Name(NoticeName_gotoMyChongZhiTIXianWebVc)
    //直播间切去聊天会话功能
    Y_NSNotificationCenter_RemoveNotice_Name(Notice_Name_zhiBoGoToChatWithOnTheAir)

    DLog(@" SceneDelegate dealoc 多个notice");
    
}

//跳转聊天直播间的chat会话页面
//在FREEPER直播的同时，可以返回FREEPER社交群里操作聊天。
//zhiBoGoToChatWithOnTheAir
- (void)zhiBoGoToChatVcAction:(NSNotification *)notice{

    UIViewController *puUseVc = notice.object;

    ZhiBoGroupWillChooseGroupOrFriendToChatListVc *vcGotoChat = [[ZhiBoGroupWillChooseGroupOrFriendToChatListVc alloc]init];
    //跳转相关
    if([puUseVc isKindOfClass:[UITabBarController class]]){
        UITabBarController *tabvc = (UITabBarController *)puUseVc;
        
         if([tabvc.childViewControllers[tabvc.selectedIndex] isKindOfClass:[UINavigationController class]]){
            UINavigationController * useNav =  (UINavigationController *)tabvc.childViewControllers[tabvc.selectedIndex];
            [useNav pushViewController:vcGotoChat animated:YES];
            
         }else{
             UIViewController * usevc =  (UIViewController *)tabvc.childViewControllers[tabvc.selectedIndex];
             [usevc.navigationController pushViewController:vcGotoChat animated:YES];
         }
    }else{
        [puUseVc.navigationController pushViewController:vcGotoChat animated:YES];

    }
}



//分享直播活动
- (void)zhiBoInfoWillShareToChatAction:(NSNotification *)notice{
    
    UIViewController *puUseVc = notice.object;
    NSLog(@"zhiBoInfoWillShareToChatAction ---  %@",notice.userInfo);
    NSDictionary *infoOfZhiBoShareDic = [notice.userInfo isKindOfClass:[NSDictionary class]] ? [NSDictionary dictionaryWithDictionary:notice.userInfo] : @{};
    
    ZhiBoGroupWillShareDoChooseGroupOrFriendListVc *vcShare = [[ZhiBoGroupWillShareDoChooseGroupOrFriendListVc alloc]init];
    vcShare.hidesBottomBarWhenPushed = YES;
    vcShare.zhiBoShare_activityId = [[infoOfZhiBoShareDic allKeys]containsObject:@"activityId"] ? [NSString stringWithFormat:@"%@",[infoOfZhiBoShareDic objectForKey:@"activityId"]] : @"";
    vcShare.zhiBoShare_address = [[infoOfZhiBoShareDic allKeys]containsObject:@"address"] ? [NSString stringWithFormat:@"%@",[infoOfZhiBoShareDic objectForKey:@"address"]] : @"";
    vcShare.zhiBoShare_shareContent = [[infoOfZhiBoShareDic allKeys]containsObject:@"shareContent"] ? [NSString stringWithFormat:@"%@",[infoOfZhiBoShareDic objectForKey:@"shareContent"]] : @"";
    vcShare.zhiBoShare_activityImage = [[infoOfZhiBoShareDic allKeys]containsObject:@"activityImage"] ? [NSString stringWithFormat:@"%@",[infoOfZhiBoShareDic objectForKey:@"activityImage"]] : @"";
    vcShare.category = [[infoOfZhiBoShareDic allKeys]containsObject:@"category"] ? [[infoOfZhiBoShareDic objectForKey:@"category"] intValue] : 2;//暂时语音直播有分享

    //跳转相关
    if([puUseVc isKindOfClass:[UITabBarController class]]){
        UITabBarController *tabvc = (UITabBarController *)puUseVc;
        
         if([tabvc.childViewControllers[tabvc.selectedIndex] isKindOfClass:[UINavigationController class]]){
            UINavigationController * useNav =  (UINavigationController *)tabvc.childViewControllers[tabvc.selectedIndex];
            [useNav pushViewController:vcShare animated:YES];
            
         }else{
             UIViewController * usevc =  (UIViewController *)tabvc.childViewControllers[tabvc.selectedIndex];
             [usevc.navigationController pushViewController:vcShare animated:YES];
         }
    }else{
        [puUseVc.navigationController pushViewController:vcShare animated:YES];

    }
    
    
}


- (void)chatCellTouchAndOtherIfGoTozhiBoCreatOrLookAction:(NSNotification *)notice{
    //@{@"id":activityID,@"address":createUserAddressStr,@"password":passwordID}
    NSDictionary *noticeUserInfo = @{};
    NSString *activityId = @"";
    NSString *address = @"";
    NSString *password = @"";
    if([notice.userInfo isKindOfClass:[NSDictionary class]]){
        noticeUserInfo = [NSDictionary dictionaryWithDictionary:notice.userInfo];
        activityId = [[noticeUserInfo allKeys]containsObject:@"id"] ? [ noticeUserInfo objectForKey:@"id"] : @"";
        address = [[noticeUserInfo allKeys]containsObject:@"address"] ? [ noticeUserInfo objectForKey:@"address"] : @"";
        password = [[noticeUserInfo allKeys]containsObject:@"password"] ? [ noticeUserInfo objectForKey:@"password"] : @"";
    }
    UIViewController *noticeObj ;
    if([notice.object isKindOfClass:[UIViewController class]]){
        noticeObj = (UIViewController *)notice.object;
    }
        
    if(activityId.length<=0){
        Y_SVP_SHOW_ERR_MES(Y_LocaleTypeFile_NSLocalString(@"该分享数据有误"));
        return;
    }
    //---
    NSString *title = @"";
    BOOL isZhuBoBool = NO;
    if([address isEqualToString:[ShareUserInfo share].userInfo.address] || [address isEqualToString:[ShareUserInfo share].userInfo.imId]){//创建人是自己
        title = Y_LocaleTypeFile_NSLocalString(@"是否开启该直播");
        isZhuBoBool = YES;
    }else{
        title = Y_LocaleTypeFile_NSLocalString(@"是否去看该直播");
    }
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:title message:@"" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:Y_LocaleTypeFile_NSLocalString(@"确定") style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [ShareZhiBoOfOtherTool getThisZhiBoInfoWithUseActivityId:activityId withMyRoleIsZhuBoBool:isZhuBoBool WithWillUsePushUseVc:noticeObj];
 
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:Y_LocaleTypeFile_NSLocalString(@"取消") style:UIAlertActionStyleCancel handler:nil];
    [alertC addAction:alertA];
    [alertC addAction:cancleAction];
    dispatch_async(dispatch_get_main_queue(), ^{
        if(isNotNil(noticeObj)){
            [noticeObj presentViewController:alertC animated:YES completion:nil];
        }else{
            [self.window.rootViewController presentViewController:alertC animated:YES completion:nil];
        }
    });
}


#pragma mark ===
//iOS13以上 window 的 windowScene 属性无值，需要手动赋值
- (void)addNoticeAndBaoHuoViewsWithwindowScene:(UIWindowScene *)windowScene{
    DLog(@" ---------------------------- ");
    self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
    self.window.frame = windowScene.coordinateSpace.bounds;
    self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;//浅色模式
    
    //0828先到root加载页 需要判断LauncViewController 非tabbvc的情况
    if([self.window.rootViewController isKindOfClass: [LauncViewController class]]){
        NSLog(@"当前在初始页 不检查保活界面");
        return;
    }
    //直接到主页
    self.window.rootViewController  = [[MainTabbarControll alloc]init];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [UIApplication sharedApplication].delegate.window = self.window;
    
    [self windowCheckBaoHuoView];
   
  
}
- (void)windowCheckBaoHuoView{
    DLog(@"---------------  self.window.sub %@" ,self.window.subviews);
    BOOL haveBaoHuoBool = NO;
    for (UIView * subview in self.window.subviews) {
        if(subview.tag == 9999){
            haveBaoHuoBool = YES;
        }
    }
    if(haveBaoHuoBool == NO){
        [self.window addSubview:self.baoHuoViews];
        
    }else{
        
    }
    //[self performSelector:@selector(addBaoHuoWebV) withObject:nil afterDelay:0.1];
    
}

#pragma mark === 通知
- (void)anNotice{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        Y_NSNotificationCenter_Creat_NameAction(NociceName_WindowSubBaoHUOWebView_ShowOrHidden, showOrHidenView:);
        Y_NSNotificationCenter_Creat_NameAction(Notice_Name_GotoImOneUserInfoVc,gotoImOneUserInfoVcNotice:)
        Y_NSNotificationCenter_Creat_NameAction(Notice_Name_AddOnePersion,addFriendPushUseVcNotice:)
        Y_NSNotificationCenter_Creat_NameAction(Notice_Name_ChatGroupQRTool, chatGroupQR_ShowVcTool:);
        Y_NSNotificationCenter_Creat_NameAction(Notice_Name_ChatGroupQR_ScanActionTool, chatGroupQR_ScanActionTool:);
        //币种
        Y_NSNotificationCenter_Creat_NameAction(Chat_Get_Wallet_List_Notice,chat_Get_Wallet_ListAction:);
        //红包
        Y_NSNotificationCenter_Creat_NameAction(Chat_Create_RedEnv_Notice,chat_ReadEnv_Create:);
        //钱包授权后红包继续下一个接口
        Y_NSNotificationCenter_Creat_NameAction(RedEnv_OnWebVc_SignGeted_Notice,web_ReadEnv_signGeted:);
        //
        Y_NSNotificationCenter_Creat_NameAction(Chat_Got_RedEnv_Notice,chat_RedEnv_Got:);
        //直播聊天两个涉及到的 直播分享到群 或者 跳转去看或者跳转去直播
        Y_NSNotificationCenter_Creat_NameAction(Notice_Name_Chat_ActivityAction_NowIsZhiBoJoin_WillShowShareTool, zhiBoInfoWillShareToChatAction:);
        Y_NSNotificationCenter_Creat_NameAction(Notice_Name_Chat_ActivityAction_ZhiBoJoinActiveOrKaiBoTool, chatCellTouchAndOtherIfGoTozhiBoCreatOrLookAction:);
        //通知去充值界面
        Y_NSNotificationCenter_Creat_NameAction(NoticeName_gotoMyChongZhiTIXianWebVc, gotoMyChongZhiTIXianWebVcAction:);

        //直播间切去聊天会话功能
        Y_NSNotificationCenter_Creat_NameAction(Notice_Name_zhiBoGoToChatWithOnTheAir,zhiBoGoToChatVcAction:);
    });

    
}
#pragma mark == 币种

- (void)chat_Get_Wallet_ListAction:(NSNotification *)notice{
    DLog(@"币种  ---- noticeobject %@",notice.object);
    
    [PopSendOrGetRedNoticeOfDataTool redEnvGetWalletListWithBolock:^(NSArray * _Nullable listArrOfBlock, BOOL succes) {
        if(succes){
            if(listArrOfBlock.count==3){//类型数据和余额度数据 1007增加类型数据
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    /**
                     我的钱包余额列表 (
                            {
                            address = 0x03837ced4b55d4f61166c05baeb697222f63f623;
                            balance = 0;
                            contractAddress = 0xc026606ff35c50e26e18d9908df879b8a49857e7;
                            frozen = 0;
                            id = 651456;
                            rowCreate = "2023-09-27 07:23:57";
                            rowUpdate = "2023-09-27 10:17:55";
                            state = 1;
                        }
                    )
                     ,arr_network= (
                            {
                            chainCode = "evm_bsc_97_test";
                            chainId = 97;
                            decimals = 18;
                            icon = "https://un93kdk-v1source.freeper.cc/icon/bnb.png";
                            id = 1;
                            manageAddress = 0xA03804720e7B0f0244bc39bD6ABe48097d1ca504;
                            name = "BNB Smart Chain";
                            rpcUrl = "https://bsc-testnet.nodereal.io/v1/af5a90bdee9740ed8cbd645c593ca727";
                            shortName = bnb;
                            symbol = BNB;
                        },
                            {
                            chainCode = "evm_mmc_79";
                            chainId = 79;
                            decimals = 18;
                            icon = "https://un93kdk-v1source.freeper.cc/icon/mmc.png";
                            id = 2;
                            manageAddress = 0xF6ec9Ce77bB586fbA62EE65449f31A3d46c48A4F;
                            name = "Mix Max";
                            rpcUrl = "https://chain.mixmax.cc";
                            shortName = MMC;
                            symbol = MC;
                        }
                    )
                     合约信息 (
                            {
                            chainCode = "evm_bsc_97_test";
                            contractAddress = 0xc026606FF35c50e26E18d9908df879B8a49857e7;
                            decimals = 18;
                            heat = 99;
                            icon = "https://un93kdk-v1source.freeper.cc/icon/f-u.png";
                            id = 1;
                            isBuy = 0;
                            name = FFF;
                            symbol = "F-U";
                        },
                            {
                            chainCode = "evm_bsc_97_test";
                            contractAddress = 0xb366b91306F06399829De3575c6B237aEDBEe475;
                            decimals = 18;
                            heat = 99;
                            icon = "https://un93kdk-v1source.freeper.cc/icon/fusdt.png";
                            id = 2;
                            isBuy = 0;
                            name = UUUU;
                            symbol = FUSDT;
                        },
                            {
                            chainCode = "evm_mmc_79";
                            contractAddress = 0xC0679a3372eC4273150b93Cc535a644B15870663;
                            decimals = 18;
                            heat = 99;
                            icon = "https://un93kdk-v1source.freeper.cc/icon/usd-mc.png";
                            id = 3;
                            isBuy = 0;
                            name = "USD-MC";
                            symbol = "USD-MC";
                        }
                    )
                    币种相关数据*/
                    Y_NSNotificationCenter_PostNotice_HaveObject_Name(Chat_Get_Wallet_List_Notice_Result, listArrOfBlock);
                    
                    //余额度处理成键值 不走数据类型
                    /**
                     wallet =     (
                                 {
                             address = 0xf2504a866bed5fb0a58e5fd92e9cec069fa578f5;
                             balance = 1132904685081120440253;
                             contractAddress = 0xc026606ff35c50e26e18d9908df879b8a49857e7;
                             frozen = 0;
                             id = 651446;
                             rowCreate = "2023-09-16 10:04:02";
                             rowUpdate = "2023-09-28 07:34:39";
                             state = 1;
                         }
                     //余额相关
                     k contractAddress obj
                     o balance obj
                     );*/
                    NSArray *arrOfwallet = [NSArray arrayWithArray:listArrOfBlock.lastObject];//钱包信息
                    NSMutableDictionary *willUseMyBalanceInfoDic = [[NSMutableDictionary alloc]init];//余额信息dic
                    for (int i = 0; i <arrOfwallet.count; i++) {
                        NSDictionary *an_w_obj = arrOfwallet[i];
                        NSString *contractAddress = [[an_w_obj allKeys]containsObject:@"contractAddress"] ? [an_w_obj objectForKey:@"contractAddress"] : @"";
                        NSString *balance = [[an_w_obj allKeys]containsObject:@"balance"] ? [NSString stringWithFormat:@"%@",[an_w_obj objectForKey:@"balance"]] : @"";
                        if(contractAddress.length>0){
                            [willUseMyBalanceInfoDic setValue:balance forKey:contractAddress];
                        }
                    }
                    NSLog(@"willUseMyBalanceInfoDic= %@",willUseMyBalanceInfoDic);
                    Y_NSNotificationCenter_PostNotice_HaveObject_Name(Chat_Get_myBalanceInfo, willUseMyBalanceInfoDic);
                });
            }
        }
    }];
 
 
}
#pragma mark == 跳转去充值提现界面 dapp
//充值提现界面
#define Money_User_Income                @"/pages/user/income"

//如果满足提现最低的话）  域名+/#/pages/user/income
- (void)gotoMyChongZhiTIXianWebVcAction:(NSNotification *)notice{
    DLog(@"");
    if([notice.object isKindOfClass:[UIViewController class]]){
        UIViewController *puUseVc = (UIViewController *)notice.object;
     
        DappUseBaseVc *chongZhiVc = [[DappUseBaseVc alloc]init];
        chongZhiVc.hidesBottomBarWhenPushed = YES;
        //chongZhiVc.dappShowUseInfoBodyDic = @{};
        //chongZhiVc.isShouCangeType = collect;
        NSString *okUrl = @"";
        NSString *this_WebVcBaseUrl = WebVc_Base_URL;
        NSString *WebVc_Base_URL_Str = [this_WebVcBaseUrl substringFromIndex: this_WebVcBaseUrl.length - 1];//最末位
        if([WebVc_Base_URL_Str containsString:@"#"]){//带了 不拼WebCenterUrlUseStr 且位置不一样所以无需/
            okUrl = [NSString stringWithFormat:@"%@%@",WebVc_Base_URL,Money_User_Income ];
        }else{
            okUrl = [NSString stringWithFormat:@"%@%@%@",WebVc_Base_URL,WebCenterUrlUseStr,Money_User_Income];
        }
        NSLog(@" //充值提现界面 okUrl == %@",okUrl);

        chongZhiVc.thisDappUseUrlStr = okUrl;
        chongZhiVc.isGoSubVcDontDealTabbarsHidenOrShow = YES;
        //跳转相关
        if([puUseVc isKindOfClass:[UITabBarController class]]){
            UITabBarController *tabvc = (UITabBarController *)puUseVc;
            
             if([tabvc.childViewControllers[tabvc.selectedIndex] isKindOfClass:[UINavigationController class]]){
                UINavigationController * useNav =  (UINavigationController *)tabvc.childViewControllers[tabvc.selectedIndex];
                [useNav pushViewController:chongZhiVc animated:YES];
                
             }else{
                 UIViewController * usevc =  (UIViewController *)tabvc.childViewControllers[tabvc.selectedIndex];
                 [usevc.navigationController pushViewController:chongZhiVc animated:YES];
             }
        }else{
            if(isNil(puUseVc.navigationController)){
                //chongZhiVc.modalPresentationStyle = UIModalPresentationFullScreen;//跳转到充值界面 全屏展示 无nav展示半屏幕 好做返回动作
                [puUseVc presentViewController:chongZhiVc animated:YES completion:^{
                    DLog(@"到达充值界面");
                }];
            }else{
                [puUseVc.navigationController pushViewController:chongZhiVc animated:YES];
            }


        }
        
    }
    
}
 

#pragma mark == 红包


static NSString *redCellType_morePerson = @"redCellType_morePerson";
static NSString *redCellType_moneyNum = @"redCellType_moneyNum";
static NSString *redCellType_moneyTip = @"redCellType_moneyTip";
static NSString *redCellType_moneyType = @"redCellType_moneyType";

- (void)chat_ReadEnv_Create:(NSNotification *)notice{
    NSString *myUserAddress = [ShareUserInfo share].userInfo.address;
    DLog(@"红包  ---- 发送者 myUserAddress %@",myUserAddress);
    DLog(@"红包  ---- noticeobject %@",notice.object);
    DLog(@"红包  ---- noticeuserInfo %@",notice.userInfo);
    NSDictionary *redEnvDic = [NSDictionary dictionaryWithDictionary:notice.userInfo];
    //保活界面 做相关的数据交互
    NSString *personCountStr = ([[redEnvDic allKeys] containsObject:redCellType_morePerson]) ? [redEnvDic objectForKey:redCellType_morePerson] : @"";
    NSString *moneyStr = ([[redEnvDic allKeys] containsObject:redCellType_moneyNum]) ? [redEnvDic objectForKey:redCellType_moneyNum] : @"";
    NSString *msgStr = ([[redEnvDic allKeys] containsObject:redCellType_moneyTip]) ? [redEnvDic objectForKey:redCellType_moneyTip] : @"";
    NSString *moneyTypeStr = ([[redEnvDic allKeys] containsObject:redCellType_moneyType]) ? [redEnvDic objectForKey:redCellType_moneyType] : @"";
    NSString *saveMoneyTypeContractAddresssStr = ([[redEnvDic allKeys] containsObject:@"address"]) ? [redEnvDic objectForKey:@"address"] : @"";
    NSString *userIDStr = ([[redEnvDic allKeys] containsObject:@"userID"]) ? [redEnvDic objectForKey:@"userID"] : @"";//及时通讯ID 获取到对应者address
    NSString *groupIDStr = ([[redEnvDic allKeys] containsObject:@"groupID"]) ? [redEnvDic objectForKey:@"groupID"] : @"";
    NSString *activityIdS = ([[redEnvDic allKeys] containsObject:@"activityId"]) ? [redEnvDic objectForKey:@"activityId"] : @"";
    NSString *cZhiBoInfo =  ([[redEnvDic allKeys] containsObject:CreateSubDataType_ZhiBoInfoKey]) ? [redEnvDic objectForKey:CreateSubDataType_ZhiBoInfoKey] : @"";
    self.saveThisZhiBoInfo_ZhuBoCreateRedEnvStr = cZhiBoInfo;//本次调起创建的类型文本
    self.createRedEnv_sendMoneyType = moneyTypeStr;
    self.saveCreatRedEvnInfoModel = [[RedEvnInfoModel alloc]init];
    self.saveCreatRedEvnInfoModel.activityId = activityIdS;
    self.saveCreatRedEvnInfoModel.address = [ShareUserInfo share].userInfo.address;//发送者的地址数据带入
    self.saveCreatRedEvnInfoModel.category = 0;//红包类型， 0、运气红包， 1、均分红包，2、定向红包。 定向红包可不传
    self.saveCreatRedEvnInfoModel.contractAddress = saveMoneyTypeContractAddresssStr;//合约地址
    self.saveCreatRedEvnInfoModel.scene = @(0);//红包模块， 0、聊天， 1、直播
    self.saveCreatRedEvnInfoModel.pieces = [personCountStr integerValue];//红包个数， 定向红包不传
    self.saveCreatRedEvnInfoModel.amount =  @([moneyStr integerValue]);
    self.saveCreatRedEvnInfoModel.title = msgStr;
    self.saveCreatRedEvnInfoModel.cover = @"https://c-ssl.dtstatic.com/uploads/blog/202203/21/20220321204722_1fa16.thumb.1000_0.jpg";   //cover封面
    
    if(cZhiBoInfo.length>0){//saveThisZhiBoInfoStr
        self.saveCreatRedEvnInfoModel.scene = @(1);//红包模块， 0、聊天， 1、直播
        if([cZhiBoInfo isEqualToString:BussinessID_ZhiBo_CUSTOM_onAnchorSendRedEnvelope]){
            NSLog(@"主播发红包")
        }else if ([cZhiBoInfo isEqualToString:BussinessID_ZhiBo_CUSTOM_onAudienceSendRedEnvelope]){
            NSLog(@"观众发红包")
        }else if ([cZhiBoInfo isEqualToString:BussinessID_ZhiBo_CUSTOM_onSendGifts]){
            NSLog(@"观众发礼物");
        }else{
            NSLog(@"cZhiBoInfo ---  %@",cZhiBoInfo);
        }
        self.saveCreatRedEvnInfoModel.channelId = groupIDStr;
        self.creatRedEnv_isGroupInfo = YES;
        self.createRedEnv_sendGroupOrFrendImId = groupIDStr;
        //调起红包创建接口
        [self.bhvc creatredEnvOfWebInfo:notice.userInfo];
        return;
    }else{
        if(groupIDStr.length>0){
            self.saveCreatRedEvnInfoModel.channelId = groupIDStr;
            self.creatRedEnv_isGroupInfo = YES;
            self.createRedEnv_sendGroupOrFrendImId = groupIDStr;
            [self.bhvc creatredEnvOfWebInfo:notice.userInfo];
            
        }else{
            //获取到接受者的地址 才能给他发
            
            [LoginUseModel userImid:userIDStr checkAddressAndOtherInfoWithBlock:^(NSDictionary * _Nonnull dicOfBlock, BOOL succes) {
                NSLog(@"checkAddressAndOtherInfoWithBlock -- dicOfBlock %@",dicOfBlock);
                if(succes){
                    
                    if([[dicOfBlock allKeys] containsObject:@"personalProfileResDto"]){
                        NSDictionary *personalProfileResDto = [NSDictionary dictionaryWithDictionary:[dicOfBlock objectForKey:@"personalProfileResDto"]];
                        if( [personalProfileResDto isKindOfClass:[NSDictionary class]] && [[personalProfileResDto allKeys] containsObject:@"address"]){
                            NSString *sendToAddress = [TextShowWithModelStr textShowWithModelStr:[personalProfileResDto objectForKey:@"address"]];
                            //获取红包签名
                            self.creatRedEnv_isGroupInfo = NO;
                            self.createRedEnv_sendGroupOrFrendImId = userIDStr;
                            self.saveCreatRedEvnInfoModel.receiver = @[@{
                                @"address":sendToAddress,
                                @"amount":@([moneyStr integerValue])
                            }];
                            
                            self.saveCreatRedEvnInfoModel.channelId = userIDStr;//imid
                            [self.bhvc creatredEnvOfWebInfo:notice.userInfo];
                        }
                        
                    }
                }
            }];
            
        }
        
    }
}


//红包签名拿到后 创建接口动作完成后 得到本次创建红包的信息 格式为 签名 逗号 后续要用的时间戳
- (void)web_ReadEnv_signGeted:(NSNotification *)notice{
    DLog(@"红包 webvc收到签名信息 ---- noticeobject %@",notice.object);
    DLog(@"红包 webvc收到签名信息 ---- noticeuserInfo %@",notice.userInfo);
    
    
    NSString *signStr = [[NSString stringWithFormat:@"%@",notice.object] componentsSeparatedByString:@","].firstObject;
    NSString *times = [[NSString stringWithFormat:@"%@",notice.object] componentsSeparatedByString:@","].lastObject;
    
    if(isNil(self.saveCreatRedEvnInfoModel)){
        return;
    }
    
//    NSString *signStr = [NSString stringWithFormat:@"%@，time",notice.object];
    //类型--聊天类型 | 直播类型

    RedEvnInfoModel *redCreatModel = self.saveCreatRedEvnInfoModel;
    redCreatModel.signature = signStr;
    redCreatModel.time = times;//[YTimeStamp getNowTimeTimestamp_haoMiao];
    NSMutableDictionary *redCreatData = [[NSMutableDictionary alloc]initWithDictionary:[redCreatModel mj_keyValues]];
    NSLog(@"redEnv CreatData --- %@  ,self.saveThisZhiBoInfo_ZhuBoCreateRedEnvSt=%@",redCreatData,self.saveThisZhiBoInfo_ZhuBoCreateRedEnvStr);
    NSLog(@"redEnv CreatData 当前创建者地址 --- %@",[ShareUserInfo share].userInfo.address);

    if(self.saveThisZhiBoInfo_ZhuBoCreateRedEnvStr.length>0 && ([self.saveThisZhiBoInfo_ZhuBoCreateRedEnvStr isEqualToString:BussinessID_ZhiBo_CUSTOM_onAudienceSendRedEnvelope])){//直播 + 观众发红包=赏
        //[redCreatData setValue:@"activityId" forKey:self.saveCreatRedEvnInfoModel.channelId];//活动ID 放的数据为房间号ID 直播频道ID
        [PopSendOrGetRedNoticeOfDataTool redEnvLiveRewardWithData:redCreatData
                                                        withBlock:^(NSDictionary * _Nonnull dicOfBlock, BOOL succes) {
            if(succes){
                //新旧更迭
                self.saveCreatRedEvnInfoModel = [RedEvnInfoModel mj_objectWithKeyValues:dicOfBlock];
                if(self.saveCreatRedEvnInfoModel.address.length<0){
                    self.saveCreatRedEvnInfoModel.address = [ShareUserInfo share].userInfo.address;//发送者的地址数据带入
                }
          
                
                /** 发送信息 重复问题 ，只通知basevc发送 当前页不发*/
                dispatch_async(dispatch_get_main_queue(), ^{
                    Y_NSNotificationCenter_PostNotice_HaveObject_Name(Chat_RedEnv_CreatMsg_WillSend_Notice, dicOfBlock);
                });
            }
            
          
            return;
            
        }];
        
        return;
    }else{
        //直播 主播发红包，聊天 用底下的部分
    }
    
    
    
    [PopSendOrGetRedNoticeOfDataTool redEnvCreateWithData:redCreatData
                                                withBlock:^(NSDictionary * _Nonnull dicOfBlock, BOOL succes) {
        if(succes){
            //直播
            if(self.saveThisZhiBoInfo_ZhuBoCreateRedEnvStr.length>0){
                self.saveCreatRedEvnInfoModel.scene = @(1);//红包模块， 0、聊天， 1、直播
                if([self.saveThisZhiBoInfo_ZhuBoCreateRedEnvStr isEqualToString:BussinessID_ZhiBo_CUSTOM_onAnchorSendRedEnvelope]){
                    NSLog(@"主播发红包 redEnvCreateWithData")
                }else if ([self.saveThisZhiBoInfo_ZhuBoCreateRedEnvStr isEqualToString:BussinessID_ZhiBo_CUSTOM_onAudienceSendRedEnvelope]){
                    NSLog(@"观众发红包 redEnvCreateWithData")
                }else if ([self.saveThisZhiBoInfo_ZhuBoCreateRedEnvStr isEqualToString:BussinessID_ZhiBo_CUSTOM_onSendGifts]){
                    NSLog(@"观众发礼物 redEnvCreateWithData");
                }else{
                    NSLog(@"self.saveThisZhiBoInfoStr 空串，是聊天相关的  -redEnvCreateWithData--  %@",self.saveThisZhiBoInfo_ZhuBoCreateRedEnvStr);
                }
                //新旧更迭
                self.saveCreatRedEvnInfoModel = [RedEvnInfoModel mj_objectWithKeyValues:dicOfBlock];
                if(self.saveCreatRedEvnInfoModel.address.length<0){
                    self.saveCreatRedEvnInfoModel.address = [ShareUserInfo share].userInfo.address;//发送者的地址数据带入
                }
                /** 发送信息 重复问题 ，只通知basevc发送 当前页不发*/
                dispatch_async(dispatch_get_main_queue(), ^{
                    Y_NSNotificationCenter_PostNotice_HaveObject_Name(Chat_RedEnv_CreatMsg_WillSend_Notice, dicOfBlock);
                });
                return;
               
            }else{
                //聊天
                //发送红包的信息
                [self doChatImOfSendMessageAction:dicOfBlock];
            }
            
           
        }
        
    }]; 
   
}


- (void)doChatImOfSendMessageAction:(NSDictionary *)getDic{
    if([[getDic allKeys] containsObject:@"channelId"]){//防止单人红包 非群红包 时 imid数据无效问题
        self.saveCreatRedEvnInfoModel.channelId = [TextShowWithModelStr textShowWithModelStr:[getDic objectForKey:@"channelId"]];
    }
    //新旧更迭
    self.saveCreatRedEvnInfoModel = [RedEvnInfoModel mj_objectWithKeyValues:getDic];
    if(self.saveCreatRedEvnInfoModel.address.length<0){
        self.saveCreatRedEvnInfoModel.address = [ShareUserInfo share].userInfo.address;//发送者的地址数据带入
    }
    NSLog(@"self.saveCreatRedEvnInfoModel === %@ %@ %@",self.saveCreatRedEvnInfoModel.senderMsg,self.saveCreatRedEvnInfoModel.ID,self.saveCreatRedEvnInfoModel.uno);
    NSLog(@"self.saveCreatRedEvnInfoModel ===address %@",self.saveCreatRedEvnInfoModel.address);
    
    V2TIMMessage *sendMsg = [self creatRedEnv_dealCustomMsg];
    
    /** 发送信息 重复问题 ，只通知basevc发送 当前页不发*/
    dispatch_async(dispatch_get_main_queue(), ^{
        Y_NSNotificationCenter_PostNotice_HaveObject_Name(Chat_RedEnv_CreatMsg_WillSend_Notice, sendMsg);
    });
    return;
    if(self.creatRedEnv_isGroupInfo){
       
        NSString *groupID =  self.createRedEnv_sendGroupOrFrendImId;
        [[V2TIMManager sharedInstance] sendMessage:sendMsg
                                          receiver:@""
                                           groupID:groupID
                                          priority:V2TIM_PRIORITY_DEFAULT
                                    onlineUserOnly:NO
                                   offlinePushInfo:nil
                                          progress:^(uint32_t progress) {
        } succ:^{
            NSLog(@"发送成功");
            [TUITool makeToast: Y_LocaleTypeFile_NSLocalString(@"成功") ];
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_NSNotificationCenter_PostNotice_HaveObject_Name(Chat_RedEnv_CreatMsg_WillSend_Notice, sendMsg);
            });
        } fail:^(int code, NSString *desc) {
            NSLog(@"code %d desc %@ ",code,desc);
        }];
        
    }else{
        
        NSString *userId =  self.createRedEnv_sendGroupOrFrendImId;
        [[V2TIMManager sharedInstance] sendMessage:sendMsg
                                          receiver:userId
                                           groupID:@""
                                          priority:V2TIM_PRIORITY_DEFAULT
                                    onlineUserOnly:NO
                                   offlinePushInfo:nil
                                          progress:^(uint32_t progress) {
        } succ:^{
            NSLog(@"发送成功");
            //[TUITool makeToast:@"成功"];
            [TUITool makeToast: Y_LocaleTypeFile_NSLocalString(@"成功") ];
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_NSNotificationCenter_PostNotice_HaveObject_Name(Chat_RedEnv_CreatMsg_WillSend_Notice, sendMsg);
            });
            
            
        } fail:^(int code, NSString *desc) {
            NSLog(@"code %d desc %@ ",code,desc);
        }];
    }
    
    
}

- (V2TIMMessage *)creatRedEnv_dealCustomMsg{
    V2TIMMessage *cusmessage;
    NSMutableDictionary *redCreatData = [[NSMutableDictionary alloc]initWithDictionary:[self.saveCreatRedEvnInfoModel mj_keyValues]];
    //币种需要单独处理
    [redCreatData setValue:self.createRedEnv_sendMoneyType forKey:@"unit"];//币种类型
    NSMutableDictionary *customDic = [[NSMutableDictionary alloc]initWithDictionary:redCreatData];
    [customDic setValue:redCreatData forKey:@"data"];
    [customDic setValue:@(GroupCreate_Version) forKey:@"version"];
    [customDic setValue:BussinessID_CUSTOM_RED_ENVELOPE forKey:BussinessID];
    [customDic setValue:@(2) forKey:@"type"];//
    //安卓需要的部分键值处理
    [customDic setValue:self.createRedEnv_sendMoneyType forKey:@"unit"];//币种类型
    [customDic setValue:[ShareUserInfo share].userInfo.profileImageUrl forKey:@"sendUserAdavter"];//
    [customDic setValue:self.saveCreatRedEvnInfoModel.uno forKey:@"id"];//创建uno类型
    [customDic setValue:self.saveCreatRedEvnInfoModel.senderMsg forKey:@"sendUserName"];//创建者
    [customDic setValue:[ShareUserInfo share].userInfo.imId forKey:@"sendUserId"];//创建者


    NSError *err;
    NSData *customData= [NSJSONSerialization dataWithJSONObject:customDic options:NSJSONWritingPrettyPrinted error:&err];
    if(err){
        NSLog(@"dealCustomMsg -- 失败");
        return cusmessage;
    }
    cusmessage = [[V2TIMManager sharedInstance] createCustomMessage:customData];
    cusmessage.customElem.desc = [NSString stringWithFormat:@"%ld",Link_Type_RedEnv_2];//用于主页显示[自定义消息]的desc处理
    NSLog(@"sendMsg == %@",customDic);
    NSLog(@"sendMsg.msgid == %@",cusmessage.msgID);
    return cusmessage;
    
}


#pragma mark --
#define cellData_Parms_redEnvData_subUnit          @"unit"
#define cellData_Parms_redEnvData_subUno          @"uno"
#define cellData_Parms_redEnvData_subid           @"id"
//抢红包动作
- (void)chat_RedEnv_Got:(NSNotification *)notice{
    NSString *doGotEnvActionUserAddressStr = [ShareUserInfo share].userInfo.address;
    DLog(@"抢红包动作  ---- 我的地址是 %@",doGotEnvActionUserAddressStr);
    DLog(@"抢红包动作  ---- noticeobject %@",notice.object);
    
    NSString *unoStr = [NSString stringWithFormat:@"%@",notice.object];
    NSDictionary *got_redEnvInfoDic = [NSDictionary dictionaryWithDictionary:notice.userInfo];
    NSLog(@"got_redEnvInfoDic = %@",got_redEnvInfoDic);
    
    NSString *got_Red_Vc_gorupId = ([[got_redEnvInfoDic allKeys] containsObject:@"groupID"]) ? [got_redEnvInfoDic objectForKey:@"groupID"] : @"";
    NSString *got_Red_Vc_userId = ([[got_redEnvInfoDic allKeys] containsObject:@"userID"]) ? [got_redEnvInfoDic objectForKey:@"userID"] : @"";
    NSString *cZhiBoInfo =  ([[got_redEnvInfoDic allKeys] containsObject:CreateSubDataType_ZhiBoInfoKey]) ? [got_redEnvInfoDic objectForKey:CreateSubDataType_ZhiBoInfoKey] : @"";
    self.saveThisZhiBoInfo_ZhuBoCreateRedEnvStr = cZhiBoInfo;//本次调起创建的类型文本 直播类型另外处理

    
    if(got_Red_Vc_userId.length > 0){
        self.gotRedEnv_isGroupInfo = NO;
        self.gotRedEnv_sendGroupOrFrendImId = got_Red_Vc_userId;

    }
    if(got_Red_Vc_gorupId.length > 0){
        self.gotRedEnv_isGroupInfo = YES;
        self.gotRedEnv_sendGroupOrFrendImId = got_Red_Vc_gorupId;
    }
    if((got_Red_Vc_userId.length <= 0 && got_Red_Vc_gorupId.length <= 0) || (got_Red_Vc_userId.length > 0 && got_Red_Vc_gorupId.length > 0)){// 都无数据 或 都有数据 则错误
        self.gotRedEnv_sendGroupOrFrendImId = @"";
        if(cZhiBoInfo.length > 0){
            //直播类型 允许抢
        }else{
            return;
            //其他类型
        }
     
    }
    [PopSendOrGetRedNoticeOfDataTool redEnvSnatchWithData:@{@"reUno":unoStr}.mutableCopy
                                                withBlock:^(NSDictionary * _Nonnull dicOfBlock, BOOL succes) {
        if(succes){
            
            //存储抢成功的数据 /是否领取过本红包时用来处理UI
            NSMutableArray *saveUnoArr = [[NSMutableArray alloc]initWithArray: [[NSUserDefaults standardUserDefaults] objectForKey:Chat_Got_RedEnv_SaveUnoIdKey]];
            [saveUnoArr addObject:unoStr];
            NSLog(@"抢到某个红包 保存本地");
            [[NSUserDefaults standardUserDefaults] setValue:saveUnoArr forKey:Chat_Got_RedEnv_SaveUnoIdKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            if(cZhiBoInfo){
                dispatch_async(dispatch_get_main_queue(), ^{
                    Y_SVP_SHOW_SUCCESS_MES(Y_LocaleTypeFile_NSLocalString(@"成功"));//@"抢红包成功"
                    self.saveThisZhiBoInfo_ZhuBoCreateRedEnvStr = @"";
                    Y_NSNotificationCenter_PostNotice_HaveObject_Name(Chat_Got_RedEnv_Notice_Result, unoStr);      //发送红包领取成功成功数据 该红包uno ID 其他红包可能还在 不能直接隐藏红包UI
                });
                return;
            }
            //抢红包成功的聊天信息
            [self doSendMessageOfGotRedEnvAction:dicOfBlock];
         
            
            
        }else{
            NSLog(@"抢红包 失败数据");
            
            if(cZhiBoInfo){
                NSLog(@"直播抢红包 失败");
                dispatch_async(dispatch_get_main_queue(), ^{
                    //Y_SVP_SHOW_INFO_MES_5Delay(Y_LocaleTypeFile_NSLocalString(@"获取失败"));
                    self.saveThisZhiBoInfo_ZhuBoCreateRedEnvStr = @"";
                    Y_NSNotificationCenter_PostNotice_HaveObject_Name(Chat_Got_RedEnv_Notice_Result_isFail, dicOfBlock);  //@"抢红包失败"
                    
                });
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_NSNotificationCenter_PostNotice_HaveObject_Name(Chat_Got_RedEnv_Notice_Result_isFail, dicOfBlock);//responsObject
            });
        }
    }];
}

#pragma mark == 点击二维码 跳转 二维码展示vc
- (void)chatGroupQR_ShowVcTool:(NSNotification *)notice{
    DLog(@"群二维码 跳转notice ---- noticeobject %@",notice.object);
    if(isNil(notice.object)){
        return;
    }else{//@[gID,gName,gImg]
        if([notice.object isKindOfClass:[NSArray class]]){
            NSArray *objArr = [NSArray arrayWithArray:notice.object];
            NSString *gID;
            NSString *gName;
            UIImage *gImg;
            UIViewController *willUsePushVc;
            if(objArr.count>=4){
                gID = objArr.firstObject;
                gName = objArr[1];
                gImg = objArr[2];
                willUsePushVc = objArr[3];
                [ChatGroupQRTool groupToolQrWithGroupID:gID withGroupImg:gImg withGroupName:gName withusePushVc:willUsePushVc];
            }else{
                gID = objArr.firstObject;
                gName = objArr[1];
                willUsePushVc = objArr[2];
                [ChatGroupQRTool groupToolQrWithGroupID:gID withGroupImg:gImg withGroupName:gName withusePushVc:willUsePushVc];
            }
        }else{
            DLog(@"");
        }
    }
}

#pragma mark === 扫码 二维码 跳转 进群或者申请加群vc
- (void)chatGroupQR_ScanActionTool:(NSNotification *)notice{
    DLog(@"群二维码 跳转notice ---- noticeobject %@",notice.object);
    if(isNil(notice.object)){
        return;
    }else{//gID
        if([notice.object isKindOfClass:[NSArray class]]){
            NSArray *gArr = [NSArray arrayWithArray:notice.object];
            NSString *gID = [NSString stringWithFormat:@"%@", gArr.firstObject];
            UIViewController *willUsePushVc;
            if(gArr.count>=2){
                willUsePushVc = gArr[1];
                GroupOfScanOk_DetailInfoVcOfApplingVc *vc = [[GroupOfScanOk_DetailInfoVcOfApplingVc alloc]init];
                vc.groupId = gID;
                vc.hidesBottomBarWhenPushed = YES;
                [willUsePushVc .navigationController pushViewController:vc animated:YES];
            }else{
                NSLog(@"加群跳转数据不符合规则");
            }
        }

    }
    
    
}


#pragma mark ===
//控制保活页显示隐藏
- (void)showOrHidenView:(NSNotification *)notce{
    DLog(@"控制保活页显示隐藏 ---- noticeobject %@",notce.object);
    
    //已经在项目内。在项目内界面才做显示隐藏  ； 在登录页出现状态 不做保活页的显示与隐藏
    if([[Y_ToolOfOthers toolGetKeyWindow].rootViewController isKindOfClass: [UITabBarController class]] || [[Y_ToolOfOthers toolGetKeyWindow].rootViewController isKindOfClass: [MainTabbarControll class]] ){
        //UITabBarController
        DLog(@"UITabBarController MainTabbarControll 继续走显示隐藏");
    }else{
        DLog(@"旧版登录页为rootvc时 不做保活页显示隐藏的处理");
        return;
    }
    if(!_baoHuoViews || !_bhvc){
        [self addBaoHuoWebV];
        DLog(@"控制保活页显示隐藏 addBaoHuoWebV %@",notce.object);
    }
  
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        BOOL isOrNotHiddenType =  [notce.object boolValue];
        if( isOrNotHiddenType ){
            NSLog(@"baoHuoViews 隐藏");
        }else{
            NSLog(@"baoHuoViews 显示");
            [self windowCheckBaoHuoView];
            self.baoHuoViews.frame = CGRectMake(0, 0, Screen_W, Screen_H);//位置
            //最顶上一层
            [self.baoHuoViews sendSubviewToBack:self.window.rootViewController.view];
        }
        self.baoHuoViews.hidden = isOrNotHiddenType;
    });
   
}

//直播时 点击头像 通知去某用户的粉友id持有页面
- (void)gotoImOneUserInfoVcNotice:(NSNotification *)notice{
    DLog(@"通知去某用户的粉友id持有页面 ");
    NSString *imStr =  @"";
    if(isNil(notice.object)){
        return;
    }else{
        if([notice.object isKindOfClass:[NSArray class]]){
            [IMGoChatOneUserInfoVcTool gotoImOneUserInfoViewControllerWithUserImId:imStr withOtherInfo:notice.object withusePushVc:self.window.rootViewController];
            
        }else{
            imStr = [NSString stringWithFormat:@"%@", notice.object];
            [IMGoChatOneUserInfoVcTool gotoImOneUserInfoViewControllerWithUserImId:imStr withOtherInfo:@[] withusePushVc:self.window.rootViewController];

        }
        
    }
   
}

- (void)addFriendPushUseVcNotice:(NSNotification *)notice{
    DLog(@"加好友的动作");
    NSString *imStr =  @"";
    if(isNil(notice.object)){
        return;
    }else{
        if([notice.object isKindOfClass:[NSArray class]]){
            [ChatAddFriendTool addOnePersonWithUserImId:imStr withOtherInfo:notice.object withusePushVc:self.window.rootViewController];
            
        }else{
            NSLog(@"传个id过来走加好友动作");
            imStr = [NSString stringWithFormat:@"%@", notice.object];
            [ChatAddFriendTool addOnePersonWithUserImId:imStr withOtherInfo:notice.object withusePushVc:self.window.rootViewController];
            
        }
        
    }
}

//- (BaoHuoWebView *)baoHuoWebView{
//    if(!_baoHuoWebView){
//        _baoHuoWebView = [[BaoHuoWebView alloc]initWithFrame:CGRectMake(0, KNavBarHeight, Screen_W, Screen_H-KNavBarHeight)];
//    }
//    return _baoHuoWebView;
//}

- (UIView *)baoHuoViews{
    if(!_baoHuoViews || !_bhvc){
        _bhvc = [[BaoHuoWebViewVc alloc]init];
        _bhvc.view.backgroundColor = [UIColor clearColor];
        _baoHuoViews = _bhvc.view;
        _baoHuoViews.tag = 9999;
        _baoHuoViews.frame = CGRectMake(0, 0, Screen_W, Screen_H);//位置
        NSLog(@" baoHuoViews ----  %@",_baoHuoViews);
        NSLog(@" _bhvc ----  %@",_bhvc);
    }
    return _baoHuoViews;
}

- (void)addBaoHuoWebV{
    
    if(!_baoHuoViews || !_bhvc){
        [self.window addSubview:self.baoHuoViews];//baoHuoViews 打底
        NSLog(@" addBaoHuoWebV  已增加");
        self.baoHuoViews.hidden = YES;//初始时隐藏 需要时显示
        [self anNotice];
    }else{
        NSLog(@" addBaoHuoWebV  已经有值 无需增加");
    
    }
    
}

//------  保活 webview


- (XuanFuView *)mainXuanFuView{
    if(!_mainXuanFuView){
        _mainXuanFuView = [[XuanFuView alloc]init];
        _mainXuanFuView.frame = CGRectMake(Screen_W-xuanFuView_Max_W-20, Screen_H-kTabBar_Height-xuanFuView_Max_H-20, xuanFuView_Max_W, xuanFuView_Max_H);//初始在屏幕上的位置
        _mainXuanFuView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.7];//Y_randomColor;
    }
    return _mainXuanFuView;
}

- (void)addXuanFuView{
    if (!_mainXuanFuView) {
        [self.window addSubview:self.mainXuanFuView];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:
                                       self action:@selector(locationChange:)];
        pan.delaysTouchesBegan = YES;
        [_mainXuanFuView addGestureRecognizer:pan];
        
        //        if([self.window.rootViewController.childViewControllers.firstObject isKindOfClass:[LoginViewController class]]){
        //            _mainXuanFuView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.7];
        //        }else{
        //            _mainXuanFuView.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.5];
        //        }
    }else{
        //        if([self.window.rootViewController.childViewControllers.firstObject isKindOfClass:[LoginViewController class]]){
        //            _mainXuanFuView.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.7];
        //        }else{
        //            _mainXuanFuView.backgroundColor = [[UIColor cyanColor] colorWithAlphaComponent:0.5];
        //        }
    }
}

//上下左右
-(void)locationChange:(UIPanGestureRecognizer*)p{
    CGFloat HEIGHT=_mainXuanFuView.frame.size.height;
    CGFloat WIDTH=_mainXuanFuView.frame.size.width;
    BOOL isOver = NO;
    CGPoint panPoint = [p locationInView:[UIApplication sharedApplication].windows[0]];
    CGRect frame = CGRectMake(panPoint.x, panPoint.y, HEIGHT, WIDTH);
    NSLog(@"%f--panPoint.x-%f-panPoint.y-", panPoint.x, panPoint.y);
    if(p.state == UIGestureRecognizerStateChanged){
        _mainXuanFuView.center = CGPointMake(panPoint.x, panPoint.y);
    }
    else if(p.state == UIGestureRecognizerStateEnded){
        if (panPoint.x + WIDTH > Screen_W) {
            frame.origin.x = Screen_W - WIDTH;
            isOver = YES;
        } else if (panPoint.y + HEIGHT > Screen_H) {
            frame.origin.y = Screen_H - HEIGHT;
            isOver = YES;
        } else if(panPoint.x - WIDTH / 2< 0) {
            frame.origin.x = 0;
            isOver = YES;
        } else if(panPoint.y - HEIGHT / 2 < 0) {
            frame.origin.y = 0;
            isOver = YES;
        }
        if (isOver) {
            [UIView animateWithDuration:0.3 animations:^{
                self.mainXuanFuView.frame = frame;
            }];
        }
    }
    
}


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    
    [self initWithShowScen];
    NSLog(@"====================================willConnectToSession");
    DLog(@"1 scene %@",scene);
    DLog(@"2 session %@  userInfo %@  configuration %@",session,session.userInfo,session.configuration);
    DLog(@"3 connectionOptions %@",connectionOptions);
    
    NSLog(@"==================================== ");
    UIWindowScene *windowScene = (UIWindowScene *)scene;
    self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
    self.window.frame = windowScene.coordinateSpace.bounds;
    self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;//浅色模式

    //主题色初始化
    [[ShareLocale shared] getNowThemeTypeStr];
    [[ShareLocale shared] saveNowThemeTypeStr: [ShareLocale shared].nowThemeStr];
    
    
    //语言初始
    [[ShareLocale shared] getNowLacaleTypeStr];//拿到当前语言
    //空的
    if([[ShareLocale shared].nowLocaleTypeStr isEqualToString:@""] ||  isNil([ShareLocale shared].nowLocaleTypeStr)){
        /**
         [[ShareLocale shared] saveNowLacaleTypeStr: Now_Locale_Type_zhHans];
         读取本机设置的语言列表，获取第一个语言，该方法读取的语言为：国际通用语言Code+国际通用国家地区代码，
         所以实际上想获取语言还需将国家地区代码剔除
         代码：
         */
        NSString *languageCode = [NSLocale preferredLanguages][0];// 返回的也是国际通用语言Code+国际通用国家地区代码
        NSString *countryCode = [NSString stringWithFormat:@"-%@", [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode]];
        if (languageCode) {
            languageCode = [languageCode stringByReplacingOccurrencesOfString:countryCode withString:@""];
        }
        NSLog(@"读取本机设置的语言列表 第一个languageCode 是 : %@", languageCode);
        [ShareLocale shared].nowLocaleTypeStr = languageCode;
    }
    //切换到没有对应设定语言时 转en
    if( ![[ShareLocale shared].nowLocaleTypeStr isEqualToString: Now_Locale_Type_en]
             && ![[ShareLocale shared].nowLocaleTypeStr isEqualToString: Now_Locale_Type_zhHans]
             && ![[ShareLocale shared].nowLocaleTypeStr isEqualToString: Now_Locale_Type_zhHant]
             && ![[ShareLocale shared].nowLocaleTypeStr isEqualToString: Now_Locale_Type_ja]
             && ![[ShareLocale shared].nowLocaleTypeStr isEqualToString: Now_Locale_Type_ko]){
        [[ShareLocale shared] saveNowLacaleTypeStr: Now_Locale_Type_en];
    //有对应设定语言时 保存设置
    }else{
        [[ShareLocale shared] saveNowLacaleTypeStr:  [ShareLocale shared].nowLocaleTypeStr ];
    }

    
    NSString *nowStr = [ShareLocale shared].nowLocaleTypeStr;
//    NSLog(@" ---语言初始 --  %@",nowStr);
//    NSLog(@"---- IM_userID %@",[ShareUserInfo share].userInfo.imId);
//    NSLog(@"---- IM_sig %@",[ShareUserInfo share].userInfo.imSignature );
//    NSLog(@"---- userInfo.token %@",[ShareUserInfo share].userInfo.token );
  
    //初始用户信息是否存在
    [[ShareUserInfo share] getDefaultsLoginUserInfo];
    
//    NSLog(@"---- IM_userID %@",[ShareUserInfo share].userInfo.imId);
//    NSLog(@"---- IM_sig %@",[ShareUserInfo share].userInfo.imSignature );
//    NSLog(@"---- userInfo.token %@",[ShareUserInfo share].userInfo.token );

    
    //悬浮按钮 保活页面
    //[self performSelector:@selector(addXuanFuView) withObject:nil afterDelay:2.0];
    [self performSelector:@selector(addBaoHuoWebV) withObject:nil afterDelay:0.2];
    /**0831 只加载头一次*/
    if(![[ShareLocale shared] get_Have_ShowLauncVc]){
        LauncViewController *launC =  [[LauncViewController alloc]init];
        launC.window = self.window;
        self.window.rootViewController  = launC;
        self.window.backgroundColor = [UIColor whiteColor];
        [self.window makeKeyAndVisible];
        [UIApplication sharedApplication].delegate.window = self.window;
        [[ShareLocale shared] save_Have_ShowLauncVc];
    }else{
        //直接到主页
        self.window.rootViewController  = [[MainTabbarControll alloc]init];//0831
        self.window.backgroundColor = [UIColor whiteColor];
        [self.window makeKeyAndVisible];
        [UIApplication sharedApplication].delegate.window = self.window;
    }
    
    

    
    
    [self addVoiceAndLiveNotice];

    
}

#pragma mark =====
//直播状态改变的通知
- (void)addVoiceAndLiveNotice{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        Y_NSNotificationCenter_Creat_NameAction(VoiceAndLiveNotice_ChangeActivity_Statu_Notice, changeZhiBoInfoNotice:)
        Y_NSNotificationCenter_Creat_NameAction(VoiceAndLiveNotice_ChangeActivity_Info_Notice, changeZhiboRoomNameNotice:)
    });
    
    
  
}

- (void)changeZhiBoInfoNotice:(NSNotification *)notice{

    NSLog(@" changeZhiBoInfoNotice %@ ",notice);
    NSLog(@" changeZhiBoInfoNotice object %@ ",notice.object);//block
    NSLog(@" changeZhiBoInfoNotice userInfo %@ ",notice.userInfo);//parm
    
    NSMutableDictionary *willUseParms = [NSMutableDictionary dictionaryWithDictionary:notice.userInfo];
    if([ShareUserInfo share].userInfo.address.length >0 ){
        [willUseParms setValue:[ShareUserInfo share].userInfo.address forKey:@"account"];
    }
    [ZhiBoBaseNetTools changeActivityStateParms:willUseParms withBlock:notice.object];
    
}
- (void)changeZhiboRoomNameNotice:(NSNotification *)notice{
    
    NSLog(@" changeZhiboRoomNameNotice %@ ",notice);
    NSLog(@" changeZhiboRoomNameNotice object %@ ",notice.object);//block
    NSLog(@" changeZhiboRoomNameNotice userInfo %@ ",notice.userInfo);//parm
    NSMutableDictionary *willUseParms = [NSMutableDictionary dictionaryWithDictionary:notice.userInfo];
    [ZhiBoBaseNetTools oneActivityInfoChangeWithParms:willUseParms withBlock:notice.object];
}



- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
    [[WalletSqlTools share] dbCloseAction];
}

#pragma mark == 抢红包
- (void)doSendMessageOfGotRedEnvAction:(NSDictionary *)successGotRedEnvDic{
    NSLog(@"抢红包  %@",successGotRedEnvDic);
    V2TIMMessage *sendMsg = [self gotedSuccessRedEnv_dealCustomMsg:successGotRedEnvDic];
    
    /** 发送信息 重复问题 ，只通知basevc发送 当前页不发*/
    /** 发送信息 抢红包信息 成功的聊天信息 群类型 不发*/
    
    if(self.gotRedEnv_isGroupInfo == NO){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            Y_NSNotificationCenter_PostNotice_HaveObject_Name(Chat_Got_RedEnv_Notice_Result, sendMsg);
        });
        
    }
    return;
    
    if(self.gotRedEnv_isGroupInfo == YES){
   
        NSString *groupID =  self.gotRedEnv_sendGroupOrFrendImId;
        [[V2TIMManager sharedInstance] sendMessage:sendMsg
                                          receiver:@""
                                           groupID:groupID
                                          priority:V2TIM_PRIORITY_DEFAULT
                                    onlineUserOnly:NO
                                   offlinePushInfo:nil
                                          progress:^(uint32_t progress) {
        } succ:^{
            NSLog(@"发送成功");
            //[TUITool makeToast:@"成功"];
            [TUITool makeToast: Y_LocaleTypeFile_NSLocalString(@"成功") ];

            dispatch_async(dispatch_get_main_queue(), ^{
                Y_NSNotificationCenter_PostNotice_HaveObject_Name(Chat_Got_RedEnv_Notice_Result, sendMsg);
            });
            

        } fail:^(int code, NSString *desc) {
            NSLog(@"code %d desc %@ ",code,desc);
            //= code 6017 desc receiver and groupID must set one
         }];
        
    }else{
        
        NSString *userId =  self.gotRedEnv_sendGroupOrFrendImId;
        [[V2TIMManager sharedInstance] sendMessage:sendMsg
                                          receiver:userId
                                           groupID:@""
                                          priority:V2TIM_PRIORITY_DEFAULT
                                    onlineUserOnly:NO
                                   offlinePushInfo:nil
                                          progress:^(uint32_t progress) {
        } succ:^{
            NSLog(@"发送成功");
            //[TUITool makeToast:@"成功"];
            [TUITool makeToast: Y_LocaleTypeFile_NSLocalString(@"成功") ];

            dispatch_async(dispatch_get_main_queue(), ^{
                Y_NSNotificationCenter_PostNotice_HaveObject_Name(Chat_Got_RedEnv_Notice_Result, sendMsg);
            });
            
            
        } fail:^(int code, NSString *desc) {
            NSLog(@"code %d desc %@ ",code,desc);
        }];
    }
    
    
}

- (V2TIMMessage *)gotedSuccessRedEnv_dealCustomMsg:(NSDictionary *)successGotRedEnvDic{
    V2TIMMessage *cusmessage;
    NSLog(@"gotedSuccessRedEnv_dealCustomMsg  == %@  ",successGotRedEnvDic);

    RedEvn_gotRecordDataModel *gotRenSuccessModel = [RedEvn_gotRecordDataModel mj_objectWithKeyValues:successGotRedEnvDic];
    //gotRenSuccessModel.redEnvelope;
    //NSArray *gotListArr =   [RedEvn_gotRecordArrObjModel mj_keyValuesArrayWithObjectArray:gotRenSuccessModel.gotRecord];
    NSArray *gotListArr =   [RedEvn_gotRecordArrObjModel mj_keyValuesArrayWithObjectArray:gotRenSuccessModel.gotRecord];
    NSLog(@"%@",gotListArr.firstObject);
    RedEvn_gotRecordArrObjModel *gModel = [RedEvn_gotRecordArrObjModel mj_objectWithKeyValues:gotListArr.firstObject];
    
    NSLog(@"gotedSuccessRedEnv_dealCustomMsg . imId %@  , address %@ ,gotAmount %@, domain %@",gModel.imId, gModel.address,gModel.gotAmount, gModel.domain);
    NSString *gModelFirstUserNameStr = (gModel.domain.length>0) ? gModel.domain : (gModel.username.length>0 ?  gModel.username : gModel.address);//优先级 域名 昵称 地址
 
    NSMutableDictionary *customDic = [[NSMutableDictionary alloc]init];
    [customDic setValue:@(GroupCreate_Version) forKey:@"version"];
    [customDic setValue:BussinessID_CUSTOM_RED_ENVELOPE_Tip forKey:BussinessID];//V2TIM_ELEM_TYPE_GROUP_TIPS
    [customDic setValue:@(3) forKey:@"type"];//
    [customDic setValue:successGotRedEnvDic forKey:@"data"];
    [customDic setValue:gModel.imId forKey:@"imId"];//"消息发送者imId",
    [customDic setValue:gModelFirstUserNameStr forKey:@"userName"];//"消息发送者imId",
    NSLog(@" gotedSuccessRedEnv_dealCustomMsg customDic %@", customDic);
    NSError *err;
    NSData *customData= [NSJSONSerialization dataWithJSONObject:customDic options:NSJSONWritingPrettyPrinted error:&err];
    if(err){
        NSLog(@"dealCustomMsg -- 失败");
        return cusmessage;
    }
    cusmessage =  [[V2TIMManager sharedInstance] createCustomMessage:customData];
    cusmessage.customElem.desc = [NSString stringWithFormat:@"%ld",Link_Type_RedEnv_3];//用于主页显示[自定义消息]的desc处理
    return cusmessage;
    
}

@end
