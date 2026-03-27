//
//  SceneDelegate.h
//  Socialize
//
//  Created by 余莹 on 2023/5/10.
//

#import <UIKit/UIKit.h>
#import "XuanFuView.h"
//保活页显示隐藏 + 显示主题变化
#define NociceName_WindowSubBaoHUOWebView_ShowOrHidden  @"NociceName_WindowSubBaoHUOWebView_ShowOrHidden"
#define WebView_Theme_Change_NoticeName  @"WebView_Theme_Change_NoticeName"


//触发接口 去获取我钱包币种列表
#define Chat_Get_Wallet_List_Notice     @"Chat_Get_Wallet_List_Notice"
//接口数据拿到后 触发需要币种列表的通知
#define Chat_Get_Wallet_List_Notice_Result     @"Chat_Get_Wallet_List_Notice_Result_Notice"
//查询当前用户 余额信息 的通知
#define Chat_Get_myBalanceInfo                 @"Chat_Get_myBalanceInfo"
//跳转去充值提现web
#define NoticeName_gotoMyChongZhiTIXianWebVc   @"NoticeName_gotoMyChongZhiTIXianWebVc"

//创建红包相关msg OK
#define Chat_RedEnv_CreatMsg_WillSend_Notice    @"Chat_RedEnv_CreatMsg_WillSend_Notice"
//红包数据调取web后，web的到信息发送过来 继续走创建红包接口的通知
#define RedEnv_OnWebVc_SignGeted_Notice        @"RedEnv_OnWebVc_SignGeted_Notice"

//红包创建  //打赏主播 等都在此
#define Chat_Create_RedEnv_Notice              @"Chat_Create_RedEnv_Notice"
#define CreateSubDataType_ZhiBoInfoKey         @"ZhiBoInfo" //接收到直播内的创建红包动作时 直播间的信息key 直播间抢红包时也用到


//抢红包
#define Chat_Got_RedEnv_Notice                 @"Chat_Got_RedEnv_Notice"
#define Chat_Got_RedEnv_Notice_Result          @"Chat_Got_RedEnv_Notice_Result"
#define Chat_Got_RedEnv_Notice_Result_isFail   @"Chat_Got_RedEnv_Notice_Result_isFail"
#define Chat_Got_RedEnv_SaveUnoIdKey           @"Save_Got_RedEnv_Uno" //保存自己抢过的红包ID 用于cell展示时的类型处理


//分享 直播分享到聊天，聊天会话 做的会话弹出处理动作 x
//一个是分享用 调起界面的 通知
//一个时聊天cell点击直播活动cell 的通知。（ 需要调用报名接口 并且跳转到播出页面 （观众去看直播，主播则开播提示去开启直播 swift通知页去做））
#define Notice_Name_Chat_ActivityAction_NowIsZhiBoJoin_WillShowShareTool     @"Notice_Name_Chat_ActivityAction_NowIsZhiBoJoin_WillShowShareTool" //一个是分享用 调起界面的 通知
#define Notice_Name_Chat_ActivityAction_ZhiBoJoinActiveOrKaiBoTool          @"Notice_Name_Chat_ActivityAction_ZhiBoJoinActiveOrKaiBoTool"


//直播里跳转聊天会话
#define Notice_Name_zhiBoGoToChatWithOnTheAir   @"Notice_Name_zhiBoGoToChatWithOnTheAir"

@interface SceneDelegate : UIResponder <UIWindowSceneDelegate>

@property (strong, nonatomic) UIWindow * window;
@property (strong, nonatomic) XuanFuView *mainXuanFuView;
@property (strong, nonatomic) UIView *baoHuoViews;

//iOS13以上 window 的 windowScene 属性无值，需要手动赋值
- (void)addNoticeAndBaoHuoViewsWithwindowScene:(UIWindowScene *)windowScene;
@end

