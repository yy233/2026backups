//
//  WeatherBottomSubCell.h
//  Community
//
//  Created by 刘久炼 on 2021/2/25.
//

#import <UIKit/UIKit.h>
#import "ZYWeatherModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WeatherBottomSubCell : UICollectionViewCell

@property (nonatomic, strong) ZYWeatherDataLiveIndexModel *liveIndexModel;

@end

NS_ASSUME_NONNULL_END
