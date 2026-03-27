//
//  ZYChatInformationCell.h
//  Community
//
//  Created by ZY on 2021/4/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYChatInformationCell : UITableViewCell

// 聊天记录视图
@property (weak, nonatomic) IBOutlet UIView *chatRecordView;

// 当前聊天背景视图
@property (weak, nonatomic) IBOutlet UIView *chatBackgroundView;

// 置顶
@property (weak, nonatomic) IBOutlet UISwitch *topSwitch;

// 免打扰
@property (weak, nonatomic) IBOutlet UISwitch *nodisturbSwitch;

// 强提醒
@property (weak, nonatomic) IBOutlet UISwitch *strongReminderSwitch;

@end

NS_ASSUME_NONNULL_END
