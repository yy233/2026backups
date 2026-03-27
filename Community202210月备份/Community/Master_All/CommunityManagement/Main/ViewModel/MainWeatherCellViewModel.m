//
//  MainWeatherCellViewModel.m
//  Community
//
//  Created by 余莹 on 2021/1/25.
//

#import "MainWeatherCellViewModel.h"

@implementation MainWeatherCellViewModel
+ (void)getWeatherNowWithLat:(double)lat
                      andLon:(double)lon
            withWeatherBlock:(WeatherCellBlock)weatherBlock{
    NSString *url = [NSString stringWithFormat:@"proprietor/common/weatherNow?lon=%lf&lat=%lf",lon,lat];
    [self getWeatherNowWithUrl:url withWeatherBlock:weatherBlock];
}
+ (void)getWeatherNowWithCityNameStr:(NSString *)cityNameStr
            withWeatherBlock:(WeatherCellBlock)weatherBlock{
    cityNameStr = @"重庆";
    NSString *url = [NSString stringWithFormat:@"proprietor/common/weatherNow?cityName=%@",cityNameStr];
    NSString *okUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [self getWeatherNowWithUrl:okUrl withWeatherBlock:weatherBlock];
}
+ (void)getWeatherNowWithUrl:(NSString *)url
            withWeatherBlock:(WeatherCellBlock)weatherBlock{
    
      [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:url withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
        WeatherCellBlock blcok =  weatherBlock;
          if (isNotNil(responsObject)) {
              if (Y_IS_Success) {
                  NSDictionary *reDic = Y_ResponsObject_dataDic;
                  NSDictionary *cityDicBlock = [[reDic allKeys] containsObject:@"city"]? [NSDictionary dictionaryWithDictionary:reDic[@"city"]] : @{};
                  NSDictionary *nowDayDicBlock = [[reDic allKeys] containsObject:@"condition"]? [NSDictionary dictionaryWithDictionary:reDic[@"condition"]] : @{};
                  NSMutableArray *otherDaysArr =  [[reDic allKeys] containsObject:@"forecast"]? [NSMutableArray arrayWithArray:reDic[@"forecast"]] : @[].mutableCopy;
                  blcok(cityDicBlock,nowDayDicBlock,otherDaysArr,YES);
              }else{
                  blcok(@{},@{},@[].mutableCopy,YES);
                  Y_SVP_SHOW_ERR_MESSAGE
              }
          }else{
              blcok(@{},@{},@[].mutableCopy,YES);
              Y_SVP_SHOW_ERR_DESCRIPTION
          }
      }];
    
}
 
@end
