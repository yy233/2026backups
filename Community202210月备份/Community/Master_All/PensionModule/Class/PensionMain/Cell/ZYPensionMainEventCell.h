//
//  ZYPensionMainEventCell.h
//  Community
//
//  Created by ZY on 2021/11/5.
//

#import <UIKit/UIKit.h>
#import "ZYEventRemindModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYPensionMainEventCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UISwitch *alarmSwitch;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (nonatomic, strong) ZYEventRemindModel *model;

@end

NS_ASSUME_NONNULL_END
