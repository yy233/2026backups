//
//  HouseRepairDetailInfoCellSubTextTableViewCell.h
//  Community
//
//  Created by 余莹 on 2020/12/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HouseRepairDetailInfoCellSubTextTableViewCell : UITableViewCell
@property (nonatomic,strong) UILabel *titleLalel;
@property (nonatomic,strong) UILabel *detailLalel;
@end

@interface HouseRepairDetailInfoCellSubTextAndRightBtnTableViewCell : HouseRepairDetailInfoCellSubTextTableViewCell
@property (nonatomic,strong) UIButton *copyBtn;
@end

NS_ASSUME_NONNULL_END
