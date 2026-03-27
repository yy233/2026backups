//
//  ZYFriendVerifyCell.h
//  Community
//
//  Created by ZY on 2021/4/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYFriendVerifyCell : UITableViewCell

// 验证框
@property (weak, nonatomic) IBOutlet UITextView *verifyTextView;

// 备注框
@property (weak, nonatomic) IBOutlet UITextView *remarkTextView;

// 发送
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@end

NS_ASSUME_NONNULL_END
