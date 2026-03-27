//
//  WeatherCenterCell.h
//  Community
//
//  Created by 刘久炼 on 2021/2/24.
//

#import <UIKit/UIKit.h>
#import "ZYWeatherModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WeatherCenterCell : UITableViewCell

@property (nonatomic, strong) NSArray<ZYWeatherDataForecastModel *> *forecastArray;

@end

NS_ASSUME_NONNULL_END
