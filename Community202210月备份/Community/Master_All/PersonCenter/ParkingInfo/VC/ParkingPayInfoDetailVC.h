//
//  ParkingPayInfoDetailVC.h
//  Community
//
//  Created by 余莹 on 2021/8/7.
//

#import <UIKit/UIKit.h>
#import "ParkingPayInfoTableViewCell.h"
#import "ParkingCarBaseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ParkingPayInfoDetailVC : BaseTableViewController
@property (nonatomic,assign) ParkingPayInfo_Type selfType;
@property (nonatomic,strong) ParkingCarBaseModel *model;//车辆历史缴费记录列表跳转到本详情页
@property (nonatomic,strong) NSString *orderIdStr;//消息某支付信息跳转到本详情页
@end

NS_ASSUME_NONNULL_END
