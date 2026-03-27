//
//  ZYContactPeopleCell.h
//  Community
//
//  Created by ZY on 2021/4/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYContactPeopleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
- (void)fillDataWithFriendModel:(ChatFriendModel *)model;
@end

NS_ASSUME_NONNULL_END
