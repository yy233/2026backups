//
//  ChatMessageListVcShowUseNotReadMsgModel.h
//  Community
//
//  Created by 余莹 on 2022/3/26.
//ChatMessageListVcShowUseNotReadMsgModel 是 ChatNotReadMsgModel 的新版本 暂未使用 数据例子存放

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatMessageListVcShowUseNotReadMsgModel : NSObject
 

////**
 
// "un_read_count" = 1;
//},
// {
// contact =         {
//     chatroomNotify = 0;
//     createTime = "2022-03-14 14:16:01";
//     delFlag = 0;
//     friendRemark = "";
//     id = 1503253595208429570;
//     imId = e57669;
//     membersMute = 0;
//     otherAccount = "zhsj_d5cee9a261204d4fab26c0c28f996757@user";
//     otherPullBlackMe = 0;
//     pullBlackOther = 0;
//     type = 1;
//     userAccount = "zhsj_25ba7d17fcff4d81b950739fdbd09b58@user";
//     verifyFlag = 9;
// };
// "contact_id" = 1503253595208429570;
// "contact_type" = 1;
// delSequenceId = "-1";
// endSequenceId = 9223372036854775807;
// "exist_last_chat_msg" = 1;
// "friend_remark" = "";
// "from_user" = "zhsj_25ba7d17fcff4d81b950739fdbd09b58@user";
// "has_mentioned" = 0;
// "head_img_max_url" = "http://192.168.12.49:8090/zhsj/base/api/file/down/load?f=1600a51c-f355-42fb-899c-c09ba50f8a36";
// "head_img_small_url" = "http://192.168.12.49:8090/zhsj/base/api/file/down/load?f=1600a51c-f355-42fb-899c-c09ba50f8a36";
// id = 1503253595317555202;
// "im_id" = e57669;
// "is_del" = 0;
// "is_top" = 0;
// "last_chat_msg" =         {
//     "create_date" = "2022-03-23 14:54:23";
//     "create_time" = 1648018463047;
//     data = "{\"content\":\"\Uff0c\"}";
//     "encrypt_flag" = 0;
//     "extra_data" = "{}";
//     format = 1;
//     "from_user" = "zhsj_25ba7d17fcff4d81b950739fdbd09b58@user";
//     "is_revoke" = 0;
//     "msg_id" = 76e945f32298462c9c77c01606cfec77;
//     "msg_ser_id" = 1506524743748714498;
//     "msg_type" = text;
//     "read_count" = 0;
//     "sdk_ver" = 1;
//     "sequence_id" = 50;
//     "session_id" = "s1v1_5747ad60f10c35b44c69c17886d7ce17";
//     "sub_type" = 0;
//     "to_user" = "zhsj_d5cee9a261204d4fab26c0c28f996757@user";
//     "total_count" = 0;
// };
// "last_update_time" = "2022-03-23 14:54:23";
// "nike_name" = "\U7070\U5316\U80a5\U6325\U53d1\U4f1a\U53d1\U9ed1";
// "notification_status" = 0;
// "session_id" = "s1v1_5747ad60f10c35b44c69c17886d7ce17";
// "to_user" = "zhsj_d5cee9a261204d4fab26c0c28f996757@user";
// "to_user_type" = 1;
// "un_read_count" = 0;
//},
// {
// */

//@property (nonatomic,strong) MainImInfoSubMsgModel *last_chat_msg;//推送消息用model 本聊天主页用dic
@property (nonatomic,strong) NSDictionary *last_chat_msg;//推送消息用model 本聊天主页用dic
@property (nonatomic,strong) ChatFriendModel *contact;
@property (nonatomic,copy) NSString *contact_type;
//@property (nonatomic,copy) NSString *contact_id;
//@property (nonatomic,copy) NSString *contact_type;
//@property (nonatomic,copy) NSString *exist_last_chat_msg;
//@property (nonatomic,copy) NSString *friend_remark;
//@property (nonatomic,copy) NSString *from_user;
//@property (nonatomic,copy) NSString *;
//@property (nonatomic,copy) NSString *;
//@property (nonatomic,copy) NSString *;
//@property (nonatomic,copy) NSString *;
//@property (nonatomic,copy) NSString *;
//@property (nonatomic,copy) NSString *;
//@property (nonatomic,copy) NSString *;
//@property (nonatomic,copy) NSString *;
//@property (nonatomic,copy) NSString *;
//@property (nonatomic,copy) NSString *;
//@property (nonatomic,copy) NSString *;
//@property (nonatomic,copy) NSString *;
//@property (nonatomic,copy) NSString *;
//@property (nonatomic,copy) NSString *;
//@property (nonatomic,copy) NSString *;
//@property (nonatomic,copy) NSString *;
//@property (nonatomic,copy) NSString *;
//@property (nonatomic,copy) NSString *;
//@property (nonatomic,copy) NSString *;
//@property (nonatomic,copy) NSString *;
//@property (nonatomic,copy) NSString *;
//@property (nonatomic,copy) NSString *;
//@property (nonatomic,copy) NSString *;
//@property (nonatomic,copy) NSString *;
//@property (nonatomic,copy) NSString *;
//@property (nonatomic,assign) NSInteger ;
//
@end

NS_ASSUME_NONNULL_END
