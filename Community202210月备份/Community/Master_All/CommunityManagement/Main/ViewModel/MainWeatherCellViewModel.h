//
//  MainWeatherCellViewModel.h
//  Community
//
//  Created by 余莹 on 2021/1/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^WeatherCellBlock)(NSDictionary *,NSDictionary *,NSMutableArray *,BOOL);// city城市数据 ，condition今日天气 ，forecast其他days天气数组
@interface MainWeatherCellViewModel : NSObject
 
+ (void)getWeatherNowWithLat:(double)lat
                      andLon:(double)lon
            withWeatherBlock:(WeatherCellBlock)weatherBlock;
+ (void)getWeatherNowWithCityNameStr:(NSString *)cityNameStr
                    withWeatherBlock:(WeatherCellBlock)weatherBlock;
@end

NS_ASSUME_NONNULL_END
