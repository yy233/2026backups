//
//  WeatherCityChooseTopCityCell.h
//  Community
//
//  Created by 刘久炼 on 2021/2/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WeatherCityChooseTopCityCellDelegate <NSObject>
- (void)topCityTableViewCellBtnAction:(UIButton *)sender;
@end

@interface WeatherCityChooseTopCityCell : UITableViewCell
@property (nonatomic,strong) NSMutableArray <CityChooseModel*>*dataSourceArr;
@property (nonatomic,weak) id <WeatherCityChooseTopCityCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
