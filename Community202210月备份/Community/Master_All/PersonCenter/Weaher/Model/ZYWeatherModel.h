//
//  ZYWeatherModel.h
//  Community
//
//  Created by ZY on 2021/6/4.
//

#import <Foundation/Foundation.h>

@class ZYWeatherDataModel, ZYWeatherDataConditionModel, ZYWeatherDataCityModel, ZYWeatherDataAqiModel, ZYWeatherDataForecastModel, ZYWeatherDataHourlyModel, ZYWeatherDataLiveIndexModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZYWeatherModel : NSObject

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) ZYWeatherDataModel *data;

@end


@interface ZYWeatherDataModel : NSObject <YYModel>

@property (nonatomic, strong) ZYWeatherDataConditionModel *condition;

@property (nonatomic, strong) ZYWeatherDataCityModel *city;

@property (nonatomic, strong) ZYWeatherDataAqiModel *aqi;

@property (nonatomic, strong) NSArray<ZYWeatherDataForecastModel *> *forecast;

@property (nonatomic, strong) NSArray<ZYWeatherDataHourlyModel *> *hourly;

@property (nonatomic, strong) NSArray<ZYWeatherDataLiveIndexModel *> *liveIndex;

@end


@interface ZYWeatherDataConditionModel : NSObject

@property (nonatomic, copy) NSString *condition;

@property (nonatomic, copy) NSString *temp;

@property (nonatomic, copy) NSString *updateDay;

@property (nonatomic, copy) NSString *dayOfWeek;

@property (nonatomic, copy) NSString *updatetime;

@property (nonatomic, copy) NSString *tips;

@end


@interface ZYWeatherDataCityModel : NSObject

@property (nonatomic, copy) NSString *counname;

@property (nonatomic, copy) NSString *ianatimezone;

@property (nonatomic, copy) NSString *secondaryname;

@property (nonatomic, copy) NSString *pname;

@property (nonatomic, copy) NSString *timezone;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger cityId;

@end


@interface ZYWeatherDataAqiModel : NSObject

@property (nonatomic, copy) NSString *aqiName;

@property (nonatomic, copy) NSString *value;

@end


@interface ZYWeatherDataForecastModel : NSObject

@property (nonatomic, copy) NSString *updateDay;

@property (nonatomic, copy) NSString *tempDay;

@property (nonatomic, copy) NSString *iconUrlDay;

@property (nonatomic, copy) NSString *conditionDay;

@property (nonatomic, copy) NSString *dayOfWeek;

@property (nonatomic, copy) NSString *windLevelDay;

@property (nonatomic, copy) NSString *conditionIdNight;

@property (nonatomic, copy) NSString *conditionNight;

@property (nonatomic, copy) NSString *windDirDay;

@property (nonatomic, copy) NSString *updatetime;

@property (nonatomic, copy) NSString *iconUrlNight;

@property (nonatomic, copy) NSString *conditionIdDay;

@property (nonatomic, copy) NSString *predictDate;

@property (nonatomic, copy) NSString *tempNight;

@end


@interface ZYWeatherDataHourlyModel : NSObject

@property (nonatomic, copy) NSString *condition;

@property (nonatomic, copy) NSString *temp;

@property (nonatomic, copy) NSString *hour;

@property (nonatomic, copy) NSString *iconUrl;

@property (nonatomic, copy) NSString *iconDay;

@end


@interface ZYWeatherDataLiveIndexModel : NSObject

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *iconUrl;

@end

NS_ASSUME_NONNULL_END
