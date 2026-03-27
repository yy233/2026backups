//
//  ChatWillGoOneChatVcGetApplyInfoModel.h
//  Community
//
//  Created by 余莹 on 2022/3/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatWillGoOneChatVcGetApplyInfoModel : NSObject
@property (nonatomic,copy) NSString *sessionId;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,copy) NSString *head_img_max_url;
@property (nonatomic,copy) NSString *head_img_small_url;
@property (nonatomic,copy) NSString *nickName;
@property (nonatomic,copy) NSString *otherAccount;
@property (nonatomic,copy) NSString *userAccount;
@property (nonatomic,copy) NSString *imId;

@property (nonatomic,assign) NSInteger hatroomNotify;
@property (nonatomic,assign) NSInteger delFlag;
@property (nonatomic,assign) NSInteger ID;

@property (nonatomic,assign) NSInteger membersMute;
@property (nonatomic,assign) NSInteger otherPullBlackMe;
@property (nonatomic,assign) NSInteger pullBlackOther;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,assign) NSInteger verifyFlag;


@end

NS_ASSUME_NONNULL_END
