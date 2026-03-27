//
//  ZYChatLeftCell.h
//  Community
//
//  Created by ZY on 2021/4/22.
//

#import <UIKit/UIKit.h>
//
#import "ChatFriendMessageModel.h"
//
NS_ASSUME_NONNULL_BEGIN

@interface ZYChatLeftCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chatViewLeftConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *bubbleImageView;

@property (weak, nonatomic) IBOutlet UIView *chatView;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;

@property (nonatomic, strong) UILabel *chatLabel;
- (void)fillFriendMsgCellWithMsgData:(ChatFriendMessageModel *)model;

@end

NS_ASSUME_NONNULL_END
