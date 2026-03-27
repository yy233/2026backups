//
//  UrlAndOtherHeader.h
//  Community
//
//  Created by 余莹 on 2020/11/12.
//

#ifndef UrlAndOtherHeader_h
#define UrlAndOtherHeader_h

#ifdef __OBJC__
/**登录相关*/
#define URL_USER_LOGIN                                                      @"proprietor/user/auth/login"
#define URL_USER_SEND_CODE                                                  @"proprietor/user/auth/send/code"
//注册 +设置初始密码 20211201两个混成一个界面 两个接口所需数据只走一次注册接口
#define URL_USER_REGISTER                                                   @"proprietor/user/auth/register"
#define URL_USER_SET_PASSWORD                                               @"proprietor/user/auth/password"

#define URL_USER_RESET_PASSWORD                                             @"proprietor/user/auth/reset/password"
#define URL_USER_FORGET_PASSWORD_CODE_CHECK                                 @"proprietor/user/auth/check/code" //token --- authToken 键值变了一下

/** 更新极光设备*/
#define URL_PUT_JG_regId                                                     @"proprietor/user/regId"  //更新极光推送设备id(regId)  PUT
/**主页相关*/
#define URL_MAIN_BANNER_LIST                                                 @"proprietor/banner/list" //顶部轮播图
#define URL_MAIN_URGENT_MESSAGE                                              @"proprietor/community/inform/page" //紧急消息
#define URL_MAIN_TOP_MESSAGE                                                 @"proprietor/inform/totalList"//顶部消息按钮的总社区消息区
#define URL_MAIN_TopOrUregent_MESSAGE_DETAIL_INFO                            @"proprietor/community/inform/details" //某一社区某一信息详情
#define URL_MAIN_MENU_LIST                                                   @"proprietor/menu/listIndexMenu"//主页菜单list
#define URL_MORE_MENU                                                        @"proprietor/menu/moreListMenu" //菜单更多
#define URL_MAIN_MENU_LIST_V2                                                @"proprietor/menu/listIndexMenu/v2"//主页菜单list 0816新
#define URL_MORE_MENU_V2                                                     @"proprietor/menu/moreListMenu/v2"//主页更多菜单 0914新

#define URL_MAIN_ADDRESS_BOOK_ALL_LIST                                       @"proprietor/department/listDepartment"  //查询所有部门信息
#define URL_MAIN_ADDRESS_BOOK_DETAILS_PHONE                                  @"proprietor/department/listStaffPhone" //根据部门查询联系方式
//主页--社区趣事
#define URL_Community_Fun_FindList                                           @"proprietor/communityfun/findList" //社区趣事
#define URL_Community_Fun_findFunDetail                                      @"proprietor/communityfun/findFunOne" //社区趣事
/**主页sub相关*/
//城市相关
#define URL_MAIN_CHOOSE_CITY                                                 @"proprietor/common/region" //城市list
//#define URL_MAIN_CHOOSE_COMMUNITY                                          @"proprietor/common/community" //社区相关list
#define URL_MAIN_CHOOSE_COMMUNITY                                            @"proprietor/common/community2" //社区相关list test
#define URL_MAIN_CHOOSE_COMMUNITY_DoorList                                   @"proprietor/common/getHouse" //房屋层级_门牌
#define URL_MAIN_CHOOSE_COMMUNITY_SEARCH                                     @"proprietor/community" //社区相关list 模糊查询
#define URL_MAIN_CHOOSE_COMMUNITY_SEARCH_USE_LON_LAT                         @"proprietor/community/locate" //距离最近的社区查询 用经纬度

//业主认证相关
#define URL_GuestInfoReistion_List                                           @"proprietor/user/query"//业主和家属的主列表
#define URL_User_Certifition_SelfDetail                                      @"proprietor/user/details" //业主详情//20210225更改
//#define URL_User_Certifition_SelfDetail                                    @"proprietor/user/info/details" //业主详情//20210225更改 暂不使用
#define URL_User_ProprietorRegister                                          @"proprietor/user/proprietorRegister" //业主认证 添加
//#define URL_User_ProprietorRegister_Change                                 @"proprietor/user/update" //业主认证 修改
#define URL_User_ProprietorRegister_Change                                   @"proprietor/user/info/update" //业主认证 修改
#define URL_User_Family_Add                                                  @"proprietor/relation/add" //家属 添加
#define URL_User_Family_Update                                               @"proprietor/relation/updateUserRelationDetails" //家属 修改
#define URL_User_SendCarImg                                                  @"proprietor/car/carImageUpload" //发送车的图片
#define URL_USER_SednCarImgArr                                               @"proprietor/car/carImageBatchUpload" //发送车的图片 多图片 返回的data是url数组 --urlstr在后续要做中文字符转字符处理
#define URL_GuestInfoReistion_Detail_Family                                  @"proprietor/relation/selectUserRelationDetails" //家属详情查询

//访客登记相关

#define URL_Visitor_List                                                     @"proprietor/visitor/page"//访客总列表
#define URL_Visitor_ShowDetail                                               @"proprietor/visitor" //访客 总信息 详情
#define URL_Visitor_Add                                                      @"proprietor/visitor" //添加访客 总信息添加

#define URL_Visitor_Accompany_Person_AddAndOther                             @"proprietor/visitor/person"//随行人员添加修改
#define URL_Visitor_Accompany_Car_AddAndOther                                @"proprietor/visitor/car"//随行车辆添加修改
#define URL_Visitor_Accompany_Person_List                                    @"proprietor/visitor/person/page" //查询-随行人员
#define URL_Visitor_Accompany_Car_List                                       @"proprietor/visitor/car/page" //查询-随行车辆

//总popview 用到的
#define URL_Get_carType                                                      @"proprietor/source/typeSource?typeName=carType"   //查车辆类型
#define URL_Get_relationship                                                 @"proprietor/source/typeSource?typeName=relationship" // 查亲属关系
#define URL_Get_visitReason                                                  @"proprietor/source/typeSource?typeName=visitReason"//来访事由
#define URL_Get_communityAccess                                              @"proprietor/source/typeSource?typeName=communityAccess"//社区门禁类型
#define URL_Get_buildingAccess                                               @"proprietor/source/typeSource?typeName=buildingAccess"//楼栋门禁类型
#define URL_Get_User_HouseList_IsYeZu                                        @"proprietor/user/houseList" //用户房屋信息list//用户查询所有身份为业主的房屋
#define URL_Get_User_HouseList_IsAll                                         @"proprietor/user/houseListAll" ////用户房屋信息list//用户查询所有身份为业主家属租客的房屋
#define URL_Get_User_CommunityList                                           @"proprietor/user/communityList" //用户小区信息list （作为业主 作为家属 作为租客）
#define URL_Get_User_communityUserList                                       @"proprietor/user/communityUserList" //用户小区信息list （只作为业主）


//房屋修理
#define URL_Get_House_RepairList                                             @"proprietor/repair/getRepair" //业主查询报修列表
#define URL_Get_House_RepairDetail                                           @"proprietor/repair/repairDetails" //业主查询报修详情
//#define URL_Get_House_Repair_Type                                          @"proprietor/repair/getRepairType"//报修类别--弃用
#define URL_Get_House_Repair_TypeList                                        @"property/repairOrder/listRepairType"//报修事项--property物业端的
#define URL_Post_House_Repari_Add                                            @"proprietor/repair/addRepair"//发起报修
#define URL_Post_House_Repari_Img                                            @"proprietor/repair/uploadRepairImg" //报修图片
#define URL_Post_House_Repari_CommentImg                                     @"proprietor/repair/uploadCommentImg" //评价图片
#define URL_Post_House_Repari_cancelRepair                                   @"proprietor/repair/cancelRepair" //报修取消
#define URL_Post_House_Repari_advice                                         @"proprietor/repair/appraiseRepair"//评价报修
#define URL_Post_House_Repari_adviceImg                                      @"proprietor/repair/uploadCommentImg"//评价图片
#define URL_Get_House_Repari_ShowDismissReason                               @"proprietor/repair/getRejectReason" //查看驳回原因


#define URL_Get_Rent_House_List                                              @"lease/house/page"//房屋租房列表数据
#define URL_Get_Rent_House_Detail                                            @"lease/house/details" //房屋租房详情
#define URL_Get_Rent_House_Const                                             @"lease/const"//房屋常量查询

//商铺筛选
#define URL_Get_Rent_BuniessShop_ShaiXuan_MoreOption                         @"lease/shop/moreOption" //商铺筛选——更多
#define URL_Get_Rent_BuniessShop_List                                        @"lease/shop/getShopBySearch"//房屋租商铺列表数据
#define URL_Get_Rent_BuniessShop_List_WithDic                                @"lease/shop/getShopByCondition"//房屋商铺列表数据 带条件的
#define URL_Get_Rent_BuniessShop_Detail                                      @"lease/shop/getShop"//商铺租房详情
//
#define URL_Rent_Look_History_list                                           @"lease/house/browses" //个人中心的浏览记录——房屋商铺浏览

//投诉建议
#define URL_ComplaintsSuggestions_Send_Img                                   @"proprietor/complain/uploadComplainImages" //更多菜单里 投诉相关
#define URL_ComplaintsSuggestions_Send_All                                   @"proprietor/complain/addComplain"          //更多菜单里 投诉相关




//生活缴费
//主页
#define URL_Life_MyCost_list                                                 @"proprietor/livingpaymentquery/selectList" //我的缴费 section0
#define URL_life_MyCost_detail                                               @"proprietor/livingpaymentquery/getPayDetails" //我的缴费
#define URL_life_MyCost_detail_PayMoney_Order_Add                            @"proprietor/livingpaymentoperation/add" //充钱add成功添加order数据接口
#define URL_Life_AddNewCost_List                                             @"proprietor/livingpaymentquery/getPayType" //新增 section1
//
#define URL_Life_Companys_List                                               @"proprietor/livingpaymentquery/selectPayCompany"//缴费单位的列表
//
#define URL_Life_DetaiHistorytlList                                          @"proprietor/livingpaymentquery/selectOrder" //缴费历史记录列表
//
#define URL_Life_DetaiHistorytlList_OneOrderDetails                          @"proprietor/livingpaymentquery/selectOrderId" //账单详情
#define URL_Life_PaymentDetails                                              @"proprietor/livingpaymentquery/selectPaymentDetailsVO" //一条缴费详情
#define URL_Life_getOrderCredentials                                         @"proprietor/livingpaymentquery/getOrderID" //缴费凭证
#define URL_Life_addOrderMarkOrNote                                          @"proprietor/livingpaymentoperation/addRemark" //备注 标签 同一个接口
#define URL_Life_addMarkImgWithGetUrl                                        @"proprietor/livingpaymentoperation/addRemarkImg" //备注图片上传
#define URL_Life_selectGroupAll                                              @"proprietor/livingpaymentquery/selectGroupAll"//户号管理
#define URL_Life_selectFamilyId                                              @"proprietor/livingpaymentquery/selectFamilyId" //查询全部户号
#define URL_Life_addGroupName                                                @"proprietor/livingpaymentoperation/saveGroupName" //新增分组
#define URL_Life_addNewLifeCostPay                                           @"proprietor/livingpaymentquery/getPayDetails"  //新增户号 假缴费单接口

//个人中心
//——————房屋新增
#define URL_Get_BuniessShop_Tags                                             @"lease/const/getShopTags"//商铺出租提交界面的 类型数据
#define URL_Get_BuniessShop_Type                                             @"lease/shop/getPublishTags"//商铺出租新增界面的第一页 滚轮的 类型数据
//——————房屋管理
#define URL_Get_BuniessShop_UserSendList                                     @"lease/shop/listShop" //查询业主发布房源列表

//——————红包卡券
#define URL_Get_Red_Packet                                                   @"services/user/userRedpacket/selectUserAllRedpacket"

//——————现金券
#define URL_Post_Tickets                                                     @"proprietor/user/account/tickets"

//——————整合查询
#define URL_Get_All_Wallet                                                   @"proprietor/user/account/all"

//——————查询余额
#define URL_Get_Balance                                                      @"proprietor/user/account/balance"

//——————账户流水
#define URL_Post_AccountWater                                                @"proprietor/user/account/record"

//——————添加/修改支付密码
#define URL_Post_Set_Password                                                @"proprietor/user/auth/password/pay"

//——————验证支付密码
#define URL_Get_Pay_Password_Verification                                    @"proprietor/user/account/password/pay/check"

//——————用户余额提现至支付宝
#define URL_Post_Alipay_Withdrawal                                           @"proprietor/user/account/zhifubao/withdrawal"

//——————用户余额提现至微信
#define URL_Post_WeChat_Withdrawal                                           @"proprietor/user/account/wechat/withdrawal"

//——————查询已绑定支付宝账户
#define URL_Post_Query_Bind_Alipay                                           @"proprietor/user/account/zhifubao/account/query" //1215弃用

//——————绑定(修改)支付宝账户
#define URL_Post_Bind_Alipay                                                 @"proprietor/user/account/zhifubao/account/binding"

//——————发送修改支付密码的手机验证码
#define URL_Get_Pay_Code                                                 @"proprietor/user/auth/send/password/pay/code"

//——————手机验证码验证，更换支付密码(忘记支付密码)
#define URL_Post_Pay_Forget                                                 @"proprietor/user/auth/check/password/pay/code"


//——————天气首页
#define URL_Get_Weather_Now                                                  @"proprietor/common/weatherNow"
//——————天气详情
#define URL_Get_Weather_Details                                              @"proprietor/common/weatherDetails"
//——————天气城市列表
#define URL_Get_Weather_City_List                                            @"proprietor/common/region"

 
#pragma mark __________________________________BASE_URL_______URL_Of_BuisinessServices_Main_VC___________BASE_Chat_Default______。
//___________________________________________________________________________________________________________________________________________________________________________
#pragma mark ===== 社区大部分
//#define BASE_URL_OnlyAsOfPort                                                 @"https://api-v1.9guanjia.com/"        //正式服
//#define BASE_URL_OnlyAsOfPort                                                 @"https://api.zhsj.co/"        //正式服 旧版
//#define BASE_URL_OnlyAsOfPort                                                 @"http://222.178.212.29:8090/" //外网测试服
#define BASE_URL_OnlyAsOfPort                                                 @"http://192.168.12.49:8090/" //本地测试服

//正式服
#define   BASE_URL                                                            [NSString stringWithFormat:@"%@%@", BASE_URL_OnlyAsOfPort,@"api/v1/"]
#define   Y_BASEURL(_URL)                                                     [NSString stringWithFormat:@"%@%@", BASE_URL, _URL]

//车牌车辆相关
#define  Y_CarSystem_Url_BaseKey                                               @"api/v1/carSystem/"
#define  Y_CarSystem_URL_AllLongURL(_URL)                                      [NSString stringWithFormat:@"%@%@%@", BASE_URL_OnlyAsOfPort,Y_CarSystem_Url_BaseKey,_URL]

//仓储小店
#define  Y_SmallShop_Url_BaseKey                                               @"zhsj/cabinet/"
#define  Y_SmallShop_URL_AllLongURL(_URL)                                      [NSString stringWithFormat:@"%@%@%@", BASE_URL_OnlyAsOfPort,Y_SmallShop_Url_BaseKey,_URL]


#pragma mark ===== 医疗商铺机构部分base
#define BASE_URL_Shop_medical                                               BASE_URL_OnlyAsOfPort


#pragma mark ===== 绑定家属租客
//绑定家属租客 所跳转的web界面
#define URL_UserBangDingFamileOrRentUseJudgeHttpHeaderStr                  @"http" // 1021不用URL_UserBangDingFamileOrRent全部来判断 用http+id+mobile三样来判断（防治接口变化时的无法识别问题）



#pragma mark ===== 推送通知消息的地址
#define BASE_Message_Push_Module_BaseURL                                  BASE_URL_OnlyAsOfPort
#define BASE_Message_Push_Module_Default_URL(_URL)                        [NSString stringWithFormat:@"%@%@", BASE_Message_Push_Module_BaseURL, _URL]

//_____________________________________________________
//_____________________________________________________
#pragma mark ===== 聊天的base地址
#define BASE_Chat_Default                                                  BASE_URL_OnlyAsOfPort // //新（1019弃用23456后的接口） （旧数据相关接口调用 走的方法不一样 需要两个即时通讯base）
#define BASE_Chat_NewUse_Change_BaseURL                                    BASE_Chat_Default  //部分聊天模块新改的接口使用8090


#define URL_ChatBaseURL(_URL)                                             [NSString stringWithFormat:@"%@%@", BASE_Chat_Default, _URL]
#define URL_ChatBaseURLNewBase8090(_URL)                                  [NSString stringWithFormat:@"%@%@", BASE_Chat_NewUse_Change_BaseURL, _URL]

#pragma mark ===== 聊天相关图片地址 （新版都是全路径 防止万一 给旧版的9000或8090）
#define BASE_Chat_Img_Default_URL                                           @""
#define BASE_Chat_Img_Default_URL_AddBase                                   @"https://image-v1.9guanjia.com/" //正式服
//#define BASE_Chat_Img_Default_URL_AddBase                                   @"https://api.zhsj.co/"     //正式服 旧
//#define BASE_Chat_Img_Default_URL_AddBase                                   @"http://222.178.212.29:8090/" //外网测试服
//#define BASE_Chat_Img_Default_URL_AddBase                                   @"http://192.168.12.49:8090/" //本地测试服


//_____________________________________________________
#pragma mark ====== 手环设备上传下拉数据的base地址

#define BASE_TrusangBlueToothData_BaseUrl                                 [NSString stringWithFormat:@"%@%@", BASE_URL_OnlyAsOfPort,@"zhsj/healthdata/"]
#define BASE_TrusangBlueToothData_BaseUrl_URL(_URL)                       [NSString stringWithFormat:@"%@%@", BASE_TrusangBlueToothData_BaseUrl, _URL]

//____________________________________________________________________________________________________________________________________________________________
#pragma mark ===== 新 商城主页
#define BaseURLWithShopping_BaseAndPost                                   @"https://market.zhsj.co/#/"      //总商城 正式服
//#define BaseURLWithShopping_BaseAndPost                                   @"http://222.178.212.29:8083/#/"    //总商城。外网测试服

#pragma mark ======  车牌号码输入 的 webview url
#define URLAllStr_With_CarPlateNumberInput                                 @"https://page.9guanjia.com/shjf/index.html#/pages/LicensePlate/LicensePlate"  //正式服
//#define URLAllStr_With_CarPlateNumberInput                                 @"https://service.payment.zhsj.co/#/pages/LicensePlate/LicensePlate"  //正式服（旧）
//#define URLAllStr_With_CarPlateNumberInput                                @"http://222.178.212.29:8084/#/pages/LicensePlate/LicensePlate"  //外网测试服
//#define URLAllStr_With_CarPlateNumberInput                                @"http://192.168.12.121:8081/#/pages/LicensePlate/LicensePlate"  //本地测试服

 

#pragma mark ====== 生活缴费 （新增缴费 webview url）
#define kLifeCostBindHouseholdWebUrl                                        @"https://page.9guanjia.com/shjf/index.html#/"   //正式服
//#define kLifeCostBindHouseholdWebUrl                                        @"https://service.payment.zhsj.co/#/"  //正式服（旧）
//#define kLifeCostBindHouseholdWebUrl                                        @"http://222.178.212.29:8084/#/"  //外网测试服
//#define kLifeCostBindHouseholdWebUrl                                      @"http://192.168.12.121:8081/#/"  //本地测试服

#pragma mark ====== 拼团（webview url）
#define kShellGroupWeb @"https://page.9guanjia.com/pt/index.html" //正式服
//#define kShellGroupWeb @"http://test.zhsj.co/tg/#/" //测试服
//#define kShellGroupWeb @"http://192.168.12.121:8080/" //本地服
 
#pragma mark __________________________________BASE_URL_______URL_Of_BuisinessServices_Main_VC___________BASE_Chat_Default______ 1 end
 


//————————————————  以下商城到订单评价 为旧版 暂未使用
#pragma mark ===== 商城订单图片资源相关
#define  URL_Of_BuisinessServicesImg_Base                                  @"http://222.178.212.29:9000/"
#define  URL_BuniessService_ImgAllURL(_URL)                                [NSString stringWithFormat:@"%@%@",URL_Of_BuisinessServicesImg_Base , _URL]
//_________________
#pragma mark ===== 商城送货地址订单相关url
#define BASE_BuniessService_Default                                       @"http://222.178.212.29:9927/"
#define URL_ALL_BuniessService(_URL)                                      [NSString stringWithFormat:@"%@%@", BASE_BuniessService_Default, _URL]

//订单评价提交接口
#define URL_BuniessService_OrderToSaveEvaluation                          @"services/order/shopEvaluation/saveEvaluation"
//订单评价获取接口
#define URL_BuniessService_GetOrderEvaluation                             @"services/order/shopEvaluation/getOrderUuidEvaluation"


//___________________________________________________________商城
#define URL_BuniessService_GetUserAddressDetailWithUUID   @"services/user/userAddress/getByUuid/"     //根据用户地址UUID查询用户地址
#define URL_BuniessService_DeletUserAddressWithUUID       @"services/user/userAddress/"               //根据用户地址UUID删除地址  (这两个接口直接后拼接uuid)
#define URL_BuniessService_PostUserAddAddress             @"services/user/userAddress/save"                //用户添加地址
#define URL_BuniessService_GetUserAddressList             @"services/user/userAddress/list"                //用户token查询用户地址列表
#define URL_BuniessService_PostUserEditAddress            @"services/user/userAddress/update"              //根据用户地址uuid修改地址
//_____________________________________________________________商城

//____________________________________________________________推送通知消息的地址
#define Message_Push_Module_ImURL_getImMessageList                        @"zhsj/im/message/session/page" //获取用户会话列表
#define Message_Push_Module_ImURL_ImMessageListOrOneMessage_Clear         @"zhsj/im/message/session/clear" //获取用户会话列表清除接口
#define Message_Push_Module_ImURL_getMessageChatSubPage                   @"zhsj/im/message/chatMsg/pageMsg" //某类型 子列表
 

//____________________________________________________________聊天 
#define URL_Chat_ChangSeverAES                            @"zh_im/login-server/api/brain/open/exchangeServer"     //交换服务器AES
#define URL_Chat_ChangClientAES                           @"zh_im/login-server/api/brain/open/exchangeClient"     //交换客户端AES

//-----好友相关
#define URL_Chat_AddFriend                                @"zh_im/user-server/api/brain/user/friend/open/addFriend"   //添加好友
#define URL_Chat_AgreeFriend                              @"zh_im/user-server/api/brain/user/friend/open/agreeFriend" //同意添加好友
#define URL_Chat_RejectFriend                             @"zh_im/user-server/api/brain/user/friend/open/rejectFriendRequest"  //拒绝添加
#define URL_Chat_ChangeFriendRemark                       @"zh_im/user-server/api/brain/user/friend/open/oneUpdateFriendRemark" //修改好友备注
#define URL_Chat_DeletFriend                              @"zh_im/user-server/api/brain/user/friend/open/oneDeleteFriend"  //删除好友

#define URL_Chat_GetSelfFriendReqList                     @"zh_im/user-server/api/brain/user/friend/open/listFriendReq"  //获取该用户好友请求数据
#define URL_Chat_GetSelfFriendAllList                     @"zh_im/user-server/api/brain/user/friend/open/listAllFriend"   //获取该用户好友列表


//____会话相关
#define URL_Chat_AllSessionsFor7Days                        @"zh_im/message-server/api/brain/message/open/sync/synchronizeAllSessionsFor7Days" //同步所有会话7天
//#define URL_Chat_AllSessionsFor7DaysAllUnreadMessages     @"zh_im/message-server/api/brain/message/open/sync/pullAllUnreadMessages"         // 拉取所有未读消息（全部会话列表 - 时间排序）
#define URL_Chat_AllSessionsFor7DaysAllUnreadMessages       @"zh_im/message-server/api/brain/message/open/sync/allSessionList"         // 拉取所有未读消息（全部会话列表 -  带昵称等数据）
#define URL_Chat_UnreadMessagesChangeToReadedStatus         @"zh_im/message-server/api/brain/message/open/sync/messageHasBeenRead"  //某会话 未读消息转成已读消息   消息id组
#define URL_Chat_UnreadMessagesChangeToReadedStatus_OneMsg  @"zh_im/message-server/api/brain/message/open/sync/messageHasBeenRead"  //某会话 未读消息转成已读消息 一个消息id



#define URL_Chat_oneSyncChatMsgList                       @"zh_im/message-server/api/brain/message/open/sync/oneSyncBySequenceId"           //消息位点同步(一个会话) 从该消息位点开始的所有消息 7天之內 不区分已读未读
#define URL_Chat_oneSyncChatMsgListBySequenceIdBetween    @"zh_im/message-server/api/brain/message/open/sync/oneSyncBySequenceIdBetween"   //消息位点同步(一个会话) 同步两个消息位点之间的数据 7天之內
#define URL_Chat_MsgSetReadedType                         @"zhsj/im/message/msgReadConfirm/readConfirm"//已读回执
#define URL_Chat_withdrawOneMessage                       @"zh_im/message-server/api/brain/message/open/sync/withdrawMessage" //撤回一条消息
#define URL_Chat_deleteOneMessage                         @"zh_im/message-server/api/brain/message/open/sync/deleteAMessage"  //删除一条消息
#define URL_Chat_deleteEntireConversation                 @"zh_im/message-server/api/brain/message/open/sync/deleteEntireConversation"  //删除整个会话

//_____群
#define URL_Chat_CreatGroup                               @"zh_im/user-server/api/brain/group/open/createGroup" //创建一个群
#define URL_Chat_GroupAddNewMember                        @"zh_im/user-server/api/brain/user/group/open/inviteFriendsToGroup" //群 拉人进群

#define URL_Chat_GroupChangeName                          @"zh_im/user-server/api/brain/group/open/updateGroupName"//群名字 改名
#define URL_Chat_GroupSetRemarks                          @"zh_im/user-server/api/brain/user/group/open/setRemarks"//群备注的设置

#define URL_Chat_GetGroupInfoToMe                         @"zh_im/user-server/api/brain/user/userInfo/open/getUserGroupInfoToMe" //当前群自己设置相关的基础信息
#define URL_Chat_GetGroupAllMemberList                    @"zh_im/user-server/api/brain/user/userInfo/open/userGetGroupUserInfo" //获取某群的全部成员
#define URL_Chat_GetExcludeGroupUserStayFriends           @"zh_im/user-server/api/brain/user/userInfo/open/excludeGroupUserStayFriends"  //拉人时用的_排除在群聊里面的好友列表后剩余的好友列表
#define URL_Chat_GetAllGroupList                          @"zh_im/user-server/api/brain/user/userInfo/open/getGroupListByUserUuid" //获取全部群
#define URL_Chat_GroupAddFriends                          @"zh_im/user-server/api/brain/user/group/open/inviteFriendsToGroup"//拉好友进群
#define URL_Chat_GroupRemoveMember                        @"zh_im/user-server/api/brain/user/group/open/kickOutUser"  //群聊 踢人

//修改用户聊天背景
#define URL_Chat_UserChatVcBackImgSet                     @"zh_im/user-server/api/brain/user/userInfo/open/updateUserBackground"//修改用户聊天背景
#define URL_Chat_GroupChatVcBackImgSet                    @"zh_im/user-server/api/brain/user/group/open/setGroupPersonalBackground"//修改用户当前群的聊天背景

//个人信息
#define URL_Chat_UserInfoGetWithMy                        @"zh_im/user-server/api/brain/user/userInfo/open/selectUserToMe" //查询用户信息（展示给自己看的）
#define URL_Chat_UserInfoGetToOther                       @"zh_im/user-server/api/brain/user/userInfo/open/selectUserToOther" //查询用户信息（展示给其他人看）
#define URL_Chat_UserInfoChangeName                       @"zh_im/user-server/api/brain/user/userInfo/open/updateUserInfo"  //修改的url地址都一样
#define URL_Chat_UserInfoChangeImg                        @"zh_im/user-server/api/brain/user/userInfo/open/updateUserInfo"  //可以修改对应键值的
#define URL_Chat_ChangeHeaderImg                          @"zh_im/user-server/api/brain/user/userInfo/open/updateUserAvatar"  //修改用户的头像
//查询是否为好友关系
#define URL_Chat_IsOrNotFriend                            @"zh_im/user-server/api/brain/user/friend/open/judgeUserFriends" //1222 后台说没见过这个接口
#define URL_Chat_IsOrNotFriend_New                        @"zhsj/im/user/user/isFriend" //1222 增

//搜索
#define URL_Chat_SearchWithNickName                       @"zh_im/user-server/api/brain/user/userInfo/open/selectUser"  //根据昵称搜索用户(跟uuid搜索用户是同一个接口，只是传参不同)
#define URL_Chat_SearchWithUUID                           @"zh_im/user-server/api/brain/user/userInfo/open/selectUser"

//聊天相关——————文件传输接口
#define URL_Chat_SendFileGetFileDicNewSystem              @"zhsj/im/files/f/up/load"  //聊天相关 所有文件数据上传接口 (1025新版本)

#define URL_Chat_SendFileGetFileSavUrl                    @"zh_im/file-server/file/upload"  //聊天相关 所有文件数据上传接口
#define URL_Chat_DownFileWithFileUrl                      @"zh_im/file-server/file/download"  //聊天相关 所有文件数据下载
//____________________________________________________________聊天
//___________________________________________________________Y_ResponsObject_相关__

#define  Y_IS_Success                                   ( [[responsObject objectForKey:@"code"] intValue]== 0  ||  [[responsObject objectForKey:@"code"] intValue]== 200 )
#define  Y_Success_Or_ErrCode                            [[responsObject objectForKey:@"code"] intValue]
#define  Y_Success_Or_ErrCodeKeyIntV                     [[responsObject objectForKey:@"err_code"] intValue]

#define  Y_ResponsObject_codeStr                         [[responsObject allKeys] containsObject:@"code"] ? [NSString stringWithFormat:@"%@",[responsObject objectForKey:@"code"]] : @"1000"
#define  Y_ResponsObject_dataDic                         ( [[responsObject allKeys] containsObject:@"data"] && isNotNil([responsObject objectForKey:@"data"]) ) ? [responsObject objectForKey:@"data"] : [NSDictionary dictionary]
#define  Y_ResponsObject_dataArr                         ( [[responsObject allKeys] containsObject:@"data"] && isNotNil([responsObject objectForKey:@"data"]) ) ? [responsObject objectForKey:@"data"] : [NSMutableArray array]
#define  Y_ResponsObject_dataStr                         [[responsObject allKeys] containsObject:@"data"] ? [TextShowWithModelStr textShowWithNotNullStr:[NSString stringWithFormat:@"%@",[responsObject objectForKey:@"data"]] ] : @""
#define  Y_ResponsObject_messageStr                      [[responsObject allKeys] containsObject:@"message"] ? [TextShowWithModelStr textShowWithNotNullStr:[NSString stringWithFormat:@"%@",[responsObject objectForKey:@"message"]] ] : @"暂无具体信息"
//商城订单列表用的
#define  Y_ResponsObject_rowsArr [[rows allKeys] containsObject:@"rows"]?[rows objectForKey:@"rows"]:[NSMutableArray array]

//_________________________________________________________SVProgressHUD__相关__

#define Y_SVP_SHOW_SUCCESS_MESSAGE           [SVProgressHUD showSuccessWithStatus:Y_ResponsObject_messageStr]; [SVProgressHUD dismissWithDelay:2.0];
#define Y_SVP_SHOW_ERR_DESCRIPTION           [SVProgressHUD showErrorWithStatus:error.description];  [SVProgressHUD dismissWithDelay:2.0];
#define Y_SVP_SHOW_ERR_MESSAGE               [SVProgressHUD showErrorWithStatus:Y_ResponsObject_messageStr];[SVProgressHUD dismissWithDelay:2.0];
#define Y_SVP_SHOW_ERR_MES(_msg)             [SVProgressHUD showErrorWithStatus:_msg]; [SVProgressHUD dismissWithDelay:2.0];
#define Y_SVP_SHOW_SUCCESS_MES(_msg)         [SVProgressHUD showSuccessWithStatus:_msg]; [SVProgressHUD dismissWithDelay:2.0];
#define Y_SVP_SHOW_SUCCESS_MES_5Delay(_msg)         [SVProgressHUD showSuccessWithStatus:_msg]; [SVProgressHUD dismissWithDelay:5.0];
#define Y_SVP_SHOW_SUCCESS_MES_10Delay(_msg)         [SVProgressHUD showSuccessWithStatus:_msg]; [SVProgressHUD dismissWithDelay:10.0];
#define Y_SVP_SHOW_SUCCESS_MES_15Delay(_msg)         [SVProgressHUD showSuccessWithStatus:_msg]; [SVProgressHUD dismissWithDelay:15.0];
#define Y_SVP_SHOW_MES(_msg)                 [SVProgressHUD showWithStatus:_msg];[SVProgressHUD dismissWithDelay:2.0];
#define Y_SVP_DISMISS                        [SVProgressHUD dismiss];
#define Y_SVP_DISMISS_DELAY_TWO              [SVProgressHUD dismissWithDelay:2.0];
#define Y_SVP_SHOW_MES_5Delay(_msg)          [SVProgressHUD showWithStatus:_msg];[SVProgressHUD dismissWithDelay:5.0];
#define Y_SVP_SHOW_MES_10Delay(_msg)          [SVProgressHUD showWithStatus:_msg];[SVProgressHUD dismissWithDelay:10.0];

#define Y_SVP_SHOW_MES_5Delay_Loading        [SVProgressHUD showWithStatus:@"加载中"];[SVProgressHUD dismissWithDelay:5.0];
#define Y_SVP_SHOW_MES_Loading               [SVProgressHUD showWithStatus:@"处理中"];
#define Y_SVP_SHOW_MES_IsDealing             [SVProgressHUD showWithStatus:@"正在处理"];
#define Y_SVP_SHOW_MES_IsDealing_15Delay     [SVProgressHUD showWithStatus:@"正在处理"];[SVProgressHUD dismissWithDelay:15.0];
#define Y_SVP_SHOW_MES_IsLoading_15Delay     [SVProgressHUD showWithStatus:@"正在加载"];[SVProgressHUD dismissWithDelay:15.0];
#define Y_SVP_SHOW_INFO_MES(_msg)            [SVProgressHUD showInfoWithStatus:_msg]; [SVProgressHUD dismissWithDelay:2.0];
#define Y_SVP_SHOW_INFO_MES_5Delay(_msg)     [SVProgressHUD showInfoWithStatus:_msg]; [SVProgressHUD dismissWithDelay:5.0];

#define Y_SVP_SHOW_MES_IsDling_15Delay(_msg) [SVProgressHUD showWithStatus:_msg];[SVProgressHUD dismissWithDelay:15.0];
//________________________________________________________ToolOfNetWork_网络_相关
 
#import "HttpResult.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "NetworkManager.h"
#import "DataRequestTools.h"
#import "ToolOfNetWork.h"


#endif
#endif /* UrlAndOtherHeader_h */
