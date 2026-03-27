//
//  TopCityTableViewCell.h
//  Community
//
//  Created by 余莹 on 2020/11/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TopCityTableViewCellCityBtnDelegate <NSObject>
- (void)topCityTableViewCellBtnAction:(UIButton *)sender;
@end

@interface TopCityTableViewCell : UITableViewCell
@property (nonatomic,strong) NSMutableArray <CityChooseModel*>*dataSourceArr;
@property (nonatomic,weak) id <TopCityTableViewCellCityBtnDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
