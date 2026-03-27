//
//  ZYSearchFriendsCell.h
//  Community
//
//  Created by ZY on 2021/4/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYSearchFriendsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *telLabel;

@property (weak, nonatomic) IBOutlet UIView *addView;

- (void)fillDataWithDic:(NSMutableDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
