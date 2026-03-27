//
//  ZYOwnersVoteDetailContentCell.h
//  Community
//
//  Created by ZY on 2021/8/3.
//

#import <UIKit/UIKit.h>
#import "ZYOwnersVoteDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYOwnersVoteDetailContentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *radioButton;

@property (nonatomic, strong) ZYOwnersVoteDetailDataVoteTopicEntityOptionsModel *model;

@end

NS_ASSUME_NONNULL_END
