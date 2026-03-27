//
//  ZYAccessRecordSettingCell.h
//  Community
//
//  Created by ZY on 2022/4/25.
//

#import <UIKit/UIKit.h>
#import "ZYAccessRecordVisitPermitModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZYAccessRecordSettingCellDelegate <NSObject>

- (void)visitSwitchChangedEvent:(UISwitch *)sender;

- (void)noticeSwitchChangedEvent:(UISwitch *)sender;

@end

@interface ZYAccessRecordSettingCell : UITableViewCell

@property (nonatomic, weak) id<ZYAccessRecordSettingCellDelegate> delegate;

@property (nonatomic, strong) ZYAccessRecordVisitPermitModel *model;

@end

NS_ASSUME_NONNULL_END
