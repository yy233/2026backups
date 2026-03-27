//
//  ChatFriendUserAndOwnUserTheRelationshipInfoModel.h
//  Community
//
//  Created by 余莹 on 2021/9/9.
// 用户信息界面 用来获取到的关系数据 （陌生人时 部分键为空）


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatOneUserAndOwnUserTheRelationshipInfoModel : NSObject
@property (nonatomic,strong) NSString *account;
@property (nonatomic,strong) NSString *headImgMaxUrl;
@property (nonatomic,strong) NSString *headImgSmallUrl;
@property (nonatomic,strong) NSString *imId;
@property (nonatomic,strong) NSString *nickName;
//@property (nonatomic,strong) NSString *friendRemark;
//@property (nonatomic,strong) NSString *;

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
 allowToAdd = 1;
 contactId = 1435065672114782209;
 friendRemark = "\U4f2f\U4ec0";
 headImgMaxUrl = "https://img1.baidu.com/it/u=2298484978,1703903334&fm=26&fmt=auto&gp=0.jpg";
 headImgSmallUrl = "https://img1.baidu.com/it/u=2298484978,1703903334&fm=26&fmt=auto&gp=0.jpg";
 imId = c116ceaba26411ebb476002590f3d4a8;
 me = 0;
 nickName = " \U4f2f\U80dc";
 otherPullBlackMe = 0; //是否拉黑
 sex = 1;
 type = 5;//联系人类型
 */


@end

NS_ASSUME_NONNULL_END
