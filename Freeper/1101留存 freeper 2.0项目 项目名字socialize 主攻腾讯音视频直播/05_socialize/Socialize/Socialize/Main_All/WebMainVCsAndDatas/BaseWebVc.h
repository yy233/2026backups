//
//  BaseWebVc.h
//  Socialize
//
//  Created by 余莹 on 2023/6/6.
//


#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "WebViewUseDataModel.h"
#import "WebVcsTool.h"
#import "SqlUseResReqWebDataTool.h"
#import "NftModels.h"


NS_ASSUME_NONNULL_BEGIN

static NSString *kOCGetJsInfoFunction = @"OcGetJsInfoFunction";
static NSString *kOcSendToJsFunction_methodRouter = @"methodRouter";
static NSString *kOcSendToJsFunction_setUserInfoData = @"setUserInfoData";
static NSString *kOcSendToJsFunction_setDappRecord = @"setDappRecord";
//市场 通信 接口名称apiCall 更改marketApiCall
static NSString *kOcSendToJsFunction_apiCall = @"apiCall";
static NSString *kOcSendToJsFunction_marketApiCall = @"marketApiCall";
static NSString *kOcGetJsInfoFunction_actionType = @"actionType"; //数字类型的

#pragma mark -----
//显示隐藏web窗口口
static NSString *kOCGetJsInfoFunction_Sub_Method_showWaletPage = @"showWalletPage";
static NSString *kOCGetJsInfoFunction_Sub_Method_closeWaletPage = @"closeWalletPage";
static NSString *kOCGetJsInfoFunction_Sub_Method_hideWaletPage = @"hideWalletPage";
//钱包解密加载完成
static NSString *kOCGetJsInfoFunction_Sub_Method_walletLoadFinished = @"walletLoadFinished";
//登录触发相关红包相关
static NSString *kOCSendRedEnvUseFunction_Sub_Method_personalSign = @"personalSign";
static NSString *kOCGetJsInfoFunction_Sub_Method_personalSign = @"personalSign";
static NSString *kLoginRqpersonalSignInfo_Sub_Mothod_login = @"login";
//sql执行
static NSString *kOCGetJsInfoFunction_Sub_Method_executeSqlObj = @"executeSql";
//心跳执行相关
static NSString *kOCGetJsInfoFunction_Sub_Method_pong = @"pong";     //拿到的
static NSString *kOcSendToJsFunction_apiCall_methodObj_Ping = @"ping";//回复的
//二维码相关
static NSString *kOCGetJsInfoFunction_Sub_Method_sacnQR = @"scanQR";
//钱包跳转 换成指令拉起保活界面
static NSString *kOcSendToJsFunction_apiCall_methodObj_goWalletPage = @"goWalletPage";
//保活页面颜色处理
static NSString *kOCGetJsInfoFunction_Sub_Method_pageChanged = @"pageChanged";
//设置语言设置主题
static NSString *kOcSendToJsFunction_apiCall_methodObj_setTheme = @"setTheme";
static NSString *kOcSendToJsFunction_apiCall_methodObj_setLangue = @"setLocale";



static NSString *GetInfoType_Dapp_refer = @"DAPP";
static NSString *GetInfoType_Wallet_To = @"WALLET";
static NSString *GetInfoType_Dapp_To = @"DAPP";
static NSString *GetInfoType_Wallet_refer = @"WALLET";

//dapp相关 Dapp通讯转发
static NSString *kOCGetJsInfoFunction_Sub_DappAndWallet_ethRequestAccounts = @"eth_requestAccounts";
static NSString *kOCGetJsInfoFunction_Sub_DappAndWallet_switchEthereumChain  = @"wallet_switchEthereumChain";

#pragma mark -----
typedef enum : NSUInteger {
    kOcGetJs_TypeNum_1000_BackAction        = 1000,
    kOcGetJs_TypeNum_1001_SetLanguage       = 1001,
    kOcGetJs_TypeNum_1002_LoadFinish        = 1002,
    kOcGetJs_TypeNum_1003_SetUserInfoOk     = 1003,
    kOcGetJs_TypeNum_1004_OpenDapp          = 1004,
    kOcGetJs_TypeNum_1005_NowPage           = 1005,
    kOcGetJs_TypeNum_1006_OpenZhiBo         = 1006,
    kOcGetJs_TypeNum_1007_SetZhuTi          = 1007, //主题
    kOcGetJs_TypeNum_1008_LoginPopViewShow  = 1008,
    kOcGetJs_TypeNum_1009_LogoutAction      = 1009,
    kOcGetJs_TypeNum_1010_OpenWalletMainVc  = 1010,
    kOcGetJs_TypeNum_1011_OpenShare         = 1011,
    kOcGetJs_TypeNum_1012_ScanQR            = 1012,
    kOcGetJs_TypeNum_1013_ChangeUserHeaderImg  = 1013,
    kOcGetJs_TypeNum_1014_ChangeUserNick    = 1014,
    kOcGetJs_TypeNum_1015_ChangeUserIntro   = 1015,
    kOcGetJs_TypeNum_1016_GoSiXin           = 1016,
    kOcGetJs_TypeNum_1017_GoGroupChat       = 1017,
    kOcGetJs_TypeNum_1020_NeedBackVersionNum = 1020,
    kOcGetJs_TypeNum_1104_userInfoCheckAndLoginOrSendUserInfoData = 1104,

} kOcGetJs_TypeNum;


#pragma mark -----
//设置访问的dapp记录
static NSString *kSub_Method_SetDappRecord = @"setDappRecord";




#define  PopWebView_Tag    (728)

#define WebView_Theme_Change_NoticeName                                        @"WebView_Theme_Change_NoticeName"
#define NociceName_WindowSubBaoHUOWebView_ShowOrHidden                          @"NociceName_WindowSubBaoHUOWebView_ShowOrHidden"
#define NociceName_WindowSubBaoHUOWebView_ShowAndNeedSendSigWithDoLoginAction   @"NociceName_WindowSubBaoHUOWebView_ShowAndNeedSendSigWithDoLoginAction"

#define NociceName_DappSendToWallet  @"NociceName_DappSendToWallet"
#define NociceName_WalletSendToDapp  @"NociceName_WalletSendToDapp"


@interface BaseWebVc : Y_BaseViewController
@property (nonatomic,strong) WKWebView *webView;
@property (nonatomic,strong) NSString *thisVcUseUrlStr;
@property (nonatomic,assign) NSInteger agreeLoadNum;
@property (nonatomic,assign) BOOL walletLoadFinishedBool;
//dapp所需的数据中转view
@property (nonatomic,strong) WKWebView *popWebView;
- (void)initData;
/*
 * 判断是否白屏(WKCompositingView不存在)
 * YES：blank
 */
- (BOOL)isBlankView:(UIView*)view;


@property (nonatomic,assign) BOOL isGoSubVcDontDealTabbarsHidenOrShow; //触发状态 不处理显示隐藏


@end

NS_ASSUME_NONNULL_END
