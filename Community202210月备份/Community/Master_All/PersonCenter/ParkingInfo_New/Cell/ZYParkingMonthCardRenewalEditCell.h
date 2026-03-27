//
//  ZYParkingMonthCardRenewalEditCell.h
//  Community
//
//  Created by ZY on 2022/5/7.
//

#import <UIKit/UIKit.h>
#import "ZYParkingMonthCardRenewalModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZYParkingMonthCardRenewalEditCellDelegate <NSObject>

- (void)subtractButtonEventWithMonth:(NSInteger)month;

- (void)addButtonEventWithMonth:(NSInteger)month;

@end

@interface ZYParkingMonthCardRenewalEditCell : UITableViewCell

@property (nonatomic, strong) ZYParkingMonthCardRenewalModel *model;

@property (nonatomic, assign) NSInteger maxMonthNum;

@property (nonatomic, weak) id<ZYParkingMonthCardRenewalEditCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
