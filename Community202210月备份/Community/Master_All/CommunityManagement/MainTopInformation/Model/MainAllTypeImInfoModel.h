//
//  MainAllTypeImInfoModel.h
//  Community
//
//  Created by 余莹 on 2021/9/4.
//

#import <Foundation/Foundation.h>
#import "MainImInfoSubMsgModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MainAllTypeImInfoModel : NSObject
@property (nonatomic,assign) BOOL has_mentioned;
@property (nonatomic,assign) BOOL is_del;
@property (nonatomic,assign) BOOL is_top;
@property (nonatomic,assign) BOOL notification_status;
//@property (nonatomic,assign) NSInteger id;
@property (nonatomic,assign) NSInteger ID;
@property (nonatomic,assign) NSInteger to_user_type; //to_user_type 对方账号类型；     * 1是普通用户      * 2是群聊      * 3是公众号 4 、商家proxy，对应商家客服体系账号）
@property (nonatomic,assign) NSInteger un_read_count;
@property (nonatomic,assign) NSInteger type;//2 支付类型 1文本类型

@property (nonatomic,strong) NSString *create_time;
@property (nonatomic,strong) NSString *from_user;
@property (nonatomic,strong) NSString *head_img_max_url;
@property (nonatomic,strong) NSString *head_img_small_url;
@property (nonatomic,strong) NSString *last_msg_id;
@property (nonatomic,strong) NSString *last_update_time;
@property (nonatomic,strong) NSString *mentioned_text_info;
@property (nonatomic,strong) NSString *nike_name;
@property (nonatomic,strong) NSString *session_id;
@property (nonatomic,strong) NSString *to_user;
@property (nonatomic,strong) NSString *im_id;

@property (nonatomic,strong) MainImInfoSubMsgModel *last_chat_msg;

@property (nonatomic,strong) ChatFriendModel *contact;//和联系列表一样部分数据 属性可能不同   ********************* [type = 5是陌生人];

//0910增
@property (nonatomic,assign) BOOL exist_last_chat_msg;//是否存在最后一条信息数据last_chat_msg是否存在
@property (nonatomic,assign) BOOL contact_type;//0表示不存在联系人关系contact是否存在

//___
@property (nonatomic,strong) NSString *messagelistWillShowDetailText;//好友类型群类型系统公众号类型
 
/**
 
 {
"from_user" = "zhsj_cf70684e984e462aa98e33f546323c49@user";
"has_mentioned" = 0;
"head_img_max_url" = "headImgMaxUrls.png";
"head_img_small_url" = "headImgSmallUrls.png";
id = 1433770928499732499;
"is_del" = 0;
"is_top" = 0;
"last_chat_msg" =             {
 "create_date" = "2021-09-04 14:54:20";
 "create_time" = 1630738459612;
 data = "{\"content\":\"\U98de\U98de\U98de\"}";
 "encrypt_flag" = 0;
 format = 1;
 "from_user" = "zhsj_daebe5eed88441468b4ab4ad111048bf@user";
 "msg_id" = bb4aa1da47334a528e5ad491fad909dc;
 "msg_ser_id" = 1434047150169399297;
 "msg_type" = text;
 "sdk_ver" = 0;
 "sequence_id" = 7;
 "session_id" = "s1v1_5476e0c1917f7d476c8bc914d830e8fe";
 "sub_type" = 0;
 "to_user" = "zhsj_cf70684e984e462aa98e33f546323c49@user";
 "total_count" = 0;
 "un_read_count" = 0;
};
"last_msg_id" = bb4aa1da47334a528e5ad491fad909dc;
"last_update_time" = "2021-09-04 14:54:18";
"mentioned_text_info" = "";
"nike_name" = " \U94f6\U5e0c";
"notification_status" = 0;
"session_id" = "s1v1_5476e0c1917f7d476c8bc914d830e8fe";
"to_user" = "zhsj_daebe5eed88441468b4ab4ad111048bf@user";
"to_user_type" = 1;
"un_read_count" = 7;
}
 */
@end

NS_ASSUME_NONNULL_END
