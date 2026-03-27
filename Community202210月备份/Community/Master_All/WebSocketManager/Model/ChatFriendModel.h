//
//  ChatFriendModel.h
//  Community
//
//  Created by 余莹 on 2021/4/29.
//

#import <Foundation/Foundation.h>
//#import "ChatUserModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ChatFriendModel : ChatUserModel
//@property (nonatomic,strong) NSString *friendRemarks;//旧版有s
@property (nonatomic,strong) NSString *friendRemark;//好友列表没有后缀s
/**
 {
     autograph = "\U9ed8\U8ba4\U4e2a\U6027\U7b7e\U540d";
     avatarMediaId = "2021-02-10/9ac8268a449443c4bff6c3f88775d147-1612951479379.jpg";
     friendRemarks = "\U540c\U610f\U52a0\U597d\U53cb\U7684\U5907\U6ce8";
     notice = "\U9ed8\U8ba4\U63cf\U8ff0";
     userNickname = "\U6635\U79f0888";
     userUuid = e3aae6c288a94e8e96517ab729328bde;
 },
 */
@end

NS_ASSUME_NONNULL_END
