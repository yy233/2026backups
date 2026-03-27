//
//  ZYNewFriendsCell.h
//  Community
//
//  Created by ZY on 2021/4/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface ZYNewFriendsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;

@property (weak, nonatomic) IBOutlet UIView *agreeView;

@property (weak, nonatomic) IBOutlet UILabel *agreeLabel;

- (void)fillUserInfo:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
