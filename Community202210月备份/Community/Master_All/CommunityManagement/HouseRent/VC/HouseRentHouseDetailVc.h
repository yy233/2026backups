//
//  HouseRentHouseDetailVc.h
//  Community
//
//  Created by 余莹 on 2020/12/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HouseRentHouseDetailVc : BaseViewController
@property (nonatomic,assign) NSInteger IDNum;
//用于房东下架页 复用
@property (nonatomic,assign) BOOL isManagerTypeLastCellIsChange;//房东管理房屋 编辑修改功能下架功能按钮cell的判断bool
@property (nonatomic,strong) HouseRentDetailVcHouseModel *houseModel;
@end

NS_ASSUME_NONNULL_END
