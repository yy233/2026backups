//
//  WeatherBottomCell.h
//  Community
//
//  Created by 刘久炼 on 2021/2/24.
//

#import <UIKit/UIKit.h>
#import "ZYWeatherModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WeatherBottomCell : UITableViewCell

@property (nonatomic, strong) NSArray<ZYWeatherDataLiveIndexModel *> *liveIndexArray;

@end

NS_ASSUME_NONNULL_END
