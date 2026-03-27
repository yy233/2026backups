//
//  ChatFriendMessageModel.h
//  Community
//
//  Created by 余莹 on 2021/4/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatFriendMessageModel : NSObject
//@property (nonatomic,strong) NSString *to_user;
//
//@property (nonatomic,strong) NSString *create_time;
//@property (nonatomic,strong) NSString *from_user;
//@property (nonatomic,strong) NSString *sequence_id;
//@property (nonatomic,strong) NSString *msg_id;
@property (nonatomic,strong) NSString *noSynchronizedDevice;
//@property (nonatomic,strong) NSString *msg_type;
// msg_type
//@property (nonatomic,strong) NSDictionary *text; //新版只有data
//@property (nonatomic,strong) NSDictionary *image;
//@property (nonatomic,strong) NSDictionary *voice;

//_______ 新版本 数据
//0913
@property (nonatomic,strong) NSString *create_date;
@property (nonatomic,strong) NSString *create_time;
@property (nonatomic,strong) NSString *data;
@property (nonatomic,strong) NSString *from_user;
@property (nonatomic,strong) NSString *msg_id;
@property (nonatomic,strong) NSString *msg_type;
@property (nonatomic,strong) NSString *session_id;
@property (nonatomic,strong) NSString *to_user;
@property (nonatomic,strong) NSString *sequence_id;
@property (nonatomic,strong) NSString *msg_ser_id;

@property (nonatomic,assign) NSInteger format;
@property (nonatomic,assign) NSInteger sdk_ver;
@property (nonatomic,assign) NSInteger sub_type;
@property (nonatomic,assign) NSInteger total_count;
@property (nonatomic,assign) NSInteger un_read_count;

@property (nonatomic,assign) BOOL encrypt_flag;
@property (nonatomic,assign) BOOL is_revoke;//是否撤回
//220324 已读次数 昵称 头像
@property (nonatomic,assign) NSInteger read_count;
@property (nonatomic,copy) NSString *from_acc_headImg;
@property (nonatomic,copy) NSString *from_acc_name;

/**
 "create_date" = "2022-03-28 13:35:51";
 "create_time" = 1648445750717;
 data = "{\"latitude\":\"29.603873\",\"addr_str\":\"\U91cd\U5e86\U5e02\U6e1d\U5317\U533a\U68a7\U6850\U8def106\U53f7\U9760\U8fd1\U5929\U5bab\U6bbf\U8857\U9053\U529e\U4e8b\U5904\",\"longitude\":\"106.555887\"}";
 "encrypt_flag" = 0;
 "extra_data" = "{}";
 format = 1;
 "from_acc_headImg" = "http://192.168.12.49:8090/zhsj/base/api/file/down/load?f=90bf2445-cd44-4ebc-bd51-838c27464ff4";
 "from_acc_name" = "\U554a\U554a\U554a\U554a";
 "from_user" = "zhsj_25ba7d17fcff4d81b950739fdbd09b58@user";
 "is_revoke" = 0;
 "msg_id" = 25252236cf6b488dad8dc9cea642c5f9;
 "msg_ser_id" = 1508316925618999298;
 "msg_type" = position;
 "read_count" = 0;
 "sdk_ver" = 1;
 "sequence_id" = 11;
 "session_id" = "cpk_5752ae2fd439acd2c7cdd10d5389a95d";
 "sub_type" = 0;
 "to_user" = "zhsj_4d9cb0a515a5449f85e3660607d528c6@proxy";
 "total_count" = 0;
 */
@end

NS_ASSUME_NONNULL_END
