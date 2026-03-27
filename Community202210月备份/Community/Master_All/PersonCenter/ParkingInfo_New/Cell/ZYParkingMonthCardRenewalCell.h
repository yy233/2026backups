//
//  ZYParkingMonthCardRenewalCell.h
//  Community
//
//  Created by ZY on 2022/5/7.
//

#import <UIKit/UIKit.h>
#import "ZYParkingMonthCardRenewalModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYParkingMonthCardRenewalCell : UITableViewCell

@property (nonatomic, strong) ZYParkingMonthCardRenewalModel *model;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

NS_ASSUME_NONNULL_END
