//
//  ZYReportAboutRepairApplyVoiceCell.h
//  Community
//
//  Created by ZY on 2022/3/7.
//

#import <UIKit/UIKit.h>
#import "ZYReportAboutRepairApplyUploadModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ReportVoicePlayCompleteBlock)(ZYReportAboutRepairApplyUploadModel *model);

@protocol ZYReportAboutRepairApplyVoiceCellDelegate <NSObject>

- (void)playButtonEvent;

- (void)closeButtonEvent;

@end

@interface ZYReportAboutRepairApplyVoiceCell : UITableViewCell

@property (nonatomic, strong) ZYReportAboutRepairApplyUploadModel *model;

@property (nonatomic, weak) id<ZYReportAboutRepairApplyVoiceCellDelegate> delegate;

@property (nonatomic, copy) ReportVoicePlayCompleteBlock voicePlayCompleteBlock;

 - (void)isUseOnDetailVc;
@end

NS_ASSUME_NONNULL_END
