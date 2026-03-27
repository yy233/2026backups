//
//  ZYMyRepairShowDetailFollowUpInfoCell.h
//  Community
//
//  Created by ZY on 2022/4/13.
//

#import <UIKit/UIKit.h>
#import "ZYMyRepairShowDetailFollowUpInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZYMyRepairShowDetailFollowUpInfoCellDelegate <NSObject>

- (void)playButtonEventWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface ZYMyRepairShowDetailFollowUpInfoCell : UITableViewCell

@property (nonatomic, strong) ZYMyRepairShowDetailFollowUpInfoModel *model;

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (weak, nonatomic) IBOutlet UILabel *voiceTimeLabel;

@property (nonatomic, weak) id<ZYMyRepairShowDetailFollowUpInfoCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
