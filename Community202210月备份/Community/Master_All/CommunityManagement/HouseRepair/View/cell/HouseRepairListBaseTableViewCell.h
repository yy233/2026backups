//
//  HouseRepairListTableViewCell.h
//  Community
//
//  Created by 余莹 on 2020/12/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol HouseRepairListBaseTableViewCellDelegate <NSObject>
- (void)removeThisRepairWithModel:(HouseRepairListModel *)model;//取消报修
- (void)evaluatThisRepairWithModel:(HouseRepairListModel *)model;//评价
- (void)showDismissReasonWithModel:(HouseRepairListModel *)model;//展示驳回原因
@end
@interface HouseRepairListBaseTableViewCell : UITableViewCell
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UIButton *statusBtn;
@property (nonatomic,strong) UIButton *removeThisRepairBtn;
@property (nonatomic,strong) UIButton *evaluationBtn; //评价
@property (nonatomic,strong) UIButton *showReasonBtn; //查看理由
@property (nonatomic,strong) UIImageView *imgV;
@property (nonatomic,strong) HouseRepairListModel *model;
@property (nonatomic,weak)id <HouseRepairListBaseTableViewCellDelegate> delegate;
@end
//
@interface HouseRepairListWillDetailTableViewCell : HouseRepairListBaseTableViewCell
@end
@interface HouseRepairListDetailingTableViewCell : HouseRepairListBaseTableViewCell
@end
@interface HouseRepairListEndDetailTableViewCell : HouseRepairListBaseTableViewCell
@end
@interface HouseRepairListDismissDetailTableViewCell : HouseRepairListBaseTableViewCell
@end
NS_ASSUME_NONNULL_END
