//
//  ZYEditEventDateCell.h
//  Community
//
//  Created by ZY on 2021/11/11.
//

#import <UIKit/UIKit.h>
#import "ZYEventRemindModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYEditEventDateCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (nonatomic, strong) ZYEventRemindModel *model;

@end

NS_ASSUME_NONNULL_END
