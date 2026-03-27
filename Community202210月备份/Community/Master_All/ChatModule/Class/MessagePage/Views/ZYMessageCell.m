//
//  ZYMessageCell.m
//  Community
//
//  Created by ZY on 2021/4/20.
//

#import "ZYMessageCell.h"
#import "ChatNotReadMsgModel.h"
#import "ChatFriendMessageModel.h"
#import "ChatGroupMessageModel.h"
#import "ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId.h"
@interface ZYMessageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *notiNumLabel;

@end

@implementation ZYMessageCell
//未读消息
- (void)fillDataWithDic:(NSMutableDictionary *)dic{
    ChatNotReadMsgModel *notRedModel = [ChatNotReadMsgModel mj_objectWithKeyValues:dic];
    //数量
    self.notiNumLabel.text = [NSString stringWithFormat:@"%ld",(long)notRedModel.un_read_count];
    if ([self.notiNumLabel.text intValue]==0) {
        self.notiNumLabel.hidden=YES;
        self.notiNumLabel.superview.hidden = YES;
    }else{
        self.notiNumLabel.hidden=NO;
        self.notiNumLabel.superview.hidden = NO;
    }
    //消息last_chat_msg
 
    //* 1是普通用户      * 2是群聊      * 3是公众号 （本聊天接口屏蔽公众号） 4商户 5陌生人
    if (notRedModel.to_user_type == 1 || notRedModel.to_user_type == 4 || notRedModel.to_user_type == 5) {//cell展示部分不用区分——————————好友会话和群组会话 目前展示的键值都一样
        
        //content 内容 类型
        if (notRedModel.exist_last_chat_msg) {
            ChatFriendMessageModel *msgModel = [ChatFriendMessageModel mj_objectWithKeyValues:  notRedModel.last_chat_msg];
            //time
            self.dateLabel.text = [ToolOfTimeChangeFormat getDataStrWithStr: [TextShowWithModelStr textShowWithModelStr: msgModel.create_time]];;
            if ([[notRedModel.last_chat_msg allKeys]containsObject:kWebSocketMsgType_Key_Revoke]) {
                self.contentLabel.text = @"[撤回信息]";
            }else if ([[notRedModel.last_chat_msg  allKeys] containsObject:kWebSocketMsgType_Key_Deleted]) {
                self.contentLabel.text = @"[删除信息]";
            }else{
                if ([msgModel.msg_type isEqualToString:kWebSocketMsgTypeObj_Text]) {
                    NSDictionary *msgSubDataDic = [Tool dictionaryWithJsonString:msgModel.data];
                    self.contentLabel.text = [msgSubDataDic objectForKey: @"content"];//data = "{\"content\":\"\U8fd9\U662f\U4e00\U4e2a\U6587\U672c\"}";
                }else if([msgModel.msg_type isEqualToString:kWebSocketMsgTypeObj_Image]){
                    self.contentLabel.text  = @"[图片]";
                }else if([msgModel.msg_type isEqualToString:kWebSocketMsgTypeObj_Voice]){
                    self.contentLabel.text  = @"[语音]";
                }else if([msgModel.msg_type isEqualToString:kWebSocketMsgTypeObj_Link]){
                    self.contentLabel.text  = @"[链接]";
                }else if([msgModel.msg_type isEqualToString:kWebSocketMsgTypeObj_Video]){
                    self.contentLabel.text  = @"[视频]";
                }else if([msgModel.msg_type isEqualToString:kWebSocketMsgTypeObj_Position]){
                    self.contentLabel.text  = @"[位置]";
                }else{
                    self.contentLabel.text = @"[其他]";
                }
            }
        }else{
            self.dateLabel.text = [TextShowWithModelStr textShowWithModelStr:notRedModel.last_update_time];//长文本数据 时间文本
            self.contentLabel.text = @"";//没有消息数据
        }
        //个人信息___
//        if (notRedModel.contact_type && notRedModel.to_user_type == 2 ) {//是否有联系人数据 (好友类型联系人)
//            self.nameLabel.text = [TextShowWithModelStr textShowWithModelStr: notRedModel.contact.friendRemark].length >0 ? [TextShowWithModelStr textShowWithModelStr: notRedModel.contact.friendRemark] :[TextShowWithModelStr textShowWithModelStr: notRedModel.nike_name];
//        }else{
//            self.nameLabel.text = [TextShowWithModelStr textShowWithModelStr: notRedModel.nike_name] ;
//        }
//
//        if (notRedModel.to_user_type == 4) {//商店类型
//            self.nameLabel.text = [TextShowWithModelStr textShowWithModelStr: notRedModel.nike_name];
//        }else{
//        }
//
        
        NSString *nickStr =[TextShowWithModelStr textShowWithModelStr: notRedModel.nike_name];
        NSString *friend_remarkStr =[TextShowWithModelStr textShowWithModelStr: notRedModel.friend_remark];
        if (friend_remarkStr.length>0) {
            self.nameLabel.text = friend_remarkStr;
        }else{
            self.nameLabel.text = nickStr;
        }
        if (self.nameLabel.text.length <=0 ) {
            self.nameLabel.text = @"未知昵称";
        }
        NSLog(@"msgCell NameL show n=%@ f=%@",nickStr,friend_remarkStr);
        
        NSString *getImgStr = [TextShowWithModelStr textShowWithModelStr: notRedModel.head_img_max_url];
        [self.iconImageView sd_setImageWithURL:[UrlWithString getURLWithStr: [NSString stringWithFormat:@"%@%@",BASE_Chat_Img_Default_URL,getImgStr]] placeholderImage:[UIImage imageNamed:@"My_headportrait"]];
        //
        if ([[TextShowWithModelStr textShowWithModelStr:notRedModel.from_user] isEqualToString: [TextShowWithModelStr textShowWithModelStr:notRedModel.to_user]] && [TextShowWithModelStr textShowWithModelStr: notRedModel.from_user].length>0)  {//自己和自己的对话
            self.nameLabel.text =  @"我";
            NSString *getImgStr = [TextShowWithModelStr textShowWithModelStr: [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].chatUserMyOwn.headImgMaxUrl];
            [self.iconImageView sd_setImageWithURL:[UrlWithString getURLWithStr: [NSString stringWithFormat:@"%@%@",BASE_Chat_Img_Default_URL,getImgStr]] placeholderImage:[UIImage imageNamed:@"My_headportrait"]];
        }
        
    }else if (notRedModel.to_user_type == 2) {//群组未读
        DLog(@"群组未读");
      
        //content 内容 类型
        if (notRedModel.exist_last_chat_msg) {
            ChatGroupMessageModel *msgModel = [ChatGroupMessageModel mj_objectWithKeyValues:notRedModel.last_chat_msg];
            //time
            self.dateLabel.text = [ToolOfTimeChangeFormat getDataStrWithStr: [TextShowWithModelStr textShowWithModelStr: msgModel.create_time]];
            if ([[notRedModel.last_chat_msg allKeys]containsObject:kWebSocketMsgType_Key_Revoke]) {
                self.contentLabel.text = @"[撤回信息]";
            }else if ([[notRedModel.last_chat_msg  allKeys] containsObject:kWebSocketMsgType_Key_Deleted]) {
                self.contentLabel.text = @"[删除信息]";
            }else{
                if ([msgModel.msg_type isEqualToString:kWebSocketMsgTypeObj_Text]) {
    //                self.contentLabel.text = [[[NSDictionary alloc]initWithDictionary:msgModel.text] objectForKey: @"content"];//旧
                    NSDictionary *msgSubDataDic = [Tool dictionaryWithJsonString:msgModel.data];
                    self.contentLabel.text = [msgSubDataDic objectForKey: @"content"];
                }else if([msgModel.msg_type isEqualToString:kWebSocketMsgTypeObj_Image]){
                    self.contentLabel.text  = @"[图片]";
                }else if([msgModel.msg_type isEqualToString:kWebSocketMsgTypeObj_Voice]){
                    self.contentLabel.text  = @"[语音]";
                }else if([msgModel.msg_type isEqualToString:kWebSocketMsgTypeObj_Link]){
                    self.contentLabel.text  = @"[链接]";
                }else if([msgModel.msg_type isEqualToString:kWebSocketMsgTypeObj_group_member_add]){
                    self.contentLabel.text = @"[新成员加入]";
                }else if([msgModel.msg_type isEqualToString:kWebSocketMsgTypeObj_Video]){
                    self.contentLabel.text  = @"[视频]";
                }else if([msgModel.msg_type isEqualToString:kWebSocketMsgTypeObj_Position]){
                    self.contentLabel.text  = @"[位置]";
                }else{
                    self.contentLabel.text = @"[其他]";
                }
            }
        }else{
            self.dateLabel.text = [TextShowWithModelStr textShowWithModelStr:notRedModel.last_update_time];//长文本数据 时间文本
            self.contentLabel.text = @"";//没有消息数据
        }
    
        //群头像昵称新版本暂时不确定
        self.nameLabel.text = [TextShowWithModelStr textShowWithModelStr: notRedModel.nike_name];
        NSString *getImgStr = [TextShowWithModelStr textShowWithModelStr: notRedModel.head_img_max_url];
        [self.iconImageView sd_setImageWithURL:[UrlWithString getURLWithStr: [NSString stringWithFormat:@"%@%@",BASE_Chat_Img_Default_URL,getImgStr]] placeholderImage:[UIImage imageNamed:@"My_headportrait"]];

       
    }else{//其他类型消息  公众号暂屏蔽 notRedModel.to_user_type == 3
        
    }
  
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    // 图片切圆角
    [self.iconImageView zy_cornerRadiusAdvance:self.iconImageView.bounds.size.width / 2 rectCornerType:UIRectCornerAllCorners];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
