//
//  ZYAddGroupFriendCell.h
//  Community
//
//  Created by ZY on 2021/4/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYAddGroupFriendCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *telLabel;
- (void)fillCellWithDic:(NSDictionary *)dic;
- (void)leftSelectedImgTypeIsSelected:(BOOL)isSelected;

@end

NS_ASSUME_NONNULL_END
