//
//  WebVcsTool.h
//  Socialize
//
//  Created by 余莹 on 2023/6/6.
//

#import <Foundation/Foundation.h>

//市场//推荐
#define   ShiChang_VC_Url      WebVc_Base_URL
#define   TuiJian_VC_Url       WebVc_Base_URL
#define   TuiJian_VC__1005Use_Url_Sufx_Index  @"/pages/index/index"
//发现

#define   FaXian_VC_Url_Sufx_Index  @"/pages/discover/discover"

//我的
#define   WoDe_VC_Url_Sufx_Index    @"/pages/user/index"

//语言切换通知
#define  WebView_Langeuge_Change_NoticeName                                    @"WebView_Langeuge_Change_NoticeName"

//主题切换通知
#define  WebView_Theme_Change_NoticeName                                    @"WebView_Theme_Change_NoticeName"
//dapp
#define  WebView_SubDapp_LoadFinishOkSendInfoOf_History_NoticeName             @"WebView_SubDapp_LoadFinishOkSendInfoOf_History_NoticeName"
#define  WebView_SubDapp_SouCangeInfo_Change_NoticeName                        @"WebView_SubDapp_SouCangeInfo_Change_NoticeName"
#define  WebView_SubDapp_PopWebView_GetDataWillSendDataPanDingKey   @"fw@forward"
#define  WebView_SubDapp_PopWebView_GetDataWillSendDataGetRequestPanDingKey   @"fw@forward/request"


#define  WebView_SubDapp_DataInfo_NoticeName             @"WebView_SubDapp_DataInfo_NoticeName"


#define  WebView_NavUse_PurpleColor      rgba(71, 51 , 235, 1)


NS_ASSUME_NONNULL_BEGIN

@interface WebVcsTool : NSObject

+ (NSString *)getWebUrlLocaleStr;
+ (NSString *)getWebUrlLocaleStrNotRandomstr;

@end

NS_ASSUME_NONNULL_END
