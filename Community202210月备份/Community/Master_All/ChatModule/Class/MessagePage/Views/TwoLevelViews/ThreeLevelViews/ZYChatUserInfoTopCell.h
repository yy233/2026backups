//
//  ZYChatUserInfoTopCell.h
//  Community
//
//  Created by ZY on 2021/4/23.
//

#import <UIKit/UIKit.h>
#import "ChatOneUserAndOwnUserTheRelationWithOneUserHomeVcUseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZYChatUserInfoTopCell : UITableViewCell

// 头像
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

// 添加好友视图
@property (weak, nonatomic) IBOutlet UIView *addFriendView;

// 添加好友按钮
@property (weak, nonatomic) IBOutlet UIButton *addFriendButton;

// 昵称
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;

// 签名
@property (weak, nonatomic) IBOutlet UILabel *signatureLabel;

// 注册号
@property (weak, nonatomic) IBOutlet UILabel *registrationNumLabel;

// 地址
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

- (void)fillMyInfoDataWithModel:(ChatUserModel *)model;//自己
- (void)fillOtherUserInfoWithModel:(ChatOneUserAndOwnUserTheRelationWithOneUserHomeVcUseModel *)model;//他人


@end

NS_ASSUME_NONNULL_END
