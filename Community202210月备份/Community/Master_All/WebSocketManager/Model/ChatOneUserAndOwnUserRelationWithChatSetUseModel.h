//
//  ChatOneUserAndOwnUserRelationWithChatSetUseModel.h
//  Community
//
//  Created by 余莹 on 2021/9/10.
// 查询一个联系人(getOne接口 ) 得到和当前用户的关系具体数据 当前用户基础数据（含有联系人id 用于聊天页资料设置页等）


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatOneUserAndOwnUserTheRelationWithChatVcUseModel : NSObject
@property (nonatomic,strong) NSString *userAccount;
@property (nonatomic,strong) NSString *otherAccount;

@property (nonatomic,strong) NSString *headImgMaxUrl;
@property (nonatomic,strong) NSString *headImgSmallUrl;
@property (nonatomic,strong) NSString *imId;
@property (nonatomic,strong) NSString *nickName;
@property (nonatomic,strong) NSString *friendRemark;

@property (nonatomic,assign) NSInteger verifyFlag;
@property (nonatomic,assign) NSInteger type;//类型 1:好友、2、群、3、订阅号、4服务号
@property (nonatomic,assign) NSInteger id;//contactId
@property (nonatomic,assign) BOOL delFlag;
@property (nonatomic,assign) BOOL membersMute;
@property (nonatomic,assign) BOOL chatroomNotify;
//拉黑
@property (nonatomic,assign) BOOL pullBlackOther;
@property (nonatomic,assign) BOOL otherPullBlackMe;

/**
 po getDic
 {
     chatroomNotify = 0;
     createTime = "2021-09-07 10:21:33";
     delFlag = 0;
     friendRemark = "\U4f2f\U4ec0";
     headImgMaxUrl = "https://img1.baidu.com/it/u=2298484978,1703903334&fm=26&fmt=auto&gp=0.jpg";
     headImgSmallUrl = "https://img1.baidu.com/it/u=2298484978,1703903334&fm=26&fmt=auto&gp=0.jpg";
     id = 1435065672114782209;
     imId = c116ceaba26411ebb476002590f3d4a8;
     membersMute = 0;
     nickName = " \U4f2f\U80dc";
     otherAccount = "zhsj_242f36c5f4544376b76e399147f106ae@user";
     otherPullBlackMe = 0;
     pullBlackOther = 0;
     type = 1;
     userAccount = "zhsj_36bb529de58844bcaf77710c41cff199@user";
     verifyFlag = 9;
 }

 */
@end

NS_ASSUME_NONNULL_END
