//
//  ChatFriendUserAndOwnUserTheRelationshipInfoModel.h
//  Community
//
//  Created by 余莹 on 2021/9/9.
// 用户信息界面 用来获取到的关系数据 （陌生人时 部分键不存在）
// 查询一个联系人(ImId) 得到和当前用户的关系具体数据（注重是否好友关系等键）

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatOneUserAndOwnUserTheRelationWithOneUserMainVcModel : NSObject
@property (nonatomic,strong) NSString *account;
@property (nonatomic,strong) NSString *headImgMaxUrl;
@property (nonatomic,strong) NSString *headImgSmallUrl;
@property (nonatomic,strong) NSString *imId;
@property (nonatomic,strong) NSString *nickName;
@property (nonatomic,strong) NSString *friendRemark;

@property (nonatomic,assign) NSInteger sex;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,assign) NSInteger contactId;

@property (nonatomic,assign) BOOL allowToAdd;
@property (nonatomic,assign) BOOL me;
@property (nonatomic,assign) BOOL otherPullBlackMe;

/**
 //非好友
 account = "zhsj_e9b158bc223f4851b2bb5ef212394ce8@user";
 allowToAdd = 1;
 headImgMaxUrl = "https://img1.baidu.com/it/u=2298484978,1703903334&fm=26&fmt=auto&gp=0.jpg";
 headImgSmallUrl = "https://img1.baidu.com/it/u=2298484978,1703903334&fm=26&fmt=auto&gp=0.jpg";
 imId = 34535567562;
 me = 0;
 nickName = " \U6c9b\U4fca";
 otherPullBlackMe = 0;
 sex = 1;
 
 //是好友（有继续到chatvc的键值contactId friendRemark type ）
 account = "zhsj_242f36c5f4544376b76e399147f106ae@user";
 
 contactId = 1435065672114782209;
 friendRemark = "\U4f2f\U4ec0";
 
 
 type = 5;//联系人类型
 */


@end

NS_ASSUME_NONNULL_END
