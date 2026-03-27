//
//  IssBuniessShopAppmentManagerDetailVC.h
//  Community
//
//  Created by 余莹 on 2021/4/2.
//  发布（商铺）详情 含有下架功能

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IssBuniessShopManagerDetailVC : HouseRentBuniessShopDetailVc

@end

@interface IssBuniessShopManagerDetailVcLastTableViewCell : BaseTableViewCell
@property (nonatomic,strong) UIButton *delRentBtn;
@property (nonatomic,strong) UIButton *editRentBtn;
@end

NS_ASSUME_NONNULL_END
