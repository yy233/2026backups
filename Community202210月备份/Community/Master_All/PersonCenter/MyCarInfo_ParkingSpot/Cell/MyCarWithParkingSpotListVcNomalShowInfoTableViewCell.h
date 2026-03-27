//
//  MyCarWithParkingSpotListVcNomalShowInfoTableViewCell.h
//  Community
//
//  Created by 余莹 on 2022/5/6.
//

#import <UIKit/UIKit.h>
#import "MyCarWithParkingSpotModel.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *MyCarWithParkingSpotListVcNomalShowInfoTableViewCell_I = @"MyCarWithParkingSpotListVcNomalShowInfoTableViewCell";

@interface MyCarWithParkingSpotListVcNomalShowInfoTableViewCell : BaseTableViewCell

- (void)fillModel:(MyCarWithParkingSpotModel *)model;

@end

NS_ASSUME_NONNULL_END
