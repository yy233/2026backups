//
//  ChatUserModel.h
//  Community
//
//  Created by 余莹 on 2021/4/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatUserModel : NSObject
//旧
//@property (nonatomic,strong) NSString *userUuid;
//@property (nonatomic,strong) NSString *userStr;
//@property (nonatomic,strong) NSString *userNickname;
@property (nonatomic,strong) NSString *openId;
@property (nonatomic,strong) NSString *notice;
//@property (nonatomic,strong) NSString *avatarMediaId;
@property (nonatomic,strong) NSString *autograph;//个性签名
@property (nonatomic,assign) NSInteger state;
@property (nonatomic,assign) NSInteger id;
@property (nonatomic,assign) NSInteger accountBalance;
@property (nonatomic,strong) NSString *personalBackground;//好友聊天默认背景图,群聊未设置当前群背景时的背景图片
//———————— 新
//0908 用户个人信息
@property (nonatomic,assign) NSInteger sex;
@property (nonatomic,assign) BOOL allowAnonymousChat;
@property (nonatomic,assign) BOOL married;
@property (nonatomic,assign) NSInteger age;
@property (nonatomic,strong) NSString *account; //自己账户信息
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *updateTime;

//0906 好友列表用户信息_____
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *headImgMaxUrl;
@property (nonatomic,strong) NSString *headImgSmallUrl;
@property (nonatomic,strong) NSString *nickName;
@property (nonatomic,strong) NSString *otherAccount;//他账户信息
@property (nonatomic,strong) NSString *userAccount;//自己账户信息
@property (nonatomic,strong) NSString *imId; //用于后续请求时（旧版用uuid即account）

@property (nonatomic,assign) NSInteger hatroomNotify;
@property (nonatomic,assign) NSInteger delFlag;
//@property (nonatomic,assign) NSInteger id;
@property (nonatomic,assign) NSInteger membersMute;
@property (nonatomic,assign) NSInteger otherPullBlackMe;
@property (nonatomic,assign) NSInteger pullBlackOther;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,assign) NSInteger verifyFlag;

/**
 * 0906 好友列表用户信息 
 chatroomNotify = 0;
 createTime = "2021-09-07 10:21:33";
 delFlag = 0;
 "head_img_max_url" = "https://img1.baidu.com/it/u=2298484978,1703903334&fm=26&fmt=auto&gp=0.jpg";
 "head_img_small_url" = "https://img1.baidu.com/it/u=2298484978,1703903334&fm=26&fmt=auto&gp=0.jpg";
 id = 1435065672114782209;
 imId = c116ceaba26411ebb476002590f3d4a8;
 membersMute = 0;
 nickName = " \U4f2f\U80dc";
 otherAccount = "zhsj_242f36c5f4544376b76e399147f106ae@user";
 otherPullBlackMe = 0;
 pullBlackOther = 0;
 type = 5;
 userAccount = "zhsj_36bb529de58844bcaf77710c41cff199@user";
 verifyFlag = 3;
 
 
 */
/**
 (lldb) po dic
 {0906 个人信息格式
 accountBalance = 0;
 autograph = "\U9ed8\U8ba4\U4e2a\U6027\U7b7e\U540d";
 avatarMediaId = "2021-02-10/9ac8268a449443c4bff6c3f88775d147-1612951479379.jpg";
 id = 10379;
 notice = "\U9ed8\U8ba4\U63cf\U8ff0";
 openId = "open_7dcad41c19c24e7da0a61ab465c58bc0";
 state = 1;
 userNickname = "\U9ed8\U8ba4\U6635\U79f0";
 userStr = 0ea7b3fb119c4bb68ce351b976de5b6e;
 userUuid = "zhsj_36bb529de58844bcaf77710c41cff199@user";
 旧
     accountBalance = 0;
     autograph = "\U9ed8\U8ba4\U4e2a\U6027\U7b7e\U540d";
     avatarMediaId = "2021-02-10/9ac8268a449443c4bff6c3f88775d147-1612951479379.jpg";
     id = 10293;
     notice = "\U9ed8\U8ba4\U63cf\U8ff0";
     openId = ef26775d663f4d4c9ac21855e97f16f2;
     state = 1;
     userNickname = "\U9ed8\U8ba4\U6635\U79f0";
     userStr = c116ceaba26411ebb476002590f3d4a8;
     userUuid = be2103f6b74f440c93c4dd8c5d2402b7;
 }*/
@end

NS_ASSUME_NONNULL_END
