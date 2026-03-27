//
//  ChatNotReadMsgModel.h
//  Community
//
//  Created by 余莹 on 2021/4/28.
//

#import <Foundation/Foundation.h>
#import "ChatFriendModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ChatNotReadMsgModel : NSObject
 
/****
 *to from 只用于判断当前是不是好友会话类型 f键值一直是自己 to键值是别人
 */
//@property (nonatomic,strong) NSString *avatarMediaId;
//@property (nonatomic,strong) NSString *remark;//备注 昵称
//@property (nonatomic,assign) NSInteger unreadTotal;//未读数量
//@property (nonatomic,strong) NSArray *messages;//消息 元素数组
////


@property (nonatomic,strong) NSString *from_user;   //______这是自己ID数据。
@property (nonatomic,strong) NSString *to_user;     //——————————这是对方ID数据
@property (nonatomic,strong) NSString *to_group;    //——————————这是群类型数据

//留存上 不一定有该数据
//0908改为 --MainAllTypeImInfoModel一样

@property (nonatomic,assign) BOOL has_mentioned;
@property (nonatomic,assign) BOOL is_del;
@property (nonatomic,assign) BOOL is_top;
@property (nonatomic,assign) BOOL notification_status;

//@property (nonatomic,assign) NSInteger id;
@property (nonatomic,assign) NSInteger ID;
@property (nonatomic,strong) NSString *im_id;

@property (nonatomic,assign) NSInteger to_user_type; //to_user_type 对方账号类型；     【 * 1是普通用户      * 2是群聊      * 3是公众号 （本聊天接口屏蔽公众号）】     to_user_type   多了个  （4 、商家proxy，对应商家客服体系账号）
@property (nonatomic,assign) NSInteger un_read_count;
@property (nonatomic,assign) NSInteger type;//2 支付类型 1文本类型
//@property (nonatomic,strong) NSString *from_user;
@property (nonatomic,strong) NSString *head_img_max_url;
@property (nonatomic,strong) NSString *head_img_small_url;
@property (nonatomic,strong) NSString *last_msg_id;
@property (nonatomic,strong) NSString *last_update_time;
@property (nonatomic,strong) NSString *mentioned_text_info;
@property (nonatomic,strong) NSString *nike_name;
@property (nonatomic,strong) NSString *friend_remark;
@property (nonatomic,strong) NSString *session_id;
//@property (nonatomic,strong) NSString *to_user;

//@property (nonatomic,strong) MainImInfoSubMsgModel *last_chat_msg;//推送消息用model 本聊天主页用dic
@property (nonatomic,strong) NSDictionary *last_chat_msg;
@property (nonatomic,strong) ChatFriendModel *contact;//和联系列表一样部分数据 属性可能不同   ********************* [type = 5是陌生人];

//0910增
@property (nonatomic,assign) BOOL exist_last_chat_msg;//是否存在最后一条信息数据last_chat_msg是否存在
@property (nonatomic,assign) NSInteger contact_type;//0表示不存在联系人关系contact是否存在  //联系人类型：0 表示不存联系人关系（不可聊天），1:好友、2、群、3、订阅号、服务号、5陌生人(可聊天)


/**
 contact =         {
     chatroomNotify = 0;
     createTime = "2021-09-07 10:21:33";
     delFlag = 0;
     friendRemark = "\U4f2f\U80dc\U5907\U6ce8";
     id = 1435065672114782209;
     imId = c116ceaba26411ebb476002590f3d4a8;
     membersMute = 0;
     otherAccount = "zhsj_242f36c5f4544376b76e399147f106ae@user";
     otherPullBlackMe = 0;
     pullBlackOther = 0;
     type = 5;
     userAccount = "zhsj_36bb529de58844bcaf77710c41cff199@user";
     verifyFlag = 3;
 };
 //        未读消息列表 区分分好友 (////留存
 avatarMediaId = "2021-02-10/9ac8268a449443c4bff6c3f88775d147-1612951479379.jpg";
 "from_user" = e5778bdaa9b747d5b6bb1d39c90a9ba7;
 messages =     (
             {
         "create_time" = 1619596594228;
         "from_user" = 2a314f0322884e1b927e89a636ac0ec2;
         "msg_id" = zltxcokqjfgahzcustnjpphadvyuiege;
         "msg_type" = text;
         noSynchronizedDevice = mobile;
         "sequence_id" = 2;
         text =             {
             content = "\U6d4b\U8bd5\U4e00\U4e0b";
         };
         "to_user" = e5778bdaa9b747d5b6bb1d39c90a9ba7;
     },
             {
         "create_time" = 1619596590508;
         "from_user" = 2a314f0322884e1b927e89a636ac0ec2;
         "msg_id" = qstjnrerjoweqgqdyebufabajbgjjuef;
         "msg_type" = text;
         noSynchronizedDevice = mobile;
         "sequence_id" = 1;
         text =             {
             content = "\U6d4b\U8bd5";
         };
         "to_user" = e5778bdaa9b747d5b6bb1d39c90a9ba7;
     }
 );
 remark = "\U540c\U610f\U52a0\U597d\U53cb\U7684\U5907\U6ce8";
 "to_user" = 2a314f0322884e1b927e89a636ac0ec2;
 total = 2;
 unreadTotal = 2;
 
  
  {
      avatarMediaId = "2021-05-06/f7de7a28183240d7977c850a594ea07e.jpg";
      "from_user" = 2a314f0322884e1b927e89a636ac0ec2;
      messages =     (
                  {
              "create_time" = 1620290431159;
              "from_user" = 2a314f0322884e1b927e89a636ac0ec2;
              "msg_id" = sesgojhprhfokfsesfgfpbtydbjunqnj;
              "msg_type" = text;
              noSynchronizedDevice = mobile;
              "sequence_id" = 3;
              text =             {
                  content = 2;
              };
              "to_group" = 20235b866d9f47bfbed4dbedf5ebe41b;
          },
                  {
              "create_time" = 1620288646098;
              "from_user" = 2a314f0322884e1b927e89a636ac0ec2;
              "msg_id" = vszarkflkcdheqvyhylnocplfpxqdpoi;
              "msg_type" = text;
              noSynchronizedDevice = mobile;
              "sequence_id" = 2;
              text =             {
                  content = 1;
              };
              "to_group" = 20235b866d9f47bfbed4dbedf5ebe41b;
          },
                  {
              "create_time" = 1620281896871;
              "from_user" = "sys_notice";
              "group_member_add" =             {
                  "group_member" = e5778bdaa9b747d5b6bb1d39c90a9ba7;
                  "invite_people" = 2a314f0322884e1b927e89a636ac0ec2;
                  style = "member_invite";
              };
              "msg_id" = 89a171c07b654d16af32577cf14fa37a;
              "msg_type" = "group_member_add";
              "sequence_id" = 1;
              "to_group" = 20235b866d9f47bfbed4dbedf5ebe41b;
          }
      );
      remark = "1\U7fa4\U65b0\U540d\U5b57test1";
      "to_group" = 20235b866d9f47bfbed4dbedf5ebe41b;
      total = 3;
      unreadTotal = 0;
  }
 
 
 */
@end

NS_ASSUME_NONNULL_END
