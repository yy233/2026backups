//
//  ZYChatUserInfoBottomCell.h
//  Community
//
//  Created by ZY on 2021/4/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYChatUserInfoBottomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
- (void)fillDataWithModel:(ChatUserModel *)model;
@end

NS_ASSUME_NONNULL_END
