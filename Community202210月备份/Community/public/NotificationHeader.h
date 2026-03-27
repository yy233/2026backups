//
//  NotificationHeader.h
//  Community
//
//  Created by 余莹 on 2020/11/19.
//

#ifndef NotificationHeader_h
#define NotificationHeader_h
//改密码
#define NotificationName_ResetPassword_Finish     @"Notification_ResetPassword_Finish"
//主页
#define Notice_ChangeHouseWithChangeCommnityId_ToRefreshMainVcInfo_Name @"Notice_ChangeHouseWithChangeCommnityId_ToRefreshMainVcInfo_Name"
//业主登记
//#define Notice_Certifiction_MainUser_Add_Or_Edit_OK                     @"Notice_Certifiction_MainUser_Add_Or_Edit_OK"//20210225更改
#define Notice_Certifiction_MainUser_Add_Ok                               @"Notice_Certifiction_MainUser_Add_OK"
#define Notice_Certifiction_MainUser_Edit_OK                              @"Notice_Certifiction_MainUser_Edit_OK"
#define Notice_Certifiction_Famile_Add_Or_Edit_OK                         @"Notice_Certifiction_Famile_Add_Or_Edit_OK"
 
//访客--
#define GuestOneInfoAddSuccessWillRefreshListVc_Notice_Name             @"GuestOneInfoAddSuccessWillRefreshListVc_Notice_Name"
//访客--随行
#define GuestInfo_Add_Accompany_Person_Notice_Name                      @"GuestInfo_Add_Accompany_Person_Notice_Name"
#define GuestInfo_Add_Accompany_Car_Notice_Name                         @"GuestInfo_Add_Accompany_Car_Notice_Name"
#define GuestInfo_Add_Accompanu_UserInfo_Key_Person                     @"personUserInfo"
#define GuestInfo_Add_Accompanu_UserInfo_Key_Car                        @"carUserInfo"

//生活缴费
#define LifeCostPayChooseCompany_Notice_Name                            @"LifeCostPay_ChooseCompany_Notice_Name"
#define Notice_UserInfo_Key                              @"userInfo"

#define LifeCost_BillMark_Save_Notice_Name                             @"LifeCost_BillMark_Save_Notice_Name"
#define LifeCost_BillNote_Save_Notice_Name                              @"LifeCost_BillNote_Save_Notice_Name"

#define LifeCose_Group_ChooseOneGroup_Notice_Name                      @"LifeCose_Group_Choose_Notice_Name"


//房屋商铺 图片上传回调通知 命名
#define ShopBuniessPhotoAddEnd_Notice_Name                              @"ShopBuniessPhotoAddEnd_Notice_Name"
#define HousePhotoAddEnd_Notice_Name                                    @"HousePhotoAddEnd_Notice_Name"
//房屋商铺
#define ShopBuniessAddSuccess_Notice_Name                               @"ShopBuniessAddSuccess_Notice_Name"

//支付相关
#define PaySuccessedEndInfo_Notice_Name                                 @"PaySuccessEndInfo_Notice_Name"
#define PayFailEndInfo_Notice_Name                                      @"PayFailEndInfo_Notice_Name"
//
#define Pay_Success_OrderNum_Key                                        @"Pay_Success_OrderNum_Key"
#define Pay_Success_PayType_Key                                         @"Pay_Success_PayTpye_Key"
#define Pay_Fail__Key                                                   @"Pay_Fail__Key"

//个人中心
#define PersonInfo_Change_Notice                                        @"PersonInfo_Change_Notice"

//仓储小店
#define Notice_SmallShopCarCreatOrderChangeOtherThings                  @"Notice_SmallShopCarCreatOrderChangeOtherThings"
//养老 设备 模块
#define HistoryDeletConnectDevNoticeName                                @"HistoryDeletConnectDevNoticeName"



//________ 商城部分

//购买前选择了一个地址
#define Buniess_willPay_To_ChooseAddress                                @"Buniess_willPay_To_ChooseAddress"

//个人中心 订单被评价等状况 需要更新list的数据Notice
#define Buniess_PopToListVC_WithReloadList                               @"Buniess_PopToListVC_WithReloadList"

  
//________ 聊天部分_ websocket收到的数据分类后的noticeName
//---------------------------------------------------------------------
#define kWebSocketdidReceiveMessage_NoticeName_ChatMsg_ReadedInfo        @"kWebSocketdidReceiveMessage_NoticeName_ChatMsg_ReadedInfo"        //已读回执信息 在当前匹配的sessionID 则更新对应的UI从未读 数据刷新为 已读 20220325
#define kWebSocketdidReceiveMessage_NoticeName_ChatMsg                   @"kWebSocketdidReceiveMessage_NoticeName_ChatMsg"        //仅仅是聊天类型数据数据（多种chat类型）
#define kWebSocketdidReceiveMessage_NoticeName_Revoke_ChatMsg            @"kWebSocketdidReceiveMessage_NoticeName_Revoke_ChatMsg" //聊天类型数据 撤回信息
#define kWebSocketdidReceiveMessage_NoticeName_Group_MemberAdd           @"kWebSocketMsgTypeObj_group_member_add"                 // 群成员 新增
#define kWebSocketdidReceiveMessage_NoticeName_ChatMsgResponse_SendOk    @"kWebSocketdidReceiveMessage_NoticeName_ChatMsgResponse_SendOk"      //服务器已到该信息 且发送成功
#define kWebSocketdidReceiveMessage_NoticeName_ChatMsgResponse_SendFail  @"kWebSocketdidReceiveMessage_NoticeName_ChatMsgResponse_SendFail"      //服务器已到该信息 且发送失败

//好友相关数据类型
#define kWebSocketdidReceiveMessage_NoticeName_Have_NewAddFriendReq       @"kWebSocketdidReceiveMessage_NoticeName_Have_NewAddFriendReq"     //新的好友 请求
#define kWebSocketdidReceiveMessage_NoticeName_Friend_AddIsSuccess        @"kWebSocketdidReceiveMessage_NoticeName_Friend_AddIsSuccess"    //新增好友成功 通知
#define kWebSocketdidReceiveMessage_NoticeName_Friend_AddIsRej            @"kWebSocketdidReceiveMessage_NoticeName_Friend_AddIsRej"      //新增好友失败 被拒绝通知

//聊天非聊天msg的类型
#define ChatVcChangeBackImg_NoticeName                                    @"ChatVcChangeBackImg_NoticeName"      //聊天界面的背景图更换通知

//聊天删除好友的通知
#define ChatDeletFriend_NoticeName                                        @"ChatDeletFriend_NoticeName"

//好友备注设置修改的通知
#define ChatSetFriendRemarkName_NoticeName                                @"ChatSetFriendRemarkName_NoticeName"

//群成员新增的通知_主动添加删除的群成员
#define ChatGroupAddOrDeletMember_NoticeName                              @"ChatGroupAddOrDeletMember_NoticeName"                 // 群成员 新增 ｜踢人 主UI数据的通知

//语音数据动画的处理声音完结后or停止的通知 带obj音频文件uuID
#define ChatVoicePalyingEnd_NoticeName                                     @"ChatVoicePalyEnd_NoticeName"
//语音在各个主动停止的清空下 通知manager .(mananger自行在对应响应内用ChatVoicePalyingEnd_NoticeName通知cell)
#define NoticeName_TakeInitiativeToStopVoice                               @"TakeInitiativeToStopVoice"

#define NoticeName_WxPayBackH5Type                                         @"H5WxPayBack_NoticeName"            //光大银行调用微信支付后 回到app的通知名字

#endif /* NotificationHeader_h */
