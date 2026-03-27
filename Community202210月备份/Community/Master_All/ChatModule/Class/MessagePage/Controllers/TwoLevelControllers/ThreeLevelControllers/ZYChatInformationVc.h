//
//  ZYChatInformationVc.h
//  Community
//
//  Created by ZY on 2021/4/23.
//
// 聊天信息

#import <UIKit/UIKit.h>
#import "ZYPageBaseVc.h"
#import "ChatVcMsgViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZYChatInformationVc : ZYPageBaseVc
@property (nonatomic,assign) ChatVc_Seesion_type thisChatVc_Seesion_type; 

@property (nonatomic,strong) NSString *friendUUID;
@property (nonatomic,strong) NSString *friendNickName;
@property (nonatomic,strong) NSString *friendImgUrlStr;
//
@property (nonatomic,strong) NSString *groupUUID;
@property (nonatomic,strong) NSMutableArray *groupMemberList;

@end

NS_ASSUME_NONNULL_END
