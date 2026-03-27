//
//  IssuHouseQianYueManagerVcHouseTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/9/1.
//

#import "IssueHouseManagerVcHouseTableViewCellLate.h"

NS_ASSUME_NONNULL_BEGIN

@interface IssuHouseQianYueManagerVcHouseTableViewCell : IssueHouseManagerVcHouseTableViewCellLate
@property (nonatomic,strong) UILabel *redNumL;//业主的cell 
@property (nonatomic,strong) UILabel *redShowPoint;//租客的cell
- (void)setTypeBackViewSubViews:(NSDictionary *)houseAdvantage;
@end

NS_ASSUME_NONNULL_END
