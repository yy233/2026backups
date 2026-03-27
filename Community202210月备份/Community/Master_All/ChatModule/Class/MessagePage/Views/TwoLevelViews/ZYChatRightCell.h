//
//  ZYChatRightCell.h
//  Community
//
//  Created by ZY on 2021/4/22.
//

#import <UIKit/UIKit.h>
//
#import "ChatFriendMessageModel.h"
#import "ChatGroupMessageModel.h"
//
NS_ASSUME_NONNULL_BEGIN

@protocol ZYChatRightCellDelegate

//撤回删除
//- (void)cellDelegateWithTouchUndoFriendMsgWithMsgData:(nullable ChatFriendMessageModel *)fmodel orGroupModel:(nullable ChatGroupMessageModel *)gmodle;
//- (void)cellDelegateWithTouchDeletFriendMsgWithMsgData:(nullable ChatFriendMessageModel *)fmodel  orGroupModel:(nullable ChatGroupMessageModel *)gmodle;
@end

@interface ZYChatRightCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chatViewLeftConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *bubbleImageView;

@property (weak, nonatomic) IBOutlet UIView *chatView;

@property (weak, nonatomic) IBOutlet UIButton *readStateBtn;
@property (nonatomic, strong) UILabel *chatLabel;

//
//删除撤销键
@property (nonatomic,strong) UIButton *deletThisMsgBtn;
@property (nonatomic,strong) UIButton *undoThisMsgBtn;
//
- (void)showOrHiddenCellDeletAndUndoBtnWithNilNumIsHidden:(BOOL)numBool;//删除撤销
//- (void)fillFriendMsgCellWithMsgData:(ChatFriendMessageModel *)model;
- (void)fillMsgCellWithFriendMsgData:(nullable ChatFriendMessageModel *)fmodel orGroupModel:(nullable ChatGroupMessageModel *)gmodel;

@end

NS_ASSUME_NONNULL_END
