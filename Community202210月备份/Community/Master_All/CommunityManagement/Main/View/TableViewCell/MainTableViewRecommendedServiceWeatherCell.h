//
//  MainTableViewRecommendedServiceCell.h
//  Community
//
//  Created by 余莹 on 2020/11/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainTableViewRecommendedServiceWeatherCell : UITableViewCell
- (void)showCellDataSourceWithWeathOtherNowDayDic:(NSMutableDictionary *)nowDayDic
                  withWeathOtherDaysDataSourceArr:(NSMutableArray *)weathOtherDaysDataSourceArr;

@end

NS_ASSUME_NONNULL_END
