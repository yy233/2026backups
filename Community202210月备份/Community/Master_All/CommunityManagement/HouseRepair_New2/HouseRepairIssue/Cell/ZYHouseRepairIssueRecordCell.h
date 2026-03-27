//
//  ZYHouseRepairIssueRecordCell.h
//  Community
//
//  Created by ZY on 2022/4/11.
//

#import <UIKit/UIKit.h>
#import "ZYHouseRepairIssueUploadModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ReportVoicePlayCompleteBlock)(ZYHouseRepairIssueUploadModel *model);

@protocol ZYHouseRepairIssueRecordCellDelegate <NSObject>

- (void)playButtonEvent;

- (void)closeButtonEvent;

@end

@interface ZYHouseRepairIssueRecordCell : UITableViewCell

@property (nonatomic, strong) ZYHouseRepairIssueUploadModel *model;

@property (nonatomic, weak) id<ZYHouseRepairIssueRecordCellDelegate> delegate;

@property (nonatomic, copy) ReportVoicePlayCompleteBlock voicePlayCompleteBlock;

- (void)isUseOnDetailVc;//工单详情页使用时

@end

NS_ASSUME_NONNULL_END
