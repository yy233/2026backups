//
//  IssueHistroyListVcHouseTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/2/19.
//

#import <UIKit/UIKit.h>
#import "HouseRentHouseTableViewCell.h"
#import "IssueHistoryModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface IssueHistroyListVcHouseTableViewCell : HouseRentHouseTableViewCell
@property (nonatomic,strong) IssueHistoryModel *historyhouseCellmodel;
@end

NS_ASSUME_NONNULL_END
