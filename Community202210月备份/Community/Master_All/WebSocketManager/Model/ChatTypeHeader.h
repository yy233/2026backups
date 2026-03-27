//
//  ChatTypeHeader.h
//  Community
//
//  Created by 余莹 on 2021/4/28.
//

#ifndef ChatTypeHeader_h
#define ChatTypeHeader_h

typedef enum : NSUInteger {
    ChatVC_FriendsChat,
    ChatVC_GroupChat,
} ChatVC_Type;

typedef enum : NSUInteger {
    Photo_Choose_Type_Grapht,
    Photo_Choose_Type_Album
} Photo_Choose_Type;

//
static NSString * const kWebSocketMsgType_Key_RevokeMsg              = @"revoke_msg";
static NSString * const kWebSocketMsgType_Key_Revoke                 = @"revoke";
static NSString * const kWebSocketMsgType_Key_Deleted                = @"deleted";
static NSString * const kWebSocketMsgType_Key                        = @"msg_type";
//
static NSString * const kWebSocketMsgTypeObj_OffLine                    = @"forced_offline";  //*********  被踢下线
//
static NSString * const kWebSocketMsgTypeObj_Content                 = @"content";
//
static NSString * const kWebSocketMsgTypeObj_PING                    = @"ping";
static NSString * const kWebSocketMsgTypeObj_PONG                    = @"pong";

static NSString * const kWebSocketMsgTypeKey_MsgReadNotify           = @"msgReadNotify";//已读消息类型
static NSString * const kWebSocketMsgTypeKey_Tips                    = @"tips";//客户客服等相关的类型 
static NSString * const kWebSocketMsgTypeObj_Text                    = @"text";
static NSString * const kWebSocketMsgTypeObj_Music                   = @"music";
static NSString * const kWebSocketMsgTypeObj_News                    = @"news";     // 图文
static NSString * const kWebSocketMsgTypeObj_Image                   = @"image";
static NSString * const kWebSocketMsgTypeObj_Position                = @"position";    //定位位置地图
static NSString * const kWebSocketMsgTypeObj_Video                   = @"video";    // 视频
static NSString * const kWebSocketMsgTypeObj_Voice                   = @"voice";    // 语音
static NSString * const kWebSocketMsgTypeObj_File                    = @"file";     //文件
static NSString * const kWebSocketMsgTypeObj_Link                    = @"link";     //连接
static NSString * const kWebSocketMsgTypeObj_RedEnv                  = @"red_env";//  红包
static NSString * const kWebSocketMsgTypeObj_transfer                = @"transfer";// 转账
static NSString * const kWebSocketMsgTypeObj_goodsInfo               = @"goodsType";   //商品信息
//
static NSString * const kWebSocketMsgTypeObj_appmsg                  = @"appmsg";// 推送列表类型3公众号的


//
static NSString * const kWebSocketMsgTypeObj_Have_An_friendAddReq    = @"friend_req";// 好友请求 add_friend
static NSString * const kWebSocketMsgTypeObj_Friend_add_Success      = @"friend_add";//  新增好友通知
static NSString * const kWebSocketMsgTypeObj_Friend_rej_info         = @"friend_rej";//  好友请求被拒绝
//
static NSString * const kWebSocketMsgTypeKey_ReceiveAck              = @"receive_ack";// 客户端发送给服务器的确认
static NSString * const kWebSocketMsgTypeObj_ReceiveAck              = @"receive_ack";//@"receiveAck";// 客户端发送给服务器的确认
static NSString * const kWebSocketMsgTypeObj_revoke_msg              = @"revoke_msg";//撤回消息通知
static NSString * const kWebSocketMsgTypeObj_group_member_add_notice     = @"group_member_add_notice"; //群聊新增通知
static NSString * const kWebSocketMsgTypeObj_group_member_add            = @"group_member_add"; //群聊 新增了成员



//
static NSString * const kWebSocketMsgTypeKey_from_user_sys_notice    = @"sys_notice"; //from_user==系统时
static NSString * const kWebSocketMsgTypeKey_Response                = @"response";
static NSString * const kWebSocketMsgTypeObj_Response                = @"response";
static NSString * const kWebSocketMsgResponse_err_code               = @"err_code";
static NSString * const kWebSocketMsgResponse_err_info               = @"err_info";
//  发送失败 err_code=401
//  消息成功送达 err_code=0

#endif /* ChatTypeHeader_h */
