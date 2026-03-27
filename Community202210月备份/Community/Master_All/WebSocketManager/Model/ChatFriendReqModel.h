//
//  ChatFriendReqModel.h
//  Community
//
//  Created by 余莹 on 2021/4/27.
// 好友通知列表 请求好友同意拒绝的列表 cellmodel 

#import <Foundation/Foundation.h>
#import "ChatFriendReqModelSubRemarkModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatFriendReqModel : NSObject
//旧
//@property (nonatomic,strong) NSString *create_time;
//@property (nonatomic,strong) NSString *update_time;
//@property (nonatomic,strong) NSString *open_id;
//@property (nonatomic,strong) NSString *sequence_id;
//@property (nonatomic,strong) NSString *origin;
//@property (nonatomic,strong) NSString *friendRemark;
//@property (nonatomic,strong) NSString *fromAvatar;
//@property (nonatomic,strong) NSString *fromName;
//@property (nonatomic,strong) NSString *from_user;
//@property (nonatomic,strong) NSString *to_user;
//@property (nonatomic,strong) NSString *toAvatar;
//@property (nonatomic,strong) NSString *toName;
//@property (nonatomic,strong) NSArray *verifyMessage;
//
//@property (nonatomic,assign) NSInteger status;
//@property (nonatomic,assign) NSInteger id;
//@property (nonatomic,assign) NSInteger accountBalance;

//0909改
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *friendAccount;
//@property (nonatomic,strong) NSString *friendRemark;//这个键（对方的 给用户 做的新备注昵称）不能用于列表显示
@property (nonatomic,strong) NSString *headImgMaxUrl;
@property (nonatomic,strong) NSString *headImgSmallUrl;
@property (nonatomic,strong) NSString *imId;
@property (nonatomic,strong) NSString *nickName;
@property (nonatomic,strong) NSString *userAccount;
@property (nonatomic,strong) ChatFriendReqModelSubRemarkModel *remark;

@property (nonatomic,assign) NSInteger id;
@property (nonatomic,assign) NSInteger isRead;
@property (nonatomic,assign) NSInteger origin;
@property (nonatomic,assign) NSInteger verifyFlag;
 

 
/**
 createTime = "2021-09-04 18:02:56";
 friendAccount = "zhsj_e9b158bc223f4851b2bb5ef212394ce8@user";
 friendRemark = "java\U540e\U53f0\U6d4b\U8bd53";
 headImgMaxUrl = "https://img1.baidu.com/it/u=2298484978,1703903334&fm=26&fmt=auto&gp=0.jpg";
 headImgSmallUrl = "https://img1.baidu.com/it/u=2298484978,1703903334&fm=26&fmt=auto&gp=0.jpg";
 id = 1434094619309285386;
 imId = 34535567562;
 isRead = 0;
 nickName = " \U6c9b\U4fca";
 origin = 1;
 remark =     (
             {
         createTime = "2021-09-04 18:02:56";
         message = "\U4f60\U597d\Uff01";
         speaker = "test_0002";
     }
 );
 userAccount = "zhsj_36bb529de58844bcaf77710c41cff199@user";
 verifyFlag = 3;
 
 friendRemark    string
 非必须
 好友备注
 verifyFlag    number
 非必须
 验证状态；好友验证状态：1已添加，2已同意对方为好友，3已拒绝对方，4对方已同意，5对方已拒绝，6等待我方操作 同意、拒绝
 createTime    string
 非必须
 创建时间
 userAccount    string
 非必须
 我方聊天号（from_user）
 origin    number
 非必须
 来源
 isRead    boolean
 非必须
 本条好友通知是否已读
 remark    object []
 非必须
 回复信息
 item 类型: object
 createTime    string
 必须
 消息发出时间
 speaker    string
 必须
 说话者（字符串-直接展示）
 message    string
 必须
 消息
 id    number
 非必须
     好友通知ID
 imId    string
 非必须
 对方IMID
 friendAccount    string
 非必须
     对方聊天号（to_user）    */

/***
 //@property (nonatomic,strong) NSString *fromAvatarMediaId;
 //@property (nonatomic,strong) NSString *fromNickname;
 //@property (nonatomic,strong) NSString *toAvatarMediaId;
 //@property (nonatomic,strong) NSString *toNickname;
 //@property (nonatomic,assign) NSInteger rejStatus;

 
 "create_time" = 1620788989566;
 friendRemark = "\U6ef4\U6ef4\U6ef4";
 fromAvatar = "2021-02-10/9ac8268a449443c4bff6c3f88775d147-1612951479379.jpg";
 fromName = "\U6309\U65f6\U53d1\U65af\U8482\U82ac\U7684";
 "from_user" = a23fd9e4c4b146719a8bc61ff22a7181;
 "open_id" = ef26775d663f4d4c9ac21855e97f16f2;
 origin = "\U4e8c\U7ef4\U7801";
 "sequence_id" = 2;
 status = 2;
 toAvatar = "2021-02-10/9ac8268a449443c4bff6c3f88775d147-1612951479379.jpg";
 toName = "\U9ed8\U8ba4\U6635\U79f0";
 "to_user" = de2bda7200b6439181b354f468da155b;
 "update_time" = 1620788989566;
 verifyMessage =     (
     "\U6309\U65f6\U53d1\U65af\U8482\U82ac\U7684: \U6211\U7684\U7559\U8a00"
 );
*/
@end

NS_ASSUME_NONNULL_END
