//
//  ZYHouseRepairIssueTimeCell.h
//  Community
//
//  Created by ZY on 2022/4/11.
//

#import <UIKit/UIKit.h>
#import "ZYHouseRepairIssueUploadModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZYHouseRepairIssueTimeCellDelegate <NSObject>

// 预约时间
- (void)timeViewEvent;

@end

@interface ZYHouseRepairIssueTimeCell : UITableViewCell

@property (nonatomic, strong) ZYHouseRepairIssueUploadModel *model;

@property (nonatomic, weak) id<ZYHouseRepairIssueTimeCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
