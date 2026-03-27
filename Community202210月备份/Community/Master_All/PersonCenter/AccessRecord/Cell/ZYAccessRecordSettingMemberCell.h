//
//  ZYAccessRecordSettingMemberCell.h
//  Community
//
//  Created by ZY on 2022/4/26.
//

#import <UIKit/UIKit.h>
#import "ZYAccessRecordVisitPermitModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYAccessRecordSettingMemberCell : UITableViewCell

@property (nonatomic, strong) ZYAccessRecordVisitPermitModel *model;

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UISwitch *memberSwitch;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

NS_ASSUME_NONNULL_END
