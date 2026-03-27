//
//  ZYMyPensionSettingCell.h
//  Community
//
//  Created by ZY on 2021/11/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYMyPensionSettingCellDelegate <NSObject>

- (void)remindSwitchEvent:(UISwitch *)sender;

- (void)shakeSwitchEvent:(UISwitch *)sender;

@end

@interface ZYMyPensionSettingCell : UITableViewCell

@property (nonatomic, weak) id<ZYMyPensionSettingCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
