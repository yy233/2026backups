//
//  HouseRentBuniessShopDetailVc.h
//  Community
//
//  Created by 余莹 on 2021/1/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HouseRentBuniessShopDetailVc : BaseViewController
@property (nonatomic,assign) NSInteger IDNum;
//用于房东下架页 复用
@property (nonatomic,assign) BOOL isManagerTypeLastCellIsChange;
@end

NS_ASSUME_NONNULL_END
 
