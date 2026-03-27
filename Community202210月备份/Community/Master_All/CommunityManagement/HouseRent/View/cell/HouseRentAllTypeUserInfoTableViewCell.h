//
//  HouseRentUserInfoTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/8/30.
//

#import <UIKit/UIKit.h>
#import "HouseRentDetailVcHouseUserModel.h"
#import "HouseRentDetailVcBuniessShopModelUserModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HouseRentAllTypeUserInfoTableViewCell : UITableViewCell
@property (nonatomic,strong) UIImageView *imgV;
@property (nonatomic,strong) UILabel *nameL; 
@property (nonatomic,strong) UIButton *typeBtn;
- (void)fillUserInfoWithHouseData:(HouseRentDetailVcHouseUserModel *)houseUserModel;
- (void)fillUserInfoWithBuniesShopData:(HouseRentDetailVcBuniessShopModelUserModel *)buniessUserModel;

@end

NS_ASSUME_NONNULL_END
