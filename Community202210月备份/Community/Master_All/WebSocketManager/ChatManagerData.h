//
//  ChatManagerData.h
//  Community
//
//  Created by 余莹 on 2021/4/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSInteger Im_err_code_Num_NotOnLineMsg  = 1003;

//单独h文件
//static NSString * const kWebSocketMsgType_Key                         = @"msg_type";
////
//static NSString * const kWebSocketMsgTypeObj_Content                 = @"content";
////
//static NSString * const kWebSocketMsgTypeObj_Text                    = @"text";
//static NSString * const kWebSocketMsgTypeObj_Music                   = @"music";
//static NSString * const kWebSocketMsgTypeObj_News                    = @"news";     // 图文
//static NSString * const kWebSocketMsgTypeObj_Image                   = @"image";
//static NSString * const kWebSocketMsgTypeObj_Video                   = @"video";    // 视频
//static NSString * const kWebSocketMsgTypeObj_Voice                   = @"voice";    // 语音
//static NSString * const kWebSocketMsgTypeObj_File                    = @"file";     //文件
//static NSString * const kWebSocketMsgTypeObj_Link                    = @"link";     //连接
//static NSString * const kWebSocketMsgTypeObj_RedEnv                  = @"red_env";//  红包
//static NSString * const kWebSocketMsgTypeObj_transfer                = @"transfer";// 转账
////
//static NSString * const kWebSocketMsgTypeObj_Have_An_friendAddReq    = @"friend_req";// 好友请求 add_friend
//static NSString * const kWebSocketMsgTypeObj_Friend_add_Success      = @"friend_add";//  新增好友通知
//static NSString * const kWebSocketMsgTypeObj_Friend_rej_info         = @"friend_rej";//  好友请求被拒绝
////
//static NSString * const kWebSocketMsgTypeKey_ReceiveAck              = @"receive_ack";// 客户端发送给服务器的确认
//static NSString * const kWebSocketMsgTypeObj_ReceiveAck              = @"receive_ack";//@"receiveAck";// 客户端发送给服务器的确认
//static NSString * const kWebSocketMsgTypeObj_revoke_msg              = @"revoke_msg";//撤回消息通知
//static NSString * const kWebSocketMsgTypeObj_group_member_add        = @"group_member_add_notice"; //群聊新增通知
//
////
//static NSString * const kWebSocketMsgTypeKey_Response                = @"response";
//static NSString * const kWebSocketMsgTypeObj_Response                = @"response";
//static NSString * const kWebSocketMsgResponse_err_code               = @"err_code";
//static NSString * const kWebSocketMsgResponse_err_info               = @"err_info";
////  发送失败 err_code=401
////  消息成功送达 err_code=0


typedef void(^ImMessageWillSendBodyAndHeaderInfoBlock)(NSString *onlyReq,NSMutableDictionary *parms);
@interface ChatManagerData : NSObject
/**
 *一：交换秘钥（分为两步）
 1、交换服务端的AES key和iv （目的是为获得服务端的AES key 和 iv）
 2、交换客户端的AES key（目的是将客户端的AES key 送到服务端）
 */
+ (void)sendUserImId:(NSString *)ImId andGetWebSocketInfoBlcok:(BaseDicAndSuccessBoolBlock)dicBlock;



/**
 *连后的socket收到数据了数据消息解析
 */
+ (NSString *)useMessageDicGetDecStr:(NSDictionary *)dic;
/**
 *解析收到的socket数据 处理code==0的解析
 */
+ (NSString *)useMessageDicGetDecStrWhenCodeIsZero:(NSDictionary *)dic;
#pragma  mark ========================================================================  好友相关 _  添加 同意  拒绝
/**
 *好友相关
 */
+ (void)addFriendWithFriendImIdStr:(NSString *)friendImIdStr withVerifyMessage:(NSString *)verifyMessage withFriendRemark:(NSString *)friendRemark;
//+ (void)addFriendWithFriendUUID:(NSString *)friendUUID;//添加
+ (void)agreeAddWithFriendNotifyId:(NSString *)friendNotifyId withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock;//同意他人的好友申请
+ (void)agreeAddWithFriendNotifyId:(NSString *)friendNotifyId withFriendRemark:(NSString *)friendRemark withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock;//带有设置对方好友备注的 同意他人的好友申请
+ (void)rejectAddWithFriendNotifyId:(NSString *)friendNotifyId withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock;//拒绝
/**
 *删除好友
 */
+ (void)deletFriendWithFriendNotUuidIsInfoId:(NSString *)friendNotUuidIsInfoId withDic:(BaseDicAndSuccessBoolBlock)block;
/**
 拉黑好友+ 移除黑名单

 */
+ (void)backFriendWithFriendNotUuidIsInfoId:(NSString *)friendNotUuidIsInfoId withDic:(BaseDicAndSuccessBoolBlock)block;
+ (void)whiteFriendWithFriendNotUuidIsInfoId:(NSString *)friendNotUuidIsInfoId withDic:(BaseDicAndSuccessBoolBlock)block;

/**
 *修改好友备注
 */
+ (void)changeFriendRemarkWithFriendNotUuidIsIDStr:(NSString *)idStr  withFriendRemark:(NSString *)friendRemark withDic:(BaseDicAndSuccessBoolBlock)block;;

#pragma  mark ========================================================================  好友相关 _  请求数据获取 列表数据获取
/**
 *获取好友请求的数据列表
 */
+ (void)getImFriendReqInfoListWithBlcok:(BaseListArrAndSuccessBoolBlock)block;
/**
 *获取好友列表 全部联系人列表
 */
+ (void)getFriendInfoListWithBlcok:(BaseListArrAndSuccessBoolBlock)block;
+ (void)getAllContactInfoListWithBlcok:(BaseListArrAndSuccessBoolBlock)block;


#pragma  mark ======================================================================== 发送数据打包

/**普通加密打包 */
+ (void)chatNomalEncryptionWithDic:(NSDictionary *)parmsDic withBlock:(BaseDicAndSuccessBoolBlock)dicBlock;

#pragma  mark ================= eceiveAck类型
/**
 *receiveAck类型
 */
+ (void)chatWillSnedReceiveAckwithGetMsgDic:(NSDictionary *)getMsgDic withBlock:(BaseDicBlock)dicBlock;
#pragma  mark ===================================处理成｜ [文本类型结构数据 发送前datadic数据]
/**
 *发送心跳
 */
+ (void)chatWithSendPingTypeWithBlock:(BaseListArrBlock)arrBlock;//ping
#pragma  mark ================= 文字类型
/**
 *文字类型
 */
//+ (void)chatWillSendTextTypeWithStr:(NSString *)chatTextStr withFriendUUId:(NSString *)otherUuid withDicBlockAndWillSendDataDicBlock:(BaseDicBlock)dicBlock;
+ (void)chatWillSendTextTypeWithChatMsgBaseInfo:(NSMutableDictionary *)chatMsgBaseInfoDic withStr:(NSString *)chatTextStr withFriendUUId:(NSString *)otherUuid withDicBlockAndWillSendDataDicBlock:(BaseListArrBlock)arrBlock;
/**
 *文字类型 _群聊
 */
+ (void)chatWillSendTextTypeWithChatMsgBaseInfo:(NSMutableDictionary *)chatMsgBaseInfoDic withStr:(NSString *)chatTextStr withGroupUUId:(NSString *)groupUuid withDicBlockAndWillSendDataDicBlock:(BaseListArrBlock)arrBlock;
/**
 *文字类型 _群组发送
 */
//+ (void)chatWillSendTextTypeWithStr:(NSString *)chatTextStr withGroupId:(NSString *)groupId withBlock:(BaseDicBlock)dicBlock;

/**
 位置类型
 */
+ (void)chatWillSendLocateAddressWithChatMsgBaseInfo:(NSMutableDictionary *)chatMsgBaseInfoDic withLati:(CGFloat)lati withLongi:(CGFloat)longi withaddressTextStr:(NSString *)addresstextStr wtihFriendId:(NSString *)otherUuid  withDicBlockAndWillSendDataDicBlock:(BaseListArrBlock)arrBlock;
+ (void)chatWillSendLocateAddressWithChatMsgBaseInto:(NSMutableDictionary *)chatInfoDic withlat:(CGFloat)lati withLongi:(CGFloat)longi withaddressTextStr:(NSString *)addresstextStr wtihGroupId:(NSString *)groupId withDicBlockAndWillSendDataDicBlock:(BaseListArrBlock)arrBlock;
#pragma mark ==  视频上传 发送数据组装等
//0622新
+ (void)sendMp4WithFileUrl:(NSURL *)fileUrl withGetDicBlick:(BaseDicAndSuccessBoolBlock)dicBlock;
+ (void)chatWillSendFileNewSystemNotHaveOrHaveSecretwithChatSessionId:(NSString *)chatSessionId andWithMovieBaseUrl:(NSURL *)movieUrl withGetDicBlick:(BaseDicAndSuccessBoolBlock)dicBlock;

#pragma  mark ================= 1025文件上传 （图片上传）（接口更换 换了键值增加了的接口）
+ (void)chatWillSendFileNewSystemNotHaveOrHaveSecretwithChatSessionId:(NSString *)chatSessionId andWithImg:(UIImage *)willSendImg withGetDicBlick:(BaseDicAndSuccessBoolBlock)dicBlock;
/**
 好友会话-发送图片类型
 */
+ (void)chatWillSendImgUrlWithChatMsgBaseInfo:(NSMutableDictionary *)chatMsgBaseInfoDic withDic:(NSDictionary *)chatSendImgDic withFriendUUId:(NSString *)otherUuid withDicBlockAndWillSendDataDicBlock:(BaseListArrBlock)arrBlock;
/**
 群会话-发送图片类型
 */
+ (void)chatWillSendImgUrlWithChatMsgBaseInfo:(NSMutableDictionary *)chatMsgBaseInfoDic withDic:(NSDictionary *)chatSendImgDic withGroupUUId:(NSString *)groupUuid  withDicBlockAndWillSendDataDicBlock:(BaseListArrBlock)arrBlock;
#pragma  mark ================= chat 图片类型上传
/**
 chat 总图片上传
 */
+ (void)chatWillSendImgFileWithImg:(UIImage *)willSendImg withGetDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock;
/**
 好友会话-发送图片类型
 */
+ (void)chatWillSendImgUrlWithChatMsgBaseInfo:(NSMutableDictionary *)chatMsgBaseInfoDic withStr:(NSString *)chatSendImgUrlStr withFriendUUId:(NSString *)otherUuid withDicBlockAndWillSendDataDicBlock:(BaseListArrBlock)arrBlock;
/**
 群会话-发送图片类型
 */
+ (void)chatWillSendImgUrlWithChatMsgBaseInfo:(NSMutableDictionary *)chatMsgBaseInfoDic WithStr:(NSString *)chatSendImgUrlStr withGroupUUId:(NSString *)groupUuid  withDicBlockAndWillSendDataDicBlock:(BaseListArrBlock)arrBlock;
#pragma  mark ================= chat 语音类型上传
//语音上传 （1026新接口）
+ (void)chatWillSendFileNewSystemNotHaveOrHaveSecretwithChatSessionId:(NSString *)chatSessionId  withSendOneVoiceFileWithVoicePathUrl:(NSURL *)willSendVoicePathUrl   withGetDicBlick:(BaseDicAndSuccessBoolBlock)dicBlock;
/**
 chat 语音上传
 */
//语音 传path的 文件上传 旧版
+ (void)chatWillSendOneVoiceFileWithVoicePathUrl:(NSURL *)willSendVoicePathUrl withGetDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock;
#pragma mark == 发送信息数据整合 voice
 //1026 voice新
+ (void)chatWillSendVoiceTypeWithChatMsgBaseInfo:(NSMutableDictionary *)chatMsgBaseInfoDic withFileDic:(NSDictionary *)voiceFileDic withFriendUUId:(NSString *)otherUuid withDicBlockAndWillSendDataDicBlock:(BaseListArrBlock)arrBlock;
/**
 群会话-发送voice类型 1026新
 */
//1026 voice新
+ (void)chatWillSendVoiceTypeWithChatMsgBaseInfo:(NSMutableDictionary *)chatMsgBaseInfoDic withVoiceFileDic:(NSDictionary *)voiceFileDic withGroupUUId:(NSString *)groupUuid  withDicBlockAndWillSendDataDicBlock:(BaseListArrBlock)arrBlock;
/**
 好友会话-发送语音类型
 */
+ (void)chatWillSendVoiceFileUUIDWithFileUUIDStr:(NSString *)chatSendVoiceFileUUIDStr  withFriendUUId:(NSString *)otherUuid withDicBlockAndWillSendDataDicBlock:(BaseListArrBlock)arrBlock;
/**
 群会话-发送语音类型
 */
+ (void)chatWillSendVoiceFileUUIDWithFileUUIDStr:(NSString *)chatSendVoiceFileUUIDStr withGroupUUId:(NSString *)groupUuid  withDicBlockAndWillSendDataDicBlock:(BaseListArrBlock)arrBlock;

#pragma  mark ======================================================================== 信息相关
/**
 *会话信息 拉取 ｜｜  同步所有会话7天
 */
+ (void)getAllConversationFor7DaysWithBlock:(BaseListArrAndSuccessBoolBlock)dicBlock;

/**
 *拉取所有未读消息（全部会话列表 - 时间排序）
 */
+ (void)getAllSessionsNotReadFor7DaysWithBlock:(BaseListArrAndSuccessBoolBlock)listBlock;
/**
 *未读消息转转成已读消息
 */
+ (void)chatHistoryNotReadChangeToReadedWithUnRedDic:(NSMutableDictionary *)unRedDic withBlock:(BaseDicAndSuccessBoolBlock)dicBlock;
//------新历史消息请求接口
+ (void)getOneFriendChatHistoryMsgListWithFriendUUIDNewInfo:(NSString *)friendUUID withBlock:(BaseListArrAndSuccessBoolBlock)block;
+ (void)getOneFriendChatHistoryMsgListWithPageNum:(NSInteger)pageNum withPageSize:(NSInteger)size WithFriendUUIDNewInfo:(NSString *)friendUUID withBlock:(BaseListArrAndSuccessBoolBlock)block;
/**
 *聊天信息 拉取 ｜｜ 消息位点同步(一个会话 7天内 不区分已读未读 -- 好友会话
 */
+ (void)getOneFriendChatHistoryMsgListWithFriendUUID:(NSString *)friendUUID withBlock:(BaseDicAndSuccessBoolBlock)dicBlock;
/**
 *聊天信息 拉取 ｜｜ 消息位点同步(一个会话 7天内 不区分已读未读 -- 群聊会话
 */
+ (void)getOneGroupChatHistoryMsgListWithGroupUUID:(NSString *)groupUUID withBlock:(BaseDicAndSuccessBoolBlock)dicBlock;
/**
 *消息位点同步(一个会话) 同步两个消息位点之间的数据 7天之內
 */
+ (void)getOneFriendChatMsgListWithBeginSeqId:(NSString *)beginSeqId withEndSeqId:(NSString *)endSeqId withFriendUUID:(NSString *)friendUUID withBlock:(BaseDicAndSuccessBoolBlock)dicBlock;

/**
 * msg已读状态提交
 */
+ (void)chatInfoSetReadedTypeWithDic:(NSMutableDictionary *)infoDic withBlock:(BaseDicAndSuccessBoolBlock)dicBlock;
/**
 * 撤回一条消息
 */
+ (void)chatInfoWithUndoOneMessageWithSequenceId:(NSString *)sequenceId withFriendId:(NSString *)friendUUID withBlock:(BaseDicAndSuccessBoolBlock)dicBlock;
/**
 * 删除一条消息
 */
+ (void)chatInfoDeletOneMessageWithSequenceId:(NSString *)sequenceId withFriendId:(NSString *)friendUUID withBlock:(BaseDicAndSuccessBoolBlock)dicBlock;
/**
 * 删除整个会话
 */
+ (void)chatInfoDeletOneConversationWithFriendId:(NSString *)friendUUID withBlock:(BaseDicAndSuccessBoolBlock)dicBlock;
//deleteEntireConversation删除整个会话 改为 删除会话列表
+ (void)chatSessionDeleteWithBodyDic:(NSMutableDictionary *)bodyDic withBlock:(BaseDicAndSuccessBoolBlock)dicBlock;

#pragma  mark ============================================================================================================================== 群
/**
 *建群
 */
+ (void)chatCreatGroupWithOnlyMeInfoWithGroupName:(NSString *)groupName withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock;
+ (void)chatCreatGroupWithGroupName:(NSString *)groupNameStr withFriendsUuidArr:(NSArray *)friendsUuidArr withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock;
/**
 *拉人进群
 */
+ (void)chatAddOtherFriendIntoTheGroupWithGroupId:(NSString *)groupUuid WithOhterFriendIdArr:(NSMutableArray *)othterFriendIdArr withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock;
/**
 *修改群名称
 */
+ (void)chatGroupNameChangeWithNewNameStr:(NSString *)groupName withGroupId:(NSString *)groupUuid  withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock;
/**
 *设置群备注
 */
+ (void)chatGroupSetRemarkWithRemarkStr:(NSString *)remark withGroupId:(NSString *)groupUuid  withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock;
/**
 *获取某群的全部成员列表
 */
+ (void)chatGroupAllMemberListWithGroupId:(NSString *)groupUuid withlistBlock:(BaseListArrAndSuccessBoolBlock)listBlock;
/**
 排除在群聊里面的好友列表后剩余的好友列表
 */
+ (void)chatGroupAddNewMemberWillExcludeGroupUserStayFriendWithGroupId:(NSString *)groupUuid withlistBlock:(BaseListArrAndSuccessBoolBlock)listBlock;
/**获取当前群自己设置的信息
 */
+ (void)chatGroupOwnSetInfoWithGroupId:(NSString *)groupUuid withlistBlock:(BaseDicAndSuccessBoolBlock)dicBlock;
/**
 *获取用户所有群聊
 */
+ (void)chatGetAllGroupListWithBlock:(BaseListArrAndSuccessBoolBlock)dicBlock;
/**
 *拉好友到某群组
 */
+ (void)chatGroupAddFriendWithGroupId:(NSString *)groupId withFriendIdArr:(NSMutableArray *)friendUuidArr withBlock:(BaseDicAndSuccessBoolBlock)dicBlock;
/**
 群聊 踢人 管理员/群主可踢
 */
+ (void)chatGroupRemoveMemberWithGroupId:(NSString *)groupId withMemberIdArr:(NSMutableArray *)willRemoveUuidArr withBlock:(BaseDicAndSuccessBoolBlock)dicBlock;
/**
 *聊天信息 拉取 ｜｜ 消息位点同步(一个会话 7天内 不区分已读未读    群组
 */
+ (void)getOneFriendChatMsgListWithGroupID:(NSString *)groupID withBlock:(BaseDicAndSuccessBoolBlock)dicBlock;

   
#pragma mark ===  聊天用户背景修改
//用户的聊天背景
+ (void)chatVcSetBackImgWithImgUrlStr:(NSString *)imgUrlStr withBlock:(BaseDicAndSuccessBoolBlock)dicBlock;
//当前用户群聊的聊天背景
+ (void)chatVcSetBackImgWithGroupId:(NSString *)groupId withImgUrlStr:(NSString *)imgUrlStr withBlock:(BaseDicAndSuccessBoolBlock)dicBlock;
#pragma mark ===  个人信息修改
/**
 *查看用户自己的信息
 */
+ (void)chatUserInfoGetWithMyInfoWithBlock:(BaseDicAndSuccessBoolBlock)dicBlock;
/**
 *查看他人信息 infoByImId 仅仅有简单的图片名字imid和性别可用 （0909新增数据）
 */
+ (void)chatOtherUserInfoWithOthterImId:(NSString *)otherImId withBlock:(BaseDicAndSuccessBoolBlock)dicBlock;

/**
 查询一个联系人(ImId) contact/getOne  有关系信息 没有查看他人信息接口infoByImId 的基础信息
 */
+ (void)chatOtherUserGetOneInfoWithImId:(NSString *)otherImId withBlock:(BaseDicAndSuccessBoolBlock)dicBlock;
    
    
/**
 *
// //0909新加接口
// //查询联系人和自己的关系 --- 新版本暂无 查询是否为好友关系 只用本接口的部分键替代
// */
//+ (void)chatOtherUserAndOwnUserTheRelationshipInfoWithOthterImId:(NSString *)otherImId withBlock:(BaseDicAndSuccessBoolBlock)dicBlock;
/**
 *查询是否为好友关系  旧版使用 新版换了
 */
//+ (void)chatSearchIsOrNotFriendsWithOherUUID:(NSString *)toUserId withBlock:(BaseDicAndSuccessBoolBlock)dicBlock;
//1222 新增 查询是否为好友
+ (void)chatSearchIsOrNotFriendsWithImid:(NSString *)imId withBlock:(BaseDicAndSuccessBoolBlock)dicBlock;
/**
 *昵称修改
 */
//+ (void)chatUserInfoChangeNickName:(NSString *)nickNameStr withBlock:(BaseDicAndSuccessBoolBlock)dicBlock;//旧
/***
 个性签名修改
 */
+ (void)chatUserInfoChangeAutograph:(NSString *)autograph withBlock:(BaseDicAndSuccessBoolBlock)dicBlock;//旧 暂无替换
/**
 *头像修改
 */
//+ (void)chatUserInfoChangeHeaderImgUrlStr:(NSString *)headerImgUrlStr withBlock:(BaseDicAndSuccessBoolBlock)dicBlock;//旧

+ (void)chatUserInfoChangeNickNameNew:(NSString *)nickNameStr withBlock:(BaseDicAndSuccessBoolBlock)dicBlock;//新

+ (void)chatUserChangeHeaderImgUrlStrNew:(NSString *)headerImgUrlStr withBlock:(BaseDicAndSuccessBoolBlock)dicBlock;//新

/**
 *搜索 用昵称或uuid/
 */
+ (void)chatSeatchPersonWithNickName:(NSString *)nickNameStr withBlock:(BaseListArrAndSuccessBoolBlock)listBlock;
+ (void)chatSeatchPersonWithUUID:(NSString *)otherUUID withBlock:(BaseListArrAndSuccessBoolBlock)listBlock;

#pragma mark ===  通知的信息模块 加密 签名 和回调的header所用数据
+ (void)toolImMesssageInfoBodyStrWithParmsDic:(NSMutableDictionary *)dic withHeaderUseSBlock:(ImMessageWillSendBodyAndHeaderInfoBlock)imWillSendDic;
//通知的信息模块 得到数据data等 后解密成dic
+ (void)toolImMesssageInfoResponsObject:(id)responsObject  withChangeToDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock;
@end

NS_ASSUME_NONNULL_END

