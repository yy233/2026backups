//
//  MainAllTypeImInfoModel.m
//  Community
//
//  Created by 余莹 on 2021/9/4.
//

#import "MainAllTypeImInfoModel.h"

@implementation MainAllTypeImInfoModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"last_chat_msg":[MainImInfoSubMsgModel class]};
}

- (NSString *)messagelistWillShowDetailText{
    if (!_messagelistWillShowDetailText) {
        _messagelistWillShowDetailText = @"";
    }
    //好友类型
    //0408 增加
    //客服类型 陌生人类型
    if ((self.to_user_type == 1) || (self.to_user_type == 4) || (self.to_user_type == 5)) {
        if ([self.last_chat_msg.msg_type  isEqualToString: kWebSocketMsgTypeObj_Text]) {
            NSDictionary *dic = [Tool dictionaryWithJsonString:self.last_chat_msg.data];
            _messagelistWillShowDetailText = [[dic allKeys]containsObject: kWebSocketMsgTypeObj_Content] ? [dic objectForKey:kWebSocketMsgTypeObj_Content] : [dic objectForKey:kWebSocketMsgTypeObj_Text];
        }else if ([self.last_chat_msg.msg_type  isEqualToString: kWebSocketMsgTypeObj_Image]){
            _messagelistWillShowDetailText = @"[图片]";
        }else if ([self.last_chat_msg.msg_type  isEqualToString: kWebSocketMsgTypeObj_Voice]){
            _messagelistWillShowDetailText = @"[语音]";
        }else if ([self.last_chat_msg.msg_type  isEqualToString: kWebSocketMsgTypeObj_Position]){
            _messagelistWillShowDetailText = @"[位置]";
        }else if ([self.last_chat_msg.msg_type  isEqualToString: kWebSocketMsgTypeObj_Video]){
            _messagelistWillShowDetailText = @"[视频]";
        }else if ([self.last_chat_msg.msg_type  isEqualToString: kWebSocketMsgTypeObj_Link]){
            _messagelistWillShowDetailText = @"[链接]";
        }else if ([self.last_chat_msg.msg_type  isEqualToString: kWebSocketMsgTypeObj_File]){
            _messagelistWillShowDetailText = @"[文件]";
        }else if ([self.last_chat_msg.msg_type  isEqualToString: kWebSocketMsgTypeObj_Image]){
            _messagelistWillShowDetailText = @"[其他]";
        }
    }
    //公众号类型
    if (self.to_user_type == 3) {
        if ([self.last_chat_msg.msg_type  isEqualToString: kWebSocketMsgTypeObj_appmsg]) {
            NSDictionary *dic = [Tool dictionaryWithJsonString:self.last_chat_msg.data];
            if ([[dic allKeys]containsObject:@"pay_amount"]) {
                _messagelistWillShowDetailText = [[dic allKeys]containsObject: @"desc"] ?  [dic objectForKey:@"desc"] : [dic objectForKey:kWebSocketMsgTypeObj_Content];
            }else{
                _messagelistWillShowDetailText = [[dic allKeys]containsObject: kWebSocketMsgTypeObj_Content] ? [dic objectForKey:kWebSocketMsgTypeObj_Content] : [dic objectForKey:@"desc"];
            }
//            if ([[dic allKeys]containsObject:@"pay_amount"]) {
//            }
        }
    }
   
    
    
    return _messagelistWillShowDetailText;
}

//////
//"{\"appinfo\"
//:{\"version\"
//    :\"1\"},\
//    "links\":[{\"url\":\"www.baidu.com\",\"desc\":\"\U67e5\U770b\U623f\U5c4b\U4fe1\U606f\"}],
//    \"template_id\":\"\U6682\U65e0\U6a21\U677f\",
//    \"title\":\"\U623f\U5c4b\U79df\U8d41\",
//    \"type\":1,\
//    "content\":\"\U4f60\U7684\U623f\U5c4b\U5df2\U7ecf\U7531xxx\U51fa\U79df\U4e86\Uff01\U8d76\U5feb\U67e5\U770b\U5427\",
//    \"url\":\"www.baidu.com\",
//    \"desc\":\"\U623f\U5c4b\U51fa\U79df\U63d0\U9192\"}";


//_____//    \"sub_im_id\":\"monthlyRentPayment\",
//{\"sub_name\":\"\U6708\U79df\U7f34\U8d39\",
//    \"pay_amount\":\"200\",\
//    "title\":\"\U652f\U4ed8\U901a\U77e5\"
//    ,\"type\":2,
//    \"content\":\"\
//    ",\"url\":\"www.baidu.com\",
//    \"sub_head_img_url\":\"www.baidu.com\",
//    \"sub_im_id\":\"monthlyRentPayment\",
//    \"appinfo\":{\"version\":\"1\"},\"currency\":\"RMB\",\"links\":[{\"url\":\"www.baidu.com\",
//    \"desc\":\"\U67e5\U770b\U8d26\U5355\U8be6\U60c5\"}],
//    \"pay_type\":\"\U5fae\U4fe1\U652f\U4ed8\"
//    ,\"template_id\":\"\"
//    ,\"desc\":\"\U623f\U5c4b\U7f34\U8d39\"}";
@end
