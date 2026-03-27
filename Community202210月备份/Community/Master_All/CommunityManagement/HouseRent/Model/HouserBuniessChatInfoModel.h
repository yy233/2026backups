//
//  HouserBuniessChatInfoModel.h
//  Community
//
//  Created by 余莹 on 2021/7/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HouserBuniessChatInfoModel : NSObject
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *head_img_max_url;
@property (nonatomic,strong) NSString *head_img_small_url;
@property (nonatomic,strong) NSString *nickName;
@property (nonatomic,strong) NSString *otherAccount;
@property (nonatomic,strong) NSString *userAccount;
@property (nonatomic,strong) NSString *imId;

@property (nonatomic,assign) NSInteger hatroomNotify;
@property (nonatomic,assign) NSInteger delFlag;
//@property (nonatomic,assign) NSInteger id;
@property (nonatomic,assign) NSInteger ID;

@property (nonatomic,assign) NSInteger membersMute;
@property (nonatomic,assign) NSInteger otherPullBlackMe;
@property (nonatomic,assign) NSInteger pullBlackOther;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,assign) NSInteger verifyFlag;


//@property (nonatomic,strong) NSString *businessToken;
//@property (nonatomic,strong) NSString *consumerToken;
//@property (nonatomic,strong) ChatUserModel *businessUser;
//@property (nonatomic,strong) ChatUserModel *consumerUser;
/**
 0906新
 hatroomNotify = 0;
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
}
 
 ////___旧
 po dic
 {
     businessToken = 0ea7b3fb119c4bb68ce351b976de5b6e;
     businessUser =     {
         accountBalance = 0;
         autograph = "\U4f59\U4e2a\U6027\U7b7e\U540d";
         avatarMediaId = "2021-05-24/a577d795cde941f29df9fa2b56bcca5f.png";
         notice = "\U9ed8\U8ba4\U63cf\U8ff0";
         openId = dd7186834b30422984643cb446ba0055;
         state = 1;
         userNickname = "\U4f59";
         userUuid = 2a314f0322884e1b927e89a636ac0ec2;
     };
     consumerToken = c889034ef4d3424aa8ac9bf7cea909c1;
     consumerUser =     {
         accountBalance = 0;
         autograph = "nog sign";
         avatarMediaId = "2021-06-18/6908d6a847404bf88a84e608d5cf5029.jpeg";
         notice = "\U9ed8\U8ba4\U63cf\U8ff0";
         openId = dd7186834b30422984643cb446ba0055;
         state = 1;
         userNickname = "chat_001";
         userUuid = e3aae6c288a94e8e96517ab729328bde;
     };
 }
 
 */
@end

NS_ASSUME_NONNULL_END
