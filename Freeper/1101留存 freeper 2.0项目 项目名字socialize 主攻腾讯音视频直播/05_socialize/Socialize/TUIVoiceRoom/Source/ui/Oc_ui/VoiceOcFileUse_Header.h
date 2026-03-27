//
//  VoiceOcFileUse_Header.h
//  Pods
//
//  Created by 余莹 on 2023/5/31.
//

#ifndef VoiceOcFileUse_Header_h
#define VoiceOcFileUse_Header_h

#define podUse_rgba(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]



#define BussinessID_CUSTOM_SHARE               @"text_share"
#define BussinessID_CUSTOM_RED_ENVELOPE        @"red_envelope"//红包0912
#define BussinessID_CUSTOM_RED_ENVELOPE_Tip    @"red_envelope_tip"//抢红包

//聊天的
#define Cell_CUSTOM_RedEnv                     @"TUIRedEnvelopeCell_Minimalist"
#define Cell_Data_CUSTOM_RedEnv                @"TUIRedEnvelopeCellData_Minimalist"

#define BussinessID_CUSTOM_SHARE               @"text_share"
#define BussinessID_CUSTOM_RED_ENVELOPE        @"red_envelope"//红包0912
#define BussinessID_CUSTOM_RED_ENVELOPE_Tip    @"red_envelope_tip"//抢红包




//直播的

#define BussinessID_ZhiBo_CUSTOM_onAnchorSendRedEnvelope      @"onAnchorSendRedEnvelope"//主播给观众红包0922 发红包.(主播或管理员发红包给观众， 所有人 （左上角 红包位置 点击后才抢）)
#define BussinessID_ZhiBo_CUSTOM_onAudienceSendRedEnvelope    @"onAudienceSendRedEnvelope"//打赏.(观众给主播发红包， 主播自动接收 UI后调)
#define BussinessID_ZhiBo_CUSTOM_onSendGifts                  @"onSendGifts"//打赏.(观众给主播发礼物， 主播自动接收 UI炫酷类型后调)


#define Green_main_Color                RGBA(61, 240, 240, 1)
#define Color_White248                  RGBA(248, 248, 248, 1)
#define Color_Black51                   RGBA(51, 51, 51, 1)
#define Color_Gray121                    RGBA(121, 125, 130, 1)
#define Color_Gray153                    RGBA(153, 153, 153, 1)

#define TextColor_Yollow          [UIColor colorWithRed:255/255.0 green:248/255.0 blue:203/255.0 alpha:1.0]
#define TextColor_Yollow_light    [UIColor colorWithRed:255/255.0 green:248/255.0 blue:203/255.0 alpha:0.4]
#define BkColor_Red_ImgBk         [UIColor colorWithRed:205/255.0 green:79/255.0 blue:75/255.0 alpha:1.0]



/**
 * 创建群自定义消息业务版本
 * The business version of "Group-creating custom message"
 */
#define GroupCreate_Version 4
/** 屏幕宽高*/

#define Screen_W             [UIScreen mainScreen].bounds.size.width
#define Screen_H             [UIScreen mainScreen].bounds.size.height
/////////////////////////////////////////////////////////////////////////////////
#define Screen_Width        [UIScreen mainScreen].bounds.size.width
#define Screen_Height       [UIScreen mainScreen].bounds.size.height
//#define Is_Iphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//#define Is_IPhoneX (Screen_Width >=375.0f && Screen_Height >=812.0f && Is_Iphone)
#define Is_IPhoneXX (Screen_Width >=375.0f && Screen_Height >=812.0f)
#define KNavBarHeight        (Is_IPhoneXX ? (88.0):(64.0))          /** 导航栏高度 */
#define kStatusBar_Height    (Is_IPhoneXX ? (44.0):(20.0))          /** 状态栏高度 */
#define kTabBar_Height       (Is_IPhoneXX ? (49.0 + 34.0):(49.0))   /** 标签栏高度 */
#define kBottom_SafeHeight   (Is_IPhoneXX ? (34.0):(0))             /** 底部横条高度 */
#define Bottom_SafeHeight   (Is_IPhoneXX ? (34.0):(0))             /** 底部横条高度 */

#define StatusBar_Height    (Is_IPhoneXX ? (44.0):(20.0))
#define TabBar_Height       (Is_IPhoneXX ? (49.0 + 34.0):(49.0))
#define NavBar_Height       (44)
#define SearchBar_Height    (55)


#define kRGBA(r, g, b, a)    [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]
#define kRGB(r, g, b)    [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.f]
#define kkScale390(x) (x * (UIScreen.mainScreen.bounds.size.width / 390.0))

#define RGBA(r, g, b, a)    [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]
#define RGB(r, g, b)    [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.f]
#define kScale390(x) (x * (UIScreen.mainScreen.bounds.size.width / 390.0))

/////////////////////////////////////////////////////////////////////////////////
///
///

#endif /* VoiceOcFileUse_Header_h */
