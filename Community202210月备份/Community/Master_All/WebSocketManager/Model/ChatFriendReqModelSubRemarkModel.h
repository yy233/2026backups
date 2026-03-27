//
//  ChatFriendReqModelSubRemarkModel.h
//  Community
//
//  Created by 余莹 on 2021/9/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatFriendReqModelSubRemarkModel : NSObject
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *message;
@property (nonatomic,strong) NSString *speaker;//imid

/**
 createTime = "2021-09-04 18:02:56";
 friendAccount = "zhsj_daebe5eed88441468b4ab4ad111048bf@user";
 friendRemark = "java\U540e\U53f0\U6d4b\U8bd51";
 headImgMaxUrl = "https://img2.baidu.com/it/u=3499496407,3720395870&fm=26&fmt=auto&gp=0.jpg";
 headImgSmallUrl = "https://img2.baidu.com/it/u=3499496407,3720395870&fm=26&fmt=auto&gp=0.jpg";
 id = 1434094619309285379;
 imId = "test_0009";
 isRead = 0;
 nickName = " \U94f6\U5e0c";
 origin = 1;
 remark =     (
             {
         createTime = "2021-09-04 18:02:56";
         message = "\U4f60\U597d\Uff01";
         speaker = "test_0002";
     }
 );
 userAccount = "zhsj_36bb529de58844bcaf77710c41cff199@user";
 verifyFlag = 1;
},
 */
@end

NS_ASSUME_NONNULL_END
