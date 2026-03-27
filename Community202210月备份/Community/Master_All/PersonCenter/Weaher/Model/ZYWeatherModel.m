//
//  ZYWeatherModel.m
//  Community
//
//  Created by ZY on 2021/6/4.
//

#import "ZYWeatherModel.h"


@implementation ZYWeatherModel

@end


@implementation ZYWeatherDataModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    
    return @{@"forecast" : [ZYWeatherDataForecastModel class], @"hourly" : [ZYWeatherDataHourlyModel class], @"liveIndex" : [ZYWeatherDataLiveIndexModel class]};
}

@end


@implementation ZYWeatherDataConditionModel

@end


@implementation ZYWeatherDataCityModel

@end


@implementation ZYWeatherDataAqiModel

@end


@implementation ZYWeatherDataForecastModel

@end


@implementation ZYWeatherDataHourlyModel

@end


@implementation ZYWeatherDataLiveIndexModel

@end
