//
//  HouseRepairDetailShowOrderInfoTableViewCell.h
//  Community
//
//  Created by 余莹 on 2020/12/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol HouseRepairDetailShowOrderInfoTableViewCellDelegate <NSObject>
- (void)copyBtnIsTouch;
@end
@interface HouseRepairDetailShowOrderInfoTableViewCell : HouseRepairDetailShowBaseTableViewCell
@property (nonatomic,strong) HouseRepairDetailModel *detailModel;
@property (nonatomic,weak) id <HouseRepairDetailShowOrderInfoTableViewCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
