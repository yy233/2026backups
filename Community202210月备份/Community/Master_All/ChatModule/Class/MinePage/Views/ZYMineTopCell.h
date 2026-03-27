//
//  ZYMineTopCell.h
//  Community
//
//  Created by ZY on 2021/4/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYMineTopCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

// 动态数
@property (weak, nonatomic) IBOutlet UILabel *dynamicNumLabel;

@property (weak, nonatomic) IBOutlet UIView *dynamicView;

// 评论数
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;

@property (weak, nonatomic) IBOutlet UIView *commentsView;

// 点赞数
@property (weak, nonatomic) IBOutlet UILabel *giveLikeNumLabel;

@property (weak, nonatomic) IBOutlet UIView *giveLikeView;

- (void)fillUserInfo:(NSMutableDictionary *)userInfoDic;

@end

NS_ASSUME_NONNULL_END
