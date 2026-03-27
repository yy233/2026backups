//
//  WeatherTopCell.h
//  Community
//
//  Created by 刘久炼 on 2021/2/24.
//

#import <UIKit/UIKit.h>
#import "ZYWeatherModel.h"

@protocol WeatherTopCellDelegate <NSObject>

@optional - (void)addressClicked;

@end

NS_ASSUME_NONNULL_BEGIN

@interface WeatherTopCell : UITableViewCell

@property (nonatomic, weak) id<WeatherTopCellDelegate> delegate;

@property (nonatomic, strong) ZYWeatherDataConditionModel *conditionModel;

@property (nonatomic, strong) ZYWeatherDataCityModel *cityModel;

@property (nonatomic, strong) ZYWeatherDataAqiModel *aqiModel;

@property (nonatomic, strong) NSArray<ZYWeatherDataHourlyModel *> *hourlyArray;

@end

NS_ASSUME_NONNULL_END
