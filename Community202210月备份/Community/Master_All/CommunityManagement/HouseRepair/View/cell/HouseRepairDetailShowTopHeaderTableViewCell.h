//
//  HouseRepairDetailShowTopHeaderTableViewCell.h
//  Community
//
//  Created by 余莹 on 2020/12/26.
//

#import <UIKit/UIKit.h>
#import "HouseRepairListBaseTableViewCell.h"
NS_ASSUME_NONNULL_BEGIN
@protocol HouseRepairDetailTopHeaderTableViewCellDelegate <HouseRepairListBaseTableViewCellDelegate>
@end
@interface HouseRepairDetailShowTopHeaderTableViewCell : HouseRepairListBaseTableViewCell
@property (nonatomic,strong) HouseRepairDetailModel *detailModel;
//@property (nonatomic,assign) NSInteger id;
@property (nonatomic,assign) NSInteger IDNum;
@end

NS_ASSUME_NONNULL_END
