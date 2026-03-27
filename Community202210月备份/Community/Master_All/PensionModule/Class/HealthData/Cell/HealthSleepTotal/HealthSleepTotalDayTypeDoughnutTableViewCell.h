//
//  HealthSleepTotalDayTypeDoughnutTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/11/18.
//

#import <UIKit/UIKit.h>
#import "HealthBaseTotalDataContTouchTableViewCell.h"
#import "ZZCircleProgress.h"
NS_ASSUME_NONNULL_BEGIN

@interface HealthSleepTotalDayTypeDoughnutTableViewCell : HealthBaseTotalDataContTouchTableViewCell
@property (nonatomic,strong) ZZCircleProgress *circleProgressView;
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UILabel *detailL;
- (void)fillDataWithTotalMin:(NSInteger)tatalMin andWithScoreNum:(NSInteger)scoreNum;

@end

NS_ASSUME_NONNULL_END
