//
//  HouseRentSectionHeaderView.h
//  Community
//
//  Created by 余莹 on 2020/12/29.
//。 组头滚动图 4个筛选按钮 ---更改成 listview同级别的view 位置由偏移量更新 位置==组头

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    cell_type_city,
    cell_type_money,
    cell_type_houseType,
    cell_type_more,
} Cell_type;

@protocol HouseRentSectionHeaderViewDelegate <NSObject>
- (void)touchUpHouseCityQuBtn;
- (void)touchUpHouseMoneyBtn;
- (void)touchUpHouseHouseTypeBtn;
- (void)touchUpHouseMoreBtn;
- (void)chooseCellWithCityDic:(NSDictionary *)citydic;
- (void)chooseCellWithMoneyDic:(NSDictionary *)moneydic;
- (void)chooseCellWithHouseTypeDic:(NSDictionary *)houseTypedic;
- (void)chooseCellWithMoreDic:(NSDictionary *)moredic;
- (void)chooseNoCell;

@end
@interface HouseRentSectionHeaderView : UIView
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIButton *cityQuBtn;
@property (nonatomic,strong) UIButton *moneyBtn;
@property (nonatomic,strong) UIButton *houseTypeBtn;
@property (nonatomic,strong) UIButton *moreBtn;
@property (nonatomic,weak) id<HouseRentSectionHeaderViewDelegate> delegate;
- (void)showTableViewWithArr:(NSArray *)datasourceArr withType:(Cell_type)cellType;
- (void)hiddenTableView;
- (void)showMoreViewWithDic:(NSDictionary *)datasourceDic;
- (void)hiddenMoreView;
@end

NS_ASSUME_NONNULL_END
