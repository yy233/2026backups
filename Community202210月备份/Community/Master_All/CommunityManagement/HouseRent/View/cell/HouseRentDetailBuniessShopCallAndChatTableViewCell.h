//
//  HouseRentDetailBuniessShopCallAndChatTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/1/8.
//

#import <UIKit/UIKit.h>
#import "HouseRentDetailHousesDetailCallAndChatTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HouseRentDetailBuniessShopCallAndChatTableViewCellDelegate <NSObject>
- (void)buniessShopRentOfOnLineChat;
- (void)buniessShopRentOfQianYue;
@end

@interface HouseRentDetailBuniessShopCallAndChatTableViewCell : HouseRentDetailHousesDetailCallAndChatTableViewCell
@property (nonatomic,weak) id <HouseRentDetailBuniessShopCallAndChatTableViewCellDelegate> buniessDelegate;
@property (nonatomic,strong)  HouseRentDetailVcBuniessShopModelUserModel *userModel;
@end

NS_ASSUME_NONNULL_END
