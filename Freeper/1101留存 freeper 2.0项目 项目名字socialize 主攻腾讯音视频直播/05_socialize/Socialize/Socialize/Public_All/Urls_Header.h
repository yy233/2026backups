//
//  Urls_Header.h
//  Socialize
//
//  Created by 余莹 on 2023/5/25.
 
#ifndef Urls_Header_h
#define Urls_Header_h


#define   WebCenterUrlUseStr    @"/#"


#import "Url_OtherTool.h"

//prod
/**
 接口：https://v2api.freeper.io
 文件：https://v1source.freeper.io
 市场：https://market.freeper.io/#/
 钱包:https://wallet.freeper.io/#/
 */
//---------
/**
 #if (type_urlset_now == type_url_prod)
 #define  URL_Main_URL_Prefix                                                @"https://v2api.freeper.io"                       //接口
 #define  URL_FileUpLoad_URL_Prefix                                          @"https://v1source.freeper.io"                       //文件上传
 #define  WebVc_Base_URL                                                     @"https://market.freeper.io/#"
 #define  WebVc_Base_walletUse_URL                                           @"https://wallet.freeper.io/#"  //钱包
 #define  WebView_LoginView_Url                                              [NSString stringWithFormat:@"%@%@",WebVc_Base_walletUse_URL,@"/pages/index"] //登录
 #define  LoginUseParm_ChanID                56
 #define  LoginUseParm_BaseUrl                                               URL_Main_URL_Prefix    //如果mesg空则必须传入本数据 ，有msg可以不传*/
//---------
//#if (type_urlset_now == type_url_prod)
//#define  URL_Main_URL_Prefix                                                @"https://fne6e0-api.freeper.cc"                       //接口
//#define  URL_FileUpLoad_URL_Prefix                                          @"https://un93kdk-source.freeper.cc"                       //文件上传
//#define  WebVc_Base_URL                                                     @"https://ss8ckke-market.freeper.cc/#"
//#define  WebVc_Base_walletUse_URL                                           @"https://xhheuhw-wallet.freeper.cc/#"  //钱包
//#define  WebView_LoginView_Url                                              [NSString stringWithFormat:@"%@%@",WebVc_Base_walletUse_URL,@"/pages/index"] //登录
//#define  LoginUseParm_ChanID                56
//#define  LoginUseParm_BaseUrl                                               URL_Main_URL_Prefix    //如果mesg空则必须传入本数据 ，有msg可以不传

 
//---------
#if (type_urlset_now == type_url_prod)
#define  URL_Main_URL_Prefix                                                [Url_OtherTool getNewUrlNeedInterRandStrWithAllUrl:@"https://%@-api.freeper.cc"]                        //接口
#define  URL_FileUpLoad_URL_Prefix                                          [Url_OtherTool getNewUrlNeedInterRandStrWithAllUrl:@"https://%@-source.freeper.cc"]                        //文件上传
#define  WebVc_Base_URL                                                     [Url_OtherTool getNewUrlNeedInterRandStrWithAllUrl:@"https://%@-market.freeper.cc/#"]
#define  WebVc_Base_walletUse_URL                                           [Url_OtherTool getNewUrlNeedInterRandStrWithAllUrl:@"https://%@-wallet.freeper.cc/#"]   //钱包
#define  WebView_LoginView_Url                                              [NSString stringWithFormat:@"%@%@",WebVc_Base_walletUse_URL,@"/pages/index"] //登录
#define  LoginUseParm_ChanID                56
#define  LoginUseParm_BaseUrl                                               URL_Main_URL_Prefix    //如果mesg空则必须传入本数据 ，有msg可以不传
//---------
//外网 test
#elif (type_urlset_now == type_url_test)
#define  URL_Main_URL_Prefix                                                @"https://test.freeper.l-z.vip:61125"               //接口
#define  URL_FileUpLoad_URL_Prefix                                          @"https://test.freeper.l-z.vip:61131"               //文件上传
#define  WebVc_Base_URL                                                     @"https://test.freeper.l-z.vip:61133/index.html#"   //web其他
#define  WebVc_Base_walletUse_URL                                           @"https://test.freeper.l-z.vip:61129/index.html#"   //钱包
#define  WebView_LoginView_Url                                              [NSString stringWithFormat:@"%@%@",WebVc_Base_walletUse_URL,@"/pages/index"]//登录
#define  LoginUseParm_ChanID                97
#define  LoginUseParm_BaseUrl                                                URL_Main_URL_Prefix


//dufeng ip 1993x
#elif (type_urlset_now == type_url_dev)
#define  URL_Main_URL_Prefix                                                @"http://192.168.12.122:12200"
#define  URL_FileUpLoad_URL_Prefix                                          @"https://test.freeper.l-z.vip:61131"               //文件上传
#define  WebVc_Base_URL                                                     @"http://192.168.12.129:5173"
#define  WebVc_Base_walletUse_URL                                           @"http://192.168.12.129:19936" //测试环境
#define  WebView_LoginView_Url                                              [NSString stringWithFormat:@"%@%@",WebVc_Base_walletUse_URL,@"/#pages/index"]
#define  LoginUseParm_ChanID                97

#define  LoginUseParm_BaseUrl                                                 URL_Main_URL_Prefix


//dufeng ip。 517x
//#elif (type_urlset_now == type_url_test_dufeng)
//#define  URL_Main_URL_Prefix                                                @"http://192.168.12.122:12200"
//#define  URL_FileUpLoad_URL_Prefix                                          @"https://test.freeper.l-z.vip:61131"               //文件上传
//#define  WebVc_Base_URL                                                     @"http://192.168.2.49:5173"
//#define  WebVc_Base_walletUse_URL                                           @"http://192.168.2.49:5174" //开发环境
////#define  WebView_LoginView_Url                                              [NSString stringWithFormat:@"%@%@",WebVc_Base_walletUse_URL,@"/#pages/index"]
//#define  WebView_LoginView_Url                                              [NSString stringWithFormat:@"%@%@",WebVc_Base_walletUse_URL,@"/#/pages/index"]
//
//#define  LoginUseParm_ChanID                97
//#define  LoginUseParm_BaseUrl                                                 URL_Main_URL_Prefix

#elif (type_urlset_now == type_url_test_dufeng)
//#define  URL_Main_URL_Prefix                                                @"http://192.168.12.107:12200"
#define  URL_Main_URL_Prefix                                                @"https://fne6e0-api.freeper.cc"                       //接口
#define  URL_FileUpLoad_URL_Prefix                                          @"https://test.freeper.l-z.vip:61131"               //文件上传
#define  WebVc_Base_URL                                                     @"http://192.168.12.129:5173"
#define  WebVc_Base_walletUse_URL                                           @"http://192.168.12.129:5174" //开发环境
#define  WebView_LoginView_Url                                              [NSString stringWithFormat:@"%@%@",WebVc_Base_walletUse_URL,@"/#/pages/index"]

#define  LoginUseParm_ChanID                97
#define  LoginUseParm_BaseUrl                                                 URL_Main_URL_Prefix




//其他
#else
#define  URL_Main_URL_Prefix                                                @"https"
#define  URL_FileUpLoad_URL_Prefix                                          @"https"
#define  WebVc_Base_URL                                                     @"http"
#define  WebView_LoginView_Url                                              WebVc_Base_URL
#define  LoginUseParm_ChanID                56
#define  LoginUseParm_BaseUrl                                              URL_Main_URL_Prefix   //如果mesg空则必须传入本数据 ，有msg可以不传



#endif


//总url
#define  Y_AllURL_Main(_URL)                                                [NSString stringWithFormat:@"%@%@", URL_Main_URL_Prefix, _URL]
#define  Y_AllURL_FileUpLoad(_URL)                                          [NSString stringWithFormat:@"%@%@", URL_FileUpLoad_URL_Prefix, _URL]

#import "Y_NetWorkBaseTool.h"




#endif /* Urls_Header_h */
