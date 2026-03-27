//
//  HouseRentDetailHousesDetailListTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/1/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HouseRentDetailHousesDetailListTableViewCell : UITableViewCell
@property (nonatomic,strong) UIView *detailListBackView;
@property (nonatomic,strong) UILabel *houseIntroduceLabel;
@property (nonatomic,strong) HouseRentDetailVcHouseModel *model; 
- (UIButton *)baseBtnWithText:(NSString *)str;
@end

NS_ASSUME_NONNULL_END
