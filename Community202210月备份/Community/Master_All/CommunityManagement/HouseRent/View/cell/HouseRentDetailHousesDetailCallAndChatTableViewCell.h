//
//  HouseRentDetailHousesDetailCallAndChatTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/1/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HouseRentDetailHousesDetailCallAndChatTableViewCellDelegate <NSObject>
- (void)houseRentOfOnLineChatWithModel:(HouseRentDetailVcHouseModel *)model; //在线了解
- (void)houseRentOfAppointmentActionWithModel:(HouseRentDetailVcHouseModel *)model; //预约
//
- (void)houseRentOfQianYueActionWithModel:(HouseRentDetailVcHouseModel *)model;//签约
//- (void)houseRentOfCallPhoneActionWithModel:(HouseRentDetailVcHouseModel *)model;//电话略 本cell可直接调用


@end

@interface HouseRentDetailHousesDetailCallAndChatTableViewCell : UITableViewCell
@property (nonatomic,strong) UIButton *oneBtn;
@property (nonatomic,strong) UIButton *onLineBtn;
@property (nonatomic,strong) UIButton *thrBtn;
@property (nonatomic,strong) HouseRentDetailVcHouseModel *model;
//
@property(nonatomic,weak) id <HouseRentDetailHousesDetailCallAndChatTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
 
